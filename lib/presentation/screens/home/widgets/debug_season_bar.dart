import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/datasources/group_stats_data_source.dart';
import '../../../../data/datasources/threshold_service.dart';
import '../../../../domain/entities/season.dart';
import '../../../../presentation/providers/debug_provider.dart';
import '../../../../presentation/providers/user_profile_provider.dart';

/// 디버그 빌드 전용 — 릴리즈 빌드에서는 완전히 제거됨
class DebugSeasonBar extends ConsumerWidget {
  const DebugSeasonBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kDebugMode) return const SizedBox.shrink();

    final override = ref.watch(debugTemperatureOverrideProvider);

    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          const Text(
            'DEBUG',
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _showTempInput(context, ref, override),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              decoration: BoxDecoration(
                color: override != null
                    ? Colors.orange
                    : Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange, width: 1),
              ),
              child: Text(
                override != null
                    ? '기온 ${override.toStringAsFixed(1)}°C'
                    : '온도 설정',
                style: TextStyle(
                  fontSize: 11,
                  color: override != null ? Colors.white : Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          if (override != null)
            GestureDetector(
              onTap: () =>
                  ref.read(debugTemperatureOverrideProvider.notifier).state =
                      null,
              child: const Text(
                'API',
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _DebugChip(
                    label: 'DB시딩',
                    color: Colors.teal,
                    onTap: () => _seedThresholds(context, ref),
                  ),
                  const SizedBox(width: 6),
                  _DebugChip(
                    label: '폭염시드29',
                    color: Colors.deepOrange,
                    onTap: () =>
                        _seedGroupFeedback(context, ref, Season.heat),
                  ),
                  const SizedBox(width: 6),
                  _DebugChip(
                    label: '한파시드29',
                    color: Colors.lightBlue,
                    onTap: () =>
                        _seedGroupFeedback(context, ref, Season.cold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTempInput(
      BuildContext context, WidgetRef ref, double? current) {
    final controller = TextEditingController(
      text: current?.toStringAsFixed(1) ?? '',
    );

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('기온 입력'),
        content: TextField(
          controller: controller,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true, signed: true),
          decoration: const InputDecoration(
            hintText: '예: 36.0',
            suffixText: '°C',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (_) => _apply(ctx, ref, controller.text),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => _apply(ctx, ref, controller.text),
            child: const Text('적용'),
          ),
        ],
      ),
    );
  }

  void _apply(BuildContext ctx, WidgetRef ref, String text) {
    final value = double.tryParse(text);
    if (value != null) {
      ref.read(debugTemperatureOverrideProvider.notifier).state = value;
    }
    Navigator.pop(ctx);
  }

  Future<void> _seedThresholds(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(thresholdServiceProvider).seedIfEmpty();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('임계값 시딩 완료 (이미 있는 문서는 스킵)'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('시딩 실패: $e')),
        );
      }
    }
  }

  static const _conditionPool = ['심혈관', '당뇨', '호흡기', '고혈압', '신장', '비만'];

  // 실제 피드백 화면(FeedbackCard)과 동일한 3지선다 델타값
  // (괜찮아요/조금 힘듦/매우 힘듦) — 집단학습 직전(29건) 상태를 그대로 재현
  static double _choiceDelta(Season season, int choice) {
    if (season.isHeat) {
      return switch (choice) { 0 => 5.0, 1 => -1.0, _ => -5.0 };
    }
    return switch (choice) { 0 => -5.0, 1 => 1.0, _ => 5.0 };
  }

  /// 집단학습 임계값(30건) 바로 직전인 29건의 더미 피드백을 현재 로그인한
  /// 사용자의 연령 그룹에 시드한다. 응답 3지선다 분포와 기저질환 유무를
  /// 섞어 실제 피드백과 비슷한 복합 데이터를 재현한다.
  Future<void> _seedGroupFeedback(
      BuildContext context, WidgetRef ref, Season season) async {
    final profile = ref.read(userProfileNotifierProvider).valueOrNull;
    if (profile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('프로필을 먼저 설정해주세요')),
      );
      return;
    }

    final ageKey = _ageKey(profile.age);
    final random = Random();

    const seedCount = 29;
    var sum = 0.0;
    final conditionCounts = <String, int>{};

    for (var i = 0; i < seedCount; i++) {
      // 조금 힘듦/매우 힘듦 쪽에 조금 더 무게를 둬 집단 보정이 눈에 띄게 나오도록
      final choice = [0, 1, 1, 2, 2][random.nextInt(5)];
      sum += _choiceDelta(season, choice);

      // 절반 정도는 기저질환 없음, 나머지는 1~2개 무작위 보유 (복합 데이터)
      if (random.nextBool()) {
        final conditionCount = 1 + random.nextInt(2);
        final shuffled = [..._conditionPool]..shuffle(random);
        for (final c in shuffled.take(conditionCount)) {
          conditionCounts[c] = (conditionCounts[c] ?? 0) + 1;
        }
      }
    }

    try {
      await ref.read(groupStatsDataSourceProvider).seedDebugBatch(
            ageKey: ageKey,
            season: season,
            count: seedCount,
            sum: sum,
            conditionCounts: conditionCounts,
          );
      if (context.mounted) {
        final seasonLabel = season.isHeat ? '폭염' : '한파';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '$seasonLabel 시드 $seedCount건 완료 ($ageKey, 평균 ${(sum / seedCount).toStringAsFixed(2)}°C)'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('시드 실패: $e')),
        );
      }
    }
  }

  static String _ageKey(int age) {
    if (age <= 9) return 'infant_0to9';
    if (age <= 17) return 'youth_10to17';
    if (age <= 64) return 'adult_18to64';
    if (age <= 74) return 'elderly_65to74';
    return 'super_elderly_75plus';
  }
}

class _DebugChip extends StatelessWidget {
  const _DebugChip({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
