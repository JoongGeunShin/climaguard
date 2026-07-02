import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/group_stat.dart';
import '../../domain/entities/season.dart';
import '../../domain/entities/season_group_stat.dart';

part 'group_stats_data_source.g.dart';

@Riverpod(keepAlive: true)
GroupStatsDataSource groupStatsDataSource(Ref ref) {
  return GroupStatsDataSource(FirebaseFirestore.instance);
}

/// 폭염(hotGroupStats)과 한파(coldGroupStats)를 별도 컬렉션으로 관리한다.
/// 두 시즌은 서로 다른 시기에 쌓이므로(여름/겨울), 한쪽이 30건에 도달했다고
/// 표본이 적은 다른 쪽까지 같이 분석·소비되는 일이 없도록 완전히 독립시켰다.
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

  static const _lockTimeout = Duration(minutes: 2);

  CollectionReference _colFor(Season season) =>
      _db.collection(season.isHeat ? 'hotGroupStats' : 'coldGroupStats');

  /// 피드백 제출 시 집계 업데이트
  Future<void> incrementFeedback({
    required String ageKey,
    required Season season,
    required double delta,
    List<String> conditions = const [],
  }) async {
    try {
      final update = <String, dynamic>{
        'count': FieldValue.increment(1),
        'sum': FieldValue.increment(delta),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // 기저질환별 카운트 누적 — 반드시 중첩 맵으로 넘겨야 conditionCounts
      // 안의 필드로 병합된다. 'conditionCounts.$c'처럼 점(.)이 든 문자열 키를
      // set(merge:true)에 넘기면 점 포함 문자열 그대로 최상위 필드명이 되어버린다
      // (update()와 달리 set()은 점 표기를 경로로 해석하지 않음).
      if (conditions.isNotEmpty) {
        update['conditionCounts'] = {
          for (final c in conditions) c: FieldValue.increment(1),
        };
      }

      await _colFor(season).doc(ageKey).set(update, SetOptions(merge: true));
    } catch (_) {
      // 집단 통계 실패는 개인 피드백에 영향 없음
    }
  }

  /// 분석 대상 선점 (Cloud Function 없이 클라이언트에서 직접 트리거하므로,
  /// 임계값을 동시에 넘긴 여러 기기가 중복으로 Gemini를 호출하지 않도록 락을 건다).
  /// 락을 잡은 시점의 스냅샷을 그대로 반환해, 분석 입력과 이후 차감량이
  /// 정확히 일치하게 한다 (읽기와 락 선점을 같은 트랜잭션에서 처리).
  Future<SeasonGroupStat?> tryClaimAnalysis(String ageKey, Season season) async {
    final docRef = _colFor(season).doc(ageKey);
    try {
      return await _db.runTransaction<SeasonGroupStat?>((tx) async {
        final snap = await tx.get(docRef);
        final data = snap.data() as Map<String, dynamic>? ?? {};
        final stat = SeasonGroupStat.fromMap(ageKey, season, data);
        if (!stat.needsAiAnalysis) return null;

        final analyzing = data['analyzing'] as bool? ?? false;
        final since = (data['analyzingSince'] as Timestamp?)?.toDate();
        final lockExpired =
            since == null || DateTime.now().difference(since) > _lockTimeout;
        if (analyzing && !lockExpired) return null;

        tx.set(docRef, {
          'analyzing': true,
          'analyzingSince': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        return stat;
      });
    } catch (_) {
      return null;
    }
  }

  /// Gemini 분석 결과 저장 후, 분석에 사용된 배치(consumedBatch)만큼만
  /// 카운트/합계를 차감한다. 분석이 진행되는 동안 새로 들어온 피드백은
  /// 절대값 리셋이 아닌 차감 방식이라 안전하게 다음 배치로 남는다.
  Future<void> saveSeasonOffset({
    required String ageKey,
    required Season season,
    required double offset,
    required SeasonGroupStat consumedBatch,
  }) async {
    final update = <String, dynamic>{
      'offset': offset,
      'analyzing': false,
      'lastAnalyzedAt': FieldValue.serverTimestamp(),
      'count': FieldValue.increment(-consumedBatch.count),
      'sum': FieldValue.increment(-consumedBatch.sum),
    };
    if (consumedBatch.conditionCounts.isNotEmpty) {
      update['conditionCounts'] = {
        for (final entry in consumedBatch.conditionCounts.entries)
          entry.key: FieldValue.increment(-entry.value),
      };
    }
    await _colFor(season).doc(ageKey).set(update, SetOptions(merge: true));
  }

  /// 디버그 전용 — 집단학습 임계값(30건) 직전 상태를 재현하기 위해
  /// count/sum/conditionCounts를 지정한 값으로 덮어쓰고, 이전 분석 결과는
  /// 초기화한다(offset 삭제, analyzing 해제).
  Future<void> seedDebugBatch({
    required String ageKey,
    required Season season,
    required int count,
    required double sum,
    required Map<String, int> conditionCounts,
  }) async {
    await _colFor(season).doc(ageKey).set({
      'count': count,
      'sum': sum,
      'conditionCounts': conditionCounts,
      'offset': FieldValue.delete(),
      'analyzing': false,
      'analyzingSince': FieldValue.delete(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// 분석 도중 실패했을 때 락 해제 (다음 피드백 제출 시 재시도 가능하게)
  Future<void> releaseAnalysisLock(String ageKey, Season season) async {
    try {
      await _colFor(season).doc(ageKey).set(
        {'analyzing': false},
        SetOptions(merge: true),
      );
    } catch (_) {}
  }

  Future<SeasonGroupStat> loadOneSeason(String ageKey, Season season) async {
    try {
      final snap = await _colFor(season).doc(ageKey).get();
      if (!snap.exists) return SeasonGroupStat.empty(ageKey, season);
      return SeasonGroupStat.fromMap(
          ageKey, season, snap.data() as Map<String, dynamic>);
    } catch (_) {
      return SeasonGroupStat.empty(ageKey, season);
    }
  }

  Future<List<GroupStat>> loadAll() async {
    try {
      final hotSnaps =
          await Future.wait(_allKeys.map((k) => _colFor(Season.heat).doc(k).get()));
      final coldSnaps =
          await Future.wait(_allKeys.map((k) => _colFor(Season.cold).doc(k).get()));
      return List.generate(_allKeys.length, (i) {
        final key = _allKeys[i];
        final hot = hotSnaps[i].exists
            ? SeasonGroupStat.fromMap(
                key, Season.heat, hotSnaps[i].data() as Map<String, dynamic>)
            : SeasonGroupStat.empty(key, Season.heat);
        final cold = coldSnaps[i].exists
            ? SeasonGroupStat.fromMap(
                key, Season.cold, coldSnaps[i].data() as Map<String, dynamic>)
            : SeasonGroupStat.empty(key, Season.cold);
        return GroupStat.merge(key, hot, cold);
      });
    } catch (_) {
      return _allKeys.map(GroupStat.empty).toList();
    }
  }

  Future<GroupStat> loadOne(String ageKey) async {
    final hot = await loadOneSeason(ageKey, Season.heat);
    final cold = await loadOneSeason(ageKey, Season.cold);
    return GroupStat.merge(ageKey, hot, cold);
  }
}
