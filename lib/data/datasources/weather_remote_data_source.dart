import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/feels_like_calculator.dart';
import '../../domain/entities/risk_level.dart';
import '../../domain/entities/season.dart';
import '../../domain/entities/weather_data.dart';
import '../models/weather_forecast_response.dart';
import 'dio_provider.dart';
import 'weather_cache_service.dart';

part 'weather_remote_data_source.g.dart';

@Riverpod(keepAlive: true)
WeatherRemoteDataSource weatherRemoteDataSource(Ref ref) {
  return WeatherRemoteDataSource(
    ref.watch(dioProvider),
    ref.watch(weatherCacheServiceProvider),
  );
}

class WeatherRemoteDataSource {
  WeatherRemoteDataSource(this._dio, this._cache);

  final Dio _dio;
  final WeatherCacheService _cache;

  // L1: 인메모리 캐시 (세션 내 재호출 방지)
  WeatherData? _memCache;
  String? _memBaseKey;

  Future<WeatherData> fetchCurrentWeather({
    required int nx,
    required int ny,
  }) async {
    final now = DateTime.now();
    final (:date, :time) = _resolveBaseDateTime(now);
    final baseKey = '${date}_$time';

    // L1: 인메모리
    if (_memCache != null && _memBaseKey == baseKey) return _memCache!;

    // L2: Firestore (사용자 간 공유 캐시)
    final cached = await _cache.read(nx, ny, baseKey);
    if (cached != null) {
      _memCache = cached;
      _memBaseKey = baseKey;
      return cached;
    }

    // L3: KMA API 호출
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

      _checkKmaHeader(response.data!);
      final parsed = WeatherForecastResponse.fromJson(response.data!);
      final result = _toWeatherData(parsed.response.body.items.items, now);

      _memCache = result;
      _memBaseKey = baseKey;
      _cache.write(nx, ny, baseKey, result); // 백그라운드 저장
      return result;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 429) {
        throw Exception('API 요청 한도를 초과했습니다. 잠시 후 다시 시도해주세요.');
      }
      if (status == 401 || status == 403) {
        throw Exception('날씨 API 인증에 실패했습니다. API 키를 확인해주세요.');
      }
      if (status == 502 || status == 503) {
        throw Exception('기상청 서버가 일시적으로 응답하지 않습니다. 잠시 후 다시 시도해주세요.');
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

    // 기온으로 시즌 결정: >24°C 더위, <14°C 추위, 그 외 적정
    final season = Season.fromTemperature(temperature);

    final feelsLike = switch (season) {
      Season.heat   => FeelsLikeCalculator.heat(temperature, humidity),
      Season.cold   => FeelsLikeCalculator.cold(temperature, windSpeed),
      Season.normal => temperature,
    };

    final officialRisk = switch (season) {
      Season.heat   => _heatOfficialRisk(feelsLike),
      Season.cold   => _coldOfficialRisk(feelsLike),
      Season.normal => RiskLevel.safe,
    };

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

  // 기상청 API는 에러 시에도 HTTP 200을 반환하고 body에 resultCode를 담음
  void _checkKmaHeader(Map<String, dynamic> data) {
    final header = (data['response'] as Map<String, dynamic>?)?['header']
        as Map<String, dynamic>?;
    final code = header?['resultCode'] as String?;
    if (code == null || code == '00') return;

    throw Exception(switch (code) {
      '22' => 'API 요청 한도를 초과했습니다. 잠시 후 다시 시도해주세요.',
      '20' || '21' => '날씨 API 접근이 거부됐습니다. API 키를 확인해주세요.',
      '30' || '31' => '등록되지 않았거나 만료된 API 키입니다.',
      '03' => '해당 지역의 날씨 데이터가 없습니다.',
      '05' => '기상청 서버 응답 시간이 초과됐습니다. 잠시 후 다시 시도해주세요.',
      _ => '날씨 정보를 불러오지 못했습니다. (KMA-$code)',
    });
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
