class AppConstants {
  AppConstants._();

  // 기상청 API 엔드포인트
  static const String weatherBaseUrl = 'http://apis.data.go.kr/1360000';
  static const String shortForecastPath =
      '/VilageFcstInfoService_2.0/getVilageFcst';
  static const String impactForecastPath =
      '/ImpFcstInfoService_2.0/getImpFcst';
  static const String heatIndexPath =
      '/LivingWthrIdxServiceV4/getHeatStressIdx';

  // 대피소 API
  static const String shelterBaseUrl =
      'https://www.safetydata.go.kr';
  static const String shelterEndpoint = '/V2/api/DSSP-IF-10941';

  // 카카오 API
  static const String kakaoBaseUrl =
    'https://dapi.kakao.com/v2/local/geo';
  static const String kakaoReverseGeocoderEndpoint = '/coord2regioncode.json';

  // 앱 설정
  static const int apiPageSize = 100;
  static const Duration apiTimeout = Duration(seconds: 10);

  // ── 폭염 공식 임계치 (°C, 체감온도 기준) ──────────────────────────
  static const double heatCaution = 31.0;  // 관심
  static const double heatWarning = 33.0;  // 주의
  static const double heatAlert   = 35.0;  // 경고
  static const double heatDanger  = 38.0;  // 위험

  // ── 한파 공식 임계치 (°C, 체감한파온도 기준) ──────────────────────
  static const double coldCaution = -6.0;   // 관심
  static const double coldWarning = -12.0;  // 주의
  static const double coldAlert   = -15.0;  // 경고
  static const double coldDanger  = -18.0;  // 위험

  // ── 연령별 폭염 보정값 (음수 = 더 민감) ──────────────────────────
  static const Map<String, double> ageGroupHeatOffsets = {
    'infant_0to9':        -3.0,
    'youth_10to17':       -1.5,
    'adult_18to64':        0.0,
    'elderly_65to74':     -3.0,
    'super_elderly_75plus': -4.5,
  };

  // ── 연령별 한파 보정값 (양수 = 더 민감 → 덜 추운 온도에서 경보) ──
  static const Map<String, double> ageGroupColdOffsets = {
    'infant_0to9':          3.0,
    'youth_10to17':         1.5,
    'adult_18to64':         0.0,
    'elderly_65to74':       3.0,
    'super_elderly_75plus': 4.5,
  };

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
