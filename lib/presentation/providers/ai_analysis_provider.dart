import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/gemini_data_source.dart';
import '../../domain/entities/climate_alert.dart';
import '../../domain/entities/risk_level.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_ai_explanation_use_case.dart';
import 'climate_alert_provider.dart';
import 'user_profile_provider.dart';

part 'ai_analysis_provider.g.dart';

class ActionItem {
  const ActionItem({
    required this.emoji,
    required this.bgColor,
    required this.title,
    required this.subtitle,
  });
  final String emoji;
  final Color bgColor;
  final String title;
  final String subtitle;
}

class AiAnalysisResult {
  const AiAnalysisResult({
    required this.explanation,
    required this.actions,
    required this.alert,
  });
  final String explanation;
  final List<ActionItem> actions;
  final ClimateAlert alert;
}

@riverpod
Future<AiAnalysisResult?> aiAnalysis(AiAnalysisRef ref) async {
  // read (not watch) — 화면 진입 시 1회만 실행
  final alert = await ref.read(climateAlertProvider.future);
  final profile = await ref.read(userProfileNotifierProvider.future);
  if (alert == null || profile == null) return null;

  final explanation = await GetAiExplanationUseCase(GeminiDataSource())
      .execute(profile: profile, alert: alert);

  return AiAnalysisResult(
    explanation: explanation,
    actions: _buildActions(profile, alert),
    alert: alert,
  );
}

List<ActionItem> _buildActions(UserProfile profile, ClimateAlert alert) {
  final season = alert.season;
  final conds = profile.conditions;
  final isHighRisk = alert.personalRiskLevel == RiskLevel.warning ||
      alert.personalRiskLevel == RiskLevel.danger;

  if (season.isHeat) {
    return [
      const ActionItem(
        emoji: '💧',
        bgColor: Color(0xFFE3F2FD),
        title: '물을 자주 드세요',
        subtitle: '목마르지 않아도 1시간에 한 컵',
      ),
      const ActionItem(
        emoji: '☀️',
        bgColor: Color(0xFFFFF3E0),
        title: '한낮 외출은 미뤄요',
        subtitle: '오후 2~5시 가장 위험',
      ),
      if (conds.contains('심혈관') || conds.contains('고혈압'))
        const ActionItem(
          emoji: '❤️',
          bgColor: Color(0xFFFFEBEE),
          title: '심장 약은 거르지 마세요',
          subtitle: '더위에 혈압 변동이 커요',
        ),
      if (conds.contains('당뇨'))
        const ActionItem(
          emoji: '🩸',
          bgColor: Color(0xFFFCE4EC),
          title: '혈당 관리에 주의하세요',
          subtitle: '더위로 인슐린 흡수가 달라져요',
        ),
      if (conds.contains('호흡기'))
        const ActionItem(
          emoji: '🫁',
          bgColor: Color(0xFFE0F2F1),
          title: '실내 환기에 신경 쓰세요',
          subtitle: '더위와 오염이 겹칠 수 있어요',
        ),
      if (conds.contains('신장'))
        const ActionItem(
          emoji: '💊',
          bgColor: Color(0xFFF3E5F5),
          title: '수분 섭취량을 지켜주세요',
          subtitle: '의사 지시에 따른 수분량 유지',
        ),
      if (isHighRisk)
        const ActionItem(
          emoji: '🏢',
          bgColor: Color(0xFFE8F5E9),
          title: '무더위쉼터를 이용하세요',
          subtitle: '가까운 시원한 공간 확인',
        ),
    ];
  }

  if (season.isCold) {
    return [
      const ActionItem(
        emoji: '🧥',
        bgColor: Color(0xFFEDE7F6),
        title: '따뜻하게 입으세요',
        subtitle: '얇은 옷을 여러 겹 겹쳐 입기',
      ),
      const ActionItem(
        emoji: '🏠',
        bgColor: Color(0xFFE3F2FD),
        title: '실내에 머무르세요',
        subtitle: '불필요한 외출은 자제하세요',
      ),
      if (conds.contains('심혈관') || conds.contains('고혈압'))
        const ActionItem(
          emoji: '❤️',
          bgColor: Color(0xFFFFEBEE),
          title: '혈압 변동에 주의하세요',
          subtitle: '급격한 온도 변화를 피하세요',
        ),
      if (conds.contains('호흡기'))
        const ActionItem(
          emoji: '🫁',
          bgColor: Color(0xFFE0F2F1),
          title: '실내 습도를 유지하세요',
          subtitle: '찬 공기 직접 흡입을 피하세요',
        ),
      if (isHighRisk)
        const ActionItem(
          emoji: '🏢',
          bgColor: Color(0xFFE3F2FD),
          title: '한파쉼터를 이용하세요',
          subtitle: '가까운 따뜻한 공간 확인',
        ),
    ];
  }

  // normal
  return const [
    ActionItem(
      emoji: '😊',
      bgColor: Color(0xFFE8F5E9),
      title: '오늘은 쾌적해요',
      subtitle: '가벼운 외출을 즐기세요',
    ),
    ActionItem(
      emoji: '💧',
      bgColor: Color(0xFFE3F2FD),
      title: '수분 보충을 잊지 마세요',
      subtitle: '규칙적으로 물 드세요',
    ),
  ];
}
