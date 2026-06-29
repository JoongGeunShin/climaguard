import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../presentation/providers/debug_provider.dart';

/// 디버그 빌드 전용 — 릴리즈 빌드에서는 완전히 제거됨
class DebugSeasonBar extends ConsumerWidget {
  const DebugSeasonBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kDebugMode) return const SizedBox.shrink();

    final override = ref.watch(debugTemperatureOverrideProvider);

    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          const Text(
            'DEBUG',
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 10),
          _Chip(
            label: '일반 20°',
            selected: override == 20.0,
            color: Colors.green,
            onTap: () => ref
                .read(debugTemperatureOverrideProvider.notifier)
                .state = override == 20.0 ? null : 20.0,
          ),
          const SizedBox(width: 6),
          _Chip(
            label: '폭염 36°',
            selected: override == 36.0,
            color: Colors.deepOrange,
            onTap: () => ref
                .read(debugTemperatureOverrideProvider.notifier)
                .state = override == 36.0 ? null : 36.0,
          ),
          const SizedBox(width: 6),
          _Chip(
            label: '한파 -10°',
            selected: override == -10.0,
            color: Colors.blue,
            onTap: () => ref
                .read(debugTemperatureOverrideProvider.notifier)
                .state = override == -10.0 ? null : -10.0,
          ),
          const Spacer(),
          if (override != null)
            GestureDetector(
              onTap: () =>
                  ref.read(debugTemperatureOverrideProvider.notifier).state =
                      null,
              child: const Text(
                'API',
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: selected ? color : color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: selected ? Colors.white : color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
