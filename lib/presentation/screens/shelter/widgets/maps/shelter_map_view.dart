import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../../../../../domain/entities/season.dart';
import '../../../../../domain/entities/shelter.dart';
import 'map_controls.dart';
import 'navigate_dialog.dart';

class ShelterMapView extends StatefulWidget {
  const ShelterMapView({
    super.key,
    required this.shelters,
    required this.userLat,
    required this.userLon,
    required this.season,
  });

  final List<Shelter> shelters;
  final double userLat;
  final double userLon;
  final Season season;

  @override
  State<ShelterMapView> createState() => _ShelterMapViewState();
}

class _ShelterMapViewState extends State<ShelterMapView> {
  NaverMapController? _controller;
  double _zoom = 14.5;

  Color get _markerColor =>
      widget.season.isHeat ? const Color(0xFFE64A19) : const Color(0xFF1565C0);

  Future<void> _onMapReady(NaverMapController controller) async {
    _controller = controller;

    // 내 위치 오버레이
    final locationOverlay = controller.getLocationOverlay();
    locationOverlay.setIsVisible(true);
    locationOverlay.setPosition(NLatLng(widget.userLat, widget.userLon));

    for (final shelter in widget.shelters) {
      await _addShelterMarker(controller, shelter);
    }
  }

  Future<void> _addShelterMarker(
    NaverMapController controller,
    Shelter shelter,
  ) async {
    final icon = await NOverlayImage.fromWidget(
      widget: Icon(Icons.location_pin, color: _markerColor, size: 36),
      size: const Size(36, 36),
      context: context,
    );
    final marker = NMarker(
      id: shelter.id,
      position: NLatLng(shelter.latitude, shelter.longitude),
      icon: icon,
      caption: NOverlayCaption(
        text: shelter.name,
        textSize: 11,
        color: Colors.black87,
        haloColor: Colors.white,
      ),
    );
    marker.setOnTapListener((_) {
      if (mounted) showNavigateDialog(context, shelter: shelter);
    });
    await controller.addOverlay(marker);
  }

  Future<void> _zoomIn() async {
    _zoom = (_zoom + 1).clamp(1.0, 21.0);
    await _controller?.updateCamera(
      NCameraUpdate.scrollAndZoomTo(zoom: _zoom),
    );
  }

  Future<void> _zoomOut() async {
    _zoom = (_zoom - 1).clamp(1.0, 21.0);
    await _controller?.updateCamera(
      NCameraUpdate.scrollAndZoomTo(zoom: _zoom),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NaverMap(
          options: NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(
              target: NLatLng(widget.userLat, widget.userLon),
              zoom: _zoom,
            ),
            locationButtonEnable: true,
            consumeSymbolTapEvents: false,
          ),
          onMapReady: _onMapReady,
        ),
        Positioned(
          right: 12,
          bottom: 96,
          child: MapZoomControls(
            onZoomIn: _zoomIn,
            onZoomOut: _zoomOut,
          ),
        ),
      ],
    );
  }
}
