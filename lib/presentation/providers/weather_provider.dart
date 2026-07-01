import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
      final season = Season.fromTemperature(override);
      return WeatherData(
        temperature: override,
        feelsLike: override,
        humidity: 60,
        windSpeed: 2.0,
        officialRiskLevel: RiskLevel.safe,
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
