import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/weather_data.dart';

class WeatherSummaryCard extends StatelessWidget {
  final WeatherData weather;
  const WeatherSummaryCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final isHeat = weather.season.isHeat;
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _Item(
              label: '기온',
              value: '${weather.temperature.toStringAsFixed(1)}°C',
              icon: Icons.thermostat,
            ),
            _Item(
              label: isHeat ? '폭염 체감' : '한파 체감',
              value: '${weather.feelsLike.toStringAsFixed(1)}°C',
              icon: isHeat ? Icons.wb_sunny_outlined : Icons.ac_unit,
            ),
            _Item(
              label: '습도',
              value: '${weather.humidity}%',
              icon: Icons.water_drop_outlined,
            ),
            if (!isHeat)
              _Item(
                label: '풍속',
                value: '${weather.windSpeed.toStringAsFixed(1)}m/s',
                icon: Icons.air,
              ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _Item({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
