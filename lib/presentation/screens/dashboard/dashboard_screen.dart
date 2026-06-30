import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import 'models/demo_stats.dart';
import 'widgets/age_group_stats_section.dart';
import 'widgets/risk_distribution_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  bool get _isHeat => _tabCtrl.index == 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final hPad = size.width * 0.05;
    final distribution =
        _isHeat ? heatRiskDistribution : coldRiskDistribution;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '지자체 대시보드',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: _tabCtrl,
                indicator: BoxDecoration(
                  color: _isHeat
                      ? AppColors.heatCard
                      : AppColors.coldCard,
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.bold),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wb_sunny, size: 14),
                        SizedBox(width: 4),
                        Text('폭염'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.ac_unit, size: 14),
                        SizedBox(width: 4),
                        Text('한파'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 시연 데이터 안내
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 16, color: Colors.amber[700]),
                    const SizedBox(width: 6),
                    Text(
                      '시연용 더미 데이터 · 100명 기준',
                      style: TextStyle(
                          fontSize: 12, color: Colors.amber[800]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              RiskDistributionSection(
                distribution: distribution,
                isHeat: _isHeat,
              ),
              const SizedBox(height: 24),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 24),
              AgeGroupStatsSection(isHeat: _isHeat),
              const SizedBox(height: 24),
              // 데이터 기반 메모
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1B2E),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.groups,
                            color: Color(0xFFB39DDB), size: 16),
                        SizedBox(width: 6),
                        Text(
                          '집단 학습 진행 현황',
                          style: TextStyle(
                            color: Color(0xFFB39DDB),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '총 ${_totalFeedbacks()}개의 피드백이 쌓였어요.\n'
                      '다음 단계(Phase 3)까지 ${500 - _totalFeedbacks()}개 남았어요.',
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.5),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'Phase 2 · 실데이터 학습 중',
                          style: TextStyle(
                              color: Colors.white38, fontSize: 11),
                        ),
                        const Spacer(),
                        Text(
                          '${_totalFeedbacks()} / 500',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _totalFeedbacks() / 500,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation(
                            Color(0xFFB39DDB)),
                        minHeight: 6,
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

  int _totalFeedbacks() => demoAgeGroups.fold(
      0,
      (sum, g) =>
          sum + g.totalHeatFeedbacks + g.totalColdFeedbacks);
}
