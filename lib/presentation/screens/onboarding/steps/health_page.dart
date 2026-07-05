import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/datasources/threshold_service.dart';
import '../../../../domain/entities/age_thresholds.dart';

class HealthPage extends StatelessWidget {
  final double hPad;
  final int age;
  final String? gender;
  final Set<String> selectedConditions;
  final bool noCondition;
  final List<String> conditionOptions;
  final String riskGroupLabel;
  final List<String> conditions;
  final bool isValid;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final void Function(String) onSelectGender;
  final void Function(String) onToggleCondition;
  final VoidCallback? onNext;

  const HealthPage({
    super.key,
    required this.hPad,
    required this.age,
    required this.gender,
    required this.selectedConditions,
    required this.noCondition,
    required this.conditionOptions,
    required this.riskGroupLabel,
    required this.conditions,
    required this.isValid,
    required this.onDecrement,
    required this.onIncrement,
    required this.onSelectGender,
    required this.onToggleCondition,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(hPad, 28, hPad, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '맞춤 안전 기준을\n만들어 드릴게요',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '나이와 건강 상태에 따라 위험한 온도가 달라요.\n몇 가지만 알려 주세요.',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 28),
                const Text('나이', style: TextStyle(fontFamily: 'Pretendard', fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                _AgeStepper(age: age, onDecrement: onDecrement, onIncrement: onIncrement),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Text('성별', style: TextStyle(fontFamily: 'Pretendard', fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 6),
                    if (gender == null)
                      const Text('필수', style: TextStyle(fontFamily: 'Pretendard', fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                _GenderToggle(selected: gender, onSelect: onSelectGender),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Text('기저질환', style: TextStyle(fontFamily: 'Pretendard', fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    const Text('중복 선택 가능', style: TextStyle(fontFamily: 'Pretendard', fontSize: 13, color: AppColors.textSecondary)),
                    const SizedBox(width: 6),
                    if (!noCondition && selectedConditions.isEmpty)
                      const Text('필수', style: TextStyle(fontFamily: 'Pretendard', fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ...conditionOptions.map((c) => _ConditionChip(
                          label: c,
                          selected: selectedConditions.contains(c),
                          onTap: () => onToggleCondition(c),
                        )),
                    _ConditionChip(
                      label: '없음',
                      selected: noCondition,
                      onTap: () => onToggleCondition('없음'),
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                _RiskSummaryCard(groupLabel: riskGroupLabel, age: age, conditions: conditions),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 24),
          child: Column(
            children: [
              if (!isValid)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline, size: 14, color: AppColors.primary),
                      SizedBox(width: 6),
                      Text(
                        '성별과 기저질환을 모두 선택해주세요.',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 13,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: const Color(0xFFE8E4DF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: onNext,
                  child: Text(
                    '다음',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: isValid ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AgeStepper extends StatelessWidget {
  final int age;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  const _AgeStepper({required this.age, required this.onDecrement, required this.onIncrement});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: const Color(0xFFF0EDE8), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          GestureDetector(
            onTap: onDecrement,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.remove, size: 24, color: Color(0xFF1A1A1A)),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('$age', style: const TextStyle(fontFamily: 'Pretendard', fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                const SizedBox(width: 4),
                const Text('세', style: TextStyle(fontFamily: 'Pretendard', fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
              ],
            ),
          ),
          GestureDetector(
            onTap: onIncrement,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.add, size: 24, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderToggle extends StatelessWidget {
  final String? selected;
  final void Function(String) onSelect;
  const _GenderToggle({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ['남성', '여성'].map((g) {
        final isSelected = selected == g;
        final isFirst = g == '남성';
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(g),
            child: Container(
              height: 52,
              margin: isFirst ? const EdgeInsets.only(right: 8) : EdgeInsets.zero,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1A1A1A) : const Color(0xFFF0EDE8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  g,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF555555),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ConditionChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ConditionChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.08) : const Color(0xFFF0EDE8),
          borderRadius: BorderRadius.circular(12),
          border: selected ? Border.all(color: AppColors.primary, width: 1.5) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: selected ? AppColors.primary : const Color(0xFF555555),
          ),
        ),
      ),
    );
  }
}

class _RiskSummaryCard extends ConsumerWidget {
  final String groupLabel;
  final int age;
  final List<String> conditions;
  const _RiskSummaryCard({
    required this.groupLabel,
    required this.age,
    required this.conditions,
  });

  String _ageKey(int age) {
    if (age <= 9) return 'infant_0to9';
    if (age <= 17) return 'youth_10to17';
    if (age <= 64) return 'adult_18to64';
    if (age <= 74) return 'elderly_65to74';
    return 'super_elderly_75plus';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ageKey = _ageKey(age);

    // Firestore 실시간 스트림 watch — 프로필 화면(ThresholdCards)과 동일하게
    // warning 단계 기준으로 계산하며, 그룹학습 갱신도 즉시 반영된다.
    final ageOff = ref.watch(ageOffsetsProvider(ageKey)).valueOrNull ??
        AgeOffsets.zero;

    double condHeat = 0;
    for (final c in conditions) {
      final off = ref.watch(conditionOffsetProvider(c)).valueOrNull;
      if (off != null) condHeat += off.heat;
    }

    final heatOffset = ageOff.heat.warning + condHeat;
    final sign = heatOffset >= 0 ? '+' : '';
    final offsetStr = '$sign${heatOffset.toStringAsFixed(1)}°';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('자동 분류 결과', style: TextStyle(fontFamily: 'Pretendard', fontSize: 12, color: Color(0xFF888888))),
                const SizedBox(height: 4),
                Text(groupLabel, style: const TextStyle(fontFamily: 'Pretendard', fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('폭염 보정', style: TextStyle(fontFamily: 'Pretendard', fontSize: 12, color: Color(0xFF888888))),
              const SizedBox(height: 4),
              Text(offsetStr, style: const TextStyle(fontFamily: 'Pretendard', fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }
}
