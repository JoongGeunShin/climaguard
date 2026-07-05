import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/gemini_data_source.dart';
import '../../domain/usecases/get_response_protocol_use_case.dart';
import '../../domain/usecases/regional_risk_projection_use_case.dart';

part 'response_protocol_provider.g.dart';

@riverpod
Future<String> responseProtocol(
  Ref ref, {
  required String regionLabel,
  required bool isHeat,
  required int danger,
  required int warning,
  required int caution,
  required int safe,
}) {
  final projection = RegionRiskProjection(
    totalPopulation: danger + warning + caution + safe,
    danger: danger,
    warning: warning,
    caution: caution,
    safe: safe,
  );
  return GetResponseProtocolUseCase(GeminiDataSource()).execute(
    regionLabel: regionLabel,
    isHeat: isHeat,
    projection: projection,
  );
}
