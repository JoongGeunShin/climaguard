import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../providers/response_protocol_provider.dart';

class ResponseProtocolScreen extends ConsumerWidget {
  const ResponseProtocolScreen({
    super.key,
    required this.regionLabel,
    required this.isHeat,
    required this.danger,
    required this.warning,
    required this.caution,
    required this.safe,
  });

  final String regionLabel;
  final bool isHeat;
  final int danger;
  final int warning;
  final int caution;
  final int safe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final protocolAsync = ref.watch(responseProtocolProvider(
      regionLabel: regionLabel,
      isHeat: isHeat,
      danger: danger,
      warning: warning,
      caution: caution,
      safe: safe,
    ));
    final seasonColor = isHeat ? AppColors.heatCard : AppColors.coldCard;
    final size = MediaQuery.sizeOf(context);
    final hPad = size.width * 0.05;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '대응 프로토콜',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isHeat ? Icons.wb_sunny : Icons.ac_unit,
                    size: 16,
                    color: seasonColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$regionLabel · ${isHeat ? '폭염' : '한파'}',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '위험 $danger명 · 경고 $warning명 · 주의 $caution명 · 안전 $safe명',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              protocolAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'AI가 대응 프로토콜을 작성 중이에요...',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                error: (_, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        const Text('생성에 실패했어요',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () => ref.invalidate(
                            responseProtocolProvider(
                              regionLabel: regionLabel,
                              isHeat: isHeat,
                              danger: danger,
                              warning: warning,
                              caution: caution,
                              safe: safe,
                            ),
                          ),
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (protocol) => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                  ),
                  child: Text(
                    protocol,
                    style: const TextStyle(fontSize: 14, height: 1.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
