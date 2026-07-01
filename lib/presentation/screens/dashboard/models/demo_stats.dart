import 'package:flutter/material.dart';
import '../../../../domain/entities/risk_level.dart';

// ── 시연용 더미 데이터 (100명분) ─────────────────────────────────────
// 실제 Firestore groupStats 연동 전 Phase 7 시연 전용

class AgeGroupStat {
  const AgeGroupStat({
    required this.key,
    required this.label,
    required this.ageRange,
    required this.count,
    required this.totalHeatFeedbacks,
    required this.totalColdFeedbacks,
    required this.heatGroupOffset,
    required this.coldGroupOffset,
  });

  final String key;
  final String label;
  final String ageRange;
  final int count;
  final int totalHeatFeedbacks;
  final int totalColdFeedbacks;
  final double heatGroupOffset; // 집단 피드백 평균 * 0.2
  final double coldGroupOffset;
}

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

// ── 연령 그룹 집단 학습 현황 ──────────────────────────────────────────

const demoAgeGroups = [
  AgeGroupStat(
    key: 'super_elderly_75plus',
    label: '초고위험군',
    ageRange: '75세 이상',
    count: 20,
    totalHeatFeedbacks: 247,
    totalColdFeedbacks: 183,
    heatGroupOffset: -0.24, // avg=-1.2, *0.2
    coldGroupOffset: 0.30,  // avg=+1.5, *0.2
  ),
  AgeGroupStat(
    key: 'elderly_65to74',
    label: '고령 위험군',
    ageRange: '65~74세',
    count: 28,
    totalHeatFeedbacks: 183,
    totalColdFeedbacks: 142,
    heatGroupOffset: -0.16,
    coldGroupOffset: 0.22,
  ),
  AgeGroupStat(
    key: 'adult_18to64',
    label: '성인',
    ageRange: '18~64세',
    count: 35,
    totalHeatFeedbacks: 156,
    totalColdFeedbacks: 98,
    heatGroupOffset: 0.10,
    coldGroupOffset: 0.02,
  ),
  AgeGroupStat(
    key: 'youth_10to17',
    label: '청소년',
    ageRange: '10~17세',
    count: 12,
    totalHeatFeedbacks: 82,
    totalColdFeedbacks: 54,
    heatGroupOffset: -0.12,
    coldGroupOffset: 0.14,
  ),
  AgeGroupStat(
    key: 'infant_0to9',
    label: '영유아',
    ageRange: '0~9세',
    count: 5,
    totalHeatFeedbacks: 43,
    totalColdFeedbacks: 29,
    heatGroupOffset: -0.18,
    coldGroupOffset: 0.20,
  ),
];

// ── 위험 단계별 인원 분포 (체감 36.5°C 폭염 / -12.0°C 한파 시나리오) ──

const heatRiskDistribution = RiskDistribution(
  danger: 54,   // 초고위험군·고령·청소년·영유아 대부분
  warning: 39,  // 성인 + 조건 없는 고령 일부
  caution: 7,   // 성인 중 낮은 감수성
  safe: 0,
);

const coldRiskDistribution = RiskDistribution(
  danger: 14,   // 초고위험군 심혈관 보유자 등
  warning: 31,  // 초고위험군·고령
  caution: 48,  // 성인·청소년
  safe: 7,      // 건강한 성인 일부
);

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
