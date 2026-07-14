// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'official_guideline.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OfficialGuideline {

 String get hazardType;// 'heat' | 'cold'
 String get excerpt;// 매뉴얼 발췌 원문
 String get source;// 예: "행정안전부 재난유형별 위기관리 실무매뉴얼(폭염)"
 String? get sourceUrl;
/// Create a copy of OfficialGuideline
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfficialGuidelineCopyWith<OfficialGuideline> get copyWith => _$OfficialGuidelineCopyWithImpl<OfficialGuideline>(this as OfficialGuideline, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfficialGuideline&&(identical(other.hazardType, hazardType) || other.hazardType == hazardType)&&(identical(other.excerpt, excerpt) || other.excerpt == excerpt)&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl));
}


@override
int get hashCode => Object.hash(runtimeType,hazardType,excerpt,source,sourceUrl);

@override
String toString() {
  return 'OfficialGuideline(hazardType: $hazardType, excerpt: $excerpt, source: $source, sourceUrl: $sourceUrl)';
}


}

/// @nodoc
abstract mixin class $OfficialGuidelineCopyWith<$Res>  {
  factory $OfficialGuidelineCopyWith(OfficialGuideline value, $Res Function(OfficialGuideline) _then) = _$OfficialGuidelineCopyWithImpl;
@useResult
$Res call({
 String hazardType, String excerpt, String source, String? sourceUrl
});




}
/// @nodoc
class _$OfficialGuidelineCopyWithImpl<$Res>
    implements $OfficialGuidelineCopyWith<$Res> {
  _$OfficialGuidelineCopyWithImpl(this._self, this._then);

  final OfficialGuideline _self;
  final $Res Function(OfficialGuideline) _then;

/// Create a copy of OfficialGuideline
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hazardType = null,Object? excerpt = null,Object? source = null,Object? sourceUrl = freezed,}) {
  return _then(_self.copyWith(
hazardType: null == hazardType ? _self.hazardType : hazardType // ignore: cast_nullable_to_non_nullable
as String,excerpt: null == excerpt ? _self.excerpt : excerpt // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OfficialGuideline].
extension OfficialGuidelinePatterns on OfficialGuideline {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfficialGuideline value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfficialGuideline() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfficialGuideline value)  $default,){
final _that = this;
switch (_that) {
case _OfficialGuideline():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfficialGuideline value)?  $default,){
final _that = this;
switch (_that) {
case _OfficialGuideline() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String hazardType,  String excerpt,  String source,  String? sourceUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfficialGuideline() when $default != null:
return $default(_that.hazardType,_that.excerpt,_that.source,_that.sourceUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String hazardType,  String excerpt,  String source,  String? sourceUrl)  $default,) {final _that = this;
switch (_that) {
case _OfficialGuideline():
return $default(_that.hazardType,_that.excerpt,_that.source,_that.sourceUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String hazardType,  String excerpt,  String source,  String? sourceUrl)?  $default,) {final _that = this;
switch (_that) {
case _OfficialGuideline() when $default != null:
return $default(_that.hazardType,_that.excerpt,_that.source,_that.sourceUrl);case _:
  return null;

}
}

}

/// @nodoc


class _OfficialGuideline implements OfficialGuideline {
  const _OfficialGuideline({required this.hazardType, required this.excerpt, required this.source, this.sourceUrl});
  

@override final  String hazardType;
// 'heat' | 'cold'
@override final  String excerpt;
// 매뉴얼 발췌 원문
@override final  String source;
// 예: "행정안전부 재난유형별 위기관리 실무매뉴얼(폭염)"
@override final  String? sourceUrl;

/// Create a copy of OfficialGuideline
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfficialGuidelineCopyWith<_OfficialGuideline> get copyWith => __$OfficialGuidelineCopyWithImpl<_OfficialGuideline>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfficialGuideline&&(identical(other.hazardType, hazardType) || other.hazardType == hazardType)&&(identical(other.excerpt, excerpt) || other.excerpt == excerpt)&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl));
}


@override
int get hashCode => Object.hash(runtimeType,hazardType,excerpt,source,sourceUrl);

@override
String toString() {
  return 'OfficialGuideline(hazardType: $hazardType, excerpt: $excerpt, source: $source, sourceUrl: $sourceUrl)';
}


}

/// @nodoc
abstract mixin class _$OfficialGuidelineCopyWith<$Res> implements $OfficialGuidelineCopyWith<$Res> {
  factory _$OfficialGuidelineCopyWith(_OfficialGuideline value, $Res Function(_OfficialGuideline) _then) = __$OfficialGuidelineCopyWithImpl;
@override @useResult
$Res call({
 String hazardType, String excerpt, String source, String? sourceUrl
});




}
/// @nodoc
class __$OfficialGuidelineCopyWithImpl<$Res>
    implements _$OfficialGuidelineCopyWith<$Res> {
  __$OfficialGuidelineCopyWithImpl(this._self, this._then);

  final _OfficialGuideline _self;
  final $Res Function(_OfficialGuideline) _then;

/// Create a copy of OfficialGuideline
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hazardType = null,Object? excerpt = null,Object? source = null,Object? sourceUrl = freezed,}) {
  return _then(_OfficialGuideline(
hazardType: null == hazardType ? _self.hazardType : hazardType // ignore: cast_nullable_to_non_nullable
as String,excerpt: null == excerpt ? _self.excerpt : excerpt // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
