import '../entities/season.dart';
import '../entities/shelter.dart';

abstract interface class ShelterRepository {
  /// season에 따라 무더위쉼터(heat) 또는 한파쉼터(cold) 조회
  Future<List<Shelter>> getNearby({
    required double latitude,
    required double longitude,
    required Season season,
    double radiusKm = 3.0,
  });
}
