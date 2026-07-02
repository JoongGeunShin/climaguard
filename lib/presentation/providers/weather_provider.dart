import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/feels_like_calculator.dart';
import '../../core/utils/grid_converter.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/entities/risk_level.dart';
import '../../domain/entities/season.dart';
import '../../domain/entities/weather_data.dart';
import 'debug_provider.dart';
import 'location_provider.dart';

part 'weather_provider.g.dart';

@Riverpod(keepAlive: true)
Future<WeatherData> weather(WeatherRef ref) async {
  // 디버그 override가 설정된 경우 API 호출 없이 즉시 반환
  if (kDebugMode) {
    final override = ref.watch(debugTemperatureOverrideProvider);
    if (override != null) {
      // override 값은 실제 기온(°C) — 체감온도는 Steadman/WindChill 공식으로 계산
      final season = Season.fromTemperature(override);
      const debugHumidity = 40;   // 한국 여름 평균 습도 기준
      const debugWindMs   = 2.0;
      final feelsLike = season.isHeat
          ? FeelsLikeCalculator.heat(override, debugHumidity)
          : season.isCold
              ? FeelsLikeCalculator.cold(override, debugWindMs)
              : override;
      final officialRisk = _debugOfficialRisk(feelsLike, season);
      return WeatherData(
        temperature: override,
        feelsLike: feelsLike,
        humidity: debugHumidity,
        windSpeed: debugWindMs,
        officialRiskLevel: officialRisk,
        season: season,
        observedAt: DateTime.now(),
      );
    }
  }

  final position = await ref.watch(locationProvider.future);
  final grid = GridConverter.toGrid(position.latitude, position.longitude);
  final repo = ref.watch(weatherRepositoryProvider);
  return repo.getCurrentWeather(nx: grid.nx, ny: grid.ny);
}

RiskLevel _debugOfficialRisk(double temp, Season season) {
  if (season.isHeat) {
    if (temp >= AppConstants.heatDanger)   return RiskLevel.danger;
    if (temp >= AppConstants.heatAlert)    return RiskLevel.warning;
    if (temp >= AppConstants.heatWarning)  return RiskLevel.caution;
    if (temp >= AppConstants.heatCaution)  return RiskLevel.attention;
    return RiskLevel.safe;
  }
  if (season.isCold) {
    if (temp <= AppConstants.coldDanger)   return RiskLevel.danger;
    if (temp <= AppConstants.coldAlert)    return RiskLevel.warning;
    if (temp <= AppConstants.coldWarning)  return RiskLevel.caution;
    if (temp <= AppConstants.coldCaution)  return RiskLevel.attention;
    return RiskLevel.safe;
  }
  return RiskLevel.safe;
}
