import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/notification_item.dart';
import 'firebase_auth_data_source.dart';
import 'local_notification_service.dart';
import 'notification_history_service.dart';

part 'fcm_service.g.dart';

@Riverpod(keepAlive: true)
FcmService fcmService(Ref ref) {
  return FcmService(
    auth: ref.watch(firebaseAuthDataSourceProvider),
    db: FirebaseFirestore.instance,
    localNotif: ref.watch(localNotificationServiceProvider),
    historyService: ref.watch(notificationHistoryServiceProvider).valueOrNull,
  );
}

class FcmService {
  FcmService({
    required this.auth,
    required this.db,
    required this.localNotif,
    required this.historyService,
  });

  final FirebaseAuthDataSource auth;
  final FirebaseFirestore db;
  final LocalNotificationService localNotif;
  final NotificationHistoryService? historyService;

  final _fcm = FirebaseMessaging.instance;

  /// 앱 시작 시 1회 호출: 권한 요청 → 토큰 저장 → foreground 리스너
  Future<void> init() async {
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await _fcm.getToken();
    if (token != null) await _saveToken(token);

    _fcm.onTokenRefresh.listen(_saveToken);

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  Future<void> _saveToken(String token) async {
    try {
      final phone = auth.currentUser?.phoneNumber;
      if (phone == null) return;
      await db.collection('users').doc(phone).set(
        {
          'fcmToken': token,
          'tokenUpdatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (_) {}
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final n = message.notification;
    if (n == null) return;

    final season = message.data['season'] as String? ?? 'normal';
    final title = n.title ?? 'ClimaGuard';
    final body = n.body ?? '';

    await localNotif.show(title: title, body: body);

    final item = NotificationItem(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      season: season,
      createdAt: DateTime.now(),
    );
    await historyService?.add(item);
  }

  /// climateAlertProvider 변화 시 위험·경고 단계 로컬 알림 발송
  Future<void> showClimateAlert({
    required String title,
    required String body,
    required String season,
  }) async {
    await localNotif.show(
      title: title,
      body: body,
      id: season == 'heat' ? 1001 : 1002,
    );

    final item = NotificationItem(
      id: '${season}_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      season: season,
      createdAt: DateTime.now(),
    );
    await historyService?.add(item);
  }
}
