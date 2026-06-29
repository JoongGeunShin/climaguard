import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class ClimaGuardLogo extends StatefulWidget {
  const ClimaGuardLogo({super.key});

  @override
  State<ClimaGuardLogo> createState() => _ClimaGuardLogoState();
}

class _ClimaGuardLogoState extends State<ClimaGuardLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(9),
          ),
          child: RotationTransition(
            turns: _animationController,
            child: const Icon(
              Icons.wb_sunny_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'ClimaGuard',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}
