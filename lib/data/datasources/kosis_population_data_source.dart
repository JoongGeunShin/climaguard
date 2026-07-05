import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_provider.dart';

part 'kosis_population_data_source.g.dart';

@Riverpod(keepAlive: true)
KosisPopulationDataSource kosisPopulationDataSource(Ref ref) {
  return KosisPopulationDataSource(ref.watch(dioProvider), FirebaseFirestore.instance);
}

/// 통계청 KOSIS 공유서비스로 행정동 단위 5세별 주민등록인구를 조회한다.
///
/// 테이블: orgId=101, tblId=DT_1B04005N
/// ("행정구역(읍면동)별/5세별 주민등록인구") — 실제 발급받은 키로 호출해
/// 확인한 값들:
///   - itmId=T2 → 총인구수 (T3=남자, T4=여자)
///   - objL1 → 10자리 행정동코드. GeoJSON의 adm_cd2와 동일 체계임을 실제로
///     확인함(예: 종로구 사직동 = "1111053000", 양쪽 동일).
///   - objL2 → 5세 단위 연령 코드. "0"=계(전체 합계, 제외해야 함),
///     "5"=0~4세, "10"=5~9세, ... "100"=95~99세, "105"=100세 이상
///     (코드 = (5년 단위 밴드 인덱스+1) * 5, 마지막 "105"만 개방형 최상위 구간)
///
/// KOSIS는 SGIS와 달리 인증키 하나(apiKey)만 쓰고 별도 서비스ID/토큰 발급이 없다.
class KosisPopulationDataSource {
  KosisPopulationDataSource(this._dio, this._db);

  final Dio _dio;
  final FirebaseFirestore _db;

  static const _dataUrl =
      'https://kosis.kr/openapi/Param/statisticsParameterData.do';
  static const _orgId = '101';
  static const _tblId = 'DT_1B04005N';
  static const _totalPopulationItmId = 'T2';
  static const _cacheTtl = Duration(days: 30);
  static const _cacheCollection = 'populationCache';

  bool get _hasKey => (dotenv.env['KOSIS_API_KEY'] ?? '').isNotEmpty;

  /// 5개 연령 버킷(infant_0to9 등)별 인구수를 반환한다. 캐시에 없으면 KOSIS를
  /// 실제로 호출해서 채운다 — 사용자가 그 지역을 직접 조회할 때(시/동 드릴다운)만
  /// 불러야 한다. 지도 전체를 한 번에 색칠하는 등 대량 병렬 호출이 필요한
  /// 곳에서는 절대 쓰지 말고 [peekCachedAgeBuckets]를 쓸 것.
  /// 키 미설정·조회 실패 시 빈 맵 — 호출부는 "인구 데이터 없음"으로 처리해야 한다.
  Future<Map<String, int>> loadAgeBuckets(String regionCode) async {
    final cached = await _readCache(regionCode);
    if (cached != null) return cached;
    if (!_hasKey) return {};

    try {
      final bands = await _fetchLatestAgeBands(regionCode);
      final buckets = _toAgeBuckets(bands);
      await _writeCache(regionCode, buckets);
      return buckets;
    } catch (e, st) {
      debugPrint('[KOSIS] $regionCode 조회 실패: $e');
      if (e is DioException) {
        debugPrint('[KOSIS] $regionCode DioException type=${e.type} '
            'status=${e.response?.statusCode} data=${e.response?.data} '
            'message=${e.message}');
      } else {
        debugPrint('[KOSIS] $regionCode stack: $st');
      }
      return {};
    }
  }

  /// KOSIS를 호출하지 않고 Firestore 캐시만 확인한다 — 아직 아무도 조회한 적
  /// 없는 지역이면 빈 맵을 반환한다. 경기도 전체 지도처럼 한 번에 수백 개
  /// 지역을 다뤄야 하는 화면에서, 실제 API 호출은 사용자가 그 지역을
  /// 클릭했을 때만 [loadAgeBuckets]로 하고 그 결과가 캐시에 쌓이길 기다리는
  /// "점진적 데이터 축적" 방식에 쓴다.
  Future<Map<String, int>> peekCachedAgeBuckets(String regionCode) async {
    return await _readCache(regionCode) ?? {};
  }

  /// 최근 3개월 범위로 조회한 뒤, 실제로 값이 있는 가장 최신 달만 골라낸다
  /// (주민등록인구 통계는 발표까지 1~2개월 시차가 있어 "이번 달"을 바로
  /// 조회하면 빈 응답이 나올 수 있다).
  Future<List<({int ageFrom, int ageTo, int population})>>
      _fetchLatestAgeBands(String regionCode) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 2);
    final startPrd =
        '${start.year}${start.month.toString().padLeft(2, '0')}';
    final endPrd = '${now.year}${now.month.toString().padLeft(2, '0')}';

    // KOSIS는 실제로는 JSON을 내려주면서 응답 헤더의 Content-Type을
    // "text/html"로 잘못 표기한다. Dio는 이 헤더를 믿고 JSON 자동 파싱을
    // 건너뛰어 res.data가 원본 문자열로만 남는다 — 그러면 아래 `rows is! List`
    // 체크에 걸려 정상 응답인데도 "데이터 없음"으로 오판된다. 그래서 항상
    // plain 텍스트로 강제로 받은 뒤 직접 jsonDecode 한다.
    final res = await _dio.get<String>(
      _dataUrl,
      queryParameters: {
        'method': 'getList',
        'apiKey': dotenv.env['KOSIS_API_KEY'],
        'orgId': _orgId,
        'tblId': _tblId,
        'itmId': _totalPopulationItmId,
        'objL1': regionCode,
        'objL2': 'ALL',
        'format': 'json',
        'jsonVD': 'Y',
        'prdSe': 'M',
        'startPrdDe': startPrd,
        'endPrdDe': endPrd,
      },
      options: Options(responseType: ResponseType.plain),
    );

    final rows = jsonDecode(res.data ?? '');
    // KOSIS는 실패 시(레이트리밋 등) 배열이 아니라 {"err":"..","errMsg":".."}
    // 형태의 에러 객체를 200 OK로 내려준다. 이걸 "데이터 없음"으로 오인해 그대로
    // 진행하면 0명짜리 버킷이 "정상 조회 결과"로 캐싱되어 버린다 — 반드시 구분해서
    // 예외를 던져야 바깥의 catch가 캐시 저장을 건너뛴다.
    if (rows is Map) {
      throw Exception('KOSIS error for $regionCode: ${rows['errMsg'] ?? rows}');
    }
    if (rows is! List || rows.isEmpty) {
      throw Exception('KOSIS returned no rows for $regionCode');
    }

    final latestPrd = rows
        .map((r) => (r as Map<String, dynamic>)['PRD_DE'] as String)
        .reduce((a, b) => a.compareTo(b) > 0 ? a : b);

    return rows
        .cast<Map<String, dynamic>>()
        .where((r) => r['PRD_DE'] == latestPrd && r['C2'] != '0')
        .map((r) {
      final ageCode = int.parse(r['C2'] as String);
      final population = int.tryParse('${r['DT']}') ?? 0;
      if (ageCode == 105) {
        return (ageFrom: 100, ageTo: 120, population: population);
      }
      return (ageFrom: ageCode - 5, ageTo: ageCode - 1, population: population);
    }).toList();
  }

  /// 5세 단위 인구를 기존 5개 연령 버킷으로 배분한다. 버킷 경계와 겹치는 5세
  /// 구간(예: 15~19세)은 구간 내 연령이 균등 분포한다고 가정해 나이 수 비율로 쪼갠다.
  Map<String, int> _toAgeBuckets(
      List<({int ageFrom, int ageTo, int population})> bands) {
    final buckets = <String, double>{
      'infant_0to9': 0,
      'youth_10to17': 0,
      'adult_18to64': 0,
      'elderly_65to74': 0,
      'super_elderly_75plus': 0,
    };
    for (final band in bands) {
      final ageCount = band.ageTo - band.ageFrom + 1;
      if (ageCount <= 0) continue;
      final perAge = band.population / ageCount;
      for (var age = band.ageFrom; age <= band.ageTo; age++) {
        final key = _bucketFor(age);
        buckets[key] = buckets[key]! + perAge;
      }
    }
    return buckets.map((k, v) => MapEntry(k, v.round()));
  }

  String _bucketFor(int age) {
    if (age <= 9) return 'infant_0to9';
    if (age <= 17) return 'youth_10to17';
    if (age <= 64) return 'adult_18to64';
    if (age <= 74) return 'elderly_65to74';
    return 'super_elderly_75plus';
  }

  Future<Map<String, int>?> _readCache(String regionCode) async {
    try {
      final snap = await _db.collection(_cacheCollection).doc(regionCode).get();
      if (!snap.exists) return null;
      final data = snap.data()!;
      final cachedAt = (data['cachedAt'] as Timestamp?)?.toDate();
      if (cachedAt == null || DateTime.now().difference(cachedAt) > _cacheTtl) {
        return null;
      }
      final buckets = data['buckets'] as Map<String, dynamic>;
      final parsed = buckets.map((k, v) => MapEntry(k, (v as num).toInt()));
      // 실제 인구가 있는 읍면동이 전부 0으로 캐싱된 경우는 과거 버그로 오염된
      // 데이터일 뿐이므로 "캐시 없음" 취급해 재조회를 유도한다(자가 치유).
      if (parsed.values.every((v) => v == 0)) return null;
      return parsed;
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeCache(String regionCode, Map<String, int> buckets) async {
    try {
      await _db.collection(_cacheCollection).doc(regionCode).set({
        'buckets': buckets,
        'cachedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // 캐시 저장 실패는 조회 결과에 영향 없음
    }
  }
}
