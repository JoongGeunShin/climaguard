import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/group_stats_data_source.dart';

part 'region_feedback_provider.g.dart';

/// 지역(행정동)별 집단학습 참여 현황 — 대시보드에서 "이 지역에서 몇 건 참여했는지" 표시용.
@riverpod
Future<({int heatCount, int coldCount})> regionFeedback(
    Ref ref, String regionCode) {
  return ref.read(groupStatsDataSourceProvider).loadRegionFeedback(regionCode);
}
