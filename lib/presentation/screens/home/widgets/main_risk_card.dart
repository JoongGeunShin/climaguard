import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/season_theme.dart';
import '../../../../domain/entities/climate_alert.dart';
import '../../../../domain/entities/season.dart';
import '../../../../domain/entities/weather_data.dart';
import '../../../../domain/usecases/alert_generation_use_case.dart';

class MainRiskCard extends StatelessWidget {
  final WeatherData weather;
  final ClimateAlert alert;

  const MainRiskCard({
    super.key,
    required this.weather,
    required this.alert,
  });

  @override
  Widget build(BuildContext context) {
    final season = weather.season;
    final cardColor = SeasonTheme.riskColor(alert.personalRiskLevel, season);
    final textColor = SeasonTheme.onRiskColor(alert.personalRiskLevel, season);
    final riskScore = _riskScore(season);
    final message = AlertGenerationUseCase().generate(alert: alert);
    final levelLabel = alert.personalRiskLevel.label;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -30,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: textColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            size: 14, color: textColor),
                        const SizedBox(width: 4),
                        Text(
                          '내 기준 $levelLabel',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '지금 체감온도',
                              style: TextStyle(
                                color: textColor.withValues(alpha: 0.75),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${weather.feelsLike.toStringAsFixed(1)}°',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 52,
                                fontWeight: FontWeight.w800,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '기온 ${weather.temperature.toStringAsFixed(1)}°C',
                              style: TextStyle(
                                color: textColor.withValues(alpha: 0.6),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _RiskScoreRing(score: riskScore, textColor: textColor),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: textColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          season.isHeat
                              ? Icons.remove_circle_outline
                              : season.isCold
                                  ? Icons.ac_unit
                                  : Icons.check_circle_outline,
                          color: textColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            message,
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _riskScore(Season season) {
    final fl = alert.currentFeelsLike;
    final threshold = alert.personalThreshold;
    // 개인 임계치 기준 ±5°C 범위로 0~100 매핑
    if (season.isHeat) {
      return ((fl - threshold + 5) / 10 * 100).round().clamp(0, 100);
    }
    if (season.isCold) {
      return ((threshold - fl + 5) / 10 * 100).round().clamp(0, 100);
    }
    return 0;
  }
}

class _RiskScoreRing extends StatelessWidget {
  final int score;
  final Color textColor;
  const _RiskScoreRing({required this.score, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      height: 84,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(84, 84),
            painter: _RingPainter(progress: score / 100, color: textColor),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '위험도',
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.75),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$score',
                style: TextStyle(
                  color: textColor,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  const _RingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 10) / 2;
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    final trackPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}

class NoProfileRiskCard extends StatelessWidget {
  final Season season;
  final VoidCallback onSetupProfile;

  const NoProfileRiskCard({
    super.key,
    required this.season,
    required this.onSetupProfile,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = season.isHeat
        ? AppColors.heatCard
        : season.isCold
            ? AppColors.coldCard
            : AppColors.normalCard;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            const Icon(Icons.person_add_outlined,
                color: Colors.white, size: 40),
            const SizedBox(height: 12),
            const Text(
              '프로필을 설정하면\n개인화 위험 단계를 볼 수 있어요',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onSetupProfile,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('프로필 설정하기'),
            ),
          ],
        ),
      ),
    );
  }
}
