import 'package:climaguard/presentation/providers/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../providers/ai_analysis_provider.dart';
import 'widgets/action_items_section.dart';
import 'widgets/analysis_explanation_card.dart';
import 'widgets/group_learning_card.dart';

class AiAnalysisScreen extends ConsumerWidget {
  const AiAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);
    final analysisAsync = ref.watch(aiAnalysisProvider);
    final size = MediaQuery.sizeOf(context);
    final hPad = size.width * 0.05;

    final season = weatherAsync.valueOrNull?.season;
    final bg = season?.isHeat == true
        ? AppColors.heatBackground
        : season?.isCold == true
        ? AppColors.coldBackground
        : AppColors.normalBackground;

    return Scaffold(
      backgroundColor: bg,
      body: analysisAsync.when(
        loading: () => const _LoadingView(),
        error: (e, _) =>
            _ErrorView(onRetry: () => ref.invalidate(aiAnalysisProvider)),
        data: (result) {
          if (result == null) {
            return const Center(child: Text('분석 데이터가 없어요'));
          }
          final alert = result.alert;
          final showShelterBtn = alert.season.isHeat || alert.season.isCold;

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnalysisExplanationCard(
                          alert: alert,
                          explanation: result.explanation,
                        ),
                        const SizedBox(height: 16),
                        if (!alert.season.isNormal) ...[
                          GroupLearningCard(alert: alert),
                          const SizedBox(height: 16),
                        ],
                        ActionItemsSection(actions: result.actions),
                        const SizedBox(height: 24),
                        if (showShelterBtn)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => context.go('/shelter'),
                              icon: const Text(
                                '🏢',
                                style: TextStyle(fontSize: 18),
                              ),
                              label: Text(
                                alert.season.isHeat
                                    ? '가까운 무더위쉼터 보기'
                                    : '가까운 한파쉼터 보기',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: alert.season.isHeat
                                    ? AppColors.heatCard
                                    : AppColors.coldCard,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'AI가 분석 중이에요...',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          const Text(
            '분석에 실패했어요',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('잠시 후 다시 시도해주세요', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}
