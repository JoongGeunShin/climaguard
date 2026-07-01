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
          GestureDetector(
            onTap: () => _showTempInput(context, ref, override),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              decoration: BoxDecoration(
                color: override != null
                    ? Colors.orange
                    : Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange, width: 1),
              ),
              child: Text(
                override != null
                    ? '기온 ${override.toStringAsFixed(1)}°C'
                    : '온도 설정',
                style: TextStyle(
                  fontSize: 11,
                  color: override != null ? Colors.white : Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
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

  void _showTempInput(
      BuildContext context, WidgetRef ref, double? current) {
    final controller = TextEditingController(
      text: current?.toStringAsFixed(1) ?? '',
    );

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('기온 입력'),
        content: TextField(
          controller: controller,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true, signed: true),
          decoration: const InputDecoration(
            hintText: '예: 36.0',
            suffixText: '°C',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (_) => _apply(ctx, ref, controller.text),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => _apply(ctx, ref, controller.text),
            child: const Text('적용'),
          ),
        ],
      ),
    );
  }

  void _apply(BuildContext ctx, WidgetRef ref, String text) {
    final value = double.tryParse(text);
    if (value != null) {
      ref.read(debugTemperatureOverrideProvider.notifier).state = value;
    }
    Navigator.pop(ctx);
  }
}
