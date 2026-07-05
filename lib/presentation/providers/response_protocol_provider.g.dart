// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_protocol_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$responseProtocolHash() => r'c23fa7e6aab38bff5539b61c8513233a9a87e8b2';

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

/// See also [responseProtocol].
@ProviderFor(responseProtocol)
const responseProtocolProvider = ResponseProtocolFamily();

/// See also [responseProtocol].
class ResponseProtocolFamily extends Family<AsyncValue<String>> {
  /// See also [responseProtocol].
  const ResponseProtocolFamily();

  /// See also [responseProtocol].
  ResponseProtocolProvider call({
    required String regionLabel,
    required bool isHeat,
    required int danger,
    required int warning,
    required int caution,
    required int safe,
  }) {
    return ResponseProtocolProvider(
      regionLabel: regionLabel,
      isHeat: isHeat,
      danger: danger,
      warning: warning,
      caution: caution,
      safe: safe,
    );
  }

  @override
  ResponseProtocolProvider getProviderOverride(
    covariant ResponseProtocolProvider provider,
  ) {
    return call(
      regionLabel: provider.regionLabel,
      isHeat: provider.isHeat,
      danger: provider.danger,
      warning: provider.warning,
      caution: provider.caution,
      safe: provider.safe,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'responseProtocolProvider';
}

/// See also [responseProtocol].
class ResponseProtocolProvider extends AutoDisposeFutureProvider<String> {
  /// See also [responseProtocol].
  ResponseProtocolProvider({
    required String regionLabel,
    required bool isHeat,
    required int danger,
    required int warning,
    required int caution,
    required int safe,
  }) : this._internal(
         (ref) => responseProtocol(
           ref as ResponseProtocolRef,
           regionLabel: regionLabel,
           isHeat: isHeat,
           danger: danger,
           warning: warning,
           caution: caution,
           safe: safe,
         ),
         from: responseProtocolProvider,
         name: r'responseProtocolProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$responseProtocolHash,
         dependencies: ResponseProtocolFamily._dependencies,
         allTransitiveDependencies:
             ResponseProtocolFamily._allTransitiveDependencies,
         regionLabel: regionLabel,
         isHeat: isHeat,
         danger: danger,
         warning: warning,
         caution: caution,
         safe: safe,
       );

  ResponseProtocolProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.regionLabel,
    required this.isHeat,
    required this.danger,
    required this.warning,
    required this.caution,
    required this.safe,
  }) : super.internal();

  final String regionLabel;
  final bool isHeat;
  final int danger;
  final int warning;
  final int caution;
  final int safe;

  @override
  Override overrideWith(
    FutureOr<String> Function(ResponseProtocolRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ResponseProtocolProvider._internal(
        (ref) => create(ref as ResponseProtocolRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        regionLabel: regionLabel,
        isHeat: isHeat,
        danger: danger,
        warning: warning,
        caution: caution,
        safe: safe,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _ResponseProtocolProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ResponseProtocolProvider &&
        other.regionLabel == regionLabel &&
        other.isHeat == isHeat &&
        other.danger == danger &&
        other.warning == warning &&
        other.caution == caution &&
        other.safe == safe;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, regionLabel.hashCode);
    hash = _SystemHash.combine(hash, isHeat.hashCode);
    hash = _SystemHash.combine(hash, danger.hashCode);
    hash = _SystemHash.combine(hash, warning.hashCode);
    hash = _SystemHash.combine(hash, caution.hashCode);
    hash = _SystemHash.combine(hash, safe.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ResponseProtocolRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `regionLabel` of this provider.
  String get regionLabel;

  /// The parameter `isHeat` of this provider.
  bool get isHeat;

  /// The parameter `danger` of this provider.
  int get danger;

  /// The parameter `warning` of this provider.
  int get warning;

  /// The parameter `caution` of this provider.
  int get caution;

  /// The parameter `safe` of this provider.
  int get safe;
}

class _ResponseProtocolProviderElement
    extends AutoDisposeFutureProviderElement<String>
    with ResponseProtocolRef {
  _ResponseProtocolProviderElement(super.provider);

  @override
  String get regionLabel => (origin as ResponseProtocolProvider).regionLabel;
  @override
  bool get isHeat => (origin as ResponseProtocolProvider).isHeat;
  @override
  int get danger => (origin as ResponseProtocolProvider).danger;
  @override
  int get warning => (origin as ResponseProtocolProvider).warning;
  @override
  int get caution => (origin as ResponseProtocolProvider).caution;
  @override
  int get safe => (origin as ResponseProtocolProvider).safe;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
