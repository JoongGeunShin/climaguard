import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/fcm_service.dart';
import '../../../data/datasources/local_notification_service.dart';
import '../../../domain/entities/climate_alert.dart';
import '../../../domain/entities/risk_level.dart';
import '../../providers/address_provider.dart';
import '../../providers/climate_alert_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/notification_history_provider.dart';
import '../../providers/user_profile_provider.dart';
import '../../providers/weather_provider.dart';
import 'widgets/debug_season_bar.dart';
import 'widgets/error_body.dart';
import 'widgets/home_header.dart';
import 'widgets/hourly_chart_card.dart';
import 'widgets/info_reason_row.dart';
import 'widgets/loading_body.dart';
import 'widgets/main_risk_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _fcmInited = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initFcm());
  }

  Future<void> _initFcm() async {
    if (_fcmInited) return;
    _fcmInited = true;
    await ref.read(localNotificationServiceProvider).init();
    await ref.read(fcmServiceProvider).init();
  }

  @override
  Widget build(BuildContext context) {
    final weatherAsync = ref.watch(weatherProvider);
    final alertAsync = ref.watch(climateAlertProvider);
    final profileAsync = ref.watch(userProfileNotifierProvider);
    final districtAsync = ref.watch(adminDistrictProvider);

    // climateAlert 변화 감지 → 주의/경고/위험 시 로컬 알림
    ref.listen<AsyncValue<ClimateAlert?>>(climateAlertProvider, (prev, next) {
      final alert = next.valueOrNull;
      if (alert == null) return;

      final prevAlert = prev?.valueOrNull;
      final riskElevated = alert.personalRiskLevel == RiskLevel.danger ||
          alert.personalRiskLevel == RiskLevel.warning ||
          alert.personalRiskLevel == RiskLevel.caution;

      // 이전과 다른 위험 단계로 변화했을 때만 알림
      if (riskElevated && prevAlert?.personalRiskLevel != alert.personalRiskLevel) {
        _sendClimateAlertNotification(alert);
      }
    });

    return weatherAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.normalBackground,
        body: Center(child: HomeLoadingBody()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: HomeErrorBody(
            message: e.toString().replaceFirst('Exception: ', ''),
            onRetry: () => ref.invalidate(locationProvider),
          ),
        ),
      ),
      data: (weather) {
        final season = weather.season;
        final bg = season.isHeat
            ? AppColors.heatBackground
            : season.isCold
                ? AppColors.coldBackground
                : AppColors.normalBackground;
        final alert = alertAsync.valueOrNull;
        final profile = profileAsync.valueOrNull;
        final district = districtAsync.valueOrNull;

        return Scaffold(
          backgroundColor: bg,
          body: SafeArea(
            child: Column(
              children: [
                const DebugSeasonBar(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: HomeHeader(
                            name: profile?.name ?? '',
                            location: district?.display,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: alert != null
                              ? MainRiskCard(weather: weather, alert: alert)
                              : NoProfileRiskCard(
                                  season: season,
                                  onSetupProfile: () => context.go('/profile'),
                                ),
                        ),
                        if (alert != null && !season.isNormal)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                              child: TextButton.icon(
                                onPressed: () => context.push('/ai-analysis'),
                                icon: const Icon(Icons.auto_awesome, size: 14),
                                label: const Text('AI 위험 분석 보기'),
                                style: TextButton.styleFrom(
                                  foregroundColor: season.isHeat
                                      ? AppColors.heatCard
                                      : AppColors.coldCard,
                                ),
                              ),
                            ),
                          ),
                        if (alert != null)
                          SliverToBoxAdapter(
                            child: InfoReasonRow(alert: alert),
                          ),
                        SliverToBoxAdapter(
                          child: HourlyChartCard(weather: weather),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 24)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _refresh() async {
    ref.invalidate(locationProvider);
    await ref.read(weatherProvider.future).catchError((e) => throw e);
  }

  void _sendClimateAlertNotification(ClimateAlert alert) {
    final isHeat = alert.season.isHeat;
    final level = alert.personalRiskLevel.label;
    final season = isHeat ? '폭염' : '한파';
    final title = '$season $level 경보';
    final body = '체감온도 ${alert.currentFeelsLike.toStringAsFixed(1)}°C — '
        '${isHeat ? "개인 임계치 ${alert.personalThreshold.toStringAsFixed(1)}°C 초과" : "한파 위험 감지"}. '
        '지금 바로 확인해보세요.';

    ref.read(fcmServiceProvider).showClimateAlert(
          title: title,
          body: body,
          season: isHeat ? 'heat' : 'cold',
        );

    // 알림 내역 갱신
    ref.read(notificationHistoryNotifierProvider.notifier).reload();
  }
}
