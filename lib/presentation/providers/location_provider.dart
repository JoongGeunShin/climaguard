import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_provider.g.dart';

@riverpod
Future<Position> location(LocationRef ref) async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('위치 서비스가 비활성화되어 있습니다.\n기기 설정에서 위치를 켜주세요.');
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    throw Exception('위치 권한이 필요합니다.\n설정에서 위치 권한을 허용해주세요.');
  }

  try {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 15),
      ),
    );
  } on TimeoutException {
    final last = await Geolocator.getLastKnownPosition();
    if (last != null) return last;
    throw Exception('위치를 가져오는 데 시간이 초과됐습니다.\n잠시 후 다시 시도해주세요.');
  }
}
