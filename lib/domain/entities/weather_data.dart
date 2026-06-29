import 'package:freezed_annotation/freezed_annotation.dart';
import 'risk_level.dart';
import 'season.dart';

part 'weather_data.freezed.dart';

@freezed
abstract class WeatherData with _$WeatherData {
  const factory WeatherData({
    required double temperature,        // 기온 (°C)
    required double feelsLike,          // 체감온도 — 폭염:Steadman / 한파:WindChill
    required int humidity,              // 습도 (%)
    required double windSpeed,          // 풍속 (m/s) — 한파 체감온도 계산용
    required RiskLevel officialRiskLevel,
    required Season season,             // 폭염/한파 모드
    required DateTime observedAt,
    int? heatwaveDays,
    DateTime? nextUpdateAt,
  }) = _WeatherData;
}
