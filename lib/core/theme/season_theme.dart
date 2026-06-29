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
    } else {
      return switch (level) {
        RiskLevel.safe    => AppColors.coldSafe,
        RiskLevel.caution => AppColors.coldCaution,
        RiskLevel.warning => AppColors.coldWarning,
        RiskLevel.danger  => AppColors.coldDanger,
      };
    }
  }

  /// 배경색 위에 올라갈 텍스트/아이콘 색상
  static Color onRiskColor(RiskLevel level, Season season) {
    // 폭염 주의(노랑)만 어두운 배경이 아니므로 검정
    if (season.isHeat && level == RiskLevel.caution) return Colors.black87;
    return Colors.white;
  }

  static IconData seasonIcon(Season season) =>
      season.isHeat ? Icons.wb_sunny : Icons.ac_unit;
}
