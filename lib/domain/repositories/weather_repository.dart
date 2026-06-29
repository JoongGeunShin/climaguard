import '../entities/weather_data.dart';

abstract interface class WeatherRepository {
  /// 현재 위치 기준 날씨 조회 (nx, ny: 기상청 격자 좌표)
  Future<WeatherData> getCurrentWeather({
    required int nx,
    required int ny,
  });
}
