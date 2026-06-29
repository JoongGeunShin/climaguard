import '../entities/season.dart';
import '../entities/user_profile.dart';

abstract interface class UserProfileRepository {
  Future<UserProfile?> loadProfile();
  Future<void> saveProfile(UserProfile profile);
  Future<void> addFeedback({required Season season, required double feelsDelta});
}
