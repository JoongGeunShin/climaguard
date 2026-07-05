import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/geojson_loader.dart';
import '../../domain/entities/region.dart';

part 'region_provider.g.dart';

@riverpod
Future<List<RegionBoundary>> gyeonggiRegions(Ref ref) {
  return GeoJsonLoader.loadGyeonggiDong();
}

/// 온보딩 1단계·대시보드 도(道) 지도에서 쓰는 경기도 31개 시/군 이름 목록.
@riverpod
Future<List<String>> gyeonggiCities(Ref ref) async {
  final regions = await ref.watch(gyeonggiRegionsProvider.future);
  final cities = regions.map((r) => r.cityName).toSet().toList()..sort();
  return cities;
}

/// 특정 시/군에 속한 읍면동 목록 (온보딩 2단계·대시보드 시 지도용).
@riverpod
Future<List<RegionBoundary>> dongsInCity(Ref ref, String cityName) async {
  final regions = await ref.watch(gyeonggiRegionsProvider.future);
  final dongs = regions.where((r) => r.cityName == cityName).toList()
    ..sort((a, b) => a.name.compareTo(b.name));
  return dongs;
}
