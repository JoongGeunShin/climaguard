import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/season.dart';
import '../../../providers/user_profile_provider.dart';

class FeedbackCard extends ConsumerStatefulWidget {
  const FeedbackCard({super.key, required this.season});

  final Season season;

  @override
  ConsumerState<FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends ConsumerState<FeedbackCard> {
  bool _submitted = false;

  // 괜찮아요=0, 조금힘들=1, 매우힘들=2
  // heat: positive = less sensitive (threshold up)
  // cold: positive = more sensitive (threshold up toward 0)
  double _delta(int choice) {
    if (widget.season.isHeat) {
      return switch (choice) { 0 => 5.0, 1 => -1.0, _ => -5.0 };
    } else {
      return switch (choice) { 0 => -5.0, 1 => 1.0, _ => 5.0 };
    }
  }

  Future<void> _submit(int choice) async {
    await ref.read(userProfileNotifierProvider.notifier).addFeedback(
          season: widget.season,
          feelsDelta: _delta(choice),
        );
    if (mounted) setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor =
        widget.season.isHeat ? AppColors.heatCard : AppColors.coldCard;
    final label = widget.season.isHeat ? '더위' : '추위';
    final options = widget.season.isHeat
        ? const [('😊', '괜찮아요'), ('😓', '조금 힘듦'), ('🥵', '매우 힘듦')]
        : const [('😊', '괜찮아요'), ('😓', '조금 힘듦'), ('🥶', '매우 힘듦')];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: _submitted
          ? const _SubmittedView()
          : _InputView(label: label, options: options, onSelect: _submit),
    );
  }
}

class _InputView extends StatelessWidget {
  const _InputView({
    required this.label,
    required this.options,
    required this.onSelect,
  });

  final String label;
  final List<(String, String)> options;
  final void Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '오늘 $label, 어떠셨어요?',
          style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          '남겨 주시면 내 기준이 더 정확해져요',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 16),
        Row(
          children: List.generate(options.length, (i) {
            final (emoji, text) = options[i];
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: i == 0 ? 0 : 6),
                child: GestureDetector(
                  onTap: () => onSelect(i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(emoji,
                            style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 4),
                        Text(text,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _SubmittedView extends StatelessWidget {
  const _SubmittedView();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, color: Colors.white, size: 22),
        SizedBox(width: 8),
        Text(
          '피드백이 반영됐어요',
          style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
