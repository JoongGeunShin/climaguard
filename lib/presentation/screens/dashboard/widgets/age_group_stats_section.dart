import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/datasources/threshold_service.dart';
import '../../../../domain/entities/age_thresholds.dart';

/// 연령대별로 실제 적용 중인 위험 단계(관심/주의/경고/위험) 보정값을 보여준다.
/// thresholds/age_{ageKey} 문서를 실시간으로 구독하므로, 집단학습으로 값이
/// 갱신되면 화면도 즉시 갱신된다.
class AgeGroupStatsSection extends StatelessWidget {
  const AgeGroupStatsSection({super.key, required this.isHeat});

  final bool isHeat;

  static const _meta = {
    'super_elderly_75plus': ('초고위험군', '75세 이상', '👴'),
    'elderly_65to74': ('고령 위험군', '65~74세', '🧓'),
    'adult_18to64': ('성인', '18~64세', '🧑'),
    'youth_10to17': ('청소년', '10~17세', '🧒'),
    'infant_0to9': ('영유아', '0~9세', '👶'),
  };

  static const _orderedKeys = [
    'super_elderly_75plus',
    'elderly_65to74',
    'adult_18to64',
    'youth_10to17',
    'infant_0to9',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('연령대별 위험 기준',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          '집단학습으로 갱신되는 연령대별 체감온도 보정값이에요',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: Column(
            children: List.generate(_orderedKeys.length, (i) {
              final key = _orderedKeys[i];
              final isLast = i == _orderedKeys.length - 1;
              return Column(
                children: [
                  _AgeOffsetRow(ageKey: key, isHeat: isHeat, meta: _meta[key]!),
                  if (!isLast)
                    const Divider(
                        height: 1,
                        indent: 72,
                        endIndent: 16,
                        color: Color(0xFFF0F0F0)),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _AgeOffsetRow extends ConsumerWidget {
  const _AgeOffsetRow({
    required this.ageKey,
    required this.isHeat,
    required this.meta,
  });

  final String ageKey;
  final bool isHeat;
  final (String, String, String) meta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (label, ageRange, emoji) = meta;
    final ageOffsets =
        ref.watch(ageOffsetsProvider(ageKey)).valueOrNull ?? AgeOffsets.zero;
    final levels = isHeat ? ageOffsets.heat : ageOffsets.cold;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(label,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 4),
                    Text(ageRange,
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _LevelChip(label: '관심', value: levels.attention, isHeat: isHeat),
                    _LevelChip(label: '주의', value: levels.caution, isHeat: isHeat),
                    _LevelChip(label: '경고', value: levels.warning, isHeat: isHeat),
                    _LevelChip(label: '위험', value: levels.danger, isHeat: isHeat),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({
    required this.label,
    required this.value,
    required this.isHeat,
  });

  final String label;
  final double value;
  final bool isHeat;

  @override
  Widget build(BuildContext context) {
    // 폭염은 음수(더 낮은 온도에서부터 위험)일수록, 한파는 양수(더 높은
    // 온도에서부터 위험)일수록 그 연령대가 더 민감하다는 뜻이라 강조색을 준다.
    final sensitive = isHeat ? value < 0 : value > 0;
    final color = sensitive ? const Color(0xFFE53920) : const Color(0xFF2E7D32);
    final sign = value > 0 ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label $sign${value.toStringAsFixed(1)}°',
        style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
