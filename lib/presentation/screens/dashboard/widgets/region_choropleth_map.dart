import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../domain/entities/region.dart';

/// GeoJSON 경계를 Canvas에 직접 그리는 통계 지도(choropleth).
/// 지도 SDK나 타일을 쓰지 않고, 위경도를 화면 좌표로 선형 투영해 폴리곤을 채색한다.
/// `InteractiveViewer`로 핀치줌·팬을 지원한다.
class RegionChoroplethMap extends StatefulWidget {
  final List<RegionBoundary> regions;

  /// 이 지역을 어떤 그룹으로 묶어서 다룰지 (도 지도에서는 시/군 이름,
  /// 시 지도에서는 읍면동 코드 자신).
  final String Function(RegionBoundary region) groupKeyOf;

  final Color Function(String groupKey) colorFor;
  final String? selectedGroupKey;
  final void Function(String groupKey) onTapRegion;

  /// 이 값이 바뀔 때만 확대/이동 상태를 초기화한다(예: 도↔시 화면 전환).
  /// 같은 화면에서 색상만 갱신되는 리빌드에서는 확대 상태를 유지해야 하므로
  /// `regions` 리스트 자체(매 빌드마다 새로 만들어질 수 있음)로 판단하지 않는다.
  final Object? resetViewKey;

  const RegionChoroplethMap({
    super.key,
    required this.regions,
    required this.groupKeyOf,
    required this.colorFor,
    required this.onTapRegion,
    this.selectedGroupKey,
    this.resetViewKey,
  });

  @override
  State<RegionChoroplethMap> createState() => _RegionChoroplethMapState();
}

class _RegionChoroplethMapState extends State<RegionChoroplethMap> {
  final _transformController = TransformationController();

  @override
  void didUpdateWidget(covariant RegionChoroplethMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resetViewKey != widget.resetViewKey) {
      _transformController.value = Matrix4.identity();
    }
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final projection = _Projection(widget.regions, size);

        return ClipRect(
          child: InteractiveViewer(
            transformationController: _transformController,
            minScale: 1.0,
            maxScale: 10.0,
            child: GestureDetector(
              onTapUp: (details) {
                final geoPoint = projection.toGeoPoint(details.localPosition);
                for (final region in widget.regions) {
                  if (region.containsPoint(geoPoint)) {
                    widget.onTapRegion(widget.groupKeyOf(region));
                    return;
                  }
                }
              },
              child: CustomPaint(
                size: size,
                painter: _ChoroplethPainter(
                  regions: widget.regions,
                  groupKeyOf: widget.groupKeyOf,
                  colorFor: widget.colorFor,
                  selectedGroupKey: widget.selectedGroupKey,
                  projection: projection,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ChoroplethPainter extends CustomPainter {
  final List<RegionBoundary> regions;
  final String Function(RegionBoundary region) groupKeyOf;
  final Color Function(String groupKey) colorFor;
  final String? selectedGroupKey;
  final _Projection projection;

  _ChoroplethPainter({
    required this.regions,
    required this.groupKeyOf,
    required this.colorFor,
    required this.selectedGroupKey,
    required this.projection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final region in regions) {
      final path = Path()..fillType = PathFillType.evenOdd;
      for (final ring in region.rings) {
        if (ring.isEmpty) continue;
        path.addPolygon(
          ring.map(projection.toOffset).toList(),
          true,
        );
      }

      final key = groupKeyOf(region);
      final isSelected = key == selectedGroupKey;

      canvas.drawPath(path, Paint()..color = colorFor(key));
      canvas.drawPath(
        path,
        Paint()
          ..color = isSelected ? Colors.black87 : Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = isSelected ? 2.0 : 0.6,
      );
    }
  }

  @override
  bool shouldRepaint(_ChoroplethPainter old) =>
      old.regions != regions || old.selectedGroupKey != selectedGroupKey;
}

/// 경도는 위도에 따라 실제 거리가 압축되므로(cos(lat) 배율), 평균 위도를
/// 기준으로 보정한 뒤 bounding box를 캔버스 크기에 맞춰 선형 투영한다.
class _Projection {
  late final double _maxLat, _minLng;
  late final double _lngScale;
  late final double _scale;
  late final double _offsetX, _offsetY;

  _Projection(List<RegionBoundary> regions, Size size) {
    double minLat = double.infinity, minLng = double.infinity;
    double maxLat = -double.infinity, maxLng = -double.infinity;
    for (final r in regions) {
      final box = r.boundingBox;
      if (box.minLat < minLat) minLat = box.minLat;
      if (box.maxLat > maxLat) maxLat = box.maxLat;
      if (box.minLng < minLng) minLng = box.minLng;
      if (box.maxLng > maxLng) maxLng = box.maxLng;
    }
    if (regions.isEmpty || minLat.isInfinite) {
      minLat = 33;
      maxLat = 39;
      minLng = 124;
      maxLng = 130;
    }
    _maxLat = maxLat;
    _minLng = minLng;

    final centerLatRad = (minLat + maxLat) / 2 * pi / 180;
    _lngScale = cos(centerLatRad);

    const padding = 16.0;
    final geoWidth = (maxLng - minLng) * _lngScale;
    final geoHeight = maxLat - minLat;
    final availW = max(size.width - padding * 2, 1.0);
    final availH = max(size.height - padding * 2, 1.0);
    _scale = min(
      geoWidth == 0 ? availW : availW / geoWidth,
      geoHeight == 0 ? availH : availH / geoHeight,
    );

    final usedW = geoWidth * _scale;
    final usedH = geoHeight * _scale;
    _offsetX = padding + (availW - usedW) / 2;
    _offsetY = padding + (availH - usedH) / 2;
  }

  Offset toOffset(GeoPoint p) {
    final x = (p.lng - _minLng) * _lngScale * _scale + _offsetX;
    // 화면 좌표는 y가 아래로 갈수록 증가하므로 위도는 뒤집는다.
    final y = (_maxLat - p.lat) * _scale + _offsetY;
    return Offset(x, y);
  }

  GeoPoint toGeoPoint(Offset offset) {
    final lng = (offset.dx - _offsetX) / (_lngScale * _scale) + _minLng;
    final lat = _maxLat - (offset.dy - _offsetY) / _scale;
    return (lat: lat, lng: lng);
  }
}
