import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/user_profile.dart';
import '../../providers/user_profile_provider.dart';
import '../../widgets/climaguard_logo.dart';
import 'steps/terms_page.dart';
import 'steps/name_page.dart';
import 'steps/health_page.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  // Step 0 – 약관
  static const _requiredItems = [
    '[필수] 서비스 이용약관',
    '[필수] 개인정보 수집·이용 동의',
    '[필수] 위치기반 서비스 이용 동의',
  ];
  static const _optionalItems = ['[선택] 마케팅 정보 수신 동의'];
  final Set<String> _agreed = {};
  bool get _allRequired => _requiredItems.every(_agreed.contains);
  bool get _allAgreed => {..._requiredItems, ..._optionalItems}.every(_agreed.contains);

  // Step 1 – 이름
  final _nameController = TextEditingController();
  bool get _nameValid => _nameController.text.trim().isNotEmpty;

  // Step 2 – 건강정보
  int _age = 30;
  String? _gender;
  final Set<String> _selectedConditions = {};
  bool _noCondition = false;
  bool _isSaving = false;

  static const _conditionOptions = ['심혈관 질환', '당뇨', '호흡기'];
  static const _conditionKeyMap = {
    '심혈관 질환': '심혈관',
    '당뇨': '당뇨',
    '호흡기': '호흡기',
  };

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _toggleAll() {
    setState(() {
      if (_allAgreed) {
        _agreed.clear();
      } else {
        _agreed.addAll([..._requiredItems, ..._optionalItems]);
      }
    });
  }

  void _toggleTerm(String item) {
    setState(() {
      if (_agreed.contains(item)) {
        _agreed.remove(item);
      } else {
        _agreed.add(item);
      }
    });
  }

  void _toggleCondition(String display) {
    setState(() {
      if (display == '없음') {
        _noCondition = !_noCondition;
        _selectedConditions.clear();
      } else {
        _noCondition = false;
        if (_selectedConditions.contains(display)) {
          _selectedConditions.remove(display);
        } else {
          _selectedConditions.add(display);
        }
      }
    });
  }

  List<String> get _storageConditions =>
      _selectedConditions.map((d) => _conditionKeyMap[d] ?? d).toList();

  String _riskGroupLabel(int age) {
    if (age <= 9) return '영유아 위험군 · 0~9세';
    if (age <= 17) return '청소년 · 10~17세';
    if (age <= 64) return '성인 · 18~64세';
    if (age <= 74) return '고령 위험군 · 65~74세';
    return '초고위험군 · 75세 이상';
  }

  bool get _healthValid =>
      _gender != null && (_noCondition || _selectedConditions.isNotEmpty);

  Future<void> _complete() async {
    setState(() => _isSaving = true);
    await ref.read(userProfileNotifierProvider.notifier).save(
          UserProfile(
            name: _nameController.text.trim(),
            age: _age,
            gender: _gender,
            conditions: _noCondition ? [] : _storageConditions,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final hPad = size.width * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 0),
              child: Row(
                children: [
                  const ClimaGuardLogo(),
                  const Spacer(),
                  _PageDots(current: _currentPage, total: 3),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  TermsPage(
                    hPad: hPad,
                    agreed: _agreed,
                    allRequired: _allRequired,
                    allAgreed: _allAgreed,
                    requiredItems: _requiredItems,
                    optionalItems: _optionalItems,
                    onToggleAll: _toggleAll,
                    onToggle: _toggleTerm,
                    onNext: _allRequired ? _nextPage : null,
                  ),
                  NamePage(
                    hPad: hPad,
                    controller: _nameController,
                    onChanged: (_) => setState(() {}),
                    onNext: _nameValid ? _nextPage : null,
                  ),
                  HealthPage(
                    hPad: hPad,
                    age: _age,
                    gender: _gender,
                    selectedConditions: _selectedConditions,
                    noCondition: _noCondition,
                    conditionOptions: _conditionOptions,
                    riskGroupLabel: _riskGroupLabel(_age),
                    conditions: _noCondition ? const [] : _storageConditions,
                    isSaving: _isSaving,
                    isValid: _healthValid,
                    onDecrement: () => setState(() { if (_age > 1) _age--; }),
                    onIncrement: () => setState(() { if (_age < 120) _age++; }),
                    onSelectGender: (g) => setState(() => _gender = g),
                    onToggleCondition: _toggleCondition,
                    onComplete: _complete,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  final int current;
  final int total;
  const _PageDots({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final isActive = i == current;
        return Container(
          width: isActive ? 20 : 8,
          height: 8,
          margin: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : const Color(0xFFDDDDDD),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
