import 'dart:math';

abstract final class FeelsLikeCalculator {
  /// 폭염 체감온도 — Steadman 간이식 (기온 27°C 이상에서 유효)
  static double heat(double t, int reh) {
    if (t < 27) return t;
    return -8.784695 +
        1.61139411 * t +
        2.338549 * reh -
        0.14611605 * t * reh -
        0.012308094 * t * t -
        0.016424828 * reh * reh +
        0.002211732 * t * t * reh +
        0.00072546 * t * reh * reh -
        0.000003582 * t * t * reh * reh;
  }

  /// 한파 체감온도 — 기상청 공식 WindChill (기온 10°C 이하, 풍속 1 m/s 이상)
  static double cold(double t, double wsdMs) {
    if (t > 10 || wsdMs < 1) return t;
    final vKmh = wsdMs * 3.6;
    final v16 = pow(vKmh, 0.16).toDouble();
    return 13.12 + 0.6215 * t - 11.37 * v16 + 0.3965 * t * v16;
  }
}
