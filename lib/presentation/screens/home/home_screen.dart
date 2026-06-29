import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../providers/address_provider.dart';
import '../../providers/climate_alert_provider.dart';
import '../../providers/location_provider.dart';
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
              Text(n.title!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
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
    final profileAsync = ref.watch(userProfileNotifierProvider);
    final districtAsync = ref.watch(adminDistrictProvider);

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
}
