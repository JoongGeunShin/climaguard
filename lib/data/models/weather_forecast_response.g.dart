// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_forecast_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherForecastResponse _$WeatherForecastResponseFromJson(
  Map<String, dynamic> json,
) => WeatherForecastResponse(
  response: WeatherForecastBody.fromJson(
    json['response'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$WeatherForecastResponseToJson(
  WeatherForecastResponse instance,
) => <String, dynamic>{'response': instance.response};

WeatherForecastBody _$WeatherForecastBodyFromJson(Map<String, dynamic> json) =>
    WeatherForecastBody(
      body: WeatherForecastBodyInner.fromJson(
        json['body'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$WeatherForecastBodyToJson(
  WeatherForecastBody instance,
) => <String, dynamic>{'body': instance.body};

WeatherForecastBodyInner _$WeatherForecastBodyInnerFromJson(
  Map<String, dynamic> json,
) => WeatherForecastBodyInner(
  items: WeatherForecastItemsWrapper.fromJson(
    json['items'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$WeatherForecastBodyInnerToJson(
  WeatherForecastBodyInner instance,
) => <String, dynamic>{'items': instance.items};

WeatherForecastItemsWrapper _$WeatherForecastItemsWrapperFromJson(
  Map<String, dynamic> json,
) => WeatherForecastItemsWrapper(
  items:
      (json['item'] as List<dynamic>?)
          ?.map((e) => WeatherForecastItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$WeatherForecastItemsWrapperToJson(
  WeatherForecastItemsWrapper instance,
) => <String, dynamic>{'item': instance.items};

WeatherForecastItem _$WeatherForecastItemFromJson(Map<String, dynamic> json) =>
    WeatherForecastItem(
      category: json['category'] as String,
      fcstDate: json['fcstDate'] as String,
      fcstTime: json['fcstTime'] as String,
      fcstValue: json['fcstValue'] as String,
      nx: (json['nx'] as num).toInt(),
      ny: (json['ny'] as num).toInt(),
    );

Map<String, dynamic> _$WeatherForecastItemToJson(
  WeatherForecastItem instance,
) => <String, dynamic>{
  'category': instance.category,
  'fcstDate': instance.fcstDate,
  'fcstTime': instance.fcstTime,
  'fcstValue': instance.fcstValue,
  'nx': instance.nx,
  'ny': instance.ny,
};
