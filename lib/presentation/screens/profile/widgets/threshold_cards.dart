import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/user_profile.dart';

class ThresholdCards extends StatelessWidget {
  const ThresholdCards({super.key, required this.profile});

  final UserProfile profile;

  String _ageKey(int age) {
    if (age <= 9) return 'infant_0to9';
    if (age <= 17) return 'youth_10to17';
    if (age <= 64) return 'adult_18to64';
    if (age <= 74) return 'elderly_65to74';
    return 'super_elderly_75plus';
  }

  double _heatThreshold() {
    final key = _ageKey(profile.age);
    double offset = AppConstants.ageGroupHeatOffsets[key]!;
    for (final c in profile.conditions) {
      offset += AppConstants.conditionHeatOffsets[c] ?? 0.0;
    }
    if (profile.heatFeedbackHistory.isNotEmpty) {
      final avg = profile.heatFeedbackHistory.reduce((a, b) => a + b) /
          profile.heatFeedbackHistory.length;
      offset += (avg * 0.2).clamp(-3.0, 3.0);
    }
    return AppConstants.heatAlert + offset;
  }

  double _coldThreshold() {
    final key = _ageKey(profile.age);
    double offset = AppConstants.ageGroupColdOffsets[key]!;
    for (final c in profile.conditions) {
      offset += AppConstants.conditionColdOffsets[c] ?? 0.0;
    }
    if (profile.coldFeedbackHistory.isNotEmpty) {
      final avg = profile.coldFeedbackHistory.reduce((a, b) => a + b) /
          profile.coldFeedbackHistory.length;
      offset += (avg * 0.2).clamp(-3.0, 3.0);
    }
    return AppConstants.coldAlert + offset;
  }

  @override
  Widget build(BuildContext context) {
    final heatT = _heatThreshold();
    final coldT = _coldThreshold();
    final totalFeedbacks = profile.heatFeedbackHistory.length +
        profile.coldFeedbackHistory.length;
    final heatDiff = heatT - AppConstants.heatAlert;
    final coldDiff = coldT - AppConstants.coldAlert;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('내 맞춤 기준',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Spacer(),
            if (totalFeedbacks > 0)
              Text('피드백 $totalFeedbacks개 기반',
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ThresholdTile(
                icon: Icons.wb_sunny,
                iconColor: AppColors.heatCard,
                label: '폭염',
                value: heatT,
                diff: heatDiff,
                isHeat: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ThresholdTile(
                icon: Icons.ac_unit,
                iconColor: AppColors.coldCard,
                label: '한파',
                value: coldT,
                diff: coldDiff,
                isHeat: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ThresholdTile extends StatelessWidget {
  const _ThresholdTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.diff,
    required this.isHeat,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final double value;
  final double diff;
  final bool isHeat;

  String get _diffLabel {
    if (diff.abs() < 0.05) return '기본 기준과 동일';
    final absStr = diff.abs().toStringAsFixed(1);
    if (isHeat) {
      return diff < 0 ? '기본보다 -$absStr° 민감' : '기본보다 +$absStr° 여유';
    } else {
      return diff > 0 ? '기본보다 +$absStr° 일찍' : '기본보다 -$absStr° 늦게';
    }
  }

  Color get _diffColor {
    if (diff.abs() < 0.05) return Colors.grey;
    return iconColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 16),
              const SizedBox(width: 4),
              Text(label,
                  style: TextStyle(
                      fontSize: 13,
                      color: iconColor,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${value.toStringAsFixed(1)}°',
            style: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            _diffLabel,
            style: TextStyle(fontSize: 12, color: _diffColor),
          ),
        ],
      ),
    );
  }
}
