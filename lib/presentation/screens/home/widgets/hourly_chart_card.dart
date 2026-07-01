import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/risk_level.dart';
import '../../../../domain/entities/season.dart';
import '../../../../domain/entities/weather_data.dart';

class HourlyChartCard extends StatelessWidget {
  final WeatherData weather;
  const HourlyChartCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final season = weather.season;
    final hourly = _simulateHourly();
    final peak = _peak(hourly, season);

    final title = season.isHeat
        ? '오늘 체감온도 추이'
        : season.isCold
            ? '오늘 체감한파 추이'
            : '오늘 기온 추이';
    final peakLabel = season.isCold
        ? '${peak.$1}시 최저 ${peak.$2.round()}°'
        : '${peak.$1}시 최고 ${peak.$2.round()}°';
    final peakColor = season.isHeat
        ? AppColors.heatCard
        : season.isCold
            ? AppColors.coldCard
            : AppColors.normalCard;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  peakLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: peakColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _BarRow(hourly: hourly, season: season),
          ],
        ),
      ),
    );
  }

  List<(int hour, double feelsLike)> _simulateHourly() {
    final current = weather.feelsLike;
    if (weather.season.isHeat) {
      const slots = [9, 12, 14, 17, 20];
      return slots.map((h) => (h, current + _heatOffset(h))).toList();
    } else if (weather.season.isCold) {
      const slots = [5, 9, 14, 19, 23];
      return slots.map((h) => (h, current + _coldOffset(h))).toList();
    } else {
      const slots = [9, 12, 14, 17, 20];
      return slots.map((h) => (h, current + _normalOffset(h))).toList();
    }
  }

  double _heatOffset(int h) {
    const offsets = {9: -3.0, 12: -1.0, 14: 0.5, 17: -1.0, 20: -3.0};
    return offsets[h] ?? 0;
  }

  double _coldOffset(int h) {
    const offsets = {5: -2.0, 9: -0.8, 14: 1.5, 19: 0.0, 23: -0.8};
    return offsets[h] ?? 0;
  }

  double _normalOffset(int h) {
    const offsets = {9: -1.5, 12: 0.0, 14: 1.5, 17: 0.5, 20: -0.5};
    return offsets[h] ?? 0;
  }

  (int, double) _peak(List<(int, double)> hourly, Season season) {
    if (season.isCold) {
      return hourly.reduce((a, b) => a.$2 <= b.$2 ? a : b);
    } else {
      return hourly.reduce((a, b) => a.$2 >= b.$2 ? a : b);
    }
  }
}

class _BarRow extends StatelessWidget {
  final List<(int hour, double feelsLike)> hourly;
  final Season season;
  const _BarRow({required this.hourly, required this.season});

  @override
  Widget build(BuildContext context) {
    const barMaxH = 72.0;
    const barMinH = 28.0;

    final values = hourly.map((e) => e.$2).toList();
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final minVal = values.reduce((a, b) => a < b ? a : b);
    final range = (maxVal - minVal).abs();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: hourly.map((item) {
        final h = item.$1;
        final fl = item.$2;
        final ratio = range < 0.01
            ? 0.5
            : season.isCold
                ? ((maxVal - fl) / range)
                : ((fl - minVal) / range);
        final barH = barMinH + ratio * (barMaxH - barMinH);
        final level = season.isHeat
            ? _heatLevel(fl)
            : season.isCold
                ? _coldLevel(fl)
                : RiskLevel.safe;
        final barColor = _barColor(level, season);

        final now = DateTime.now().hour;
        final isCurrent = (h - now).abs() < 2;
        final currentColor = season.isHeat
            ? AppColors.heatCard
            : season.isCold
                ? AppColors.coldCard
                : AppColors.normalCard;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${fl.round()}°',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isCurrent ? currentColor : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 44,
              height: barH,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$h시',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                color: isCurrent ? currentColor : AppColors.textSecondary,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  RiskLevel _heatLevel(double fl) {
    if (fl >= AppConstants.heatDanger)  return RiskLevel.danger;
    if (fl >= AppConstants.heatAlert)   return RiskLevel.warning;
    if (fl >= AppConstants.heatWarning) return RiskLevel.caution;
    if (fl >= AppConstants.heatCaution) return RiskLevel.attention;
    return RiskLevel.safe;
  }

  RiskLevel _coldLevel(double fl) {
    if (fl <= AppConstants.coldDanger)  return RiskLevel.danger;
    if (fl <= AppConstants.coldAlert)   return RiskLevel.warning;
    if (fl <= AppConstants.coldWarning) return RiskLevel.caution;
    if (fl <= AppConstants.coldCaution) return RiskLevel.attention;
    return RiskLevel.safe;
  }

  Color _barColor(RiskLevel level, Season season) {
    if (season.isHeat) {
      return switch (level) {
        RiskLevel.safe      => const Color(0xFFFFDDCC),
        RiskLevel.attention => const Color(0xFFFFF176),
        RiskLevel.caution   => const Color(0xFFFFB899),
        RiskLevel.warning   => const Color(0xFFFF7A50),
        RiskLevel.danger    => AppColors.heatCard,
      };
    } else if (season.isCold) {
      return switch (level) {
        RiskLevel.safe      => const Color(0xFFCCDDF5),
        RiskLevel.attention => const Color(0xFFB3E5FC),
        RiskLevel.caution   => const Color(0xFF9AB6E8),
        RiskLevel.warning   => const Color(0xFF5580CC),
        RiskLevel.danger    => AppColors.coldCard,
      };
    } else {
      return switch (level) {
        RiskLevel.safe      => const Color(0xFFB8DDB8),
        RiskLevel.attention => const Color(0xFFA5D6A7),
        RiskLevel.caution   => const Color(0xFF80C080),
        RiskLevel.warning   => const Color(0xFF4CAF50),
        RiskLevel.danger    => AppColors.normalCard,
      };
    }
  }
}
