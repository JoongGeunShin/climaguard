// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regional_dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$regionRiskProjectionHash() =>
    r'4fe0841014ec438b41e17d59f2a1da3e4d51152c';

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
///
/// Copied from [regionRiskProjection].
@ProviderFor(regionRiskProjection)
const regionRiskProjectionProvider = RegionRiskProjectionFamily();

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
///
/// Copied from [regionRiskProjection].
class RegionRiskProjectionFamily
    extends Family<AsyncValue<RegionRiskProjection>> {
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
  ///
  /// Copied from [regionRiskProjection].
  const RegionRiskProjectionFamily();

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
  ///
  /// Copied from [regionRiskProjection].
  RegionRiskProjectionProvider call(String? scopeKey) {
    return RegionRiskProjectionProvider(scopeKey);
  }

  @override
  RegionRiskProjectionProvider getProviderOverride(
    covariant RegionRiskProjectionProvider provider,
  ) {
    return call(provider.scopeKey);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'regionRiskProjectionProvider';
}

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
///
/// Copied from [regionRiskProjection].
class RegionRiskProjectionProvider
    extends FutureProvider<RegionRiskProjection> {
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
  ///
  /// Copied from [regionRiskProjection].
  RegionRiskProjectionProvider(String? scopeKey)
    : this._internal(
        (ref) => regionRiskProjection(ref as RegionRiskProjectionRef, scopeKey),
        from: regionRiskProjectionProvider,
        name: r'regionRiskProjectionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$regionRiskProjectionHash,
        dependencies: RegionRiskProjectionFamily._dependencies,
        allTransitiveDependencies:
            RegionRiskProjectionFamily._allTransitiveDependencies,
        scopeKey: scopeKey,
      );

  RegionRiskProjectionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.scopeKey,
  }) : super.internal();

  final String? scopeKey;

  @override
  Override overrideWith(
    FutureOr<RegionRiskProjection> Function(RegionRiskProjectionRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RegionRiskProjectionProvider._internal(
        (ref) => create(ref as RegionRiskProjectionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        scopeKey: scopeKey,
      ),
    );
  }

  @override
  FutureProviderElement<RegionRiskProjection> createElement() {
    return _RegionRiskProjectionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RegionRiskProjectionProvider && other.scopeKey == scopeKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, scopeKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RegionRiskProjectionRef on FutureProviderRef<RegionRiskProjection> {
  /// The parameter `scopeKey` of this provider.
  String? get scopeKey;
}

class _RegionRiskProjectionProviderElement
    extends FutureProviderElement<RegionRiskProjection>
    with RegionRiskProjectionRef {
  _RegionRiskProjectionProviderElement(super.provider);

  @override
  String? get scopeKey => (origin as RegionRiskProjectionProvider).scopeKey;
}

String _$regionRiskProjectionCacheOnlyHash() =>
    r'60410a85d2617bef45a6c02bbad36fee8341b291';

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
///
/// Copied from [regionRiskProjectionCacheOnly].
@ProviderFor(regionRiskProjectionCacheOnly)
const regionRiskProjectionCacheOnlyProvider =
    RegionRiskProjectionCacheOnlyFamily();

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
///
/// Copied from [regionRiskProjectionCacheOnly].
class RegionRiskProjectionCacheOnlyFamily
    extends Family<AsyncValue<RegionRiskProjection>> {
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
  ///
  /// Copied from [regionRiskProjectionCacheOnly].
  const RegionRiskProjectionCacheOnlyFamily();

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
  ///
  /// Copied from [regionRiskProjectionCacheOnly].
  RegionRiskProjectionCacheOnlyProvider call(String? scopeKey) {
    return RegionRiskProjectionCacheOnlyProvider(scopeKey);
  }

  @override
  RegionRiskProjectionCacheOnlyProvider getProviderOverride(
    covariant RegionRiskProjectionCacheOnlyProvider provider,
  ) {
    return call(provider.scopeKey);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'regionRiskProjectionCacheOnlyProvider';
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
///
/// Copied from [regionRiskProjectionCacheOnly].
class RegionRiskProjectionCacheOnlyProvider
    extends FutureProvider<RegionRiskProjection> {
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
  ///
  /// Copied from [regionRiskProjectionCacheOnly].
  RegionRiskProjectionCacheOnlyProvider(String? scopeKey)
    : this._internal(
        (ref) => regionRiskProjectionCacheOnly(
          ref as RegionRiskProjectionCacheOnlyRef,
          scopeKey,
        ),
        from: regionRiskProjectionCacheOnlyProvider,
        name: r'regionRiskProjectionCacheOnlyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$regionRiskProjectionCacheOnlyHash,
        dependencies: RegionRiskProjectionCacheOnlyFamily._dependencies,
        allTransitiveDependencies:
            RegionRiskProjectionCacheOnlyFamily._allTransitiveDependencies,
        scopeKey: scopeKey,
      );

  RegionRiskProjectionCacheOnlyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.scopeKey,
  }) : super.internal();

  final String? scopeKey;

  @override
  Override overrideWith(
    FutureOr<RegionRiskProjection> Function(
      RegionRiskProjectionCacheOnlyRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RegionRiskProjectionCacheOnlyProvider._internal(
        (ref) => create(ref as RegionRiskProjectionCacheOnlyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        scopeKey: scopeKey,
      ),
    );
  }

  @override
  FutureProviderElement<RegionRiskProjection> createElement() {
    return _RegionRiskProjectionCacheOnlyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RegionRiskProjectionCacheOnlyProvider &&
        other.scopeKey == scopeKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, scopeKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RegionRiskProjectionCacheOnlyRef
    on FutureProviderRef<RegionRiskProjection> {
  /// The parameter `scopeKey` of this provider.
  String? get scopeKey;
}

class _RegionRiskProjectionCacheOnlyProviderElement
    extends FutureProviderElement<RegionRiskProjection>
    with RegionRiskProjectionCacheOnlyRef {
  _RegionRiskProjectionCacheOnlyProviderElement(super.provider);

  @override
  String? get scopeKey =>
      (origin as RegionRiskProjectionCacheOnlyProvider).scopeKey;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
