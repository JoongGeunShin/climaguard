import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/risk_level.dart';
import '../../domain/entities/season.dart';
import '../../domain/entities/weather_data.dart';

part 'weather_cache_service.g.dart';

@Riverpod(keepAlive: true)
WeatherCacheService weatherCacheService(Ref ref) {
  return WeatherCacheService(FirebaseFirestore.instance);
}

/// Firestore 기반 날씨 캐시 서비스
///
/// 컬렉션: weatherCache / 문서 ID: {nx}_{ny}
/// baseKey(발표 시각)가 동일하면 캐시 히트 → KMA API 미호출
class WeatherCacheService {
  WeatherCacheService(this._db);

  final FirebaseFirestore _db;
  static const _collection = 'weatherCache';

  DocumentReference<Map<String, dynamic>> _doc(int nx, int ny) =>
      _db.collection(_collection).doc('${nx}_$ny');

  Future<WeatherData?> read(int nx, int ny, String baseKey) async {
    try {
      final snap = await _doc(nx, ny).get();
      if (!snap.exists) return null;
      final m = snap.data()!;
      if (m['baseKey'] != baseKey) return null;
      return _fromMap(m);
    } catch (_) {
      return null;
    }
  }

  Future<void> write(int nx, int ny, String baseKey, WeatherData data) async {
    try {
      await _doc(nx, ny).set({
        'baseKey': baseKey,
        'temperature': data.temperature,
        'feelsLike': data.feelsLike,
        'humidity': data.humidity,
        'windSpeed': data.windSpeed,
        'officialRiskLevel': data.officialRiskLevel.name,
        'season': data.season.name,
        'observedAt': data.observedAt.toIso8601String(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // 캐시 저장 실패는 날씨 조회에 영향 없음
    }
  }

  WeatherData _fromMap(Map<String, dynamic> m) => WeatherData(
        temperature: (m['temperature'] as num).toDouble(),
        feelsLike: (m['feelsLike'] as num).toDouble(),
        humidity: m['humidity'] as int,
        windSpeed: (m['windSpeed'] as num).toDouble(),
        officialRiskLevel: _parseRiskLevel(m['officialRiskLevel']),
        season: _parseSeason(m['season']),
        observedAt: DateTime.parse(m['observedAt'] as String),
      );

  // 구버전(int 인덱스)·신버전(String name) 캐시 모두 처리
  static RiskLevel _parseRiskLevel(dynamic v) {
    if (v is String) {
      return RiskLevel.values.firstWhere((e) => e.name == v,
          orElse: () => RiskLevel.safe);
    }
    if (v is int) {
      const legacy = [
        RiskLevel.safe, RiskLevel.caution, RiskLevel.warning, RiskLevel.danger
      ];
      return (v >= 0 && v < legacy.length) ? legacy[v] : RiskLevel.safe;
    }
    return RiskLevel.safe;
  }

  static Season _parseSeason(dynamic v) {
    if (v is String) {
      return Season.values.firstWhere((e) => e.name == v,
          orElse: () => Season.normal);
    }
    if (v is int) {
      return (v >= 0 && v < Season.values.length)
          ? Season.values[v]
          : Season.normal;
    }
    return Season.normal;
  }
}
