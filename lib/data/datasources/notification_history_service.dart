import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/notification_item.dart';

part 'notification_history_service.g.dart';

@Riverpod(keepAlive: true)
Future<NotificationHistoryService> notificationHistoryService(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return NotificationHistoryService(prefs);
}

class NotificationHistoryService {
  NotificationHistoryService(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'notification_history';
  static const _maxItems = 100;

  List<NotificationItem> loadAll() {
    final raw = _prefs.getStringList(_key) ?? [];
    return raw
        .map((s) {
          try {
            return NotificationItem.fromJson(
                jsonDecode(s) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<NotificationItem>()
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> add(NotificationItem item) async {
    final items = loadAll();
    items.insert(0, item);
    final trimmed = items.take(_maxItems).toList();
    await _save(trimmed);
  }

  Future<void> markRead(String id) async {
    final items = loadAll().map((n) => n.id == id ? n.copyWith(isRead: true) : n).toList();
    await _save(items);
  }

  Future<void> markAllRead() async {
    final items = loadAll().map((n) => n.copyWith(isRead: true)).toList();
    await _save(items);
  }

  Future<void> clear() async => _prefs.remove(_key);

  Future<void> _save(List<NotificationItem> items) async {
    await _prefs.setStringList(
      _key,
      items.map((n) => jsonEncode(n.toJson())).toList(),
    );
  }
}
