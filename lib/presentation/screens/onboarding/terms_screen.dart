import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  static const _requiredItems = [
    '[필수] 서비스 이용약관',
    '[필수] 개인정보 수집·이용 동의',
    '[필수] 위치기반 서비스 이용 동의',
  ];
  static const _optionalItems = [
    '[선택] 마케팅 정보 수신 동의',
  ];

  final Set<String> _agreed = {};

  bool get _allRequired => _requiredItems.every(_agreed.contains);
  bool get _allAgreed => {..._requiredItems, ..._optionalItems}.every(_agreed.contains);

  void _toggleAll() {
    setState(() {
      if (_allAgreed) {
        _agreed.clear();
      } else {
        _agreed.addAll([..._requiredItems, ..._optionalItems]);
      }
    });
  }

  void _toggle(String item) {
    setState(() {
      if (_agreed.contains(item)) {
        _agreed.remove(item);
      } else {
        _agreed.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final hPad = size.width * 0.065;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '회원가입 3 / 3',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '서비스 이용을 위해\n동의가 필요해요',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // ── 전체 동의 ────────────────────────────────────────
                    GestureDetector(
                      onTap: _toggleAll,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                        decoration: BoxDecoration(
                          color: _allAgreed
                              ? AppColors.primary.withValues(alpha: 0.08)
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            _CheckIcon(checked: _allAgreed),
                            const SizedBox(width: 14),
                            const Text(
                              '전체 동의합니다',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: AppColors.divider, height: 24),
                    // ── 필수 항목 ─────────────────────────────────────────
                    ..._requiredItems.map(
                      (item) => _TermsRow(
                        label: item,
                        checked: _agreed.contains(item),
                        onTap: () => _toggle(item),
                      ),
                    ),
                    // ── 선택 항목 ─────────────────────────────────────────
                    ..._optionalItems.map(
                      (item) => _TermsRow(
                        label: item,
                        checked: _agreed.contains(item),
                        onTap: () => _toggle(item),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ── CTA 버튼 ─────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: _allRequired ? () => context.go('/onboarding') : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: const Color(0xFFE8E4DF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    '동의하고 시작하기',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _allRequired ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckIcon extends StatelessWidget {
  final bool checked;
  const _CheckIcon({required this.checked});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: checked ? AppColors.primary : Colors.transparent,
        border: checked ? null : Border.all(color: AppColors.divider, width: 1.5),
      ),
      child: checked
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }
}

class _TermsRow extends StatelessWidget {
  final String label;
  final bool checked;
  final VoidCallback onTap;

  const _TermsRow({
    required this.label,
    required this.checked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            _CheckIcon(checked: checked),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 15,
                  color: label.startsWith('[필수]')
                      ? AppColors.onSurface
                      : AppColors.textSecondary,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
