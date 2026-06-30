class GroupStat {
  const GroupStat({
    required this.ageKey,
    required this.heatCount,
    required this.heatSum,
    required this.coldCount,
    required this.coldSum,
  });

  final String ageKey;
  final int heatCount;
  final double heatSum;
  final int coldCount;
  final double coldSum;

  int get totalFeedbacks => heatCount + coldCount;

  // 집단 평균 피드백 * 0.2 (개인과 동일한 스케일 적용)
  double get heatGroupOffset => heatCount > 0
      ? ((heatSum / heatCount) * 0.2).clamp(-3.0, 3.0)
      : 0.0;
  double get coldGroupOffset => coldCount > 0
      ? ((coldSum / coldCount) * 0.2).clamp(-3.0, 3.0)
      : 0.0;

  factory GroupStat.empty(String ageKey) => GroupStat(
        ageKey: ageKey,
        heatCount: 0,
        heatSum: 0,
        coldCount: 0,
        coldSum: 0,
      );

  factory GroupStat.fromMap(String ageKey, Map<String, dynamic> data) =>
      GroupStat(
        ageKey: ageKey,
        heatCount: (data['heatCount'] as int?) ?? 0,
        heatSum: (data['heatSum'] as num?)?.toDouble() ?? 0.0,
        coldCount: (data['coldCount'] as int?) ?? 0,
        coldSum: (data['coldSum'] as num?)?.toDouble() ?? 0.0,
      );
}
