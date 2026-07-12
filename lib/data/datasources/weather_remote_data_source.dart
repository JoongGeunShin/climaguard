import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/feels_like_calculator.dart';
import '../../domain/entities/risk_level.dart';
import '../../domain/entities/season.dart';
import '../../domain/entities/weather_data.dart';
import '../models/weather_nowcast_response.dart';
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

  // L1: 인메모리 캐시 (세션 내 재호출 방지) — 반드시 (nx, ny)까지 키에 포함해야
  // 한다. 예전엔 baseKey(발표시각)만으로 판단해서, 원래 "사용자 한 명이 자기
  // 위치만 반복 조회"하는 상황에선 문제가 없었지만, 지자체 대시보드가 여러
  // 지역(nx, ny가 서로 다름)을 같은 세션에서 조회하면서 다른 지역 날씨를
  // 그대로 재사용해버리는 심각한 버그가 있었다.
  final _memCache = <String, WeatherData>{};

  String _memKey(int nx, int ny, String baseKey) => '${nx}_${ny}_$baseKey';

  Future<WeatherData> fetchCurrentWeather({
    required int nx,
    required int ny,
  }) async {
    final now = DateTime.now();
    final (:date, :time) = _resolveUltraSrtBaseDateTime(now);
    final baseKey = '${date}_$time';
    final memKey = _memKey(nx, ny, baseKey);

    // L1: 인메모리
    final memHit = _memCache[memKey];
    if (memHit != null) return memHit;

    // L2: Firestore (사용자 간 공유 캐시)
    final cached = await _cache.read(nx, ny, baseKey);
    if (cached != null) {
      _memCache[memKey] = cached;
      return cached;
    }

    // L3: KMA 초단기실황(getUltraSrtNcst) 호출 — 예보가 아닌 실제 관측값을
    // 반환하므로, 단기예보(getVilageFcst)를 쓸 때처럼 "여러 미래 시각 중
    // 어느 슬롯이 지금인지"를 고민할 필요가 없다.
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${AppConstants.weatherBaseUrl}${AppConstants.ultraSrtNcstPath}',
        queryParameters: {
          'serviceKey': Uri.decodeComponent(dotenv.env['KMA_API_KEY'] ?? ''),
          'numOfRows': 10,
          'pageNo': 1,
          'dataType': 'JSON',
          'base_date': date,
          'base_time': time,
          'nx': nx,
          'ny': ny,
        },
      );

      _checkKmaHeader(response.data!);
      final parsed = WeatherNowcastResponse.fromJson(response.data!);
      final result = _toWeatherData(parsed.response.body.items.items, now);

      _memCache[memKey] = result;
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
    List<WeatherNowcastItem> items,
    DateTime at,
  ) {
    double temperature = 0;
    int humidity = 0;
    double windSpeed = 0;

    for (final item in items) {
      switch (item.category) {
        case 'T1H':
          temperature = double.tryParse(item.obsrValue) ?? 0;
        case 'REH':
          humidity = int.tryParse(item.obsrValue) ?? 0;
        case 'WSD':
          windSpeed = double.tryParse(item.obsrValue) ?? 0;
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

  // 초단기실황 발표 시각: 매시 정각(base_time) 기준, 매시 40분에 생성되어
  // 45분부터 제공된다. 아직 이번 시간 데이터가 생성되지 않았을 45분 이전에는
  // 이전 시간 데이터를 사용해야 한다.
  ({String date, String time}) _resolveUltraSrtBaseDateTime(DateTime now) {
    final dt = now.minute < 45 ? now.subtract(const Duration(hours: 1)) : now;

    return (
      date: _formatDate(dt),
      time: '${dt.hour.toString().padLeft(2, '0')}00',
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.year}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}';
}
