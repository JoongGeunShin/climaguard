import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/climate_alert.dart';
import '../../../../domain/entities/group_stat.dart';
import '../../../../presentation/providers/group_stats_provider.dart';
import '../../../../presentation/providers/user_profile_provider.dart';

class GroupLearningCard extends ConsumerWidget {
  const GroupLearningCard({super.key, required this.alert});

  final ClimateAlert alert;

  static String _ageKey(int age) {
    if (age <= 9) return 'infant_0to9';
    if (age <= 17) return 'youth_10to17';
    if (age <= 64) return 'adult_18to64';
    if (age <= 74) return 'elderly_65to74';
    return 'super_elderly_75plus';
  }

  static String _ageGroupLabel(String key) => switch (key) {
        'super_elderly_75plus' => '75세 이상',
        'elderly_65to74' => '65~74세',
        'adult_18to64' => '18~64세',
        'youth_10to17' => '10~17세',
        _ => '0~9세',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileNotifierProvider);
    final statsAsync = ref.watch(groupStatsProvider);
    final isHeat = alert.season.isHeat;

    return statsAsync.when(
      loading: () => const _CardShell(child: _LoadingRow()),
      error: (_, _) => _FallbackCard(isHeat: isHeat),
      data: (stats) {
        final profile = profileAsync.valueOrNull;
        final key = profile != null ? _ageKey(profile.age) : 'super_elderly_75plus';
        final stat = stats.firstWhere(
          (s) => s.ageKey == key,
          orElse: () => GroupStat.empty(key),
        );

        final count = isHeat ? stat.heatCount : stat.coldCount;
        final offset = isHeat ? stat.heatGroupOffset : stat.coldGroupOffset;

        // 피드백 없으면 연령 그룹 기반 기본 보정값으로 시연용 카드 표시
        if (count == 0) {
          final baseOffset = isHeat
              ? (AppConstants.ageGroupHeatOffsets[key] ?? 0.0)
              : (AppConstants.ageGroupColdOffsets[key] ?? 0.0);
          return _DefaultOffsetCard(
            isHeat: isHeat,
            groupLabel: _ageGroupLabel(key),
            baseOffset: baseOffset,
          );
        }

        final groupLabel = _ageGroupLabel(key);
        final seasonLabel = isHeat ? '폭염' : '한파';
        final direction = isHeat
            ? (offset < 0 ? '더 민감' : '더 여유롭게')
            : (offset > 0 ? '더 일찍' : '더 늦게');
        final adjustLabel = '${offset < 0 ? '' : '+'}${offset.toStringAsFixed(1)}°C $direction';

        return _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.groups, color: Color(0xFFB39DDB), size: 18),
                  SizedBox(width: 6),
                  Text(
                    '집단 학습이 반영됐어요',
                    style: TextStyle(
                      color: Color(0xFFB39DDB),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 14, height: 1.5),
                  children: [
                    TextSpan(text: '지금 $groupLabel '),
                    TextSpan(
                      text: '$count명',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '의 피드백을 모아, $seasonLabel 임계치를\n'),
                    TextSpan(
                      text: adjustLabel,
                      style: const TextStyle(
                          color: Color(0xFFCE93D8),
                          fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: '하게 조정했어요.'),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text('피드백 $count개 수집됨',
                      style: const TextStyle(
                          color: Colors.white38, fontSize: 12)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _LoadingRow extends StatelessWidget {
  const _LoadingRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 16, height: 16,
          child: CircularProgressIndicator(
              color: Color(0xFFB39DDB), strokeWidth: 2),
        ),
        SizedBox(width: 8),
        Text('집단 학습 데이터 불러오는 중...',
            style: TextStyle(color: Colors.white54, fontSize: 13)),
      ],
    );
  }
}

class _FallbackCard extends StatelessWidget {
  const _FallbackCard({required this.isHeat});
  final bool isHeat;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.groups, color: Color(0xFFB39DDB), size: 18),
              SizedBox(width: 6),
              Text('집단 학습 준비 중',
                  style: TextStyle(
                      color: Color(0xFFB39DDB),
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${isHeat ? "폭염" : "한파"} 피드백을 모으고 있어요. 피드백을 남겨주시면 더 정확한 기준이 만들어져요.',
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}

/// 실 피드백이 없을 때 연령별 기준 보정값을 기반 안내 카드
class _DefaultOffsetCard extends StatelessWidget {
  const _DefaultOffsetCard({
    required this.isHeat,
    required this.groupLabel,
    required this.baseOffset,
  });

  final bool isHeat;
  final String groupLabel;
  final double baseOffset;

  @override
  Widget build(BuildContext context) {
    final seasonLabel = isHeat ? '폭염' : '한파';
    final direction = isHeat
        ? (baseOffset < 0 ? '더 민감' : '더 여유롭게')
        : (baseOffset > 0 ? '더 일찍' : '더 늦게');
    final sign = baseOffset >= 0 ? '+' : '';
    final adjustLabel = '$sign${baseOffset.toStringAsFixed(1)}°C $direction';

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.groups, color: Color(0xFFB39DDB), size: 18),
              SizedBox(width: 6),
              Text(
                '집단 기준이 반영됐어요',
                style: TextStyle(
                  color: Color(0xFFB39DDB),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                  color: Colors.white70, fontSize: 14, height: 1.5),
              children: [
                TextSpan(text: '$groupLabel 연령 그룹 특성을 반영해 $seasonLabel 임계치를\n'),
                TextSpan(
                  text: adjustLabel,
                  style: const TextStyle(
                      color: Color(0xFFCE93D8),
                      fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '하게 조정했어요.'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Text('WHO 열사병 가이드라인 · 행안부 기준 적용',
                  style: TextStyle(
                      color: Colors.white38, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
