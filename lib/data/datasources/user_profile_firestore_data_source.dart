import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/season.dart';
import '../../domain/entities/user_profile.dart';
import 'firebase_auth_data_source.dart';

part 'user_profile_firestore_data_source.g.dart';

@Riverpod(keepAlive: true)
UserProfileFirestoreDataSource userProfileFirestoreDataSource(Ref ref) {
  return UserProfileFirestoreDataSource(
    FirebaseFirestore.instance,
    ref.watch(firebaseAuthDataSourceProvider),
  );
}

class UserProfileFirestoreDataSource {
  UserProfileFirestoreDataSource(this._db, this._auth);

  final FirebaseFirestore _db;
  final FirebaseAuthDataSource _auth;

  String get _phoneKey {
    final phone = _auth.currentUser?.phoneNumber;
    if (phone == null) throw StateError('Not authenticated');
    return phone;
  }

  DocumentReference get _profileRef =>
      _db.collection('users').doc(_phoneKey).collection('profile').doc('data');

  DocumentReference get _feedbackRef =>
      _db.collection('users').doc(_phoneKey).collection('thresholdOverride').doc('data');

  Future<UserProfile?> loadProfile() async {
    try {
      if (_auth.currentUser == null) return null;
      final snap = await _profileRef.get();
      if (!snap.exists) return null;
      final data = snap.data() as Map<String, dynamic>;

      final fbSnap = await _feedbackRef.get();
      final fbData = fbSnap.exists
          ? fbSnap.data() as Map<String, dynamic>
          : <String, dynamic>{};

      return UserProfile(
        age: data['age'] as int? ?? 0,
        name: data['name'] as String? ?? '',
        gender: data['gender'] as String?,
        conditions: List<String>.from(data['conditions'] as List? ?? []),
        regionCode: data['regionCode'] as String?,
        heatFeedbackHistory: _toDoubleList(fbData['heatFeedbacks']),
        coldFeedbackHistory: _toDoubleList(fbData['coldFeedbacks']),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _profileRef.set({
      'name': profile.name,
      'age': profile.age,
      'gender': profile.gender,
      'ageGroup': _ageGroup(profile.age),
      'conditions': profile.conditions,
      'regionCode': profile.regionCode,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> addFeedback({
    required Season season,
    required double delta,
  }) async {
    final ref = _feedbackRef;
    final field = season.isHeat ? 'heatFeedbacks' : 'coldFeedbacks';
    final snap = await ref.get();
    final data = snap.exists ? snap.data() as Map<String, dynamic> : {};
    final current = _toDoubleList(data[field]);
    current.add(delta);
    // 최근 30개만 유지
    final trimmed = current.length > 30
        ? current.sublist(current.length - 30)
        : current;
    await ref.set({field: trimmed, 'updatedAt': FieldValue.serverTimestamp()},
        SetOptions(merge: true));
  }

  List<double> _toDoubleList(dynamic raw) {
    if (raw is List) return raw.map((e) => (e as num).toDouble()).toList();
    return [];
  }

  String _ageGroup(int age) {
    if (age <= 9)  return 'infant';
    if (age <= 17) return 'youth';
    if (age <= 64) return 'adult';
    if (age <= 74) return 'elderly';
    return 'super_elderly';
  }
}
