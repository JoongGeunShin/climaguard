import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/demo_risk_generator.dart';
import '../../providers/debug_scenario_provider.dart';
import '../../providers/region_feedback_provider.dart';
import '../../providers/regional_dashboard_provider.dart';
import 'models/risk_distribution.dart';
import 'widgets/age_group_stats_section.dart';
import 'widgets/region_map_card.dart';
import 'widgets/risk_distribution_section.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  // 드릴다운 상태: 둘 다 null이면 경기도 전체, city만 있으면 시 단위,
  // dongCode까지 있으면 그 동 단위로 통계가 좁혀진다.
  String? _selectedCity;
  String? _selectedDongCode;
  String? _selectedDongName;

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

  /// 위험도 투영 조회 시 쓰는 지역 스코프 — 동이 선택돼 있으면 동 코드,
  /// 아니면 시 이름, 둘 다 없으면 null(경기도 전체).
  String? get _scopeKey => _selectedDongCode ?? _selectedCity;

  /// 대응 프로토콜 프롬프트 등에 쓰는 사람이 읽는 지역 이름.
  String get _regionLabel => _selectedDongName != null
      ? '$_selectedCity $_selectedDongName'
      : _selectedCity ?? '경기도 전체';

  void _onSelectCity(String city) {
    setState(() {
      _selectedCity = city;
      _selectedDongCode = null;
      _selectedDongName = null;
    });
  }

  void _onSelectDong(String code, String name) {
    setState(() {
      _selectedDongCode = code;
      _selectedDongName = name;
    });
  }

  void _goBack() {
    setState(() {
      if (_selectedDongCode != null) {
        _selectedDongCode = null;
        _selectedDongName = null;
      } else {
        _selectedCity = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final hPad = size.width * 0.05;

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
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final isDemo = ref.watch(debugScenarioProvider);
              return IconButton(
                tooltip: isDemo ? '시연 데이터 끄기' : '시연 데이터 보기',
                icon: Icon(
                  Icons.science_outlined,
                  color: isDemo ? AppColors.heatCard : Colors.grey[500],
                ),
                onPressed: () =>
                    ref.read(debugScenarioProvider.notifier).toggle(),
              );
            },
          ),
        ],
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
                  color: _isHeat ? AppColors.heatCard : AppColors.coldCard,
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                labelStyle:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
              _Breadcrumb(
                city: _selectedCity,
                dongName: _selectedDongName,
                onBack: _goBack,
              ),
              const SizedBox(height: 16),
              RegionMapCard(
                selectedCity: _selectedCity,
                selectedDongCode: _selectedDongCode,
                isHeat: _isHeat,
                onSelectCity: _onSelectCity,
                onSelectDong: _onSelectDong,
              ),
              const SizedBox(height: 24),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 24),
              Consumer(
                builder: (context, ref, _) {
                  final isDemo = ref.watch(debugScenarioProvider);
                  // 시연 모드에서는 인구·날씨 캐시를 아예 조회하지 않고
                  // 지역 코드 기반 더미 분포를 쓴다.
                  final projAsync = isDemo
                      ? AsyncValue.data(DemoRiskGenerator.projectionFor(
                          _scopeKey ?? 'gyeonggi_all',
                          isHeat: _isHeat,
                        ))
                      // 경기도 전체 화면(scope null)은 602개 읍면동을 한 번에
                      // KOSIS로 조회하는 걸 피하려고 캐시만 읽는다 — 사용자가
                      // 시/동을 실제로 선택했을 때만 실시간 조회로 전환된다.
                      : _scopeKey == null
                          ? ref.watch(regionRiskProjectionCacheOnlyProvider(null))
                          : ref.watch(regionRiskProjectionProvider(_scopeKey));
                  return projAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, _) =>
                        const Text('인구 데이터를 불러오지 못했어요.'),
                    data: (proj) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (proj.totalPopulation > 0)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: OutlinedButton.icon(
                                onPressed: () => context.push(
                                  '/response-protocol',
                                  extra: {
                                    'regionLabel': _regionLabel,
                                    'isHeat': _isHeat,
                                    'danger': proj.danger,
                                    'warning': proj.warning,
                                    'caution': proj.caution,
                                    'safe': proj.safe,
                                  },
                                ),
                                icon: const Icon(Icons.description_outlined, size: 16),
                                label: const Text('대응 프로토콜 생성'),
                              ),
                            ),
                          ),
                        RiskDistributionSection(
                          distribution: RiskDistribution(
                            danger: proj.danger,
                            warning: proj.warning,
                            caution: proj.caution,
                            safe: proj.safe,
                          ),
                          isHeat: _isHeat,
                        ),
                        if (proj.totalPopulation == 0) ...[
                          const SizedBox(height: 8),
                          Text(
                            _scopeKey == null
                                ? '아직 조회된 지역이 없어요. 시/군을 탭하면 인구 데이터를 불러와요.'
                                : 'KOSIS 인구 데이터를 불러오지 못했어요.',
                            style:
                                TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 24),
              if (_selectedDongCode != null)
                _RegionParticipationCard(regionCode: _selectedDongCode!)
              else ...[
                AgeGroupStatsSection(isHeat: _isHeat),
                const SizedBox(height: 12),
                Text(
                  '연령별 학습 현황은 경기도 전체에 공통 적용되는 값이에요. '
                  '지역별 참여 현황은 특정 읍면동을 선택하면 볼 수 있어요.',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  final String? city;
  final String? dongName;
  final VoidCallback onBack;

  const _Breadcrumb({required this.city, required this.dongName, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final parts = ['경기도', ?city, ?dongName];
    return Row(
      children: [
        if (city != null)
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.chevron_left, size: 22),
            onPressed: onBack,
          ),
        if (city != null) const SizedBox(width: 4),
        Expanded(
          child: Text(
            parts.join(' > '),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _RegionParticipationCard extends ConsumerWidget {
  final String regionCode;
  const _RegionParticipationCard({required this.regionCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedbackAsync = ref.watch(regionFeedbackProvider(regionCode));

    return Container(
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
              Icon(Icons.groups, color: Color(0xFFB39DDB), size: 16),
              SizedBox(width: 6),
              Text(
                '이 지역 집단학습 참여 현황',
                style: TextStyle(
                  color: Color(0xFFB39DDB),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          feedbackAsync.when(
            loading: () => const SizedBox(
              height: 30,
              child: Center(
                child: CircularProgressIndicator(
                    color: Color(0xFFB39DDB), strokeWidth: 2),
              ),
            ),
            error: (_, _) => const Text('불러오지 못했어요.',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            data: (fb) {
              final total = fb.heatCount + fb.coldCount;
              return Text(
                total == 0
                    ? '아직 이 지역에서 제출된 피드백이 없어요.'
                    : '폭염 피드백 ${fb.heatCount}건 · 한파 피드백 ${fb.coldCount}건이 모였어요.',
                style: const TextStyle(
                    color: Colors.white70, fontSize: 13, height: 1.5),
              );
            },
          ),
        ],
      ),
    );
  }
}
