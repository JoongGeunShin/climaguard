import 'package:flutter/material.dart';
import '../../domain/entities/risk_level.dart';
import '../../domain/entities/season.dart';
import 'app_colors.dart';

class SeasonTheme {
  SeasonTheme._();

  static Color riskColor(RiskLevel level, Season season) {
    if (season.isHeat) {
      return switch (level) {
        RiskLevel.safe    => AppColors.riskSafe,
        RiskLevel.caution => AppColors.riskWatch,
        RiskLevel.warning => AppColors.riskWarning,
        RiskLevel.danger  => AppColors.riskDanger,
      };
    }
    if (season.isCold) {
      return switch (level) {
        RiskLevel.safe    => AppColors.coldSafe,
        RiskLevel.caution => AppColors.coldCaution,
        RiskLevel.warning => AppColors.coldWarning,
        RiskLevel.danger  => AppColors.coldDanger,
      };
    }
    // normal
    return switch (level) {
      RiskLevel.safe    => AppColors.riskSafe,
      RiskLevel.caution => const Color(0xFF66BB6A),
      RiskLevel.warning => const Color(0xFF388E3C),
      RiskLevel.danger  => const Color(0xFF1B5E20),
    };
  }

  static Color onRiskColor(RiskLevel level, Season season) {
    if (season.isHeat && level == RiskLevel.caution) return Colors.black87;
    return Colors.white;
  }

  static IconData seasonIcon(Season season) => switch (season) {
        Season.heat   => Icons.wb_sunny,
        Season.cold   => Icons.ac_unit,
        Season.normal => Icons.thermostat,
      };
}
