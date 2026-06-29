import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/risk_level.dart';
import '../../domain/entities/season.dart';
import '../../domain/entities/weather_data.dart';
import '../models/weather_forecast_response.dart';
import 'dio_provider.dart';

part 'weather_remote_data_source.g.dart';

@Riverpod(keepAlive: true)
WeatherRemoteDataSource weatherRemoteDataSource(Ref ref) {
  return WeatherRemoteDataSource(ref.watch(dioProvider));
}

class WeatherRemoteDataSource {
  WeatherRemoteDataSource(this._dio);

  final Dio _dio;

  Future<WeatherData> fetchCurrentWeather({
    required int nx,
    required int ny,
  }) async {
    final now = DateTime.now();
    final season = Season.fromMonth(now.month);
    final (:date, :time) = _resolveBaseDateTime(now);

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${AppConstants.weatherBaseUrl}${AppConstants.shortForecastPath}',
        queryParameters: {
          'serviceKey': Uri.decodeComponent(dotenv.env['KMA_API_KEY'] ?? ''),
          'numOfRows': 100,
          'pageNo': 1,
          'dataType': 'JSON',
          'base_date': date,
          'base_time': time,
          'nx': nx,
          'ny': ny,
        },
      );

      final parsed = WeatherForecastResponse.fromJson(response.data!);
      return _toWeatherData(parsed.response.body.items.items, now, season);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 429) {
        throw Exception('API 요청 한도를 초과했습니다. 잠시 후 다시 시도해주세요.');
      }
      if (status == 401 || status == 403) {
        throw Exception('날씨 API 인증에 실패했습니다. API 키를 확인해주세요.');
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('날씨 서버 응답이 없습니다. 네트워크 상태를 확인해주세요.');
      }
      throw Exception('날씨 정보를 불러오지 못했습니다. (${status ?? e.type.name})');
    }
  }

  WeatherData _toWeatherData(
    List<WeatherForecastItem> items,
    DateTime at,
    Season season,
  ) {
    double temperature = 0;
    int humidity = 0;
    double windSpeed = 0;

    for (final item in items) {
      switch (item.category) {
        case 'TMP':
          temperature = double.tryParse(item.fcstValue) ?? 0;
        case 'REH':
          humidity = int.tryParse(item.fcstValue) ?? 0;
        case 'WSD':
          windSpeed = double.tryParse(item.fcstValue) ?? 0;
      }
    }

    final feelsLike = season.isHeat
        ? _heatFeelsLike(temperature, humidity)
        : _coldFeelsLike(temperature, windSpeed);

    final officialRisk = season.isHeat
        ? _heatOfficialRisk(feelsLike)
        : _coldOfficialRisk(feelsLike);

    return WeatherData(
      temperature: temperature,
      feelsLike: feelsLike,
      humidity: humidity,
      windSpeed: windSpeed,
      officialRiskLevel: officialRisk,
      season: season,
      observedAt: at,
      nextUpdateAt: at.add(const Duration(hours: 1)),
    );
  }

  /// 폭염 체감온도 — Steadman 간이식 (기온 27°C 이상에서 유효)
  double _heatFeelsLike(double t, int reh) {
    if (t < 27) return t;
    return -8.784695 +
        1.61139411 * t +
        2.338549 * reh -
        0.14611605 * t * reh -
        0.012308094 * t * t -
        0.016424828 * reh * reh +
        0.002211732 * t * t * reh +
        0.00072546 * t * reh * reh -
        0.000003582 * t * t * reh * reh;
  }

  /// 한파 체감온도 — 기상청 공식 WindChill (기온 10°C 이하, 풍속 1 m/s 이상)
  /// 공식: 13.12 + 0.6215×T - 11.37×V^0.16 + 0.3965×T×V^0.16  (V: km/h)
  double _coldFeelsLike(double t, double wsdMs) {
    if (t > 10 || wsdMs < 1) return t;
    final vKmh = wsdMs * 3.6;
    final v16 = pow(vKmh, 0.16).toDouble();
    return 13.12 + 0.6215 * t - 11.37 * v16 + 0.3965 * t * v16;
  }

  RiskLevel _heatOfficialRisk(double feelsLike) {
    if (feelsLike >= AppConstants.heatDanger)  return RiskLevel.danger;
    if (feelsLike >= AppConstants.heatAlert)   return RiskLevel.warning;
    if (feelsLike >= AppConstants.heatWarning) return RiskLevel.caution;
    return RiskLevel.safe;
  }

  RiskLevel _coldOfficialRisk(double feelsLike) {
    if (feelsLike <= AppConstants.coldDanger)  return RiskLevel.danger;
    if (feelsLike <= AppConstants.coldAlert)   return RiskLevel.warning;
    if (feelsLike <= AppConstants.coldWarning) return RiskLevel.caution;
    return RiskLevel.safe;
  }

  // 단기예보 발표 시각: 매 3시간 (0200, 0500, 0800, 1100, 1400, 1700, 2000, 2300)
  // 발표 후 약 10분 뒤 제공되므로 현재 시각에서 10분을 빼고 판단
  ({String date, String time}) _resolveBaseDateTime(DateTime now) {
    const baseTimes = [2, 5, 8, 11, 14, 17, 20, 23];
    final dt = now.subtract(const Duration(minutes: 10));
    final hour = dt.hour;

    int baseHour;
    bool useYesterday;

    if (hour < 2) {
      baseHour = 23;
      useYesterday = true;
    } else {
      baseHour = baseTimes.lastWhere((h) => h <= hour);
      useYesterday = false;
    }

    final baseDate =
        useYesterday ? dt.subtract(const Duration(days: 1)) : dt;

    return (
      date: _formatDate(baseDate),
      time: '${baseHour.toString().padLeft(2, '0')}00',
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.year}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}';
}
