import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/group_stats_data_source.dart';
import '../../domain/entities/group_stat.dart';

part 'group_stats_provider.g.dart';

@riverpod
Future<List<GroupStat>> groupStats(GroupStatsRef ref) {
  return ref.read(groupStatsDataSourceProvider).loadAll();
}
