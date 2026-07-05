import '../entities/age_thresholds.dart';
import '../entities/risk_level.dart';
import '../entities/user_profile.dart';
import '../entities/weather_data.dart';
import 'risk_calculation_use_case.dart';

/// 행정구역 단위 위험 인원 투영 결과.
///
/// [caution]에는 관심(attention) 단계 인원도 합산돼 있다 — 기존 대시보드
/// 위젯(`RiskDistributionSection`)이 4단계(위험/경고/주의/안전)만 다루기 때문.
class RegionRiskProjection {
  const RegionRiskProjection({
    required this.totalPopulation,
    required this.danger,
    required this.warning,
    required this.caution,
    required this.safe,
  });

  final int totalPopulation;
  final int danger;
  final int warning;
  final int caution;
  final int safe;

  /// "관리 필요 구역" 색상 강도에 쓰는 위험군 비율.
  double get atRiskRatio =>
      totalPopulation == 0 ? 0 : (danger + warning) / totalPopulation;
}

/// 행정구역의 연령대별 인구(SGIS)에 현재 날씨와 임계값 모델(Firestore
/// thresholds, 집단학습으로 갱신됨)을 적용해 위험 단계별 인원을 투영한다.
///
/// 기저질환 인구 통계는 공공데이터로 구할 수 없어 나이만 반영한다 —
/// 개인 앱 사용자의 기저질환 보정은 계속 프로필 화면에서만 적용된다.
class RegionalRiskProjectionUseCase {
  static const _representativeAge = {
    'infant_0to9': 5,
    'youth_10to17': 14,
    'adult_18to64': 40,
    'elderly_65to74': 70,
    'super_elderly_75plus': 80,
  };

  RegionRiskProjection project({
    required Map<String, int> ageBuckets,
    required WeatherData weather,
    required BaseThresholds base,
    required Map<String, AgeOffsets> ageOffsetsByKey,
  }) {
    final calc = RiskCalculationUseCase();
    int danger = 0, warning = 0, caution = 0, safe = 0;
    var total = 0;

    for (final entry in ageBuckets.entries) {
      final population = entry.value;
      total += population;
      if (population <= 0) continue;

      final ageOffsets = ageOffsetsByKey[entry.key] ?? AgeOffsets.zero;
      final profile = UserProfile(age: _representativeAge[entry.key] ?? 40);
      final alert = calc.calculate(
        profile: profile,
        weather: weather,
        base: base,
        ageOffsets: ageOffsets,
        conditionHeatOffset: 0,
        conditionColdOffset: 0,
      );

      switch (alert.personalRiskLevel) {
        case RiskLevel.danger:
          danger += population;
        case RiskLevel.warning:
          warning += population;
        case RiskLevel.caution:
        case RiskLevel.attention:
          caution += population;
        case RiskLevel.safe:
          safe += population;
      }
    }

    return RegionRiskProjection(
      totalPopulation: total,
      danger: danger,
      warning: warning,
      caution: caution,
      safe: safe,
    );
  }
}
