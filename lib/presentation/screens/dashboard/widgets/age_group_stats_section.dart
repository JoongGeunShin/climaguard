import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/group_stat.dart';
import '../../../../presentation/providers/group_stats_provider.dart';
import '../models/demo_stats.dart';

class AgeGroupStatsSection extends ConsumerWidget {
  const AgeGroupStatsSection({super.key, required this.isHeat});

  final bool isHeat;

  static const _meta = {
    'super_elderly_75plus': ('초고위험군', '75세 이상', 20),
    'elderly_65to74': ('고령 위험군', '65~74세', 28),
    'adult_18to64': ('성인', '18~64세', 35),
    'youth_10to17': ('청소년', '10~17세', 12),
    'infant_0to9': ('영유아', '0~9세', 5),
  };

  static const _orderedKeys = [
    'super_elderly_75plus',
    'elderly_65to74',
    'adult_18to64',
    'youth_10to17',
    'infant_0to9',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(groupStatsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('집단 학습 현황',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          '연령 그룹별 피드백 반영 현황',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        statsAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, _) => _buildTable(_demoStats()),
          data: (stats) {
            final hasRealData = stats.any((s) => s.totalFeedbacks > 0);
            final rows = hasRealData ? _mergedStats(stats) : _demoStats();
            return _buildTable(rows);
          },
        ),
      ],
    );
  }

  List<_RowData> _demoStats() => demoAgeGroups
      .map((g) => _RowData(
            key: g.key,
            label: g.label,
            ageRange: g.ageRange,
            count: g.count,
            feedbacks: isHeat ? g.totalHeatFeedbacks : g.totalColdFeedbacks,
            offset: isHeat ? g.heatGroupOffset : g.coldGroupOffset,
            isDemo: true,
          ))
      .toList();

  List<_RowData> _mergedStats(List<GroupStat> stats) {
    return _orderedKeys.map((key) {
      final stat = stats.firstWhere((s) => s.ageKey == key,
          orElse: () => GroupStat.empty(key));
      final (label, ageRange, count) = _meta[key]!;
      return _RowData(
        key: key,
        label: label,
        ageRange: ageRange,
        count: count,
        feedbacks: isHeat ? stat.heatCount : stat.coldCount,
        offset: isHeat ? stat.heatGroupOffset : stat.coldGroupOffset,
        isDemo: false,
      );
    }).toList();
  }

  Widget _buildTable(List<_RowData> rows) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: List.generate(rows.length, (i) {
          final g = rows[i];
          final isLast = i == rows.length - 1;
          final offsetLabel = isHeat
              ? (g.offset < 0
                  ? '${g.offset.toStringAsFixed(2)}° 민감'
                  : '+${g.offset.toStringAsFixed(2)}° 여유')
              : (g.offset > 0
                  ? '+${g.offset.toStringAsFixed(2)}° 일찍'
                  : '${g.offset.toStringAsFixed(2)}° 늦게');

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(_emoji(g.key),
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(g.label,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(width: 4),
                              Text(g.ageRange,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500])),
                              if (g.isDemo) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF3E0),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text('데모',
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: Color(0xFFE65100))),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${g.count}명 · 피드백 ${g.feedbacks}개',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          offsetLabel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isHeat
                                ? (g.offset < 0
                                    ? const Color(0xFFE53920)
                                    : const Color(0xFF2E7D32))
                                : (g.offset > 0
                                    ? const Color(0xFF2C4FA0)
                                    : const Color(0xFF2E7D32)),
                          ),
                        ),
                        Text('집단 보정',
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey[400])),
                      ],
                    ),
                  ],
                ),
              ),
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
    );
  }

  String _emoji(String key) => switch (key) {
        'super_elderly_75plus' => '👴',
        'elderly_65to74' => '🧓',
        'adult_18to64' => '🧑',
        'youth_10to17' => '🧒',
        _ => '👶',
      };
}

class _RowData {
  const _RowData({
    required this.key,
    required this.label,
    required this.ageRange,
    required this.count,
    required this.feedbacks,
    required this.offset,
    required this.isDemo,
  });

  final String key;
  final String label;
  final String ageRange;
  final int count;
  final int feedbacks;
  final double offset;
  final bool isDemo;
}
