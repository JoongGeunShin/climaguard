import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/threshold_service.dart';
import '../../domain/entities/climate_alert.dart';
import '../../domain/usecases/risk_calculation_use_case.dart';
import 'user_profile_provider.dart';
import 'weather_provider.dart';

part 'climate_alert_provider.g.dart';

@Riverpod(keepAlive: true)
Future<ClimateAlert?> climateAlert(ClimateAlertRef ref) async {
  final weather = await ref.watch(weatherProvider.future);
  final profile = await ref.watch(userProfileNotifierProvider.future);
  if (profile == null) return null;

  final ageKey = _ageKey(profile.age);

  // AI 집단학습 트리거는 피드백 제출 시점(user_profile_provider.addFeedback)에서
  // 실행된다 — 여기서는 대시보드 로드를 블로킹하지 않도록 호출하지 않는다.

  // Firestore 실시간 스트림 watch — 그룹학습으로 값이 바뀌면 재시작 없이 재계산된다.
  final base       = await ref.watch(baseThresholdsProvider.future);
  final ageOffsets = await ref.watch(ageOffsetsProvider(ageKey).future);

  // 기저질환 보정값 합산
  double condHeat = 0, condCold = 0;
  for (final condition in profile.conditions) {
    final off = await ref.watch(conditionOffsetProvider(condition).future);
    condHeat += off.heat;
    condCold += off.cold;
  }

  return RiskCalculationUseCase().calculate(
    profile: profile,
    weather: weather,
    base: base,
    ageOffsets: ageOffsets,
    conditionHeatOffset: condHeat,
    conditionColdOffset: condCold,
  );
}

String _ageKey(int age) {
  if (age <= 9)  return 'infant_0to9';
  if (age <= 17) return 'youth_10to17';
  if (age <= 64) return 'adult_18to64';
  if (age <= 74) return 'elderly_65to74';
  return 'super_elderly_75plus';
}
