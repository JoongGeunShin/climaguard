/// 위경도 좌표 한 점.
typedef GeoPoint = ({double lat, double lng});

/// 읍면동 단위 행정구역 경계.
///
/// 렌더링·탭 판정 모두 evenOdd 규칙을 쓰므로, 폴리곤/링(구멍)을 구분하지 않고
/// [rings]에 전부 평평하게 담는다 — 대부분의 읍면동은 구멍이 없고, 있어도
/// evenOdd 규칙이 자동으로 올바르게 처리한다.
class RegionBoundary {
  const RegionBoundary({
    required this.code,
    required this.name,
    required this.sggName,
    required this.cityName,
    required this.rings,
  });

  /// adm_cd2 — 10자리 행정동 코드 (SGIS의 adm_cd 파라미터와 동일 체계)
  final String code;

  /// 읍면동 이름 (예: "사직동")
  final String name;

  /// 원본 시군구 이름 (예: "고양시일산동구")
  final String sggName;

  /// UI에서 시/군 단위로 묶을 때 쓰는 이름 (예: "고양시")
  final String cityName;

  final List<List<GeoPoint>> rings;

  /// 모든 정점의 단순 평균 — 시각화·날씨 조회용 대표 좌표로 충분한 근사치.
  GeoPoint get centroid {
    double latSum = 0, lngSum = 0;
    int count = 0;
    for (final ring in rings) {
      for (final p in ring) {
        latSum += p.lat;
        lngSum += p.lng;
        count++;
      }
    }
    if (count == 0) return (lat: 0, lng: 0);
    return (lat: latSum / count, lng: lngSum / count);
  }

  /// 위경도 기준 바운딩 박스 (minLat, minLng, maxLat, maxLng).
  ({double minLat, double minLng, double maxLat, double maxLng})
      get boundingBox {
    double minLat = double.infinity, minLng = double.infinity;
    double maxLat = -double.infinity, maxLng = -double.infinity;
    for (final ring in rings) {
      for (final p in ring) {
        if (p.lat < minLat) minLat = p.lat;
        if (p.lat > maxLat) maxLat = p.lat;
        if (p.lng < minLng) minLng = p.lng;
        if (p.lng > maxLng) maxLng = p.lng;
      }
    }
    return (minLat: minLat, minLng: minLng, maxLat: maxLat, maxLng: maxLng);
  }

  /// evenOdd 레이캐스팅 — 여러 링(구멍 포함)을 넘나들며 정확히 판정한다.
  bool containsPoint(GeoPoint point) {
    var inside = false;
    for (final ring in rings) {
      final len = ring.length;
      for (var i = 0, j = len - 1; i < len; j = i++) {
        final pi = ring[i];
        final pj = ring[j];
        final intersects = ((pi.lat > point.lat) != (pj.lat > point.lat)) &&
            (point.lng <
                (pj.lng - pi.lng) * (point.lat - pi.lat) / (pj.lat - pi.lat) +
                    pi.lng);
        if (intersects) inside = !inside;
      }
    }
    return inside;
  }
}
