import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/firebase_auth_data_source.dart';
import '../../widgets/climaguard_logo.dart';
import 'widgets/num_pad.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String _digits = '';
  bool _isLoading = false;
  String? _error;

  String get _formatted {
    final d = _digits;
    if (d.length <= 3) return d;
    if (d.length <= 7) return '${d.substring(0, 3)}-${d.substring(3)}';
    return '${d.substring(0, 3)}-${d.substring(3, 7)}-${d.substring(7)}';
  }

  bool get _isValid => _digits.length >= 9 && _digits.length <= 11;

  void _onKey(String key) {
    if (_isLoading) return;
    setState(() {
      _error = null;
      if (key == '⌫') {
        if (_digits.isNotEmpty)
          _digits = _digits.substring(0, _digits.length - 1);
      } else if (_digits.length < 11) {
        _digits += key;
      }
    });
  }

  Future<void> _sendCode() async {
    if (!_isValid) {
      setState(() => _error = '올바른 전화번호를 입력해주세요.');
      return;
    }

    final raw = _digits.startsWith('0')
        ? '+82${_digits.substring(1)}'
        : '+82$_digits';

    setState(() {
      _isLoading = true;
      _error = null;
    });

    await ref
        .read(firebaseAuthDataSourceProvider)
        .sendVerificationCode(
          phoneNumber: raw,
          onCodeSent: (verificationId) {
            if (!mounted) return;
            setState(() => _isLoading = false);
            context.push(
              '/otp',
              extra: {'phoneNumber': raw, 'verificationId': verificationId},
            );
          },
          onFailed: (message) {
            if (!mounted) return;
            setState(() {
              _isLoading = false;
              _error = message;
            });
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final hPad = size.width * 0.065;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 헤더 ────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 0),
              child: const ClimaGuardLogo(),
            ),
            // ── 타이틀 ──────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(hPad, 32, hPad, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '휴대폰 번호를\n입력해 주세요',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '위험할 때 가장 먼저 연락드릴 번호예요.',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // ── 전화번호 입력 표시 ─────────────────────────────
                  const Text(
                    '휴대폰 번호',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0EDE8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'KR  +82',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _error != null
                                  ? Theme.of(context).colorScheme.error
                                  : AppColors.primary,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _formatted.isEmpty ? '010-0000-0000' : _formatted,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: _digits.isEmpty
                                  ? AppColors.divider
                                  : AppColors.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '통신사 본인인증 · 인증 외 다른 용도로 쓰지 않아요',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            // ── 커스텀 키패드 ────────────────────────────────────────────
            NumPad(onKey: _onKey),
            // ── 하단 버튼 ────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 20),
              child: _isLoading
                  ? Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color:  AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    )
                  : FilledButton(
                      onPressed: _isValid ? _sendCode : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: _isValid
                            ? AppColors.primary
                            : const Color(0xFFE8E4DF),
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        '로그인/회원가입',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: _isValid
                              ? Colors.white
                              : AppColors.textSecondary,
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
