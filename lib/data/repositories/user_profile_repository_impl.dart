import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/season.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/user_profile_firestore_data_source.dart';
import '../datasources/user_profile_local_data_source.dart';

part 'user_profile_repository_impl.g.dart';

@Riverpod(keepAlive: true)
Future<UserProfileRepository> userProfileRepository(Ref ref) async {
  final local = await ref.watch(userProfileLocalDataSourceProvider.future);
  final remote = ref.watch(userProfileFirestoreDataSourceProvider);
  return UserProfileRepositoryImpl(local: local, remote: remote);
}

/// Firestore 우선, 실패 시 로컬 캐시(SharedPreferences) 폴백
class UserProfileRepositoryImpl implements UserProfileRepository {
  UserProfileRepositoryImpl({
    required this.local,
    required this.remote,
  });

  final UserProfileLocalDataSource local;
  final UserProfileFirestoreDataSource remote;

  @override
  Future<UserProfile?> loadProfile() async {
    final profile = await remote.loadProfile() ?? local.loadProfile();
    if (profile != null) await local.saveProfile(profile); // 로컬 캐시 동기화
    return profile;
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await Future.wait([
      local.saveProfile(profile),
      remote.saveProfile(profile),
    ]);
  }

  @override
  Future<void> addFeedback({
    required Season season,
    required double feelsDelta,
  }) async {
    await Future.wait([
      local.addFeedback(season: season, delta: feelsDelta),
      remote.addFeedback(season: season, delta: feelsDelta),
    ]);
  }
}
