import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/notification_history_service.dart';
import '../../domain/entities/notification_item.dart';

part 'notification_history_provider.g.dart';

@Riverpod(keepAlive: true)
class NotificationHistoryNotifier extends _$NotificationHistoryNotifier {
  @override
  Future<List<NotificationItem>> build() async {
    final svc = await ref.watch(notificationHistoryServiceProvider.future);
    return svc.loadAll();
  }

  Future<void> reload() async {
    final svc = await ref.read(notificationHistoryServiceProvider.future);
    state = AsyncValue.data(svc.loadAll());
  }

  Future<void> markRead(String id) async {
    final svc = await ref.read(notificationHistoryServiceProvider.future);
    await svc.markRead(id);
    state = AsyncValue.data(svc.loadAll());
  }

  Future<void> markAllRead() async {
    final svc = await ref.read(notificationHistoryServiceProvider.future);
    await svc.markAllRead();
    state = AsyncValue.data(svc.loadAll());
  }
}
