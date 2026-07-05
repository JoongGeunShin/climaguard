import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../domain/entities/region.dart';

/// `assets/geo/gyeonggi_emd.geojson`(경기도 읍면동 경계, vuski/admdongkor 출처)을
/// 파싱한다. 파일이 크지 않고 화면 세션 동안 바뀌지 않으므로 메모리에 캐싱한다.
abstract final class GeoJsonLoader {
  static List<RegionBoundary>? _cache;

  static Future<List<RegionBoundary>> loadGyeonggiDong() async {
    if (_cache != null) return _cache!;
    final raw =
        await rootBundle.loadString('assets/geo/gyeonggi_emd.geojson');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final features = data['features'] as List;
    final regions = features
        .map((f) => _parseFeature(f as Map<String, dynamic>))
        .toList();
    _cache = regions;
    return regions;
  }

  static RegionBoundary _parseFeature(Map<String, dynamic> feature) {
    final props = feature['properties'] as Map<String, dynamic>;
    final geometry = feature['geometry'] as Map<String, dynamic>;
    final type = geometry['type'] as String;
    final coords = geometry['coordinates'] as List;

    final rings = <List<GeoPoint>>[];
    if (type == 'Polygon') {
      for (final ring in coords) {
        rings.add(_parseRing(ring as List));
      }
    } else if (type == 'MultiPolygon') {
      for (final polygon in coords) {
        for (final ring in polygon as List) {
          rings.add(_parseRing(ring as List));
        }
      }
    }

    return RegionBoundary(
      code: props['code'] as String,
      name: props['name'] as String,
      sggName: props['sggName'] as String,
      cityName: props['cityName'] as String,
      rings: rings,
    );
  }

  // GeoJSON 좌표 순서는 [lng, lat].
  static List<GeoPoint> _parseRing(List ring) {
    return ring.map((point) {
      final p = point as List;
      return (lat: (p[1] as num).toDouble(), lng: (p[0] as num).toDouble());
    }).toList();
  }
}
