// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminDistrictHash() => r'94a5a92464e4cd8534d358fa51d851aed8157eb5';

/// 현재 위치의 행정구역 정보를 반환합니다.
///
/// locationProvider가 갱신되면 자동으로 재계산됩니다.
/// Kakao API 키가 없거나 요청 실패 시 null을 반환합니다(앱 진행에 영향 없음).
///
/// Copied from [adminDistrict].
@ProviderFor(adminDistrict)
final adminDistrictProvider =
    AutoDisposeFutureProvider<AdminDistrict?>.internal(
      adminDistrict,
      name: r'adminDistrictProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$adminDistrictHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminDistrictRef = AutoDisposeFutureProviderRef<AdminDistrict?>;
String _$roadAddressHash() => r'2b77d62c45458dd151427c05b86ebd558f0a07f9';

/// 현재 위치의 도로명 주소를 반환합니다.
///
/// 상세 주소 화면 등에서 필요할 때 선택적으로 사용합니다.
///
/// Copied from [roadAddress].
@ProviderFor(roadAddress)
final roadAddressProvider = AutoDisposeFutureProvider<RoadAddress?>.internal(
  roadAddress,
  name: r'roadAddressProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$roadAddressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RoadAddressRef = AutoDisposeFutureProviderRef<RoadAddress?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
