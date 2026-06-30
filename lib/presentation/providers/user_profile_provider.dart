import 'package:riverpod_annotation/riverpod_annotation.dart';
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
    final repo = await ref.read(userProfileRepositoryProvider.future);
    await repo.addFeedback(season: season, feelsDelta: feelsDelta);
    final current = state.valueOrNull;
    if (current != null) {
      final updated = season.isHeat
          ? current.copyWith(
              heatFeedbackHistory: [...current.heatFeedbackHistory, feelsDelta])
          : current.copyWith(
              coldFeedbackHistory: [...current.coldFeedbackHistory, feelsDelta]);
      state = AsyncValue.data(updated);
    }
  }
}
