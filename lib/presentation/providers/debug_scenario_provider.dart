import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'debug_scenario_provider.g.dart';

/// 지자체 대시보드 시연 모드 on/off. 켜지면 지도 색칠과 위험 인원 통계가
/// [DemoRiskGenerator]로 만든 더미 값으로 바뀌고, 실제 인구/날씨 캐시는
/// 건드리지 않는다 — 세션 동안만 유지되는 화면 전용 상태.
@Riverpod(keepAlive: true)
class DebugScenario extends _$DebugScenario {
  @override
  bool build() => false;

  void toggle() => state = !state;
}
