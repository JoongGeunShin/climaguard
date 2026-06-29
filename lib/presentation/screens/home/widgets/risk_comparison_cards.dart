import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/season_theme.dart';
import '../../../../domain/entities/climate_alert.dart';
import '../../../../domain/entities/risk_level.dart';
import '../../../../domain/entities/season.dart';

class RiskComparisonCards extends StatelessWidget {
  final ClimateAlert alert;
  const RiskComparisonCards({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final season = alert.season;
    final officialThreshold = season.isHeat
        ? AppConstants.heatAlert
        : season.isCold
            ? AppConstants.coldAlert
            : null; // normal: 임계치 없음

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: _OfficialCard(
              level: alert.officialRiskLevel,
              season: season,
              threshold: officialThreshold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _PersonalCard(
              level: alert.personalRiskLevel,
              season: season,
              threshold: season.isNormal ? null : alert.personalThreshold,
            ),
          ),
        ],
      ),
    );
  }
}

class _OfficialCard extends StatelessWidget {
  final RiskLevel level;
  final Season season;
  final double? threshold;
  const _OfficialCard(
      {required this.level, required this.season, required this.threshold});

  @override
  Widget build(BuildContext context) {
    final levelColor = SeasonTheme.riskColor(level, season);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '기상청 공식',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            level.label,
            style: TextStyle(
              color: levelColor,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            threshold != null ? '기준 ${threshold!.toStringAsFixed(1)}°C' : '14~24°C 쾌적',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonalCard extends StatelessWidget {
  final RiskLevel level;
  final Season season;
  final double? threshold;
  const _PersonalCard(
      {required this.level, required this.season, required this.threshold});

  @override
  Widget build(BuildContext context) {
    final levelColor = season.isHeat
        ? const Color(0xFFFF6B4A)
        : season.isCold
            ? const Color(0xFF7BA8F0)
            : const Color(0xFF66BB6A);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.comparePersonalBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 맞춤 기준',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            level.label,
            style: TextStyle(
              color: levelColor,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            threshold != null ? '기준 ${threshold!.toStringAsFixed(1)}°C' : '14~24°C 쾌적',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
