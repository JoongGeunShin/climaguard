enum RiskLevel {
  safe,
  attention,
  caution,
  warning,
  danger;

  String get label => switch (this) {
        RiskLevel.safe      => '안전',
        RiskLevel.attention => '관심',
        RiskLevel.caution   => '주의',
        RiskLevel.warning   => '경고',
        RiskLevel.danger    => '위험',
      };
}
