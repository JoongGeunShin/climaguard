import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/reverse_geocoder.dart';
import '../../data/datasources/dio_provider.dart';
import 'location_provider.dart';

part 'address_provider.g.dart';

/// 현재 위치의 행정구역 정보를 반환합니다.
///
/// OpenStreetMap Nominatim API 사용 (API 키 불필요).
/// locationProvider가 갱신되면 자동으로 재계산됩니다.
@riverpod
Future<AdminDistrict?> adminDistrict(AdminDistrictRef ref) async {
  final position = await ref.watch(locationProvider.future);
  final dio = ref.watch(dioProvider);

  return ReverseGeocoder.toAdminDistrict(
    position.latitude,
    position.longitude,
    dio: dio,
  );
}

/// 현재 위치의 도로명 주소를 반환합니다.
@riverpod
Future<RoadAddress?> roadAddress(RoadAddressRef ref) async {
  final position = await ref.watch(locationProvider.future);
  final dio = ref.watch(dioProvider);

  return ReverseGeocoder.toRoadAddress(
    position.latitude,
    position.longitude,
    dio: dio,
  );
}
