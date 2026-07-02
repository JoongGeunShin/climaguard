import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/datasources/threshold_service.dart';
import '../../../../domain/entities/age_thresholds.dart';
import '../../../../domain/entities/user_profile.dart';

class ThresholdCards extends ConsumerWidget {
  const ThresholdCards({super.key, required this.profile});

  final UserProfile profile;

  String _ageKey(int age) {
    if (age <= 9)  return 'infant_0to9';
    if (age <= 17) return 'youth_10to17';
    if (age <= 64) return 'adult_18to64';
    if (age <= 74) return 'elderly_65to74';
    return 'super_elderly_75plus';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ageKey = _ageKey(profile.age);

    // Firestore 실시간 스트림 watch — 그룹학습으로 값이 바뀌면 즉시 재렌더링된다.
    final base = ref.watch(baseThresholdsProvider).valueOrNull ??
        BaseThresholds.defaults;
    final ageOff = ref.watch(ageOffsetsProvider(ageKey)).valueOrNull ??
        AgeOffsets.zero;

    double condHeat = 0, condCold = 0;
    for (final c in profile.conditions) {
      final off = ref.watch(conditionOffsetProvider(c)).valueOrNull;
      if (off != null) {
        condHeat += off.heat;
        condCold += off.cold;
      }
    }

    final totalFeedbacks = profile.heatFeedbackHistory.length +
        profile.coldFeedbackHistory.length;

    double feedbackOff = 0;
    if (profile.heatFeedbackHistory.isNotEmpty) {
      final avg = profile.heatFeedbackHistory.reduce((a, b) => a + b) /
          profile.heatFeedbackHistory.length;
      feedbackOff = (avg * 0.2).clamp(-3.0, 3.0);
    }

    // 경고 단계 기준으로 개인 임계값 표시
    final heatT = base.heatWarning + ageOff.heat.warning +
        condHeat + feedbackOff;
    final coldT = base.coldWarning + ageOff.cold.warning +
        condCold + feedbackOff;
    // 성인 기준선 대비 차이
    final heatDiff = heatT - base.heatWarning;
    final coldDiff = coldT - base.coldWarning;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('내 맞춤 기준',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
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
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            _diffLabel,
            style: TextStyle(fontSize: 12, color: iconColor),
          ),
        ],
      ),
    );
  }
}
