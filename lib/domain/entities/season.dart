enum Season {
  heat, // 폭염 (5~9월)
  cold; // 한파 (10~4월)

  static Season fromMonth(int month) =>
      (month >= 5 && month <= 9) ? Season.heat : Season.cold;

  static Season get current => fromMonth(DateTime.now().month);

  bool get isHeat => this == Season.heat;
  bool get isCold => this == Season.cold;

  String get label => this == Season.heat ? '폭염' : '한파';
}
