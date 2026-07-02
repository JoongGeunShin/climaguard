// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'threshold_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$thresholdServiceHash() => r'dfa8c5dbba5f85ba972ad4ed7b836f42efaf6d14';

/// See also [thresholdService].
@ProviderFor(thresholdService)
final thresholdServiceProvider = Provider<ThresholdService>.internal(
  thresholdService,
  name: r'thresholdServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$thresholdServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ThresholdServiceRef = ProviderRef<ThresholdService>;
String _$baseThresholdsHash() => r'c2d6a8ce7925ad776769baee5738bfb796dc20e0';

/// Firestore `thresholds/base` 실시간 스트림 — 그룹학습 등으로 값이
/// 바뀌면 앱을 재시작하지 않아도 이 스트림을 구독 중인 모든 화면에 즉시 반영된다.
///
/// Copied from [baseThresholds].
@ProviderFor(baseThresholds)
final baseThresholdsProvider = StreamProvider<BaseThresholds>.internal(
  baseThresholds,
  name: r'baseThresholdsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$baseThresholdsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BaseThresholdsRef = StreamProviderRef<BaseThresholds>;
String _$ageOffsetsHash() => r'5fb1acad0ba1779ba2deba6777874906412368a2';

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

/// Firestore `thresholds/age_{ageKey}` 실시간 스트림.
///
/// Copied from [ageOffsets].
@ProviderFor(ageOffsets)
const ageOffsetsProvider = AgeOffsetsFamily();

/// Firestore `thresholds/age_{ageKey}` 실시간 스트림.
///
/// Copied from [ageOffsets].
class AgeOffsetsFamily extends Family<AsyncValue<AgeOffsets>> {
  /// Firestore `thresholds/age_{ageKey}` 실시간 스트림.
  ///
  /// Copied from [ageOffsets].
  const AgeOffsetsFamily();

  /// Firestore `thresholds/age_{ageKey}` 실시간 스트림.
  ///
  /// Copied from [ageOffsets].
  AgeOffsetsProvider call(String ageKey) {
    return AgeOffsetsProvider(ageKey);
  }

  @override
  AgeOffsetsProvider getProviderOverride(
    covariant AgeOffsetsProvider provider,
  ) {
    return call(provider.ageKey);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'ageOffsetsProvider';
}

/// Firestore `thresholds/age_{ageKey}` 실시간 스트림.
///
/// Copied from [ageOffsets].
class AgeOffsetsProvider extends StreamProvider<AgeOffsets> {
  /// Firestore `thresholds/age_{ageKey}` 실시간 스트림.
  ///
  /// Copied from [ageOffsets].
  AgeOffsetsProvider(String ageKey)
    : this._internal(
        (ref) => ageOffsets(ref as AgeOffsetsRef, ageKey),
        from: ageOffsetsProvider,
        name: r'ageOffsetsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$ageOffsetsHash,
        dependencies: AgeOffsetsFamily._dependencies,
        allTransitiveDependencies: AgeOffsetsFamily._allTransitiveDependencies,
        ageKey: ageKey,
      );

  AgeOffsetsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ageKey,
  }) : super.internal();

  final String ageKey;

  @override
  Override overrideWith(
    Stream<AgeOffsets> Function(AgeOffsetsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AgeOffsetsProvider._internal(
        (ref) => create(ref as AgeOffsetsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ageKey: ageKey,
      ),
    );
  }

  @override
  StreamProviderElement<AgeOffsets> createElement() {
    return _AgeOffsetsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AgeOffsetsProvider && other.ageKey == ageKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ageKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AgeOffsetsRef on StreamProviderRef<AgeOffsets> {
  /// The parameter `ageKey` of this provider.
  String get ageKey;
}

class _AgeOffsetsProviderElement extends StreamProviderElement<AgeOffsets>
    with AgeOffsetsRef {
  _AgeOffsetsProviderElement(super.provider);

  @override
  String get ageKey => (origin as AgeOffsetsProvider).ageKey;
}

String _$conditionOffsetHash() => r'9c233fb6fb1592796ca6e5f003b5f2e380d530d6';

/// Firestore `thresholds/condition_{condition}` 실시간 스트림.
///
/// Copied from [conditionOffset].
@ProviderFor(conditionOffset)
const conditionOffsetProvider = ConditionOffsetFamily();

/// Firestore `thresholds/condition_{condition}` 실시간 스트림.
///
/// Copied from [conditionOffset].
class ConditionOffsetFamily
    extends Family<AsyncValue<({double heat, double cold})>> {
  /// Firestore `thresholds/condition_{condition}` 실시간 스트림.
  ///
  /// Copied from [conditionOffset].
  const ConditionOffsetFamily();

  /// Firestore `thresholds/condition_{condition}` 실시간 스트림.
  ///
  /// Copied from [conditionOffset].
  ConditionOffsetProvider call(String condition) {
    return ConditionOffsetProvider(condition);
  }

  @override
  ConditionOffsetProvider getProviderOverride(
    covariant ConditionOffsetProvider provider,
  ) {
    return call(provider.condition);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'conditionOffsetProvider';
}

/// Firestore `thresholds/condition_{condition}` 실시간 스트림.
///
/// Copied from [conditionOffset].
class ConditionOffsetProvider
    extends StreamProvider<({double heat, double cold})> {
  /// Firestore `thresholds/condition_{condition}` 실시간 스트림.
  ///
  /// Copied from [conditionOffset].
  ConditionOffsetProvider(String condition)
    : this._internal(
        (ref) => conditionOffset(ref as ConditionOffsetRef, condition),
        from: conditionOffsetProvider,
        name: r'conditionOffsetProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$conditionOffsetHash,
        dependencies: ConditionOffsetFamily._dependencies,
        allTransitiveDependencies:
            ConditionOffsetFamily._allTransitiveDependencies,
        condition: condition,
      );

  ConditionOffsetProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.condition,
  }) : super.internal();

  final String condition;

  @override
  Override overrideWith(
    Stream<({double heat, double cold})> Function(ConditionOffsetRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConditionOffsetProvider._internal(
        (ref) => create(ref as ConditionOffsetRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        condition: condition,
      ),
    );
  }

  @override
  StreamProviderElement<({double heat, double cold})> createElement() {
    return _ConditionOffsetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConditionOffsetProvider && other.condition == condition;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, condition.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConditionOffsetRef on StreamProviderRef<({double heat, double cold})> {
  /// The parameter `condition` of this provider.
  String get condition;
}

class _ConditionOffsetProviderElement
    extends StreamProviderElement<({double heat, double cold})>
    with ConditionOffsetRef {
  _ConditionOffsetProviderElement(super.provider);

  @override
  String get condition => (origin as ConditionOffsetProvider).condition;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
