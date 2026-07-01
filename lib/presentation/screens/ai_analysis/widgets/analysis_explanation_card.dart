import 'package:flutter/material.dart';
import '../../../../domain/entities/climate_alert.dart';
import '../../../../domain/entities/risk_level.dart';

class AnalysisExplanationCard extends StatelessWidget {
  const AnalysisExplanationCard({
    super.key,
    required this.alert,
    required this.explanation,
  });

  final ClimateAlert alert;
  final String explanation;

  String get _riskEmoji => switch (alert.personalRiskLevel) {
        RiskLevel.safe      => '😌',
        RiskLevel.attention => '🙂',
        RiskLevel.caution   => '😟',
        RiskLevel.warning   => '😰',
        RiskLevel.danger    => '🤯',
      };

  String get _riskTitle => switch (alert.personalRiskLevel) {
        RiskLevel.safe      => '지금은 안전 단계예요',
        RiskLevel.attention => '지금은 관심 단계예요',
        RiskLevel.caution   => '지금은 주의 단계예요',
        RiskLevel.warning   => '지금은 경고 단계예요',
        RiskLevel.danger    => '지금은 위험 단계예요',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_riskEmoji,
                  style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Text(
                _riskTitle,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            explanation,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}
