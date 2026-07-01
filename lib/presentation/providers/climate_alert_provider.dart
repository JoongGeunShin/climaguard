import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/ai_group_offset_service.dart';
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

  // AI 집단 보정값: 30건 이상이면 Gemini 분석 후 반환, 미달이면 통계 fallback
  final aiOffset = await ref
      .read(aiGroupOffsetServiceProvider)
      .fetchOrAnalyze(profile);

  return RiskCalculationUseCase().calculate(
    profile: profile,
    weather: weather,
    aiGroupOffset: aiOffset,
  );
}
