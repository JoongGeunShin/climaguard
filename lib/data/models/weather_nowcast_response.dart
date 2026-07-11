import 'package:json_annotation/json_annotation.dart';

part 'weather_nowcast_response.g.dart';

/// 기상청 초단기실황(getUltraSrtNcst) 응답 — 예보가 아닌 실제 관측값.
@JsonSerializable()
class WeatherNowcastResponse {
  WeatherNowcastResponse({required this.response});

  final WeatherNowcastBody response;

  factory WeatherNowcastResponse.fromJson(Map<String, dynamic> json) =>
      _$WeatherNowcastResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherNowcastResponseToJson(this);
}

@JsonSerializable()
class WeatherNowcastBody {
  WeatherNowcastBody({required this.body});

  final WeatherNowcastBodyInner body;

  factory WeatherNowcastBody.fromJson(Map<String, dynamic> json) =>
      _$WeatherNowcastBodyFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherNowcastBodyToJson(this);
}

@JsonSerializable()
class WeatherNowcastBodyInner {
  WeatherNowcastBodyInner({required this.items});

  final WeatherNowcastItemsWrapper items;

  factory WeatherNowcastBodyInner.fromJson(Map<String, dynamic> json) =>
      _$WeatherNowcastBodyInnerFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherNowcastBodyInnerToJson(this);
}

/// API 응답의 items 객체: { "item": [...] }
@JsonSerializable()
class WeatherNowcastItemsWrapper {
  WeatherNowcastItemsWrapper({this.items = const []});

  @JsonKey(name: 'item')
  final List<WeatherNowcastItem> items;

  factory WeatherNowcastItemsWrapper.fromJson(Map<String, dynamic> json) =>
      _$WeatherNowcastItemsWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherNowcastItemsWrapperToJson(this);
}

/// 초단기실황 개별 항목 — 단기예보(fcstValue)와 달리 obsrValue(실제 관측값)를 담는다.
/// category: T1H(기온), REH(습도), WSD(풍속), PTY(강수형태)
@JsonSerializable()
class WeatherNowcastItem {
  WeatherNowcastItem({
    required this.category,
    required this.baseDate,
    required this.baseTime,
    required this.obsrValue,
    required this.nx,
    required this.ny,
  });

  final String category;
  final String baseDate;
  final String baseTime;
  final String obsrValue;
  final int nx;
  final int ny;

  factory WeatherNowcastItem.fromJson(Map<String, dynamic> json) =>
      _$WeatherNowcastItemFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherNowcastItemToJson(this);
}
