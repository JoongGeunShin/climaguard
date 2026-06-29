import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/weather_data.dart';

class NextUpdateChip extends StatelessWidget {
  final WeatherData weather;
  const NextUpdateChip({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(color: AppColors.textSecondary);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.update, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(_nextUpdateLabel(), style: style),
          const Spacer(),
          Text('관측 ${_fmt(weather.observedAt)}', style: style),
        ],
      ),
    );
  }

  String _nextUpdateLabel() {
    final next = weather.nextUpdateAt;
    if (next != null) return '${_fmt(next)} 업데이트';
    return '${_nextKmaHour()} 업데이트';
  }

  String _fmt(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  // 기상청 단기예보 발표 시각: 02, 05, 08, 11, 14, 17, 20, 23
  String _nextKmaHour() {
    const hours = [2, 5, 8, 11, 14, 17, 20, 23];
    final now = DateTime.now();
    for (final h in hours) {
      if (now.hour < h) return '${h.toString().padLeft(2, '0')}:00';
    }
    return '02:00';
  }
}
