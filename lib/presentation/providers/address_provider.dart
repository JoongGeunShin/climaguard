import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/reverse_geocoder.dart';
import '../../data/datasources/dio_provider.dart';
import 'location_provider.dart';

part 'address_provider.g.dart';

/// 현재 위치의 행정구역 정보를 반환합니다.
///
/// locationProvider가 갱신되면 자동으로 재계산됩니다.
/// Kakao API 키가 없거나 요청 실패 시 null을 반환합니다(앱 진행에 영향 없음).
@riverpod
Future<AdminDistrict?> adminDistrict(AdminDistrictRef ref) async {
  final position = await ref.watch(locationProvider.future);
  final dio = ref.watch(dioProvider);
  final apiKey = dotenv.env['KAKAO_REST_API_KEY'] ?? '';

  return ReverseGeocoder.toAdminDistrict(
    position.latitude,
    position.longitude,
    dio: dio,
    apiKey: apiKey,
  );
}

/// 현재 위치의 도로명 주소를 반환합니다.
///
/// 상세 주소 화면 등에서 필요할 때 선택적으로 사용합니다.
@riverpod
Future<RoadAddress?> roadAddress(RoadAddressRef ref) async {
  final position = await ref.watch(locationProvider.future);
  final dio = ref.watch(dioProvider);
  final apiKey = dotenv.env['KAKAO_REST_API_KEY'] ?? '';

  return ReverseGeocoder.toRoadAddress(
    position.latitude,
    position.longitude,
    dio: dio,
    apiKey: apiKey,
  );
}
