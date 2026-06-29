import 'dart:math';

/// 위경도 → 기상청 격자 좌표(nx, ny) 변환
/// 기상청 공식 Lambert 투영 공식 사용
class GridConverter {
  GridConverter._();

  static const double _re = 6371.00877;
  static const double _grid = 5.0;
  static const double _slat1 = 30.0;
  static const double _slat2 = 60.0;
  static const double _olon = 126.0;
  static const double _olat = 38.0;
  static const double _xo = 43;
  static const double _yo = 136;

  static ({int nx, int ny}) toGrid(double lat, double lon) {
    const degrad = pi / 180.0;
    final re = _re / _grid;
    final slat1 = _slat1 * degrad;
    final slat2 = _slat2 * degrad;
    final olon = _olon * degrad;
    final olat = _olat * degrad;

    var sn = tan(pi * 0.25 + slat2 * 0.5) / tan(pi * 0.25 + slat1 * 0.5);
    sn = log(cos(slat1) / cos(slat2)) / log(sn);
    var sf = tan(pi * 0.25 + slat1 * 0.5);
    sf = pow(sf, sn) * cos(slat1) / sn;
    var ro = tan(pi * 0.25 + olat * 0.5);
    ro = re * sf / pow(ro, sn);

    var ra = tan(pi * 0.25 + lat * degrad * 0.5);
    ra = re * sf / pow(ra, sn);

    var theta = lon * degrad - olon;
    if (theta > pi) theta -= 2.0 * pi;
    if (theta < -pi) theta += 2.0 * pi;
    theta *= sn;

    final x = (ra * sin(theta) + _xo + 0.5).floor();
    final y = (ro - ra * cos(theta) + _yo + 0.5).floor();
    return (nx: x, ny: y);
  }
}
