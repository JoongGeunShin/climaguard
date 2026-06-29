import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/climate_alert.dart';
import '../../../domain/entities/weather_data.dart';
import '../../providers/climate_alert_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/weather_provider.dart';
import 'widgets/adjustment_reason_card.dart';
import 'widgets/next_update_chip.dart';
import 'widgets/risk_banner.dart';
import 'widgets/risk_comparison_row.dart';
import 'widgets/weather_summary_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  StreamSubscription<RemoteMessage>? _fcmSub;

  @override
  void initState() {
    super.initState();
    _fcmSub = FirebaseMessaging.onMessage.listen(_onFcmMessage);
  }

  void _onFcmMessage(RemoteMessage message) {
    final n = message.notification;
    if (n == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (n.title != null)
              Text(n.title!, style: const TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.bold)),
            if (n.body != null) Text(n.body!),
          ],
        ),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _fcmSub?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(locationProvider);
    await ref.read(weatherProvider.future).catchError((e) => throw e);
  }

  @override
  Widget build(BuildContext context) {
    final weatherAsync = ref.watch(weatherProvider);
    final alertAsync = ref.watch(climateAlertProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('ClimaGuard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: weatherAsync.when(
          loading: () => const _LoadingView(),
          error: (e, _) => _ErrorView(
            message: e.toString().replaceFirst('Exception: ', ''),
            onRetry: () => ref.invalidate(locationProvider),
          ),
          data: (weather) => _ContentView(
            weather: weather,
            alertAsync: alertAsync,
          ),
        ),
      ),
    );
  }
}

// ── 로딩 ─────────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                '날씨 정보를 불러오는 중...',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 에러 ─────────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 80),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Icon(
                  Icons.cloud_off,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── 메인 콘텐츠 ──────────────────────────────────────────────────────────────

class _ContentView extends StatelessWidget {
  final WeatherData weather;
  final AsyncValue<ClimateAlert?> alertAsync;
  const _ContentView({required this.weather, required this.alertAsync});

  @override
  Widget build(BuildContext context) {
    final alert = alertAsync.valueOrNull;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        // 위험단계 배너 (알림 로딩/없는 경우 별도 처리)
        alertAsync.when(
          loading: () => const _BannerSkeleton(),
          error: (_, __) => const SizedBox.shrink(),
          data: (a) => a == null
              ? _NoProfileBanner(onTap: () => context.go('/profile'))
              : RiskBanner(alert: a),
        ),

        WeatherSummaryCard(weather: weather),

        if (alert != null) ...[
          RiskComparisonRow(alert: alert),
          AdjustmentReasonCard(alert: alert),
        ],

        NextUpdateChip(weather: weather),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ── 배너 스켈레톤 ─────────────────────────────────────────────────────────────

class _BannerSkeleton extends StatelessWidget {
  const _BannerSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140,
      color: AppColors.divider,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

// ── 프로필 미설정 유도 배너 ───────────────────────────────────────────────────

class _NoProfileBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _NoProfileBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            children: [
              const Icon(
                Icons.person_add_outlined,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '프로필을 설정하면 개인화 위험단계를 확인할 수 있어요',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '연령·기저질환 입력하기 →',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
