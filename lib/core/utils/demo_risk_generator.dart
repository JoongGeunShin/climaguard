import 'dart:math';

import '../../domain/usecases/regional_risk_projection_use_case.dart';

/// 지자체 대시보드 시연 모드에서 쓰는 더미 위험도 생성기.
///
/// 실제 인구(KOSIS)·날씨(KMA) 캐시는 절대 읽거나 쓰지 않는다 — 지역 코드를
/// 시드로 한 결정론적 난수만 사용해 화면 렌더링 단계에서만 값을 만들어낸다.
/// 같은 지역·같은 계절(폭염/한파)이면 항상 같은 값이 나오고, 지역마다는
/// 자연스럽게 다른 값이 나온다.
class DemoRiskGenerator {
  const DemoRiskGenerator._();

  /// 지도 색칠용 — 인구 대비 위험군 비율(0.0~1.0).
  static double ratioFor(String regionKey, {required bool isHeat}) {
    final rnd = Random(_seedFor(regionKey, isHeat));
    return rnd.nextDouble();
  }

  /// 통계 위젯용 — 위험 단계별 인원 분포.
  static RegionRiskProjection projectionFor(
    String regionKey, {
    required bool isHeat,
  }) {
    final rnd = Random(_seedFor(regionKey, isHeat));
    final total = 300 + rnd.nextInt(4700); // 300~5000명
    final atRiskRatio = rnd.nextDouble();

    final danger = (total * atRiskRatio * (0.2 + rnd.nextDouble() * 0.3)).round();
    final warning = (total * atRiskRatio * (0.3 + rnd.nextDouble() * 0.3)).round();
    final remaining = total - danger - warning;
    final caution = remaining <= 0 ? 0 : (remaining * (0.4 + rnd.nextDouble() * 0.3)).round();
    final safe = remaining - caution;

    return RegionRiskProjection(
      totalPopulation: total,
      danger: danger,
      warning: warning,
      caution: caution < 0 ? 0 : caution,
      safe: safe < 0 ? 0 : safe,
    );
  }

  static int _seedFor(String key, bool isHeat) =>
      key.hashCode ^ (isHeat ? 0x48454154 : 0x434f4c44); // 'HEAT' / 'COLD'
}
