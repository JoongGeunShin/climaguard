// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debug_scenario_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$debugScenarioHash() => r'dae231568dbd69d2ec6b186369dfe0b6a3e58597';

/// 지자체 대시보드 시연 모드 on/off. 켜지면 지도 색칠과 위험 인원 통계가
/// [DemoRiskGenerator]로 만든 더미 값으로 바뀌고, 실제 인구/날씨 캐시는
/// 건드리지 않는다 — 세션 동안만 유지되는 화면 전용 상태.
///
/// Copied from [DebugScenario].
@ProviderFor(DebugScenario)
final debugScenarioProvider = NotifierProvider<DebugScenario, bool>.internal(
  DebugScenario.new,
  name: r'debugScenarioProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$debugScenarioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DebugScenario = Notifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
