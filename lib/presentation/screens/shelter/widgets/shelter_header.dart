import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/season.dart';

class ShelterHeader extends StatelessWidget {
  const ShelterHeader({
    super.key,
    required this.season,
    required this.showMap,
    required this.onToggleView,
  });

  final Season season;
  final bool showMap;
  final VoidCallback? onToggleView;

  Color get _headerColor => season.isHeat
      ? AppColors.heatCard
      : season.isCold
          ? AppColors.coldCard
          : AppColors.normalCard;

  String get _title =>
      season.isHeat ? '무더위 쉼터' : season.isCold ? '한파 쉼터' : '주변 쉼터';

  String get _subtitle => season.isHeat
      ? '반경 3km 이내 무더위 쉼터'
      : season.isCold
          ? '반경 3km 이내 한파 쉼터'
          : '현재 날씨가 쾌적합니다';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Icon(
            season.isHeat
                ? Icons.wb_sunny
                : season.isCold
                    ? Icons.ac_unit
                    : Icons.park_outlined,
            color: _headerColor,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _headerColor,
                  ),
                ),
                Text(
                  _subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (onToggleView != null)
            ShelterViewToggle(showMap: showMap, onTap: onToggleView!),
        ],
      ),
    );
  }
}

class ShelterViewToggle extends StatelessWidget {
  const ShelterViewToggle({
    super.key,
    required this.showMap,
    required this.onTap,
  });

  final bool showMap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              showMap ? Icons.list : Icons.map_outlined,
              size: 16,
              color: AppColors.onSurface,
            ),
            const SizedBox(width: 4),
            Text(
              showMap ? '목록' : '지도',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
