import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/climate_alert.dart';

class InfoReasonRow extends StatelessWidget {
  final ClimateAlert alert;
  const InfoReasonRow({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    // 적정온도 구간은 별도 안내
    if (alert.season.isNormal) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Row(
          children: [
            Icon(Icons.check_circle_outline,
                size: 15, color: AppColors.riskSafe),
            const SizedBox(width: 6),
            Text(
              '현재 기온이 쾌적한 범위입니다 (14~24°C)',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    final isHeat = alert.season.isHeat;
    final officialBase =
        isHeat ? AppConstants.heatAlert : AppConstants.coldAlert;
    final offset = alert.personalThreshold - officialBase;
    final offsetAbs = offset.abs().toStringAsFixed(1);

    final reasons = _extractReasonLabels();
    final reasonText = reasons.isNotEmpty ? reasons.join('·') : '나이';
    final sensitiveLabel = isHeat ? '더 민감하게 경보해요' : '일찍 경보해요';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline,
              size: 15, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: '$reasonText 반영해 '),
                  TextSpan(
                    text: '$offsetAbs°C $sensitiveLabel',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _extractReasonLabels() {
    final labels = <String>[];
    for (final r in alert.adjustmentReasons) {
      if (r.contains('영유아') || r.contains('청소년') ||
          r.contains('성인') || r.contains('고령') || r.contains('초고령')) {
        labels.add('나이');
      } else if (r.contains('피드백')) {
        labels.add('집단학습');
      } else {
        final parts = r.split(' ');
        if (parts.isNotEmpty) labels.add(parts.first);
      }
    }
    return labels;
  }
}
