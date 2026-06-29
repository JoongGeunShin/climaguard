import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class NumPad extends StatelessWidget {
  final void Function(String) onKey;
  const NumPad({super.key, required this.onKey});

  static const _keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', '⌫'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _keys.map((row) {
        return Row(
          children: row.map((key) {
            return Expanded(
              child: key.isEmpty
                  ? const SizedBox()
                  : InkWell(
                      onTap: () => onKey(key),
                      child: SizedBox(
                        height: 62,
                        child: Center(
                          child: key == '⌫'
                              ? const Icon(Icons.backspace_outlined, size: 22, color: AppColors.onSurface)
                              : Text(
                                  key,
                                  style: const TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 26,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                        ),
                      ),
                    ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
