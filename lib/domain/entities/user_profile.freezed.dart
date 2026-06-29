// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserProfile {

 int get age; String get name; String? get gender;// '남성' or '여성'
 List<String> get conditions;// 기저질환
 String? get regionCode; List<double> get heatFeedbackHistory;// 폭염 체감 보정값 이력
 List<double> get coldFeedbackHistory;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.age, age) || other.age == age)&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&const DeepCollectionEquality().equals(other.conditions, conditions)&&(identical(other.regionCode, regionCode) || other.regionCode == regionCode)&&const DeepCollectionEquality().equals(other.heatFeedbackHistory, heatFeedbackHistory)&&const DeepCollectionEquality().equals(other.coldFeedbackHistory, coldFeedbackHistory));
}


@override
int get hashCode => Object.hash(runtimeType,age,name,gender,const DeepCollectionEquality().hash(conditions),regionCode,const DeepCollectionEquality().hash(heatFeedbackHistory),const DeepCollectionEquality().hash(coldFeedbackHistory));

@override
String toString() {
  return 'UserProfile(age: $age, name: $name, gender: $gender, conditions: $conditions, regionCode: $regionCode, heatFeedbackHistory: $heatFeedbackHistory, coldFeedbackHistory: $coldFeedbackHistory)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 int age, String name, String? gender, List<String> conditions, String? regionCode, List<double> heatFeedbackHistory, List<double> coldFeedbackHistory
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? age = null,Object? name = null,Object? gender = freezed,Object? conditions = null,Object? regionCode = freezed,Object? heatFeedbackHistory = null,Object? coldFeedbackHistory = null,}) {
  return _then(_self.copyWith(
age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<String>,regionCode: freezed == regionCode ? _self.regionCode : regionCode // ignore: cast_nullable_to_non_nullable
as String?,heatFeedbackHistory: null == heatFeedbackHistory ? _self.heatFeedbackHistory : heatFeedbackHistory // ignore: cast_nullable_to_non_nullable
as List<double>,coldFeedbackHistory: null == coldFeedbackHistory ? _self.coldFeedbackHistory : coldFeedbackHistory // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
/// A variant of `map` that fallback to returning `orElse`.
@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int age,  String name,  String? gender,  List<String> conditions,  String? regionCode,  List<double> heatFeedbackHistory,  List<double> coldFeedbackHistory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.age,_that.name,_that.gender,_that.conditions,_that.regionCode,_that.heatFeedbackHistory,_that.coldFeedbackHistory);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int age,  String name,  String? gender,  List<String> conditions,  String? regionCode,  List<double> heatFeedbackHistory,  List<double> coldFeedbackHistory)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.age,_that.name,_that.gender,_that.conditions,_that.regionCode,_that.heatFeedbackHistory,_that.coldFeedbackHistory);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int age,  String name,  String? gender,  List<String> conditions,  String? regionCode,  List<double> heatFeedbackHistory,  List<double> coldFeedbackHistory)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.age,_that.name,_that.gender,_that.conditions,_that.regionCode,_that.heatFeedbackHistory,_that.coldFeedbackHistory);case _:
  return null;

}
}

}

/// @nodoc


class _UserProfile implements UserProfile {
  const _UserProfile({required this.age, this.name = '', this.gender, final  List<String> conditions = const [], this.regionCode, final  List<double> heatFeedbackHistory = const [], final  List<double> coldFeedbackHistory = const []}): _conditions = conditions,_heatFeedbackHistory = heatFeedbackHistory,_coldFeedbackHistory = coldFeedbackHistory;


@override final  int age;
@override final  String name;
@override final  String? gender;
// '남성' or '여성'
 final  List<String> _conditions;
// '남성' or '여성'
@override@JsonKey() List<String> get conditions {
  if (_conditions is EqualUnmodifiableListView) return _conditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conditions);
}

// 기저질환
@override final  String? regionCode;
 final  List<double> _heatFeedbackHistory;
@override@JsonKey() List<double> get heatFeedbackHistory {
  if (_heatFeedbackHistory is EqualUnmodifiableListView) return _heatFeedbackHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_heatFeedbackHistory);
}

// 폭염 체감 보정값 이력
 final  List<double> _coldFeedbackHistory;
// 폭염 체감 보정값 이력
@override@JsonKey() List<double> get coldFeedbackHistory {
  if (_coldFeedbackHistory is EqualUnmodifiableListView) return _coldFeedbackHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coldFeedbackHistory);
}


/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.age, age) || other.age == age)&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&const DeepCollectionEquality().equals(other._conditions, _conditions)&&(identical(other.regionCode, regionCode) || other.regionCode == regionCode)&&const DeepCollectionEquality().equals(other._heatFeedbackHistory, _heatFeedbackHistory)&&const DeepCollectionEquality().equals(other._coldFeedbackHistory, _coldFeedbackHistory));
}


@override
int get hashCode => Object.hash(runtimeType,age,name,gender,const DeepCollectionEquality().hash(_conditions),regionCode,const DeepCollectionEquality().hash(_heatFeedbackHistory),const DeepCollectionEquality().hash(_coldFeedbackHistory));

@override
String toString() {
  return 'UserProfile(age: $age, name: $name, gender: $gender, conditions: $conditions, regionCode: $regionCode, heatFeedbackHistory: $heatFeedbackHistory, coldFeedbackHistory: $coldFeedbackHistory)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 int age, String name, String? gender, List<String> conditions, String? regionCode, List<double> heatFeedbackHistory, List<double> coldFeedbackHistory
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? age = null,Object? name = null,Object? gender = freezed,Object? conditions = null,Object? regionCode = freezed,Object? heatFeedbackHistory = null,Object? coldFeedbackHistory = null,}) {
  return _then(_UserProfile(
age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,conditions: null == conditions ? _self._conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<String>,regionCode: freezed == regionCode ? _self.regionCode : regionCode // ignore: cast_nullable_to_non_nullable
as String?,heatFeedbackHistory: null == heatFeedbackHistory ? _self._heatFeedbackHistory : heatFeedbackHistory // ignore: cast_nullable_to_non_nullable
as List<double>,coldFeedbackHistory: null == coldFeedbackHistory ? _self._coldFeedbackHistory : coldFeedbackHistory // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}


}

// dart format on
