import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HomeLoadingBody extends StatelessWidget {
  const HomeLoadingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: AppColors.primary),
        const SizedBox(height: 16),
        Text(
          '날씨 정보를 불러오는 중...',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
