import 'package:riverpod_annotation/riverpod_annotation.dart';
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
      await ref
          .read(groupStatsDataSourceProvider)
          .incrementFeedback(
            ageKey: ageKey,
            season: season,
            delta: feelsDelta,
            conditions: current.conditions,
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

  static String _ageKey(int age) {
    if (age <= 9) return 'infant_0to9';
    if (age <= 17) return 'youth_10to17';
    if (age <= 64) return 'adult_18to64';
    if (age <= 74) return 'elderly_65to74';
    return 'super_elderly_75plus';
  }
}
