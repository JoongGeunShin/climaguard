import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class TermsPage extends StatelessWidget {
  final double hPad;
  final Set<String> agreed;
  final bool allRequired;
  final bool allAgreed;
  final List<String> requiredItems;
  final List<String> optionalItems;
  final VoidCallback onToggleAll;
  final void Function(String) onToggle;
  final VoidCallback? onNext;

  const TermsPage({
    super.key,
    required this.hPad,
    required this.agreed,
    required this.allRequired,
    required this.allAgreed,
    required this.requiredItems,
    required this.optionalItems,
    required this.onToggleAll,
    required this.onToggle,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
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
                GestureDetector(
                  onTap: onToggleAll,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: allAgreed
                          ? AppColors.primary.withValues(alpha: 0.08)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        _CheckIcon(checked: allAgreed),
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
                ...requiredItems.map((item) => _TermsRow(
                      label: item,
                      checked: agreed.contains(item),
                      onTap: () => onToggle(item),
                    )),
                ...optionalItems.map((item) => _TermsRow(
                      label: item,
                      checked: agreed.contains(item),
                      onTap: () => onToggle(item),
                    )),
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
              onPressed: onNext,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: const Color(0xFFE8E4DF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                '동의하고 시작하기',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: onNext != null ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
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
      child: checked ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
    );
  }
}

class _TermsRow extends StatelessWidget {
  final String label;
  final bool checked;
  final VoidCallback onTap;
  const _TermsRow({required this.label, required this.checked, required this.onTap});

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
                  color: label.startsWith('[필수]') ? AppColors.onSurface : AppColors.textSecondary,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
