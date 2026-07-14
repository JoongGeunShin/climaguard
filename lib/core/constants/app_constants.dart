class AppConstants {
  AppConstants._();

  // 기상청 API 엔드포인트
  static const String weatherBaseUrl = 'http://apis.data.go.kr/1360000';
  static const String ultraSrtNcstPath =
      '/VilageFcstInfoService_2.0/getUltraSrtNcst';
  static const String impactForecastPath =
      '/ImpFcstInfoService_2.0/getImpFcst';
  static const String heatIndexPath =
      '/LivingWthrIdxServiceV4/getHeatStressIdx';

  // 대피소 API
  static const String shelterBaseUrl =
      'https://www.safetydata.go.kr';
  static const String shelterEndpoint = '/V2/api/DSSP-IF-10941';

  // OpenStreetMap Nominatim (역지오코딩, 무료·키 불필요)
  static const String nominatimBaseUrl = 'https://nominatim.openstreetmap.org';

  // 앱 설정
  static const int apiPageSize = 100;
  static const Duration apiTimeout = Duration(seconds: 10);

  // ── 폭염 성인 기준 임계치 (°C, 체감온도) — hourly 차트·디버그 전용 ─
  static const double heatCaution = 28.0;  // 관심
  static const double heatWarning = 31.0;  // 주의
  static const double heatAlert   = 33.0;  // 경고
  static const double heatDanger  = 36.0;  // 위험

  // ── 한파 성인 기준 임계치 (°C, 체감한파온도) — hourly 차트·디버그 전용 ─
  static const double coldCaution = -4.0;   // 관심
  static const double coldWarning = -8.0;   // 주의
  static const double coldAlert   = -12.0;  // 경고
  static const double coldDanger  = -16.0;  // 위험

  // ── 기상청 공식 특보 발표기준 (고정값, 집단학습으로 변하는 위 개인 임계치와
  // 무관) — 폭염은 일 최고체감온도, 한파는 아침 최저기온(체감 아님) 기준.
  // 출처: 기상청 특보 발표기준(weather.go.kr/w/forecast/guide/standard.do)
  static const double kmaHeatAdvisory = 33.0;  // 폭염주의보
  static const double kmaHeatWarning  = 35.0;  // 폭염경보
  static const double kmaColdAdvisory = -12.0; // 한파주의보
  static const double kmaColdWarning  = -15.0; // 한파경보

  // 연령별 오프셋은 ThresholdService로 이전 (Firestore 관리)

  // ── 기저질환별 폭염 추가 보정 (음수) ─────────────────────────────
  static const Map<String, double> conditionHeatOffsets = {
    '심혈관': -2.0,
    '당뇨':   -2.0,
    '호흡기': -1.5,
    '고혈압': -1.0,
    '신장':   -1.5,
    '비만':   -0.5,
  };

  // ── 기저질환별 한파 추가 보정 (양수) ─────────────────────────────
  static const Map<String, double> conditionColdOffsets = {
    '심혈관': 2.0,
    '당뇨':   1.5,
    '호흡기': 2.0,
    '고혈압': 1.0,
    '신장':   1.0,
    '비만':   0.0,
  };
}
