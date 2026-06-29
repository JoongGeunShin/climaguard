// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminDistrictHash() => r'e642923f47e8496ddcf31b5c5f02d9c62bca155b';

/// 현재 위치의 행정구역 정보를 반환합니다.
///
/// OpenStreetMap Nominatim API 사용 (API 키 불필요).
/// locationProvider가 갱신되면 자동으로 재계산됩니다.
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
String _$roadAddressHash() => r'41eb9dd900b791500f66d55de906868bfe619934';

/// 현재 위치의 도로명 주소를 반환합니다.
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
