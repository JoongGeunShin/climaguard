import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/season_theme.dart';
import '../../../../domain/entities/climate_alert.dart';
import '../../../../domain/entities/risk_level.dart';
import '../../../../domain/entities/season.dart';

class RiskComparisonRow extends StatelessWidget {
  final ClimateAlert alert;
  const RiskComparisonRow({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final diff = alert.personalRiskLevel.index - alert.officialRiskLevel.index;
    final same = diff == 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '위험단계 비교',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _LevelChip(
                    label: '공식 기준',
                    level: alert.officialRiskLevel,
                    season: alert.season,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    same ? Icons.drag_handle : Icons.arrow_forward,
                    color: same ? AppColors.textSecondary : AppColors.primary,
                  ),
                ),
                Expanded(
                  child: _LevelChip(
                    label: '내 기준',
                    level: alert.personalRiskLevel,
                    season: alert.season,
                  ),
                ),
              ],
            ),
            if (!same) ...[
              const SizedBox(height: 8),
              Text(
                diff > 0
                    ? '공식 단계보다 민감하게 적용되고 있어요.'
                    : '공식 단계보다 완화 적용되고 있어요.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  final String label;
  final RiskLevel level;
  final Season season;
  const _LevelChip({
    required this.label,
    required this.level,
    required this.season,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = SeasonTheme.riskColor(level, season);
    final textColor = SeasonTheme.onRiskColor(level, season);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            level.label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
