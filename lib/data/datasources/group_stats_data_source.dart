import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/group_stat.dart';
import '../../domain/entities/season.dart';

part 'group_stats_data_source.g.dart';

@Riverpod(keepAlive: true)
GroupStatsDataSource groupStatsDataSource(Ref ref) {
  return GroupStatsDataSource(FirebaseFirestore.instance);
}

class GroupStatsDataSource {
  GroupStatsDataSource(this._db);

  final FirebaseFirestore _db;

  static const _allKeys = [
    'super_elderly_75plus',
    'elderly_65to74',
    'adult_18to64',
    'youth_10to17',
    'infant_0to9',
  ];

  CollectionReference get _col => _db.collection('groupStats');

  /// 피드백 제출 시 원자적 증가 (FieldValue.increment)
  Future<void> incrementFeedback({
    required String ageKey,
    required Season season,
    required double delta,
  }) async {
    try {
      await _col.doc(ageKey).set(
        season.isHeat
            ? {
                'heatCount': FieldValue.increment(1),
                'heatSum': FieldValue.increment(delta),
                'updatedAt': FieldValue.serverTimestamp(),
              }
            : {
                'coldCount': FieldValue.increment(1),
                'coldSum': FieldValue.increment(delta),
                'updatedAt': FieldValue.serverTimestamp(),
              },
        SetOptions(merge: true),
      );
    } catch (_) {
      // 그룹 통계 실패는 개인 피드백에 영향 없음
    }
  }

  Future<List<GroupStat>> loadAll() async {
    try {
      final snaps = await Future.wait(_allKeys.map((k) => _col.doc(k).get()));
      return List.generate(_allKeys.length, (i) {
        final snap = snaps[i];
        if (!snap.exists) return GroupStat.empty(_allKeys[i]);
        return GroupStat.fromMap(
            _allKeys[i], snap.data() as Map<String, dynamic>);
      });
    } catch (_) {
      return _allKeys.map(GroupStat.empty).toList();
    }
  }

  Future<GroupStat> loadOne(String ageKey) async {
    try {
      final snap = await _col.doc(ageKey).get();
      if (!snap.exists) return GroupStat.empty(ageKey);
      return GroupStat.fromMap(ageKey, snap.data() as Map<String, dynamic>);
    } catch (_) {
      return GroupStat.empty(ageKey);
    }
  }
}
