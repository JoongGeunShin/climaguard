import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/grid_converter.dart';
import '../../data/datasources/kosis_population_data_source.dart';
import '../../data/datasources/threshold_service.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/entities/age_thresholds.dart';
import '../../domain/entities/region.dart';
import '../../domain/entities/weather_data.dart';
import '../../domain/usecases/regional_risk_projection_use_case.dart';
import 'region_provider.dart';

part 'regional_dashboard_provider.g.dart';

const _ageBucketKeys = [
  'infant_0to9',
  'youth_10to17',
  'adult_18to64',
  'elderly_65to74',
  'super_elderly_75plus',
];

const _emptyProjection = RegionRiskProjection(
    totalPopulation: 0, danger: 0, warning: 0, caution: 0, safe: 0);

/// 지정한 시/군(cityName) 또는 읍면동(code) 하나의 인구 기반 위험도
/// 투영(실시간 조회). null이면 경기도 전체. 캐시에 없는 지역은 KOSIS를 직접
/// 호출하므로, 사용자가 실제로 그 시/동을 선택했을 때만 watch해야 한다 —
/// 경기도 전체 지도를 한 번에 색칠하는 용도로는
/// [regionRiskProjectionCacheOnlyProvider]를 쓸 것 (602개 읍면동을 한꺼번에
/// 호출하는 걸 피하기 위함).
///
/// keepAlive — autoDispose였다면 지도 색칠(동 단위)과 통계 카드(시 단위)가
/// 같은 동을 서로 다른 scopeKey로 각각 구독하다가, 어느 한쪽 위젯이 잠깐
/// 사라지는 순간 provider가 폐기·재생성되면서 실패했던 조회를 계속
/// 처음부터 다시 시도하게 된다. 세션 동안 살려둬서 중복 호출을 줄인다.
@Riverpod(keepAlive: true)
Future<RegionRiskProjection> regionRiskProjection(
    Ref ref, String? scopeKey) async {
  final kosis = ref.read(kosisPopulationDataSourceProvider);
  final weatherRepo = ref.watch(weatherRepositoryProvider);
  return _project(
    ref,
    scopeKey,
    (code) => kosis.loadAgeBuckets(code),
    (nx, ny) => weatherRepo.getCurrentWeather(nx: nx, ny: ny),
    batchSize: 5,
  );
}

/// 경기도 전체 지도를 색칠할 때 쓰는 버전 — 인구는 KOSIS를 호출하지 않고
/// 이미 Firestore에 캐시된 값만 합산한다. 사용자가 시/동을 실제로 클릭해서
/// [regionRiskProjectionProvider]가 호출·캐싱한 지역만 점진적으로 색이
/// 채워지고, 아직 아무도 조회하지 않은 지역은 데이터 없음으로 남는다.
///
/// 날씨는 인구와 달리 스코프당 격자 1개만 조회하면 되므로(경기도 전체=1개,
/// 시/군 지도 색칠=최대 31개) 캐시 미스여도 실시간으로 가져온다 — 그렇지
/// 않으면 이 스코프들이 쓰는 평균 중심좌표 격자는 어떤 사용자의 실제 위치와도
/// 우연히 겹치지 않는 한 캐시에 채워질 계기가 없어, 인구가 아무리 캐싱돼도
/// 날씨 캐시 미스 때문에 항상 빈 결과가 나온다. KMA 호출 결과는 L1(메모리)
/// +L2(Firestore, 발표 시각 단위) 캐시로 공유되므로 같은 발표 슬롯 안에서는
/// 재호출되지 않는다.
@Riverpod(keepAlive: true)
Future<RegionRiskProjection> regionRiskProjectionCacheOnly(
    Ref ref, String? scopeKey) async {
  final kosis = ref.read(kosisPopulationDataSourceProvider);
  final weatherRepo = ref.watch(weatherRepositoryProvider);
  return _project(
    ref,
    scopeKey,
    (code) => kosis.peekCachedAgeBuckets(code),
    (nx, ny) => weatherRepo.getCurrentWeather(nx: nx, ny: ny),
    // 인구는 로컬 Firestore 캐시만 읽으므로 KOSIS 레이트리밋과 무관 — 전부 병렬로 조회한다.
    batchSize: _unboundedBatchSize,
  );
}

const _unboundedBatchSize = 1 << 30;

Future<RegionRiskProjection> _project(
  Ref ref,
  String? scopeKey,
  Future<Map<String, int>> Function(String regionCode) fetchBuckets,
  Future<WeatherData> Function(int nx, int ny) fetchWeather, {
  required int batchSize,
}) async {
  final allRegions = await ref.watch(gyeonggiRegionsProvider.future);
  // scopeKey는 시/군 이름(예: "성남시") 또는 읍면동 코드(예: "4182035000")
  // 둘 중 하나일 수 있다 — 시 이름으로 먼저 매칭해보고, 안 되면 동 코드
  // 하나로 매칭한다. 이 매칭이 빠지면(예전 버그) 동 단위 조회 시 dongs가
  // 항상 비어서 KOSIS를 아예 호출하지 않고 조용히 빈 값만 반환하게 된다.
  final dongs = scopeKey == null
      ? allRegions
      : allRegions
          .where((r) => r.cityName == scopeKey || r.code == scopeKey)
          .toList();

  if (dongs.isEmpty) return _emptyProjection;

  // 동시에 너무 많은 요청을 보내면 KOSIS가 레이트리밋으로 에러를 돌려주고,
  // 그게 "인구 0"으로 잘못 캐싱될 위험이 있다 — 실시간 조회 경로(batchSize=5)만
  // 해당하고, 캐시 전용 조회는 [_unboundedBatchSize]를 넘겨받아 한 번에 처리한다.
  final bucketResults = <Map<String, int>>[];
  for (var i = 0; i < dongs.length; i += batchSize) {
    final batch = dongs.skip(i).take(batchSize);
    bucketResults.addAll(await Future.wait(batch.map((d) => fetchBuckets(d.code))));
  }
  final ageBuckets = {for (final k in _ageBucketKeys) k: 0};
  for (final buckets in bucketResults) {
    for (final entry in buckets.entries) {
      ageBuckets[entry.key] = (ageBuckets[entry.key] ?? 0) + entry.value;
    }
  }
  if (ageBuckets.values.every((v) => v == 0)) return _emptyProjection;

  // 대표 좌표(산하 읍면동 중심점의 평균)로 그 지역의 현재 날씨를 조회.
  final centroid = _averageCentroid(dongs);
  final grid = GridConverter.toGrid(centroid.lat, centroid.lng);
  final weather = await fetchWeather(grid.nx, grid.ny);

  final base = await ref.watch(baseThresholdsProvider.future);
  final offsetResults = await Future.wait(
      _ageBucketKeys.map((k) => ref.watch(ageOffsetsProvider(k).future)));
  final ageOffsetsByKey = <String, AgeOffsets>{
    for (var i = 0; i < _ageBucketKeys.length; i++)
      _ageBucketKeys[i]: offsetResults[i],
  };

  return RegionalRiskProjectionUseCase().project(
    ageBuckets: ageBuckets,
    weather: weather,
    base: base,
    ageOffsetsByKey: ageOffsetsByKey,
  );
}

GeoPoint _averageCentroid(List<RegionBoundary> dongs) {
  double latSum = 0, lngSum = 0;
  for (final d in dongs) {
    final c = d.centroid;
    latSum += c.lat;
    lngSum += c.lng;
  }
  return (lat: latSum / dongs.length, lng: lngSum / dongs.length);
}
