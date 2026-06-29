import '../entities/season.dart';
import '../entities/shelter.dart';
import '../repositories/shelter_repository.dart';

class ShelterSearchUseCase {
  ShelterSearchUseCase(this._repository);

  final ShelterRepository _repository;

  Future<List<Shelter>> execute({
    required double latitude,
    required double longitude,
    required Season season,
    double radiusKm = 3.0,
  }) {
    return _repository.getNearby(
      latitude: latitude,
      longitude: longitude,
      season: season,
      radiusKm: radiusKm,
    );
  }
}
