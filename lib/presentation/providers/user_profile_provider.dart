import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/ai_group_offset_service.dart';
import '../../data/datasources/firebase_auth_data_source.dart';
import '../../data/datasources/group_stats_data_source.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../domain/entities/season.dart';
import '../../domain/entities/user_profile.dart';
import 'auth_provider.dart';

part 'user_profile_provider.g.dart';

@Riverpod(keepAlive: true)
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  Future<UserProfile?> build() async {
    // auth 상태가 바뀔 때마다 재빌드 → 로그인/로그아웃 시 프로필 자동 갱신
    ref.watch(authStateProvider);
    final repo = await ref.watch(userProfileRepositoryProvider.future);
    return repo.loadProfile();
  }

  Future<void> save(UserProfile profile) async {
    final repo = await ref.read(userProfileRepositoryProvider.future);
    await repo.saveProfile(profile);
    state = AsyncValue.data(profile);
  }

  Future<void> addFeedback({
    required Season season,
    required double feelsDelta,
  }) async {
    final current = state.valueOrNull;
    final repo = await ref.read(userProfileRepositoryProvider.future);
    await repo.addFeedback(season: season, feelsDelta: feelsDelta);

    if (current != null) {
      final ageKey = _ageKey(current.age);

      // 집단 통계 누적 (기저질환 포함)
      final groupStats = ref.read(groupStatsDataSourceProvider);
      await groupStats.incrementFeedback(
        ageKey: ageKey,
        season: season,
        delta: feelsDelta,
        conditions: current.conditions,
      );

      // 집단학습 임계값 도달 시 이 기기가 직접 Gemini 분석을 트리거
      // (Cloud Function 없이 클라이언트에서 처리 — 트랜잭션 락으로 중복 실행 방지).
      // UI를 막지 않도록 await 없이 fire-and-forget으로 실행.
      unawaited(
        ref
            .read(aiGroupOffsetServiceProvider)
            .runAnalysisIfNeeded(current, season),
      );

      final updated = season.isHeat
          ? current.copyWith(
              heatFeedbackHistory: [...current.heatFeedbackHistory, feelsDelta])
          : current.copyWith(
              coldFeedbackHistory: [
                ...current.coldFeedbackHistory,
                feelsDelta
              ]);
      state = AsyncValue.data(updated);
    }
  }

  /// 로컬 캐시를 먼저 지운 뒤 로그아웃한다 — 순서를 바꾸면 signOut 이후
  /// authStateProvider 변화로 build()가 먼저 재실행되며 지워지기 전 캐시를
  /// 읽어 다음 로그인 계정에 이 기기의 이전 프로필이 노출될 수 있다.
  Future<void> logout() async {
    final repo = await ref.read(userProfileRepositoryProvider.future);
    await repo.clearLocalCache();
    await ref.read(firebaseAuthDataSourceProvider).signOut();
  }

  static String _ageKey(int age) {
    if (age <= 9) return 'infant_0to9';
    if (age <= 17) return 'youth_10to17';
    if (age <= 64) return 'adult_18to64';
    if (age <= 74) return 'elderly_65to74';
    return 'super_elderly_75plus';
  }
}
