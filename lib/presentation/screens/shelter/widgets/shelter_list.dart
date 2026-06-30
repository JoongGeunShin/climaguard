import 'package:flutter/material.dart';

import '../../../../domain/entities/season.dart';
import '../../../../domain/entities/shelter.dart';
import 'shelter_list_item.dart';

class ShelterList extends StatelessWidget {
  const ShelterList({
    super.key,
    required this.shelters,
    required this.season,
    required this.onRefresh,
  });

  final List<Shelter> shelters;
  final Season season;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: shelters.length,
        itemBuilder: (_, i) => ShelterListItem(
          shelter: shelters[i],
          season: season,
        ),
      ),
    );
  }
}
