import 'season_group_stat.dart';

/// hotGroupStats / coldGroupStats 두 시즌 문서를 합쳐 UI에 보여주기 위한 뷰.
class GroupStat {
  const GroupStat({
    required this.ageKey,
    required this.heatCount,
    required this.heatSum,
    required this.coldCount,
    required this.coldSum,
    this.heatOffset,
    this.coldOffset,
  });

  final String ageKey;
  final int heatCount;
  final double heatSum;
  final int coldCount;
  final double coldSum;
  final double? heatOffset; // Gemini 분석 결과 (null = 미분석)
  final double? coldOffset;

  int get totalFeedbacks => heatCount + coldCount;

  // 집단 평균 피드백 * 0.2 — Gemini 결과가 없을 때 단순 통계 fallback
  double get heatGroupOffset => heatOffset ??
      (heatCount > 0
          ? ((heatSum / heatCount) * 0.2).clamp(-3.0, 3.0)
          : 0.0);
  double get coldGroupOffset => coldOffset ??
      (coldCount > 0
          ? ((coldSum / coldCount) * 0.2).clamp(-3.0, 3.0)
          : 0.0);

  factory GroupStat.empty(String ageKey) => GroupStat(
        ageKey: ageKey,
        heatCount: 0,
        heatSum: 0,
        coldCount: 0,
        coldSum: 0,
      );

  factory GroupStat.merge(
    String ageKey,
    SeasonGroupStat hot,
    SeasonGroupStat cold,
  ) =>
      GroupStat(
        ageKey: ageKey,
        heatCount: hot.count,
        heatSum: hot.sum,
        coldCount: cold.count,
        coldSum: cold.sum,
        heatOffset: hot.offset,
        coldOffset: cold.offset,
      );
}
