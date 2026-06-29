import 'package:freezed_annotation/freezed_annotation.dart';
import 'risk_level.dart';
import 'season.dart';

part 'climate_alert.freezed.dart';

@freezed
abstract class ClimateAlert with _$ClimateAlert {
  const factory ClimateAlert({
    required Season season,
    required RiskLevel personalRiskLevel,
    required RiskLevel officialRiskLevel,
    required double personalThreshold, // 최종 보정된 개인 임계치
    required double currentFeelsLike,  // 현재 체감온도 (폭염/한파 공용)
    required List<String> adjustmentReasons,
    required DateTime generatedAt,
  }) = _ClimateAlert;
}
