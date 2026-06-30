import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/notification_item.dart';
import '../../providers/notification_history_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _tab.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(notificationHistoryNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('알림'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () =>
                ref.read(notificationHistoryNotifierProvider.notifier).markAllRead(),
            child: const Text('모두 읽음',
                style: TextStyle(color: Color(0xFF5C6BC0))),
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          labelColor: const Color(0xFF5C6BC0),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF5C6BC0),
          tabs: const [
            Tab(text: '전체'),
            Tab(text: '폭염'),
            Tab(text: '한파'),
          ],
        ),
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('알림을 불러오지 못했어요')),
        data: (all) {
          final filtered = switch (_tab.index) {
            1 => all.where((n) => n.isHeat).toList(),
            2 => all.where((n) => n.isCold).toList(),
            _ => all,
          };

          if (filtered.isEmpty) return _EmptyView(tabIndex: _tab.index);

          return _GroupedList(items: filtered, ref: ref);
        },
      ),
    );
  }
}

class _GroupedList extends StatelessWidget {
  const _GroupedList({required this.items, required this.ref});

  final List<NotificationItem> items;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<NotificationItem>>{};
    final fmt = DateFormat('yyyy년 MM월 dd일');

    for (final item in items) {
      final key = fmt.format(item.createdAt);
      grouped.putIfAbsent(key, () => []).add(item);
    }

    final keys = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: keys.length,
      itemBuilder: (_, i) {
        final dateLabel = keys[i];
        final dayItems = grouped[dateLabel]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(dateLabel,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey)),
            ),
            ...dayItems.map((n) => _NotificationTile(
                  item: n,
                  onTap: () => ref
                      .read(notificationHistoryNotifierProvider.notifier)
                      .markRead(n.id),
                )),
          ],
        );
      },
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item, required this.onTap});

  final NotificationItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isHeat = item.isHeat;
    final isCold = item.isCold;
    final tagColor = isHeat
        ? const Color(0xFFFF5722)
        : isCold
            ? const Color(0xFF2196F3)
            : const Color(0xFF607D8B);
    final tagLabel = isHeat ? '폭염' : isCold ? '한파' : '일반';
    final timeFmt = DateFormat('HH:mm');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: item.isRead ? Colors.white : const Color(0xFFF0F0FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: item.isRead ? const Color(0xFFEEEEEE) : const Color(0xFFCECEF5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: tagColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  isHeat ? '🌡️' : isCold ? '❄️' : '🔔',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: tagColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(tagLabel,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: tagColor)),
                      ),
                      const SizedBox(width: 6),
                      Text(timeFmt.format(item.createdAt),
                          style: const TextStyle(
                              fontSize: 11, color: Colors.grey)),
                      if (!item.isRead) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF5C6BC0),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(item.title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(item.body,
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.tabIndex});

  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    final msg = switch (tabIndex) {
      1 => '폭염 알림이 없어요',
      2 => '한파 알림이 없어요',
      _ => '알림이 없어요',
    };

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔕', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(msg,
              style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 4),
          const Text('기후 경보가 오면 여기에 표시돼요',
              style: TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }
}
