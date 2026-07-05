// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_feedback_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$regionFeedbackHash() => r'f8f3ba660507cfcba8718e8168a2d07043f90d95';

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

/// 지역(행정동)별 집단학습 참여 현황 — 대시보드에서 "이 지역에서 몇 건 참여했는지" 표시용.
///
/// Copied from [regionFeedback].
@ProviderFor(regionFeedback)
const regionFeedbackProvider = RegionFeedbackFamily();

/// 지역(행정동)별 집단학습 참여 현황 — 대시보드에서 "이 지역에서 몇 건 참여했는지" 표시용.
///
/// Copied from [regionFeedback].
class RegionFeedbackFamily
    extends Family<AsyncValue<({int heatCount, int coldCount})>> {
  /// 지역(행정동)별 집단학습 참여 현황 — 대시보드에서 "이 지역에서 몇 건 참여했는지" 표시용.
  ///
  /// Copied from [regionFeedback].
  const RegionFeedbackFamily();

  /// 지역(행정동)별 집단학습 참여 현황 — 대시보드에서 "이 지역에서 몇 건 참여했는지" 표시용.
  ///
  /// Copied from [regionFeedback].
  RegionFeedbackProvider call(String regionCode) {
    return RegionFeedbackProvider(regionCode);
  }

  @override
  RegionFeedbackProvider getProviderOverride(
    covariant RegionFeedbackProvider provider,
  ) {
    return call(provider.regionCode);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'regionFeedbackProvider';
}

/// 지역(행정동)별 집단학습 참여 현황 — 대시보드에서 "이 지역에서 몇 건 참여했는지" 표시용.
///
/// Copied from [regionFeedback].
class RegionFeedbackProvider
    extends AutoDisposeFutureProvider<({int heatCount, int coldCount})> {
  /// 지역(행정동)별 집단학습 참여 현황 — 대시보드에서 "이 지역에서 몇 건 참여했는지" 표시용.
  ///
  /// Copied from [regionFeedback].
  RegionFeedbackProvider(String regionCode)
    : this._internal(
        (ref) => regionFeedback(ref as RegionFeedbackRef, regionCode),
        from: regionFeedbackProvider,
        name: r'regionFeedbackProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$regionFeedbackHash,
        dependencies: RegionFeedbackFamily._dependencies,
        allTransitiveDependencies:
            RegionFeedbackFamily._allTransitiveDependencies,
        regionCode: regionCode,
      );

  RegionFeedbackProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.regionCode,
  }) : super.internal();

  final String regionCode;

  @override
  Override overrideWith(
    FutureOr<({int heatCount, int coldCount})> Function(
      RegionFeedbackRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RegionFeedbackProvider._internal(
        (ref) => create(ref as RegionFeedbackRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        regionCode: regionCode,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<({int heatCount, int coldCount})>
  createElement() {
    return _RegionFeedbackProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RegionFeedbackProvider && other.regionCode == regionCode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, regionCode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RegionFeedbackRef
    on AutoDisposeFutureProviderRef<({int heatCount, int coldCount})> {
  /// The parameter `regionCode` of this provider.
  String get regionCode;
}

class _RegionFeedbackProviderElement
    extends AutoDisposeFutureProviderElement<({int heatCount, int coldCount})>
    with RegionFeedbackRef {
  _RegionFeedbackProviderElement(super.provider);

  @override
  String get regionCode => (origin as RegionFeedbackProvider).regionCode;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
