import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../providers/region_provider.dart';

class RegionPage extends ConsumerWidget {
  final double hPad;
  final String? selectedCity;
  final String? selectedDongCode;
  final String? selectedDongName;
  final bool isSaving;
  final void Function(String city) onSelectCity;
  final void Function(String code, String name) onSelectDong;
  final VoidCallback? onComplete;

  const RegionPage({
    super.key,
    required this.hPad,
    required this.selectedCity,
    required this.selectedDongCode,
    required this.selectedDongName,
    required this.isSaving,
    required this.onSelectCity,
    required this.onSelectDong,
    required this.onComplete,
  });

  bool get _isValid => selectedDongCode != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final citiesAsync = ref.watch(gyeonggiCitiesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(hPad, 28, hPad, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '사는 지역을\n알려주세요',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '지자체가 지역별 위험 현황을 파악하는 데 쓰여요.\n지금은 경기도만 지원해요.',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 28),
                const Text('시/군',
                    style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                citiesAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, _) => const Text('시/군 목록을 불러오지 못했어요.',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 13,
                          color: AppColors.textSecondary)),
                  data: (cities) => Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: cities
                        .map((c) => _RegionChip(
                              label: c,
                              selected: c == selectedCity,
                              onTap: () => onSelectCity(c),
                            ))
                        .toList(),
                  ),
                ),
                if (selectedCity != null) ...[
                  const SizedBox(height: 24),
                  const Text('읍면동',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Consumer(
                    builder: (context, ref, _) {
                      final dongsAsync =
                          ref.watch(dongsInCityProvider(selectedCity!));
                      return dongsAsync.when(
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (_, _) => const Text('읍면동 목록을 불러오지 못했어요.',
                            style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 13,
                                color: AppColors.textSecondary)),
                        data: (dongs) => Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: dongs
                              .map((d) => _RegionChip(
                                    label: d.name,
                                    selected: d.code == selectedDongCode,
                                    onTap: () =>
                                        onSelectDong(d.code, d.name),
                                  ))
                              .toList(),
                        ),
                      );
                    },
                  ),
                ],
                if (selectedDongName != null) ...[
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EDE8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          '선택한 지역: $selectedCity $selectedDongName',
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 24),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: const Color(0xFFE8E4DF),
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: isSaving || !_isValid ? null : onComplete,
              child: isSaving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text(
                      '가입 완료',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: _isValid ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RegionChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _RegionChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.08)
              : const Color(0xFFF0EDE8),
          borderRadius: BorderRadius.circular(12),
          border: selected
              ? Border.all(color: AppColors.primary, width: 1.5)
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: selected ? AppColors.primary : const Color(0xFF555555),
          ),
        ),
      ),
    );
  }
}
