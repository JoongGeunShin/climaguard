import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/season.dart';
import '../../domain/entities/shelter.dart';
import '../../domain/repositories/shelter_repository.dart';
import '../datasources/shelter_remote_data_source.dart';
import '../models/shelter_response.dart';

part 'shelter_repository_impl.g.dart';

@riverpod
ShelterRepository shelterRepository(Ref ref) {
  return ShelterRepositoryImpl(ref.watch(shelterRemoteDataSourceProvider));
}

class ShelterRepositoryImpl implements ShelterRepository {
  ShelterRepositoryImpl(this._dataSource);

  final ShelterRemoteDataSource _dataSource;

  @override
  Future<List<Shelter>> getNearby({
    required double latitude,
    required double longitude,
    required Season season,
    double radiusKm = 3.0,
  }) async {
    final delta = radiusKm / 111.0;

    final items = await _dataSource.fetchNearby(
      startLat: latitude - delta,
      endLat: latitude + delta,
      startLot: longitude - delta,
      endLot: longitude + delta,
      season: season,
    );

    return items
        .map((item) => _toShelter(item, latitude, longitude))
        .where((s) => s.distanceKm <= radiusKm)
        .toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
  }

  Shelter _toShelter(ShelterItem item, double userLat, double userLon) {
    final lat = double.tryParse(item.latitude) ?? 0;
    final lon = double.tryParse(item.longitude) ?? 0;
    return Shelter(
      id: item.managementNo ?? '${item.name}_$lat$lon',
      name: item.name,
      latitude: lat,
      longitude: lon,
      distanceKm: _haversine(userLat, userLon, lat, lon),
      address: item.address,
    );
  }

  double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  double _deg2rad(double deg) => deg * pi / 180;
}
