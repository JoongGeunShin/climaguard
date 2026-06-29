import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/weather_data.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_data_source.dart';

part 'weather_repository_impl.g.dart';

@Riverpod(keepAlive: true)
WeatherRepository weatherRepository(Ref ref) {
  return WeatherRepositoryImpl(ref.watch(weatherRemoteDataSourceProvider));
}

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl(this._dataSource);

  final WeatherRemoteDataSource _dataSource;

  @override
  Future<WeatherData> getCurrentWeather({
    required int nx,
    required int ny,
  }) {
    return _dataSource.fetchCurrentWeather(nx: nx, ny: ny);
  }
}
