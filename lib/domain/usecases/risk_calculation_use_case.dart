import '../../core/constants/app_constants.dart';
import '../entities/climate_alert.dart';
import '../entities/risk_level.dart';
import '../entities/user_profile.dart';
import '../entities/weather_data.dart';

class RiskCalculationUseCase {
  ClimateAlert calculate({
    required UserProfile profile,
    required WeatherData weather,
  }) {
    final season = weather.season;
    final reasons = <String>[];

    final ageKey = _ageKey(profile.age);
    final baseOffset = season.isHeat
        ? AppConstants.ageGroupHeatOffsets[ageKey]!
        : AppConstants.ageGroupColdOffsets[ageKey]!;

    double totalOffset = baseOffset;
    reasons.add(
      '${_ageLabel(profile.age)} ${season.label} 보정 '
      '${_sign(baseOffset)}${baseOffset.abs()}°C',
    );

    // 기저질환 보정
    final conditionOffsets = season.isHeat
        ? AppConstants.conditionHeatOffsets
        : AppConstants.conditionColdOffsets;

    for (final condition in profile.conditions) {
      final delta = conditionOffsets[condition];
      if (delta != null && delta != 0) {
        totalOffset += delta;
        reasons.add('$condition 보정 ${_sign(delta)}${delta.abs()}°C');
      }
    }

    // 개인 피드백 누적 보정 (평균의 20%, ±3°C 클램핑)
    final feedbacks = season.isHeat
        ? profile.heatFeedbackHistory
        : profile.coldFeedbackHistory;
    if (feedbacks.isNotEmpty) {
      final avg = feedbacks.reduce((a, b) => a + b) / feedbacks.length;
      final feedbackOffset = (avg * 0.2).clamp(-3.0, 3.0);
      if (feedbackOffset.abs() >= 0.1) {
        totalOffset += feedbackOffset;
        reasons.add(
          '개인 피드백 반영 (${_sign(feedbackOffset)}${feedbackOffset.abs().toStringAsFixed(1)}°C)',
        );
      }
    }

    // 공식 기준값 (adult 기준) + 총 보정
    final baseThreshold = season.isHeat ? AppConstants.heatAlert : AppConstants.coldAlert;
    final personalThreshold = baseThreshold + totalOffset;

    final feelsLike = weather.feelsLike;
    final personalRiskLevel = season.isHeat
        ? _heatRiskLevel(feelsLike, totalOffset)
        : _coldRiskLevel(feelsLike, totalOffset);

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

  /// 폭염 개인화 위험단계 — 공식 4단계 임계치에 보정값 적용
  RiskLevel _heatRiskLevel(double feelsLike, double offset) {
    if (feelsLike >= AppConstants.heatDanger  + offset) return RiskLevel.danger;
    if (feelsLike >= AppConstants.heatAlert   + offset) return RiskLevel.warning;
    if (feelsLike >= AppConstants.heatWarning + offset) return RiskLevel.caution;
    return RiskLevel.safe;
  }

  /// 한파 개인화 위험단계 — 공식 4단계 임계치에 보정값 적용 (부등호 반전)
  RiskLevel _coldRiskLevel(double feelsLike, double offset) {
    if (feelsLike <= AppConstants.coldDanger  + offset) return RiskLevel.danger;
    if (feelsLike <= AppConstants.coldAlert   + offset) return RiskLevel.warning;
    if (feelsLike <= AppConstants.coldWarning + offset) return RiskLevel.caution;
    return RiskLevel.safe;
  }

  String _ageKey(int age) {
    if (age <= 9)  return 'infant_0to9';
    if (age <= 17) return 'youth_10to17';
    if (age <= 64) return 'adult_18to64';
    if (age <= 74) return 'elderly_65to74';
    return 'super_elderly_75plus';
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
