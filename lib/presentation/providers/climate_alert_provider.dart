import 'package:riverpod_annotation/riverpod_annotation.dart';
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
  return RiskCalculationUseCase().calculate(profile: profile, weather: weather);
}
