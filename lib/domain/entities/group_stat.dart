class GroupStat {
  const GroupStat({
    required this.ageKey,
    required this.heatCount,
    required this.heatSum,
    required this.coldCount,
    required this.coldSum,
    this.conditionCounts = const {},
    this.heatOffset,
    this.coldOffset,
    this.analyzedAtCount = 0,
  });

  final String ageKey;
  final int heatCount;
  final double heatSum;
  final int coldCount;
  final double coldSum;
  final Map<String, int> conditionCounts; // 기저질환 누적 카운트
  final double? heatOffset;              // Gemini 분석 결과 (null = 미분석)
  final double? coldOffset;
  final int analyzedAtCount;            // 마지막 분석 당시 총 피드백 수

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

  /// 30건 이상이고 마지막 분석 이후 10건 이상 쌓였으면 재분석 대상
  bool get needsAiAnalysis =>
      totalFeedbacks >= 30 &&
      (analyzedAtCount == 0 || totalFeedbacks - analyzedAtCount >= 10);

  String get topConditions {
    if (conditionCounts.isEmpty) return '없음';
    final sorted = conditionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(3).map((e) => e.key).join(', ');
  }

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
        conditionCounts: (data['conditionCounts'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, (v as num).toInt())) ??
            {},
        heatOffset: (data['heatOffset'] as num?)?.toDouble(),
        coldOffset: (data['coldOffset'] as num?)?.toDouble(),
        analyzedAtCount: (data['analyzedAtCount'] as int?) ?? 0,
      );
}
