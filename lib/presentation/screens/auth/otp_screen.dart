import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/firebase_auth_data_source.dart';
import '../../../data/repositories/user_profile_repository_impl.dart';
import '../../providers/user_profile_provider.dart';
import 'widgets/num_pad.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  String _code = '';
  bool _isLoading = false;
  String? _error;
  int _secondsLeft = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onKey(String key) {
    if (_isLoading) return;
    setState(() {
      _error = null;
      if (key == '⌫') {
        if (_code.isNotEmpty) _code = _code.substring(0, _code.length - 1);
      } else if (_code.length < 6) {
        _code += key;
      }
    });
    if (_code.length == 6) _verify();
  }

  Future<void> _verify() async {
    if (_code.length != 6) {
      setState(() => _error = '6자리 인증번호를 입력해주세요.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final isNewUser = await ref.read(firebaseAuthDataSourceProvider).signInWithCode(
            verificationId: widget.verificationId,
            smsCode: _code,
          );

      if (!mounted) return;

      if (isNewUser) {
        context.go('/onboarding');
        return;
      }

      // 기존 사용자: Firestore 프로필 확인 후 라우팅
      final repo = await ref.read(userProfileRepositoryProvider.future);
      final profile = await repo.loadProfile();
      if (!mounted) return;

      // 프로바이더 갱신 → 라우터 상태 동기화
      ref.invalidate(userProfileNotifierProvider);

      if (profile != null) {
        context.go('/'); // 온보딩 완료 → 홈
      } else {
        context.go('/onboarding'); // 프로필 미등록 → 온보딩
      }
    } on Exception catch (e) {
      if (!mounted) return;
      final msg = e.toString();
      setState(() {
        _isLoading = false;
        _error = msg.contains('invalid-verification-code')
            ? '인증번호가 올바르지 않습니다.'
            : msg.contains('session-expired')
                ? '인증 시간이 만료됐습니다. 다시 시도해주세요.'
                : '인증에 실패했습니다. 다시 시도해주세요.';
      });
    }
  }

  String get _maskedPhone {
    final p = widget.phoneNumber;
    if (p.length < 8) return p;
    return '${p.substring(0, p.length - 8)}****${p.substring(p.length - 4)}';
  }

  Widget _buildOtpBox(int index) {
    final isActive = index == _code.length;
    final hasDigit = index < _code.length;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive
              ? AppColors.onSurface
              : hasDigit
                  ? AppColors.textSecondary
                  : AppColors.divider,
          width: isActive ? 2.0 : 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: hasDigit
          ? Text(
              _code[index],
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final hPad = size.width * 0.08;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.03),
                  Text(
                    'SMS를 보내드렸어요',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$_maskedPhone 으로 발송된\n보안 코드를 입력해주세요.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: 36),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, _buildOtpBox),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Center(
                    child: _secondsLeft > 0
                        ? Text(
                            '${_secondsLeft}초 후 재전송 가능',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          )
                        : GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Text(
                              '인증번호를 받지 못하셨나요?',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.onSurface,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.onSurface,
                                  ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            NumPad(onKey: _onKey),
            Padding(
              padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: (_isLoading || _code.length != 6) ? null : _verify,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          '확인',
                          style: TextStyle(fontFamily: 'Pretendard', fontSize: 18),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
