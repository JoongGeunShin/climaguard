import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/shelter_repository_impl.dart';
import '../../domain/entities/shelter.dart';
import '../../domain/usecases/shelter_search_use_case.dart';
import 'location_provider.dart';
import 'weather_provider.dart';

part 'shelter_provider.g.dart';

@riverpod
Future<List<Shelter>> shelters(SheltersRef ref) async {
  final position = await ref.watch(locationProvider.future);
  final weather = await ref.watch(weatherProvider.future);

  // 일반 기온 구간에서는 쉼터 불필요
  if (weather.season.isNormal) return [];

  final repo = ref.watch(shelterRepositoryProvider);
  return ShelterSearchUseCase(repo).execute(
    latitude: position.latitude,
    longitude: position.longitude,
    season: weather.season,
  );
}
