import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required int age,
    @Default('') String name,
    String? gender,                                 // '남성' or '여성'
    @Default([]) List<String> conditions,           // 기저질환
    String? regionCode,
    @Default([]) List<double> heatFeedbackHistory,  // 폭염 체감 보정값 이력
    @Default([]) List<double> coldFeedbackHistory,  // 한파 체감 보정값 이력
  }) = _UserProfile;
}
