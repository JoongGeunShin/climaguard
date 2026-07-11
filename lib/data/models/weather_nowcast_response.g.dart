// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_nowcast_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherNowcastResponse _$WeatherNowcastResponseFromJson(
  Map<String, dynamic> json,
) => WeatherNowcastResponse(
  response: WeatherNowcastBody.fromJson(
    json['response'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$WeatherNowcastResponseToJson(
  WeatherNowcastResponse instance,
) => <String, dynamic>{'response': instance.response};

WeatherNowcastBody _$WeatherNowcastBodyFromJson(Map<String, dynamic> json) =>
    WeatherNowcastBody(
      body: WeatherNowcastBodyInner.fromJson(
        json['body'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$WeatherNowcastBodyToJson(WeatherNowcastBody instance) =>
    <String, dynamic>{'body': instance.body};

WeatherNowcastBodyInner _$WeatherNowcastBodyInnerFromJson(
  Map<String, dynamic> json,
) => WeatherNowcastBodyInner(
  items: WeatherNowcastItemsWrapper.fromJson(
    json['items'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$WeatherNowcastBodyInnerToJson(
  WeatherNowcastBodyInner instance,
) => <String, dynamic>{'items': instance.items};

WeatherNowcastItemsWrapper _$WeatherNowcastItemsWrapperFromJson(
  Map<String, dynamic> json,
) => WeatherNowcastItemsWrapper(
  items:
      (json['item'] as List<dynamic>?)
          ?.map((e) => WeatherNowcastItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$WeatherNowcastItemsWrapperToJson(
  WeatherNowcastItemsWrapper instance,
) => <String, dynamic>{'item': instance.items};

WeatherNowcastItem _$WeatherNowcastItemFromJson(Map<String, dynamic> json) =>
    WeatherNowcastItem(
      category: json['category'] as String,
      baseDate: json['baseDate'] as String,
      baseTime: json['baseTime'] as String,
      obsrValue: json['obsrValue'] as String,
      nx: (json['nx'] as num).toInt(),
      ny: (json['ny'] as num).toInt(),
    );

Map<String, dynamic> _$WeatherNowcastItemToJson(WeatherNowcastItem instance) =>
    <String, dynamic>{
      'category': instance.category,
      'baseDate': instance.baseDate,
      'baseTime': instance.baseTime,
      'obsrValue': instance.obsrValue,
      'nx': instance.nx,
      'ny': instance.ny,
    };
