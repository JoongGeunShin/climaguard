import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/utils/grid_converter.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/entities/weather_data.dart';
import 'location_provider.dart';

part 'weather_provider.g.dart';

@Riverpod(keepAlive: true)
Future<WeatherData> weather(WeatherRef ref) async {
  final position = await ref.watch(locationProvider.future);
  final grid = GridConverter.toGrid(position.latitude, position.longitude);
  final repo = ref.watch(weatherRepositoryProvider);
  return repo.getCurrentWeather(nx: grid.nx, ny: grid.ny);
}
