import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/demo_risk_generator.dart';
import '../../../../domain/entities/region.dart';
import '../../../providers/debug_scenario_provider.dart';
import '../../../providers/region_provider.dart';
import '../../../providers/regional_dashboard_provider.dart';
import 'region_choropleth_map.dart';

/// 경기도 시/군 지도(도 레벨) 또는 특정 시의 읍면동 지도(시 레벨)를 보여주고,
/// 각 구역을 인구 대비 위험군 비율로 채색한다. 핀치줌/팬과 이름 검색을 지원한다.
class RegionMapCard extends ConsumerWidget {
  final String? selectedCity;
  final String? selectedDongCode;
  final bool isHeat;
  final void Function(String cityName) onSelectCity;
  final void Function(String dongCode, String dongName) onSelectDong;

  const RegionMapCard({
    super.key,
    required this.selectedCity,
    required this.selectedDongCode,
    required this.isHeat,
    required this.onSelectCity,
    required this.onSelectDong,
  });

  static const noDataColor = Color(0xFFE0E0E0);

  static Color ratioColor(double ratio) => Color.lerp(
        const Color(0xFF43A047),
        const Color(0xFFD50000),
        ratio.clamp(0.0, 1.0),
      )!;

  /// 시 이름에 대응하는 populationCache 문서 정보 문자열(동 단위로 여러 개).
  static String cityInfo(List<RegionBoundary> allRegions, String cityName) {
    final codes =
        allRegions.where((r) => r.cityName == cityName).map((r) => r.code).toList();
    return 'populationCache 문서 ${codes.length}개 (동 단위, 예: ${codes.first})';
  }

  /// 읍면동 코드에 대응하는 populationCache 문서 경로.
  static String dongInfo(String code) => 'populationCache/$code';

  /// 검색이든 지도 탭이든 지역을 선택하면 동일하게 스낵바로 문서 위치를 보여준다.
  static void showSelectionSnackbar(
      BuildContext context, String label, String info) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label 선택됨 — $info'),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regionsAsync = ref.watch(gyeonggiRegionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        regionsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (allRegions) {
            // 검색 결과를 고르면 스낵바로 Firestore 문서 경로를 보여준다 —
            // 콘솔에서 어떤 문서를 봐야 하는지 바로 알 수 있게. 지도를 직접
            // 탭했을 때도 (_ProvinceMap/_CityMap) 동일한 헬퍼로 똑같이 보여준다.
            final options = selectedCity == null
                ? allRegions
                    .map((r) => r.cityName)
                    .toSet()
                    .map((c) => (
                          label: c,
                          onSelect: () => onSelectCity(c),
                          info: cityInfo(allRegions, c),
                        ))
                    .toList()
                : allRegions
                    .where((r) => r.cityName == selectedCity)
                    .map((d) => (
                          label: d.name,
                          onSelect: () => onSelectDong(d.code, d.name),
                          info: dongInfo(d.code),
                        ))
                    .toList();
            return _RegionSearchBar(
              key: ValueKey(selectedCity),
              options: options,
              hintText: selectedCity == null ? '시/군 검색' : '읍면동 검색',
            );
          },
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 320,
          child: regionsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const Center(child: Text('지도를 불러오지 못했어요.')),
            data: (allRegions) => selectedCity == null
                ? _ProvinceMap(
                    allRegions: allRegions,
                    isHeat: isHeat,
                    onSelectCity: onSelectCity,
                  )
                : _CityMap(
                    allRegions: allRegions,
                    cityName: selectedCity!,
                    isHeat: isHeat,
                    selectedDongCode: selectedDongCode,
                    onSelectDong: onSelectDong,
                  ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 80,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  colors: [ratioColor(0), ratioColor(1)],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text('인구 대비 위험군 비율 낮음 → 높음',
                style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          ],
        ),
        if (selectedCity == null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: noDataColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 6),
              Text('회색 = 아직 조회되지 않은 시/군 (탭하면 조회돼요)',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ],
          ),
        ],
        const SizedBox(height: 4),
        Text(
          '지도 데이터: vuski/admdongkor (CC BY 4.0, 통계청 SGIS 기반) · 두 손가락으로 확대/축소할 수 있어요',
          style: TextStyle(fontSize: 10, color: Colors.grey[400]),
        ),
      ],
    );
  }
}

class _ProvinceMap extends ConsumerWidget {
  final List<RegionBoundary> allRegions;
  final bool isHeat;
  final void Function(String cityName) onSelectCity;

  const _ProvinceMap({
    required this.allRegions,
    required this.isHeat,
    required this.onSelectCity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cities = allRegions.map((r) => r.cityName).toSet();
    final isDemo = ref.watch(debugScenarioProvider);
    // KOSIS를 직접 호출하지 않고 이미 캐시된 인구만 읽는다 — 실제 조회는
    // 사용자가 시를 탭해서 드릴다운할 때만 일어나고, 그 결과가 Firestore에
    // 쌓이면서 지도가 점진적으로 채워진다. 시연 모드에서는 이 조회 자체를
    // 건너뛰고 지역 코드 기반 더미 비율을 쓴다.
    final colors = <String, Color>{
      for (final city in cities)
        city: isDemo
            ? RegionMapCard.ratioColor(
                DemoRiskGenerator.ratioFor(city, isHeat: isHeat))
            : switch (ref.watch(regionRiskProjectionCacheOnlyProvider(city)).valueOrNull) {
                null => RegionMapCard.noDataColor,
                final p when p.totalPopulation == 0 => RegionMapCard.noDataColor,
                final p => RegionMapCard.ratioColor(p.atRiskRatio),
              },
    };

    return RegionChoroplethMap(
      regions: allRegions,
      groupKeyOf: (r) => r.cityName,
      colorFor: (key) => colors[key] ?? RegionMapCard.noDataColor,
      onTapRegion: (city) {
        RegionMapCard.showSelectionSnackbar(
            context, city, RegionMapCard.cityInfo(allRegions, city));
        onSelectCity(city);
      },
      resetViewKey: 'province',
    );
  }
}

class _CityMap extends ConsumerWidget {
  final List<RegionBoundary> allRegions;
  final String cityName;
  final bool isHeat;
  final String? selectedDongCode;
  final void Function(String dongCode, String dongName) onSelectDong;

  const _CityMap({
    required this.allRegions,
    required this.cityName,
    required this.isHeat,
    required this.selectedDongCode,
    required this.onSelectDong,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dongs = allRegions.where((r) => r.cityName == cityName).toList();
    final nameByCode = {for (final d in dongs) d.code: d.name};
    final isDemo = ref.watch(debugScenarioProvider);
    final ratios = <String, double>{
      for (final d in dongs)
        d.code: isDemo
            ? DemoRiskGenerator.ratioFor(d.code, isHeat: isHeat)
            : ref.watch(regionRiskProjectionProvider(d.code)).valueOrNull?.atRiskRatio ?? 0,
    };

    return RegionChoroplethMap(
      regions: dongs,
      groupKeyOf: (r) => r.code,
      colorFor: (key) => RegionMapCard.ratioColor(ratios[key] ?? 0),
      selectedGroupKey: selectedDongCode,
      onTapRegion: (code) {
        final name = nameByCode[code] ?? '';
        RegionMapCard.showSelectionSnackbar(
            context, name, RegionMapCard.dongInfo(code));
        onSelectDong(code, name);
      },
      resetViewKey: cityName,
    );
  }
}

/// 시/군 또는 읍면동 이름으로 검색해서 선택하면 지도를 탭한 것과 동일하게 동작한다.
/// 선택 시 스낵바로 대응하는 Firestore 문서 경로를 보여준다(콘솔 확인용).
class _RegionSearchBar extends StatefulWidget {
  final List<({String label, VoidCallback onSelect, String info})> options;
  final String hintText;

  const _RegionSearchBar({super.key, required this.options, required this.hintText});

  @override
  State<_RegionSearchBar> createState() => _RegionSearchBarState();
}

class _RegionSearchBarState extends State<_RegionSearchBar> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _select(({String label, VoidCallback onSelect, String info}) match) {
    match.onSelect();
    _controller.clear();
    setState(() => _query = '');
    FocusScope.of(context).unfocus();
    RegionMapCard.showSelectionSnackbar(context, match.label, match.info);
  }

  @override
  Widget build(BuildContext context) {
    final matches = _query.isEmpty
        ? const <({String label, VoidCallback onSelect, String info})>[]
        : widget.options.where((o) => o.label.contains(_query)).take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          onChanged: (v) => setState(() => _query = v.trim()),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(fontSize: 14),
            prefixIcon: const Icon(Icons.search, size: 20),
            isDense: true,
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon: _query.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _controller.clear();
                      setState(() => _query = '');
                    },
                  ),
          ),
        ),
        if (matches.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 6),
            constraints: const BoxConstraints(maxHeight: 200),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            // ListTile은 가장 가까운 Material 조상에 배경/잉크 효과를 그리므로,
            // 배경색이 있는 DecoratedBox 대신 Material로 감싸야 탭 효과가 보인다.
            child: Material(
              color: Colors.white,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: matches.length,
                separatorBuilder: (context, i) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final m = matches[i];
                  return ListTile(
                    dense: true,
                    title: Text(m.label, style: const TextStyle(fontSize: 14)),
                    onTap: () => _select(m),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
