enum Season {
  heat,   // 더위 (>24°C)
  cold,   // 추위 (<14°C)
  normal; // 적정 (14~24°C)

  static Season fromTemperature(double temperature) {
    if (temperature > 24) return Season.heat;
    if (temperature < 14) return Season.cold;
    return Season.normal;
  }

  bool get isHeat => this == Season.heat;
  bool get isCold => this == Season.cold;
  bool get isNormal => this == Season.normal;

  String get label => switch (this) {
        Season.heat => '폭염',
        Season.cold => '한파',
        Season.normal => '일반',
      };
}
