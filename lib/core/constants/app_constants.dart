class AppConstants {
  AppConstants._();

  // 기상청 API 엔드포인트 (공공데이터포털)
  static const String weatherBaseUrl =
      'http://apis.data.go.kr/1360000';

  static const String shortForecastPath =
      '/VilageFcstInfoService_2.0/getVilageFcst';

  static const String impactForecastPath =
      '/ImpFcstInfoService_2.0/getImpFcst';

  static const String heatIndexPath =
      '/LivingWthrIdxServiceV4/getHeatStressIdx';

  // 대피소 API
  static const String shelterBaseUrl =
      'http://apis.data.go.kr/1741000/ShelterService';

  // 앱 설정
  static const int apiPageSize = 100;
  static const Duration apiTimeout = Duration(seconds: 10);

  // 연령별 체감온도 경고 임계치 (°C)
  static const Map<String, double> ageGroupThresholds = {
    'infant_0to9': 32.0,
    'youth_10to17': 33.5,
    'adult_18to64': 35.0,
    'elderly_65to74': 32.0,
    'super_elderly_75plus': 30.5,
  };

  // 기저질환별 임계치 보정값 (음수 = 더 민감)
  static const Map<String, double> conditionOffsets = {
    '심혈관': -2.0,
    '당뇨': -2.0,
    '호흡기': -1.5,
    '신장': -1.5,
    '고혈압': -1.0,
    '비만': -0.5,
  };
}
