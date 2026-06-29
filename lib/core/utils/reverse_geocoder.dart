import 'package:dio/dio.dart';

import '../../../core/constants/app_constants.dart';

/// 행정구역 3단계 구조
///
/// - region1: 광역지방자치단체 (서울특별시, 경기도, 부산광역시 …)
/// - region2: 기초자치단체·행정구 (강남구, 성남시 수정구, 수원시 영통구 …)
/// - region3: 읍·면·동 (삼성동, 위례동, 양평읍 …)
///
/// [display]     → 헤더 표시용: region2 + region3 ("성남시 수정구 위례동")
/// [displayFull] → 전체: region1 + region2 + region3
class AdminDistrict {
  final String region1;
  final String region2;
  final String region3;

  const AdminDistrict({
    required this.region1,
    required this.region2,
    required this.region3,
  });

  /// 헤더·지도 표시용 — 1단계(광역) 생략, 2+3단계만 노출
  String get display =>
      [region2, region3].where((s) => s.isNotEmpty).join(' ');

  /// 전체 주소 (보조 UI, 공유 등에 사용)
  String get displayFull =>
      [region1, region2, region3].where((s) => s.isNotEmpty).join(' ');

  @override
  String toString() => displayFull;
}

/// 도로명 주소 구조
class RoadAddress {
  /// 전체 도로명 주소 문자열
  final String full;
  final String? sido;
  final String? sigungu;
  final String? roadName;
  final String? buildingNo;

  const RoadAddress({
    required this.full,
    this.sido,
    this.sigungu,
    this.roadName,
    this.buildingNo,
  });

  @override
  String toString() => full;
}

/// 위경도 → 한국 주소 변환 유틸리티
///
/// OpenStreetMap Nominatim API 사용 (무료, API 키 불필요).
/// 사용 정책상 초당 1회 이하로 호출할 것.
class ReverseGeocoder {
  ReverseGeocoder._();

  static const _nominatimBase = AppConstants.nominatimBaseUrl;
  static const _userAgent = 'ClimaGuard/1.0';

  // ── 행정구역 변환 ──────────────────────────────────────────────────────────

  /// 위경도 → [AdminDistrict] (실패 시 null 반환, 예외 전파 없음)
  static Future<AdminDistrict?> toAdminDistrict(
    double lat,
    double lon, {
    required Dio dio,
  }) async {
    try {
      final resp = await dio.get<Map<String, dynamic>>(
        '$_nominatimBase/reverse',
        queryParameters: {
          'format': 'json',
          'lat': lat,
          'lon': lon,
          'accept-language': 'ko',
          'zoom': 16,
        },
        options: Options(headers: {'User-Agent': _userAgent}),
      );

      final address = resp.data?['address'] as Map<String, dynamic>?;
      if (address == null) return null;

      final region1 = (address['state'] as String?) ?? '';
      final city    = (address['city']    as String?) ?? '';
      final county  = (address['county']  as String?) ?? '';
      final suburb  = (address['suburb']  as String?) ?? '';
      final neighbourhood = ((address['neighbourhood'] ??
                               address['quarter']      ??
                               address['village']      ??
                               '') as String);

      // 기초자치단체(시/군): city 우선, 없으면 county
      final baseUnit = city.isNotEmpty ? city : county;

      // 행정구(suburb)가 기초자치단체 이름을 이미 포함하면 baseUnit 생략
      final region2 = suburb.isNotEmpty
          ? (baseUnit.isNotEmpty && !suburb.contains(baseUnit)
              ? '$baseUnit $suburb'
              : suburb)
          : baseUnit;

      return AdminDistrict(
        region1: region1,
        region2: region2,
        region3: neighbourhood,
      );
    } catch (_) {
      return null;
    }
  }

  // ── 도로명주소 변환 ────────────────────────────────────────────────────────

  /// 위경도 → [RoadAddress] (실패 시 null 반환, 예외 전파 없음)
  static Future<RoadAddress?> toRoadAddress(
    double lat,
    double lon, {
    required Dio dio,
  }) async {
    try {
      final resp = await dio.get<Map<String, dynamic>>(
        '$_nominatimBase/reverse',
        queryParameters: {
          'format': 'json',
          'lat': lat,
          'lon': lon,
          'accept-language': 'ko',
        },
        options: Options(headers: {'User-Agent': _userAgent}),
      );

      final data    = resp.data;
      final address = data?['address'] as Map<String, dynamic>?;
      if (address == null) return null;

      final city   = (address['city']   as String?) ?? '';
      final county = (address['county'] as String?) ?? '';

      return RoadAddress(
        full:       (data?['display_name'] as String?) ?? '',
        sido:       address['state']        as String?,
        sigungu:    city.isNotEmpty ? city : county,
        roadName:   address['road']         as String?,
        buildingNo: address['house_number'] as String?,
      );
    } catch (_) {
      return null;
    }
  }
}
