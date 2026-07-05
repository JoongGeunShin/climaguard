// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gyeonggiRegionsHash() => r'60e62c587d97f8e5f90d581f676efea06f02d0d9';

/// See also [gyeonggiRegions].
@ProviderFor(gyeonggiRegions)
final gyeonggiRegionsProvider =
    AutoDisposeFutureProvider<List<RegionBoundary>>.internal(
      gyeonggiRegions,
      name: r'gyeonggiRegionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$gyeonggiRegionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GyeonggiRegionsRef = AutoDisposeFutureProviderRef<List<RegionBoundary>>;
String _$gyeonggiCitiesHash() => r'b530118f6bb2a49f47063294b7af9b8a28a9b298';

/// 온보딩 1단계·대시보드 도(道) 지도에서 쓰는 경기도 31개 시/군 이름 목록.
///
/// Copied from [gyeonggiCities].
@ProviderFor(gyeonggiCities)
final gyeonggiCitiesProvider = AutoDisposeFutureProvider<List<String>>.internal(
  gyeonggiCities,
  name: r'gyeonggiCitiesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gyeonggiCitiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GyeonggiCitiesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$dongsInCityHash() => r'1f9f313574a5efd1e1009d211a7a3edf65a0592e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// 특정 시/군에 속한 읍면동 목록 (온보딩 2단계·대시보드 시 지도용).
///
/// Copied from [dongsInCity].
@ProviderFor(dongsInCity)
const dongsInCityProvider = DongsInCityFamily();

/// 특정 시/군에 속한 읍면동 목록 (온보딩 2단계·대시보드 시 지도용).
///
/// Copied from [dongsInCity].
class DongsInCityFamily extends Family<AsyncValue<List<RegionBoundary>>> {
  /// 특정 시/군에 속한 읍면동 목록 (온보딩 2단계·대시보드 시 지도용).
  ///
  /// Copied from [dongsInCity].
  const DongsInCityFamily();

  /// 특정 시/군에 속한 읍면동 목록 (온보딩 2단계·대시보드 시 지도용).
  ///
  /// Copied from [dongsInCity].
  DongsInCityProvider call(String cityName) {
    return DongsInCityProvider(cityName);
  }

  @override
  DongsInCityProvider getProviderOverride(
    covariant DongsInCityProvider provider,
  ) {
    return call(provider.cityName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dongsInCityProvider';
}

/// 특정 시/군에 속한 읍면동 목록 (온보딩 2단계·대시보드 시 지도용).
///
/// Copied from [dongsInCity].
class DongsInCityProvider
    extends AutoDisposeFutureProvider<List<RegionBoundary>> {
  /// 특정 시/군에 속한 읍면동 목록 (온보딩 2단계·대시보드 시 지도용).
  ///
  /// Copied from [dongsInCity].
  DongsInCityProvider(String cityName)
    : this._internal(
        (ref) => dongsInCity(ref as DongsInCityRef, cityName),
        from: dongsInCityProvider,
        name: r'dongsInCityProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dongsInCityHash,
        dependencies: DongsInCityFamily._dependencies,
        allTransitiveDependencies: DongsInCityFamily._allTransitiveDependencies,
        cityName: cityName,
      );

  DongsInCityProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cityName,
  }) : super.internal();

  final String cityName;

  @override
  Override overrideWith(
    FutureOr<List<RegionBoundary>> Function(DongsInCityRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DongsInCityProvider._internal(
        (ref) => create(ref as DongsInCityRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cityName: cityName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<RegionBoundary>> createElement() {
    return _DongsInCityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DongsInCityProvider && other.cityName == cityName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cityName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DongsInCityRef on AutoDisposeFutureProviderRef<List<RegionBoundary>> {
  /// The parameter `cityName` of this provider.
  String get cityName;
}

class _DongsInCityProviderElement
    extends AutoDisposeFutureProviderElement<List<RegionBoundary>>
    with DongsInCityRef {
  _DongsInCityProviderElement(super.provider);

  @override
  String get cityName => (origin as DongsInCityProvider).cityName;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
