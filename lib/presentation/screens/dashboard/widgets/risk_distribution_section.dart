import 'package:flutter/material.dart';
import '../../../../domain/entities/risk_level.dart';
import '../models/demo_stats.dart';

class RiskDistributionSection extends StatelessWidget {
  const RiskDistributionSection({
    super.key,
    required this.distribution,
    required this.isHeat,
  });

  final RiskDistribution distribution;
  final bool isHeat;

  @override
  Widget build(BuildContext context) {
    final scenarioLabel = isHeat ? '폭염 시나리오 (체감 36.5°C)' : '한파 시나리오 (체감 -12.0°C)';
    final levels = [
      RiskLevel.danger,
      RiskLevel.warning,
      RiskLevel.caution,
      RiskLevel.safe,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('위험 인원 현황',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                scenarioLabel,
                style: TextStyle(
                    fontSize: 11, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '총 ${distribution.total}명 모니터링 중',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        Row(
          children: levels
              .map((level) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: level == RiskLevel.safe ? 0 : 8),
                      child: _RiskCard(
                        level: level,
                        count: distribution.countOf(level),
                        total: distribution.total,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
        // 가로 비율 바
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Row(
            children: levels.map((level) {
              return Expanded(
                flex: distribution.countOf(level),
                child: Container(
                  height: 8,
                  color: riskColor(level),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _RiskCard extends StatelessWidget {
  const _RiskCard({
    required this.level,
    required this.count,
    required this.total,
  });

  final RiskLevel level;
  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    final color = riskColor(level);
    final pct = (count / total * 100).round();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            riskLabel(level),
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$count명',
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '$pct%',
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
