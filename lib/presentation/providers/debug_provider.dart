import 'package:flutter_riverpod/flutter_riverpod.dart';

// 디버그 빌드 전용 — 시즌 강제 오버라이드
// null = 실제 API 데이터 사용
// non-null = 해당 온도로 weather 강제 대체
final debugTemperatureOverrideProvider = StateProvider<double?>((ref) => null);
