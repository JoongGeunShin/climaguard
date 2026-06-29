import 'package:flutter/material.dart';
import '../../../../core/theme/season_theme.dart';
import '../../../../domain/entities/climate_alert.dart';
import '../../../../domain/usecases/alert_generation_use_case.dart';

class RiskBanner extends StatelessWidget {
  final ClimateAlert alert;
  const RiskBanner({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final bgColor = SeasonTheme.riskColor(alert.personalRiskLevel, alert.season);
    final textColor = SeasonTheme.onRiskColor(alert.personalRiskLevel, alert.season);
    final icon = SeasonTheme.seasonIcon(alert.season);
    final message = AlertGenerationUseCase().generate(alert: alert);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      color: bgColor,
      child: Column(
        children: [
          Icon(icon, color: textColor, size: 40),
          const SizedBox(height: 8),
          Text(
            '${alert.season.label} ${alert.personalRiskLevel.label} 단계',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '체감온도 ${alert.currentFeelsLike.toStringAsFixed(1)}°C',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: textColor.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
