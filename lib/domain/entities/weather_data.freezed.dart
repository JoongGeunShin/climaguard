// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeatherData {

 double get temperature;// 기온 (°C)
 double get feelsLike;// 체감온도 — 폭염:Steadman / 한파:WindChill
 int get humidity;// 습도 (%)
 double get windSpeed;// 풍속 (m/s) — 한파 체감온도 계산용
 RiskLevel get officialRiskLevel; Season get season;// 폭염/한파 모드
 DateTime get observedAt; int? get heatwaveDays; DateTime? get nextUpdateAt;
/// Create a copy of WeatherData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherDataCopyWith<WeatherData> get copyWith => _$WeatherDataCopyWithImpl<WeatherData>(this as WeatherData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherData&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.feelsLike, feelsLike) || other.feelsLike == feelsLike)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.officialRiskLevel, officialRiskLevel) || other.officialRiskLevel == officialRiskLevel)&&(identical(other.season, season) || other.season == season)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.heatwaveDays, heatwaveDays) || other.heatwaveDays == heatwaveDays)&&(identical(other.nextUpdateAt, nextUpdateAt) || other.nextUpdateAt == nextUpdateAt));
}


@override
int get hashCode => Object.hash(runtimeType,temperature,feelsLike,humidity,windSpeed,officialRiskLevel,season,observedAt,heatwaveDays,nextUpdateAt);

@override
String toString() {
  return 'WeatherData(temperature: $temperature, feelsLike: $feelsLike, humidity: $humidity, windSpeed: $windSpeed, officialRiskLevel: $officialRiskLevel, season: $season, observedAt: $observedAt, heatwaveDays: $heatwaveDays, nextUpdateAt: $nextUpdateAt)';
}


}

/// @nodoc
abstract mixin class $WeatherDataCopyWith<$Res>  {
  factory $WeatherDataCopyWith(WeatherData value, $Res Function(WeatherData) _then) = _$WeatherDataCopyWithImpl;
@useResult
$Res call({
 double temperature, double feelsLike, int humidity, double windSpeed, RiskLevel officialRiskLevel, Season season, DateTime observedAt, int? heatwaveDays, DateTime? nextUpdateAt
});




}
/// @nodoc
class _$WeatherDataCopyWithImpl<$Res>
    implements $WeatherDataCopyWith<$Res> {
  _$WeatherDataCopyWithImpl(this._self, this._then);

  final WeatherData _self;
  final $Res Function(WeatherData) _then;

/// Create a copy of WeatherData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? temperature = null,Object? feelsLike = null,Object? humidity = null,Object? windSpeed = null,Object? officialRiskLevel = null,Object? season = null,Object? observedAt = null,Object? heatwaveDays = freezed,Object? nextUpdateAt = freezed,}) {
  return _then(_self.copyWith(
temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,feelsLike: null == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,officialRiskLevel: null == officialRiskLevel ? _self.officialRiskLevel : officialRiskLevel // ignore: cast_nullable_to_non_nullable
as RiskLevel,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as Season,observedAt: null == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime,heatwaveDays: freezed == heatwaveDays ? _self.heatwaveDays : heatwaveDays // ignore: cast_nullable_to_non_nullable
as int?,nextUpdateAt: freezed == nextUpdateAt ? _self.nextUpdateAt : nextUpdateAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeatherData].
extension WeatherDataPatterns on WeatherData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherData value)  $default,){
final _that = this;
switch (_that) {
case _WeatherData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherData value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double temperature,  double feelsLike,  int humidity,  double windSpeed,  RiskLevel officialRiskLevel,  Season season,  DateTime observedAt,  int? heatwaveDays,  DateTime? nextUpdateAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherData() when $default != null:
return $default(_that.temperature,_that.feelsLike,_that.humidity,_that.windSpeed,_that.officialRiskLevel,_that.season,_that.observedAt,_that.heatwaveDays,_that.nextUpdateAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double temperature,  double feelsLike,  int humidity,  double windSpeed,  RiskLevel officialRiskLevel,  Season season,  DateTime observedAt,  int? heatwaveDays,  DateTime? nextUpdateAt)  $default,) {final _that = this;
switch (_that) {
case _WeatherData():
return $default(_that.temperature,_that.feelsLike,_that.humidity,_that.windSpeed,_that.officialRiskLevel,_that.season,_that.observedAt,_that.heatwaveDays,_that.nextUpdateAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double temperature,  double feelsLike,  int humidity,  double windSpeed,  RiskLevel officialRiskLevel,  Season season,  DateTime observedAt,  int? heatwaveDays,  DateTime? nextUpdateAt)?  $default,) {final _that = this;
switch (_that) {
case _WeatherData() when $default != null:
return $default(_that.temperature,_that.feelsLike,_that.humidity,_that.windSpeed,_that.officialRiskLevel,_that.season,_that.observedAt,_that.heatwaveDays,_that.nextUpdateAt);case _:
  return null;

}
}

}

/// @nodoc


class _WeatherData implements WeatherData {
  const _WeatherData({required this.temperature, required this.feelsLike, required this.humidity, required this.windSpeed, required this.officialRiskLevel, required this.season, required this.observedAt, this.heatwaveDays, this.nextUpdateAt});
  

@override final  double temperature;
// 기온 (°C)
@override final  double feelsLike;
// 체감온도 — 폭염:Steadman / 한파:WindChill
@override final  int humidity;
// 습도 (%)
@override final  double windSpeed;
// 풍속 (m/s) — 한파 체감온도 계산용
@override final  RiskLevel officialRiskLevel;
@override final  Season season;
// 폭염/한파 모드
@override final  DateTime observedAt;
@override final  int? heatwaveDays;
@override final  DateTime? nextUpdateAt;

/// Create a copy of WeatherData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherDataCopyWith<_WeatherData> get copyWith => __$WeatherDataCopyWithImpl<_WeatherData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherData&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.feelsLike, feelsLike) || other.feelsLike == feelsLike)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.officialRiskLevel, officialRiskLevel) || other.officialRiskLevel == officialRiskLevel)&&(identical(other.season, season) || other.season == season)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.heatwaveDays, heatwaveDays) || other.heatwaveDays == heatwaveDays)&&(identical(other.nextUpdateAt, nextUpdateAt) || other.nextUpdateAt == nextUpdateAt));
}


@override
int get hashCode => Object.hash(runtimeType,temperature,feelsLike,humidity,windSpeed,officialRiskLevel,season,observedAt,heatwaveDays,nextUpdateAt);

@override
String toString() {
  return 'WeatherData(temperature: $temperature, feelsLike: $feelsLike, humidity: $humidity, windSpeed: $windSpeed, officialRiskLevel: $officialRiskLevel, season: $season, observedAt: $observedAt, heatwaveDays: $heatwaveDays, nextUpdateAt: $nextUpdateAt)';
}


}

/// @nodoc
abstract mixin class _$WeatherDataCopyWith<$Res> implements $WeatherDataCopyWith<$Res> {
  factory _$WeatherDataCopyWith(_WeatherData value, $Res Function(_WeatherData) _then) = __$WeatherDataCopyWithImpl;
@override @useResult
$Res call({
 double temperature, double feelsLike, int humidity, double windSpeed, RiskLevel officialRiskLevel, Season season, DateTime observedAt, int? heatwaveDays, DateTime? nextUpdateAt
});




}
/// @nodoc
class __$WeatherDataCopyWithImpl<$Res>
    implements _$WeatherDataCopyWith<$Res> {
  __$WeatherDataCopyWithImpl(this._self, this._then);

  final _WeatherData _self;
  final $Res Function(_WeatherData) _then;

/// Create a copy of WeatherData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? temperature = null,Object? feelsLike = null,Object? humidity = null,Object? windSpeed = null,Object? officialRiskLevel = null,Object? season = null,Object? observedAt = null,Object? heatwaveDays = freezed,Object? nextUpdateAt = freezed,}) {
  return _then(_WeatherData(
temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,feelsLike: null == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,officialRiskLevel: null == officialRiskLevel ? _self.officialRiskLevel : officialRiskLevel // ignore: cast_nullable_to_non_nullable
as RiskLevel,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as Season,observedAt: null == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime,heatwaveDays: freezed == heatwaveDays ? _self.heatwaveDays : heatwaveDays // ignore: cast_nullable_to_non_nullable
as int?,nextUpdateAt: freezed == nextUpdateAt ? _self.nextUpdateAt : nextUpdateAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
