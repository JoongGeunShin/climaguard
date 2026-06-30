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

    final typeCode = season.isHeat ? '1' : '2';

    final items = await _dataSource.fetchNearby(
      startLat: latitude - delta,
      endLat: latitude + delta,
      startLot: longitude - delta,
      endLot: longitude + delta,
      season: season,
    );

    // API가 typeCode 필터를 완전히 적용하지 않으므로 클라이언트에서 재필터링
    final filtered = items.where((item) {
      final code = item.typeCode ?? '';
      return code.contains(typeCode);
    });

    return filtered
        .map((item) => _toShelter(item, latitude, longitude))
        .where((s) => s.distanceKm <= radiusKm)
        .toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
  }

  Shelter _toShelter(ShelterItem item, double userLat, double userLon) {
    return Shelter(
      id: item.managementNo ?? '${item.name}_${item.latitude}${item.longitude}',
      name: item.name,
      latitude: item.latitude,
      longitude: item.longitude,
      distanceKm: _haversine(userLat, userLon, item.latitude, item.longitude),
      address: item.address,
      operatingHours: item.operatingHours,
      phone: item.phone,
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
