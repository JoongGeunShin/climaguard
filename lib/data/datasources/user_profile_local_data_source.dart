import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/season.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_local_data_source.g.dart';

const _keyProfile       = 'user_profile';
const _keyHeatFeedbacks = 'heat_feedback_history';
const _keyColdFeedbacks = 'cold_feedback_history';
const _maxFeedbacks     = 30;

@Riverpod(keepAlive: true)
Future<UserProfileLocalDataSource> userProfileLocalDataSource(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return UserProfileLocalDataSource(prefs);
}

class UserProfileLocalDataSource {
  UserProfileLocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  UserProfile? loadProfile() {
    final raw = _prefs.getString(_keyProfile);
    if (raw == null) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return UserProfile(
      age: map['age'] as int,
      gender: map['gender'] as String?,
      conditions: List<String>.from(map['conditions'] as List? ?? []),
      regionCode: map['regionCode'] as String?,
      heatFeedbackHistory: _loadFeedbacks(_keyHeatFeedbacks),
      coldFeedbackHistory: _loadFeedbacks(_keyColdFeedbacks),
    );
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _prefs.setString(
      _keyProfile,
      jsonEncode({
        'age': profile.age,
        'gender': profile.gender,
        'conditions': profile.conditions,
        'regionCode': profile.regionCode,
      }),
    );
  }

  Future<void> addFeedback({
    required Season season,
    required double delta,
  }) async {
    final key = season.isHeat ? _keyHeatFeedbacks : _keyColdFeedbacks;
    final current = _prefs.getStringList(key) ?? [];
    current.add(delta.toString());
    final trimmed = current.length > _maxFeedbacks
        ? current.sublist(current.length - _maxFeedbacks)
        : current;
    await _prefs.setStringList(key, trimmed);
  }

  List<double> _loadFeedbacks(String key) =>
      (_prefs.getStringList(key) ?? []).map(double.parse).toList();

  /// 로그아웃 시 호출 — 다음 로그인 계정이 이 기기의 이전 계정 캐시를
  /// 이어받지 않도록 로컬 프로필/피드백 기록을 모두 지운다.
  Future<void> clearProfile() async {
    await Future.wait([
      _prefs.remove(_keyProfile),
      _prefs.remove(_keyHeatFeedbacks),
      _prefs.remove(_keyColdFeedbacks),
    ]);
  }
}
