import 'season.dart';

/// 특정 연령 그룹의 단일 시즌(폭염 또는 한파) 피드백 배치.
///
/// hotGroupStats / coldGroupStats 컬렉션 문서 하나에 대응한다.
/// 30건이 쌓이면 분석 대상이 되고, 분석 완료 시 그 배치만큼만 차감되어
/// 다시 0부터 새 배치가 쌓인다 — 두 시즌은 서로 영향을 주지 않는다.
class SeasonGroupStat {
  const SeasonGroupStat({
    required this.ageKey,
    required this.season,
    required this.count,
    required this.sum,
    this.conditionCounts = const {},
    this.offset,
  });

  final String ageKey;
  final Season season;
  final int count;
  final double sum;
  final Map<String, int> conditionCounts; // 기저질환 누적 카운트
  final double? offset; // Gemini 분석 결과 (null = 미분석)

  // 배치 평균 * 0.2 — Gemini 결과가 없을 때 단순 통계 fallback
  double get groupOffset =>
      offset ?? (count > 0 ? ((sum / count) * 0.2).clamp(-3.0, 3.0) : 0.0);

  bool get needsAiAnalysis => count >= 30;

  String get topConditions {
    if (conditionCounts.isEmpty) return '없음';
    final sorted = conditionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(3).map((e) => e.key).join(', ');
  }

  factory SeasonGroupStat.empty(String ageKey, Season season) =>
      SeasonGroupStat(ageKey: ageKey, season: season, count: 0, sum: 0);

  factory SeasonGroupStat.fromMap(
    String ageKey,
    Season season,
    Map<String, dynamic> data,
  ) =>
      SeasonGroupStat(
        ageKey: ageKey,
        season: season,
        count: (data['count'] as int?) ?? 0,
        sum: (data['sum'] as num?)?.toDouble() ?? 0.0,
        conditionCounts: (data['conditionCounts'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, (v as num).toInt())) ??
            {},
        offset: (data['offset'] as num?)?.toDouble(),
      );
}
