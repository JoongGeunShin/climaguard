/// 위험 단계별 오프셋 (관심/주의/경고/위험)
class LevelOffsets {
  const LevelOffsets({
    required this.attention,
    required this.caution,
    required this.warning,
    required this.danger,
  });

  final double attention;
  final double caution;
  final double warning;
  final double danger;

  static const zero = LevelOffsets(
      attention: 0.0, caution: 0.0, warning: 0.0, danger: 0.0);

  Map<String, dynamic> toMap() => {
        'attention': attention,
        'caution': caution,
        'warning': warning,
        'danger': danger,
      };

  factory LevelOffsets.fromMap(Map<String, dynamic> m) => LevelOffsets(
        attention: (m['attention'] as num).toDouble(),
        caution:   (m['caution']   as num).toDouble(),
        warning:   (m['warning']   as num).toDouble(),
        danger:    (m['danger']    as num).toDouble(),
      );

  LevelOffsets clampAll(double min, double max) => LevelOffsets(
        attention: attention.clamp(min, max),
        caution:   caution.clamp(min, max),
        warning:   warning.clamp(min, max),
        danger:    danger.clamp(min, max),
      );
}

/// 연령 그룹별 폭염/한파 단계별 보정값 (Firestore thresholds/age_{key})
class AgeOffsets {
  const AgeOffsets({required this.heat, required this.cold});

  final LevelOffsets heat;
  final LevelOffsets cold;

  static const zero = AgeOffsets(heat: LevelOffsets.zero, cold: LevelOffsets.zero);

  Map<String, dynamic> toFirestore() => {
        'heat': heat.toMap(),
        'cold': cold.toMap(),
      };

  factory AgeOffsets.fromFirestore(Map<String, dynamic> m) => AgeOffsets(
        heat: LevelOffsets.fromMap(m['heat'] as Map<String, dynamic>),
        cold: LevelOffsets.fromMap(m['cold'] as Map<String, dynamic>),
      );
}

/// 성인 기준 절대 임계값 (Firestore thresholds/base)
class BaseThresholds {
  const BaseThresholds({
    required this.heatAttention,
    required this.heatCaution,
    required this.heatWarning,
    required this.heatDanger,
    required this.coldAttention,
    required this.coldCaution,
    required this.coldWarning,
    required this.coldDanger,
  });

  final double heatAttention, heatCaution, heatWarning, heatDanger;
  final double coldAttention, coldCaution, coldWarning, coldDanger;

  // Firestore 미로드 시 폴백
  static const defaults = BaseThresholds(
    heatAttention: 28.0, heatCaution: 31.0,
    heatWarning:   33.0, heatDanger:  36.0,
    coldAttention: -4.0, coldCaution: -8.0,
    coldWarning:  -12.0, coldDanger: -16.0,
  );

  Map<String, dynamic> toFirestore() => {
        'heat': {
          'attention': heatAttention, 'caution': heatCaution,
          'warning':   heatWarning,   'danger':  heatDanger,
        },
        'cold': {
          'attention': coldAttention, 'caution': coldCaution,
          'warning':   coldWarning,   'danger':  coldDanger,
        },
      };

  factory BaseThresholds.fromFirestore(Map<String, dynamic> m) {
    final heat = m['heat'] as Map<String, dynamic>;
    final cold = m['cold'] as Map<String, dynamic>;
    return BaseThresholds(
      heatAttention: (heat['attention'] as num).toDouble(),
      heatCaution:   (heat['caution']   as num).toDouble(),
      heatWarning:   (heat['warning']   as num).toDouble(),
      heatDanger:    (heat['danger']    as num).toDouble(),
      coldAttention: (cold['attention'] as num).toDouble(),
      coldCaution:   (cold['caution']   as num).toDouble(),
      coldWarning:   (cold['warning']   as num).toDouble(),
      coldDanger:    (cold['danger']    as num).toDouble(),
    );
  }
}
