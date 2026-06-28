import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFFF5A36);
  static const Color primaryDark = Color(0xFFD44020);
  static const Color primaryLight = Color(0xFFFF8A65);

  // 위험 단계별 색상
  static const Color riskWatch = Color(0xFFFFD600);    // 주의 — 노랑
  static const Color riskWarning = Color(0xFFFF9100);  // 경고 — 주황
  static const Color riskDanger = Color(0xFFD50000);   // 위험 — 빨강
  static const Color riskSafe = Color(0xFF43A047);     // 안전 — 초록

  // 한파 위험단계 색상
  static const Color coldSafe    = Color(0xFF00897B); // 청록
  static const Color coldCaution = Color(0xFF0288D1); // 하늘파랑
  static const Color coldWarning = Color(0xFF1565C0); // 파랑
  static const Color coldDanger  = Color(0xFF0D47A1); // 진남색

  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFE0E0E0);
}
