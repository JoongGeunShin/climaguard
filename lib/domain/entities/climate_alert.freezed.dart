// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'climate_alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClimateAlert {

 Season get season; RiskLevel get personalRiskLevel; RiskLevel get officialRiskLevel; double get personalThreshold;// 최종 보정된 개인 임계치
 double get currentFeelsLike;// 현재 체감온도 (폭염/한파 공용)
 List<String> get adjustmentReasons; DateTime get generatedAt;
/// Create a copy of ClimateAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClimateAlertCopyWith<ClimateAlert> get copyWith => _$ClimateAlertCopyWithImpl<ClimateAlert>(this as ClimateAlert, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClimateAlert&&(identical(other.season, season) || other.season == season)&&(identical(other.personalRiskLevel, personalRiskLevel) || other.personalRiskLevel == personalRiskLevel)&&(identical(other.officialRiskLevel, officialRiskLevel) || other.officialRiskLevel == officialRiskLevel)&&(identical(other.personalThreshold, personalThreshold) || other.personalThreshold == personalThreshold)&&(identical(other.currentFeelsLike, currentFeelsLike) || other.currentFeelsLike == currentFeelsLike)&&const DeepCollectionEquality().equals(other.adjustmentReasons, adjustmentReasons)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,season,personalRiskLevel,officialRiskLevel,personalThreshold,currentFeelsLike,const DeepCollectionEquality().hash(adjustmentReasons),generatedAt);

@override
String toString() {
  return 'ClimateAlert(season: $season, personalRiskLevel: $personalRiskLevel, officialRiskLevel: $officialRiskLevel, personalThreshold: $personalThreshold, currentFeelsLike: $currentFeelsLike, adjustmentReasons: $adjustmentReasons, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class $ClimateAlertCopyWith<$Res>  {
  factory $ClimateAlertCopyWith(ClimateAlert value, $Res Function(ClimateAlert) _then) = _$ClimateAlertCopyWithImpl;
@useResult
$Res call({
 Season season, RiskLevel personalRiskLevel, RiskLevel officialRiskLevel, double personalThreshold, double currentFeelsLike, List<String> adjustmentReasons, DateTime generatedAt
});




}
/// @nodoc
class _$ClimateAlertCopyWithImpl<$Res>
    implements $ClimateAlertCopyWith<$Res> {
  _$ClimateAlertCopyWithImpl(this._self, this._then);

  final ClimateAlert _self;
  final $Res Function(ClimateAlert) _then;

/// Create a copy of ClimateAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? season = null,Object? personalRiskLevel = null,Object? officialRiskLevel = null,Object? personalThreshold = null,Object? currentFeelsLike = null,Object? adjustmentReasons = null,Object? generatedAt = null,}) {
  return _then(_self.copyWith(
season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as Season,personalRiskLevel: null == personalRiskLevel ? _self.personalRiskLevel : personalRiskLevel // ignore: cast_nullable_to_non_nullable
as RiskLevel,officialRiskLevel: null == officialRiskLevel ? _self.officialRiskLevel : officialRiskLevel // ignore: cast_nullable_to_non_nullable
as RiskLevel,personalThreshold: null == personalThreshold ? _self.personalThreshold : personalThreshold // ignore: cast_nullable_to_non_nullable
as double,currentFeelsLike: null == currentFeelsLike ? _self.currentFeelsLike : currentFeelsLike // ignore: cast_nullable_to_non_nullable
as double,adjustmentReasons: null == adjustmentReasons ? _self.adjustmentReasons : adjustmentReasons // ignore: cast_nullable_to_non_nullable
as List<String>,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ClimateAlert].
extension ClimateAlertPatterns on ClimateAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClimateAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClimateAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClimateAlert value)  $default,){
final _that = this;
switch (_that) {
case _ClimateAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClimateAlert value)?  $default,){
final _that = this;
switch (_that) {
case _ClimateAlert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Season season,  RiskLevel personalRiskLevel,  RiskLevel officialRiskLevel,  double personalThreshold,  double currentFeelsLike,  List<String> adjustmentReasons,  DateTime generatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClimateAlert() when $default != null:
return $default(_that.season,_that.personalRiskLevel,_that.officialRiskLevel,_that.personalThreshold,_that.currentFeelsLike,_that.adjustmentReasons,_that.generatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Season season,  RiskLevel personalRiskLevel,  RiskLevel officialRiskLevel,  double personalThreshold,  double currentFeelsLike,  List<String> adjustmentReasons,  DateTime generatedAt)  $default,) {final _that = this;
switch (_that) {
case _ClimateAlert():
return $default(_that.season,_that.personalRiskLevel,_that.officialRiskLevel,_that.personalThreshold,_that.currentFeelsLike,_that.adjustmentReasons,_that.generatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Season season,  RiskLevel personalRiskLevel,  RiskLevel officialRiskLevel,  double personalThreshold,  double currentFeelsLike,  List<String> adjustmentReasons,  DateTime generatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ClimateAlert() when $default != null:
return $default(_that.season,_that.personalRiskLevel,_that.officialRiskLevel,_that.personalThreshold,_that.currentFeelsLike,_that.adjustmentReasons,_that.generatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ClimateAlert implements ClimateAlert {
  const _ClimateAlert({required this.season, required this.personalRiskLevel, required this.officialRiskLevel, required this.personalThreshold, required this.currentFeelsLike, required final  List<String> adjustmentReasons, required this.generatedAt}): _adjustmentReasons = adjustmentReasons;
  

@override final  Season season;
@override final  RiskLevel personalRiskLevel;
@override final  RiskLevel officialRiskLevel;
@override final  double personalThreshold;
// 최종 보정된 개인 임계치
@override final  double currentFeelsLike;
// 현재 체감온도 (폭염/한파 공용)
 final  List<String> _adjustmentReasons;
// 현재 체감온도 (폭염/한파 공용)
@override List<String> get adjustmentReasons {
  if (_adjustmentReasons is EqualUnmodifiableListView) return _adjustmentReasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_adjustmentReasons);
}

@override final  DateTime generatedAt;

/// Create a copy of ClimateAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClimateAlertCopyWith<_ClimateAlert> get copyWith => __$ClimateAlertCopyWithImpl<_ClimateAlert>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClimateAlert&&(identical(other.season, season) || other.season == season)&&(identical(other.personalRiskLevel, personalRiskLevel) || other.personalRiskLevel == personalRiskLevel)&&(identical(other.officialRiskLevel, officialRiskLevel) || other.officialRiskLevel == officialRiskLevel)&&(identical(other.personalThreshold, personalThreshold) || other.personalThreshold == personalThreshold)&&(identical(other.currentFeelsLike, currentFeelsLike) || other.currentFeelsLike == currentFeelsLike)&&const DeepCollectionEquality().equals(other._adjustmentReasons, _adjustmentReasons)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,season,personalRiskLevel,officialRiskLevel,personalThreshold,currentFeelsLike,const DeepCollectionEquality().hash(_adjustmentReasons),generatedAt);

@override
String toString() {
  return 'ClimateAlert(season: $season, personalRiskLevel: $personalRiskLevel, officialRiskLevel: $officialRiskLevel, personalThreshold: $personalThreshold, currentFeelsLike: $currentFeelsLike, adjustmentReasons: $adjustmentReasons, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class _$ClimateAlertCopyWith<$Res> implements $ClimateAlertCopyWith<$Res> {
  factory _$ClimateAlertCopyWith(_ClimateAlert value, $Res Function(_ClimateAlert) _then) = __$ClimateAlertCopyWithImpl;
@override @useResult
$Res call({
 Season season, RiskLevel personalRiskLevel, RiskLevel officialRiskLevel, double personalThreshold, double currentFeelsLike, List<String> adjustmentReasons, DateTime generatedAt
});




}
/// @nodoc
class __$ClimateAlertCopyWithImpl<$Res>
    implements _$ClimateAlertCopyWith<$Res> {
  __$ClimateAlertCopyWithImpl(this._self, this._then);

  final _ClimateAlert _self;
  final $Res Function(_ClimateAlert) _then;

/// Create a copy of ClimateAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? season = null,Object? personalRiskLevel = null,Object? officialRiskLevel = null,Object? personalThreshold = null,Object? currentFeelsLike = null,Object? adjustmentReasons = null,Object? generatedAt = null,}) {
  return _then(_ClimateAlert(
season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as Season,personalRiskLevel: null == personalRiskLevel ? _self.personalRiskLevel : personalRiskLevel // ignore: cast_nullable_to_non_nullable
as RiskLevel,officialRiskLevel: null == officialRiskLevel ? _self.officialRiskLevel : officialRiskLevel // ignore: cast_nullable_to_non_nullable
as RiskLevel,personalThreshold: null == personalThreshold ? _self.personalThreshold : personalThreshold // ignore: cast_nullable_to_non_nullable
as double,currentFeelsLike: null == currentFeelsLike ? _self.currentFeelsLike : currentFeelsLike // ignore: cast_nullable_to_non_nullable
as double,adjustmentReasons: null == adjustmentReasons ? _self._adjustmentReasons : adjustmentReasons // ignore: cast_nullable_to_non_nullable
as List<String>,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
