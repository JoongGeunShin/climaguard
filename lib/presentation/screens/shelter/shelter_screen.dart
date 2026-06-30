import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/season.dart';
import '../../../domain/entities/shelter.dart';
import '../../providers/location_provider.dart';
import '../../providers/shelter_provider.dart';
import '../../providers/weather_provider.dart';
import 'widgets/maps/shelter_map_view.dart';
import 'widgets/shelter_header.dart';
import 'widgets/shelter_list.dart';
import 'widgets/shelter_status_body.dart';

class ShelterScreen extends ConsumerStatefulWidget {
  const ShelterScreen({super.key});

  @override
  ConsumerState<ShelterScreen> createState() => _ShelterScreenState();
}

class _ShelterScreenState extends ConsumerState<ShelterScreen> {
  bool _showMap = false;

  Future<void> _refresh() async {
    ref.invalidate(sheltersProvider);
    await ref.read(sheltersProvider.future).catchError((_) => <Shelter>[]);
  }

  @override
  Widget build(BuildContext context) {
    final weatherAsync = ref.watch(weatherProvider);
    final sheltersAsync = ref.watch(sheltersProvider);

    final season = weatherAsync.valueOrNull?.season ?? Season.normal;
    final bg = season.isHeat
        ? AppColors.heatBackground
        : season.isCold
            ? AppColors.coldBackground
            : AppColors.normalBackground;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            ShelterHeader(
              season: season,
              showMap: _showMap,
              onToggleView: season.isNormal
                  ? null
                  : () => setState(() => _showMap = !_showMap),
            ),
            Expanded(
              child: sheltersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => ShelterErrorBody(
                  message: e.toString().replaceFirst('Exception: ', ''),
                  onRetry: _refresh,
                ),
                data: (shelters) {
                  if (season.isNormal) return const ShelterNormalBody();
                  if (shelters.isEmpty) {
                    return ShelterEmptyBody(
                      season: season,
                      onRefresh: _refresh,
                    );
                  }
                  if (_showMap) {
                    final pos = ref.watch(locationProvider).valueOrNull;
                    return ShelterMapView(
                      shelters: shelters,
                      userLat: pos?.latitude ?? 37.5665,
                      userLon: pos?.longitude ?? 126.9780,
                      season: season,
                    );
                  }
                  return ShelterList(
                    shelters: shelters,
                    season: season,
                    onRefresh: _refresh,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
