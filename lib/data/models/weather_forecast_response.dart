import 'package:json_annotation/json_annotation.dart';

part 'weather_forecast_response.g.dart';

@JsonSerializable()
class WeatherForecastResponse {
  WeatherForecastResponse({required this.response});

  final WeatherForecastBody response;

  factory WeatherForecastResponse.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherForecastResponseToJson(this);
}

@JsonSerializable()
class WeatherForecastBody {
  WeatherForecastBody({required this.body});

  final WeatherForecastBodyInner body;

  factory WeatherForecastBody.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastBodyFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherForecastBodyToJson(this);
}

@JsonSerializable()
class WeatherForecastBodyInner {
  WeatherForecastBodyInner({required this.items});

  final WeatherForecastItemsWrapper items;

  factory WeatherForecastBodyInner.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastBodyInnerFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherForecastBodyInnerToJson(this);
}

/// API 응답의 items 객체: { "item": [...] }
@JsonSerializable()
class WeatherForecastItemsWrapper {
  WeatherForecastItemsWrapper({this.items = const []});

  @JsonKey(name: 'item')
  final List<WeatherForecastItem> items;

  factory WeatherForecastItemsWrapper.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastItemsWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherForecastItemsWrapperToJson(this);
}

/// 단기예보 개별 항목
/// category: TMP(기온), REH(습도), WSD(풍속), SKY(하늘), PTY(강수형태)
@JsonSerializable()
class WeatherForecastItem {
  WeatherForecastItem({
    required this.category,
    required this.fcstDate,
    required this.fcstTime,
    required this.fcstValue,
    required this.nx,
    required this.ny,
  });

  final String category;
  final String fcstDate;
  final String fcstTime;
  final String fcstValue;
  final int nx;
  final int ny;

  factory WeatherForecastItem.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastItemFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherForecastItemToJson(this);
}
