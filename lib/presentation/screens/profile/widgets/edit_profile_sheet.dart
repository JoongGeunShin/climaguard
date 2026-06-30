import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../../providers/user_profile_provider.dart';

void showEditProfileSheet(BuildContext context, UserProfile profile) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _EditProfileSheet(profile: profile),
  );
}

class _EditProfileSheet extends ConsumerStatefulWidget {
  const _EditProfileSheet({required this.profile});
  final UserProfile profile;

  @override
  ConsumerState<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<_EditProfileSheet> {
  late final TextEditingController _nameCtrl;
  late int _age;
  late String? _gender;
  late final Set<String> _conditions;
  bool _noCondition = false;
  bool _saving = false;

  static const _allConditions = [
    '심혈관', '당뇨', '호흡기', '고혈압', '신장', '비만'
  ];
  static const _conditionLabels = {
    '심혈관': '심혈관 질환',
    '당뇨': '당뇨',
    '호흡기': '호흡기 질환',
    '고혈압': '고혈압',
    '신장': '신장 질환',
    '비만': '비만',
  };

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.profile.name);
    _age = widget.profile.age;
    _gender = widget.profile.gender;
    _conditions = Set.from(widget.profile.conditions);
    _noCondition = _conditions.isEmpty;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  String _ageGroup(int age) {
    if (age <= 9) return '영유아 위험군 · 0~9세';
    if (age <= 17) return '청소년 · 10~17세';
    if (age <= 64) return '성인 · 18~64세';
    if (age <= 74) return '고령 위험군 · 65~74세';
    return '초고위험군 · 75세 이상';
  }

  void _toggleCondition(String key) {
    setState(() {
      if (_conditions.contains(key)) {
        _conditions.remove(key);
      } else {
        _conditions.add(key);
        _noCondition = false;
      }
      if (_conditions.isEmpty) _noCondition = false;
    });
  }

  void _toggleNoCondition() {
    setState(() {
      _noCondition = !_noCondition;
      if (_noCondition) _conditions.clear();
    });
  }

  bool get _valid =>
      _nameCtrl.text.trim().isNotEmpty &&
      _gender != null &&
      (_noCondition || _conditions.isNotEmpty);

  Future<void> _save() async {
    setState(() => _saving = true);
    final updated = widget.profile.copyWith(
      name: _nameCtrl.text.trim(),
      age: _age,
      gender: _gender,
      conditions: _noCondition ? [] : _conditions.toList(),
    );
    await ref.read(userProfileNotifierProvider.notifier).save(updated);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          const Text('내 정보 수정',
              style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // 이름
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              labelText: '이름',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),

          // 나이
          Row(
            children: [
              const Text('나이',
                  style:
                      TextStyle(fontSize: 14, color: Colors.grey)),
              const Spacer(),
              IconButton(
                onPressed: () =>
                    setState(() { if (_age > 1) _age--; }),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$_age세',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: () =>
                    setState(() { if (_age < 120) _age++; }),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          Text(
            _ageGroup(_age),
            style: const TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),

          // 성별
          const Text('성별',
              style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            children: [
              _GenderBtn(
                label: '남성',
                selected: _gender == '남성',
                onTap: () => setState(() => _gender = '남성'),
              ),
              const SizedBox(width: 10),
              _GenderBtn(
                label: '여성',
                selected: _gender == '여성',
                onTap: () => setState(() => _gender = '여성'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 기저질환
          const Text('기저질환',
              style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._allConditions.map((key) => GestureDetector(
                    onTap: () => _toggleCondition(key),
                    child: _ConditionChip(
                      label: _conditionLabels[key]!,
                      selected: _conditions.contains(key),
                    ),
                  )),
              GestureDetector(
                onTap: _toggleNoCondition,
                child:
                    _ConditionChip(label: '없음', selected: _noCondition),
              ),
            ],
          ),
          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_valid && !_saving) ? _save : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('저장',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderBtn extends StatelessWidget {
  const _GenderBtn(
      {required this.label,
      required this.selected,
      required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color:
                    selected ? AppColors.primary : Colors.grey[300]!),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.grey[700],
                fontWeight:
                    selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConditionChip extends StatelessWidget {
  const _ConditionChip(
      {required this.label, required this.selected});
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color:
                selected ? AppColors.primary : Colors.grey[300]!),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: selected ? AppColors.primary : Colors.grey[700],
          fontWeight:
              selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
