// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shelter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Shelter {

 String get id; String get name; double get latitude; double get longitude; double get distanceKm; int? get capacity;// 수용인원
 String? get operatingHours; String? get address; String? get phone;
/// Create a copy of Shelter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShelterCopyWith<Shelter> get copyWith => _$ShelterCopyWithImpl<Shelter>(this as Shelter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Shelter&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.operatingHours, operatingHours) || other.operatingHours == operatingHours)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,latitude,longitude,distanceKm,capacity,operatingHours,address,phone);

@override
String toString() {
  return 'Shelter(id: $id, name: $name, latitude: $latitude, longitude: $longitude, distanceKm: $distanceKm, capacity: $capacity, operatingHours: $operatingHours, address: $address, phone: $phone)';
}


}

/// @nodoc
abstract mixin class $ShelterCopyWith<$Res>  {
  factory $ShelterCopyWith(Shelter value, $Res Function(Shelter) _then) = _$ShelterCopyWithImpl;
@useResult
$Res call({
 String id, String name, double latitude, double longitude, double distanceKm, int? capacity, String? operatingHours, String? address, String? phone
});




}
/// @nodoc
class _$ShelterCopyWithImpl<$Res>
    implements $ShelterCopyWith<$Res> {
  _$ShelterCopyWithImpl(this._self, this._then);

  final Shelter _self;
  final $Res Function(Shelter) _then;

/// Create a copy of Shelter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? latitude = null,Object? longitude = null,Object? distanceKm = null,Object? capacity = freezed,Object? operatingHours = freezed,Object? address = freezed,Object? phone = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,operatingHours: freezed == operatingHours ? _self.operatingHours : operatingHours // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Shelter].
extension ShelterPatterns on Shelter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Shelter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Shelter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Shelter value)  $default,){
final _that = this;
switch (_that) {
case _Shelter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Shelter value)?  $default,){
final _that = this;
switch (_that) {
case _Shelter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double latitude,  double longitude,  double distanceKm,  int? capacity,  String? operatingHours,  String? address,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Shelter() when $default != null:
return $default(_that.id,_that.name,_that.latitude,_that.longitude,_that.distanceKm,_that.capacity,_that.operatingHours,_that.address,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double latitude,  double longitude,  double distanceKm,  int? capacity,  String? operatingHours,  String? address,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _Shelter():
return $default(_that.id,_that.name,_that.latitude,_that.longitude,_that.distanceKm,_that.capacity,_that.operatingHours,_that.address,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double latitude,  double longitude,  double distanceKm,  int? capacity,  String? operatingHours,  String? address,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _Shelter() when $default != null:
return $default(_that.id,_that.name,_that.latitude,_that.longitude,_that.distanceKm,_that.capacity,_that.operatingHours,_that.address,_that.phone);case _:
  return null;

}
}

}

/// @nodoc


class _Shelter implements Shelter {
  const _Shelter({required this.id, required this.name, required this.latitude, required this.longitude, required this.distanceKm, this.capacity, this.operatingHours, this.address, this.phone});
  

@override final  String id;
@override final  String name;
@override final  double latitude;
@override final  double longitude;
@override final  double distanceKm;
@override final  int? capacity;
// 수용인원
@override final  String? operatingHours;
@override final  String? address;
@override final  String? phone;

/// Create a copy of Shelter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShelterCopyWith<_Shelter> get copyWith => __$ShelterCopyWithImpl<_Shelter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Shelter&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.operatingHours, operatingHours) || other.operatingHours == operatingHours)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,latitude,longitude,distanceKm,capacity,operatingHours,address,phone);

@override
String toString() {
  return 'Shelter(id: $id, name: $name, latitude: $latitude, longitude: $longitude, distanceKm: $distanceKm, capacity: $capacity, operatingHours: $operatingHours, address: $address, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$ShelterCopyWith<$Res> implements $ShelterCopyWith<$Res> {
  factory _$ShelterCopyWith(_Shelter value, $Res Function(_Shelter) _then) = __$ShelterCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double latitude, double longitude, double distanceKm, int? capacity, String? operatingHours, String? address, String? phone
});




}
/// @nodoc
class __$ShelterCopyWithImpl<$Res>
    implements _$ShelterCopyWith<$Res> {
  __$ShelterCopyWithImpl(this._self, this._then);

  final _Shelter _self;
  final $Res Function(_Shelter) _then;

/// Create a copy of Shelter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? latitude = null,Object? longitude = null,Object? distanceKm = null,Object? capacity = freezed,Object? operatingHours = freezed,Object? address = freezed,Object? phone = freezed,}) {
  return _then(_Shelter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,operatingHours: freezed == operatingHours ? _self.operatingHours : operatingHours // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
