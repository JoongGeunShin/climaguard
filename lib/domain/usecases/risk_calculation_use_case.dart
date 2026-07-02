import '../entities/age_thresholds.dart';
import '../entities/climate_alert.dart';
import '../entities/risk_level.dart';
import '../entities/user_profile.dart';
import '../entities/weather_data.dart';

class RiskCalculationUseCase {
  ClimateAlert calculate({
    required UserProfile profile,
    required WeatherData weather,
    required BaseThresholds base,
    required AgeOffsets ageOffsets,
    required double conditionHeatOffset,
    required double conditionColdOffset,
  }) {
    final season = weather.season;

    if (season.isNormal) {
      return ClimateAlert(
        season: season,
        personalRiskLevel: RiskLevel.safe,
        officialRiskLevel: RiskLevel.safe,
        personalThreshold: weather.temperature,
        currentFeelsLike: weather.feelsLike,
        adjustmentReasons: ['현재 기온이 쾌적한 범위(14~24°C)입니다.'],
        generatedAt: DateTime.now(),
      );
    }

    final reasons = <String>[];
    reasons.add('${_ageLabel(profile.age)} 기준 보정값 적용');

    // 기저질환 보정 사유
    for (final c in profile.conditions) {
      final delta =
          season.isHeat ? conditionHeatOffset : conditionColdOffset;
      if (delta.abs() >= 0.1) {
        reasons.add('$c 보정 ${_sign(delta)}${delta.abs().toStringAsFixed(1)}°C');
      }
    }

    // 개인 피드백 보정 (평균의 20%, ±3°C 클램핑)
    final feedbacks = season.isHeat
        ? profile.heatFeedbackHistory
        : profile.coldFeedbackHistory;
    double feedbackOffset = 0.0;
    if (feedbacks.isNotEmpty) {
      final avg = feedbacks.reduce((a, b) => a + b) / feedbacks.length;
      feedbackOffset = (avg * 0.2).clamp(-3.0, 3.0);
      if (feedbackOffset.abs() >= 0.1) {
        reasons.add(
          '개인 피드백 반영 (${_sign(feedbackOffset)}${feedbackOffset.abs().toStringAsFixed(1)}°C)',
        );
      }
    }

    // 개인 보정합 (기저질환 + 피드백) — 연령 보정은 단계별로 별도 적용
    final personalHeatOff = conditionHeatOffset + feedbackOffset;
    final personalColdOff = conditionColdOffset + feedbackOffset;

    // 경고 단계 기준점으로 personalThreshold 표시
    final personalThreshold = season.isHeat
        ? base.heatWarning + ageOffsets.heat.warning + personalHeatOff
        : base.coldWarning + ageOffsets.cold.warning + personalColdOff;

    final feelsLike = weather.feelsLike;
    final personalRiskLevel = season.isHeat
        ? _heatRiskLevel(feelsLike, base, ageOffsets.heat, personalHeatOff)
        : _coldRiskLevel(feelsLike, base, ageOffsets.cold, personalColdOff);

    return ClimateAlert(
      season: season,
      personalRiskLevel: personalRiskLevel,
      officialRiskLevel: weather.officialRiskLevel,
      personalThreshold: personalThreshold,
      currentFeelsLike: feelsLike,
      adjustmentReasons: reasons,
      generatedAt: DateTime.now(),
    );
  }

  RiskLevel _heatRiskLevel(
      double fl, BaseThresholds b, LevelOffsets age, double personal) {
    if (fl >= b.heatDanger    + age.danger    + personal) return RiskLevel.danger;
    if (fl >= b.heatWarning   + age.warning   + personal) return RiskLevel.warning;
    if (fl >= b.heatCaution   + age.caution   + personal) return RiskLevel.caution;
    if (fl >= b.heatAttention + age.attention + personal) return RiskLevel.attention;
    return RiskLevel.safe;
  }

  RiskLevel _coldRiskLevel(
      double fl, BaseThresholds b, LevelOffsets age, double personal) {
    if (fl <= b.coldDanger    + age.danger    + personal) return RiskLevel.danger;
    if (fl <= b.coldWarning   + age.warning   + personal) return RiskLevel.warning;
    if (fl <= b.coldCaution   + age.caution   + personal) return RiskLevel.caution;
    if (fl <= b.coldAttention + age.attention + personal) return RiskLevel.attention;
    return RiskLevel.safe;
  }

  String _ageLabel(int age) {
    if (age <= 9)  return '영유아(0~9세)';
    if (age <= 17) return '청소년(10~17세)';
    if (age <= 64) return '성인(18~64세)';
    if (age <= 74) return '고령(65~74세)';
    return '초고령(75세↑)';
  }

  String _sign(double v) => v >= 0 ? '+' : '';
}
