import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/grid_converter.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/entities/season.dart';
import '../../domain/entities/weather_data.dart';
import 'debug_provider.dart';
import 'location_provider.dart';

part 'weather_provider.g.dart';

@Riverpod(keepAlive: true)
Future<WeatherData> weather(WeatherRef ref) async {
  final position = await ref.watch(locationProvider.future);
  final grid = GridConverter.toGrid(position.latitude, position.longitude);
  final repo = ref.watch(weatherRepositoryProvider);
  final real = await repo.getCurrentWeather(nx: grid.nx, ny: grid.ny);

  if (!kDebugMode) return real;

  final override = ref.watch(debugTemperatureOverrideProvider);
  if (override == null) return real;

  final season = Season.fromTemperature(override);
  return real.copyWith(
    temperature: override,
    feelsLike: override,
    season: season,
  );
}
