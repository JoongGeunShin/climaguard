import 'package:flutter/material.dart';
import '../../../../domain/entities/risk_level.dart';

class RiskDistribution {
  const RiskDistribution({
    required this.danger,
    required this.warning,
    required this.caution,
    required this.safe,
  });

  final int danger;
  final int warning;
  final int caution;
  final int safe;

  int get total => danger + warning + caution + safe;

  int countOf(RiskLevel level) => switch (level) {
        RiskLevel.danger    => danger,
        RiskLevel.warning   => warning,
        RiskLevel.caution   => caution,
        RiskLevel.attention => 0,
        RiskLevel.safe      => safe,
      };
}

// ── UI 헬퍼 ─────────────────────────────────────────────────────────

Color riskColor(RiskLevel level) => switch (level) {
      RiskLevel.danger    => const Color(0xFFD50000),
      RiskLevel.warning   => const Color(0xFFFF6D00),
      RiskLevel.caution   => const Color(0xFFFFD600),
      RiskLevel.attention => const Color(0xFFFFF176),
      RiskLevel.safe      => const Color(0xFF43A047),
    };

String riskLabel(RiskLevel level) => switch (level) {
      RiskLevel.danger    => '위험',
      RiskLevel.warning   => '경고',
      RiskLevel.caution   => '주의',
      RiskLevel.attention => '관심',
      RiskLevel.safe      => '안전',
    };
