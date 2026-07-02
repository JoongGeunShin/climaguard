import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/age_thresholds.dart';

part 'threshold_service.g.dart';

const _col = 'thresholds';

@Riverpod(keepAlive: true)
ThresholdService thresholdService(Ref ref) {
  return ThresholdService(FirebaseFirestore.instance);
}

/// Firestore `thresholds/base` 실시간 스트림 — 그룹학습 등으로 값이
/// 바뀌면 앱을 재시작하지 않아도 이 스트림을 구독 중인 모든 화면에 즉시 반영된다.
@Riverpod(keepAlive: true)
Stream<BaseThresholds> baseThresholds(Ref ref) {
  return FirebaseFirestore.instance
      .collection(_col)
      .doc('base')
      .snapshots()
      .map((snap) => snap.exists
          ? BaseThresholds.fromFirestore(snap.data()!)
          : BaseThresholds.defaults);
}

/// Firestore `thresholds/age_{ageKey}` 실시간 스트림.
@Riverpod(keepAlive: true)
Stream<AgeOffsets> ageOffsets(Ref ref, String ageKey) {
  return FirebaseFirestore.instance
      .collection(_col)
      .doc('age_$ageKey')
      .snapshots()
      .map((snap) => snap.exists
          ? AgeOffsets.fromFirestore(snap.data()!)
          : ThresholdService.defaultAgeOffsets(ageKey));
}

/// Firestore `thresholds/condition_{condition}` 실시간 스트림.
@Riverpod(keepAlive: true)
Stream<({double heat, double cold})> conditionOffset(
    Ref ref, String condition) {
  return FirebaseFirestore.instance
      .collection(_col)
      .doc('condition_$condition')
      .snapshots()
      .map((snap) {
    if (snap.exists) {
      final m = snap.data()!;
      return (
        heat: (m['heatOffset'] as num).toDouble(),
        cold: (m['coldOffset'] as num).toDouble(),
      );
    }
    return ThresholdService.defaultConditionOffset(condition);
  });
}

/// Firestore `thresholds` 컬렉션 쓰기 전용 서비스.
///
/// 읽기는 위의 실시간 스트림 프로바이더(baseThresholds/ageOffsets/conditionOffset)를
/// 사용한다 — 캐시를 직접 들고 있지 않고 Firestore snapshot 리스너에 위임함으로써
/// 그룹학습으로 값이 바뀐 즉시 모든 화면(다른 사용자 기기 포함)에 반영되게 한다.
///
/// 문서 구조:
///   base            → 성인 기준 절대 임계값
///   age_{ageKey}    → 연령별 단계별 보정값 (heat/cold × attention/caution/warning/danger)
///   condition_{name} → 기저질환 보정값 (heatOffset, coldOffset 단일값)
class ThresholdService {
  ThresholdService(this._db);

  final FirebaseFirestore _db;

  // ── 기본 시딩/폴백 데이터 ───────────────────────────────────────────

  static const _ageKeys = [
    'adult_18to64', 'elderly_65to74', 'super_elderly_75plus',
    'youth_10to17', 'infant_0to9',
  ];

  // 초기 단계별 보정값 — 위험도가 높을수록 취약 그룹은 더 민감
  // (adult 기준 0.0, AI 학습으로 점진 개선)
  static AgeOffsets defaultAgeOffsets(String ageKey) {
    final (double h, double c) = switch (ageKey) {
      'adult_18to64'          => (0.0,  0.0),
      'elderly_65to74'        => (-3.0, 3.0),
      'super_elderly_75plus'  => (-4.5, 4.5),
      'youth_10to17'          => (-1.5, 1.5),
      'infant_0to9'           => (-3.0, 3.0),
      _                       => (0.0,  0.0),
    };
    // 단계별 차등: 위험>경고>주의>관심 순으로 보정폭 조금씩 확대
    return AgeOffsets(
      heat: LevelOffsets(
        attention: h,
        caution:   h - (h < 0 ? 0.5 : 0),
        warning:   h - (h < 0 ? 0.5 : 0),
        danger:    h - (h < 0 ? 1.0 : 0),
      ),
      cold: LevelOffsets(
        attention: c,
        caution:   c + (c > 0 ? 0.5 : 0),
        warning:   c + (c > 0 ? 0.5 : 0),
        danger:    c + (c > 0 ? 1.0 : 0),
      ),
    );
  }

  static const _conditionDefaults = {
    'condition_심혈관': (heat: -2.0, cold: 2.0),
    'condition_당뇨':   (heat: -2.0, cold: 1.5),
    'condition_호흡기': (heat: -1.5, cold: 2.0),
    'condition_고혈압': (heat: -1.0, cold: 1.0),
    'condition_신장':   (heat: -1.5, cold: 1.0),
    'condition_비만':   (heat: -0.5, cold: 0.0),
  };

  static ({double heat, double cold}) defaultConditionOffset(
      String condition) {
    return _conditionDefaults['condition_$condition'] ??
        (heat: 0.0, cold: 0.0);
  }

  // ── AI 분석 결과 반영 ───────────────────────────────────────────────

  Future<void> updateAgeOffsets(String ageKey, AgeOffsets offsets) async {
    await _db.collection(_col).doc('age_$ageKey').set({
      ...offsets.toFirestore(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── 초기 시딩 ──────────────────────────────────────────────────────

  Future<void> seedIfEmpty() async {
    final col = _db.collection(_col);

    // 기준 임계값
    final baseDoc = col.doc('base');
    if (!(await baseDoc.get()).exists) {
      await baseDoc.set({
        ...BaseThresholds.defaults.toFirestore(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    // 연령별 단계별 보정값
    for (final key in _ageKeys) {
      final ref = col.doc('age_$key');
      if ((await ref.get()).exists) continue;
      await ref.set({
        ...defaultAgeOffsets(key).toFirestore(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    // 기저질환 보정값
    for (final entry in _conditionDefaults.entries) {
      final ref = col.doc(entry.key);
      if ((await ref.get()).exists) continue;
      await ref.set({
        'heatOffset': entry.value.heat,
        'coldOffset': entry.value.cold,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
