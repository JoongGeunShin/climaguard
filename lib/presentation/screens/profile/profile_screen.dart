import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/user_profile_provider.dart';
import '../../providers/weather_provider.dart';
import 'widgets/edit_profile_sheet.dart';
import 'widgets/feedback_card.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/threshold_cards.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileNotifierProvider);
    final weatherAsync = ref.watch(weatherProvider);
    final size = MediaQuery.sizeOf(context);
    final hPad = size.width * 0.05;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: profileAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('오류가 발생했어요: $e')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('프로필이 없습니다'));
          }

          final season = weatherAsync.valueOrNull?.season;

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding:
                      EdgeInsets.fromLTRB(hPad, 20, hPad, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '내 정보',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        ProfileInfoCard(
                          profile: profile,
                          onEdit: () => showEditProfileSheet(
                              context, profile),
                        ),
                        const SizedBox(height: 20),
                        if (season != null &&
                            !season.isNormal) ...[
                          FeedbackCard(season: season),
                          const SizedBox(height: 20),
                        ],
                        ThresholdCards(profile: profile),
                        const SizedBox(height: 20),
                        const Divider(
                            height: 1, color: Color(0xFFEEEEEE)),
                        const SizedBox(height: 12),
                        ListTile(
                          onTap: () => context.push('/dashboard'),
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3E5F5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.bar_chart,
                                color: Color(0xFF9C27B0), size: 20),
                          ),
                          title: const Text('지자체 대시보드',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                          subtitle: const Text('위험 인원 집계 · 집단 학습 현황',
                              style: TextStyle(fontSize: 12)),
                          trailing: const Icon(
                              Icons.chevron_right,
                              color: Colors.grey),
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
