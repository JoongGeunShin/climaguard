import 'package:freezed_annotation/freezed_annotation.dart';

part 'shelter.freezed.dart';

@freezed
abstract class Shelter with _$Shelter {
  const factory Shelter({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    required double distanceKm,
    int? capacity, // 수용인원
    String? operatingHours,
    String? address,
    String? phone,
  }) = _Shelter;
}
