// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shelter_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShelterApiResponse _$ShelterApiResponseFromJson(Map<String, dynamic> json) =>
    ShelterApiResponse(
      numOfRows: (json['numOfRows'] as num).toInt(),
      pageNo: (json['pageNo'] as num).toInt(),
      totalCount: (json['totalCount'] as num).toInt(),
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => ShelterItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ShelterApiResponseToJson(ShelterApiResponse instance) =>
    <String, dynamic>{
      'numOfRows': instance.numOfRows,
      'pageNo': instance.pageNo,
      'totalCount': instance.totalCount,
      'data': instance.data,
    };

ShelterItem _$ShelterItemFromJson(Map<String, dynamic> json) => ShelterItem(
  name: json['REARE_NM'] as String,
  address: json['RONA_DADDR'] as String?,
  latitude: _toDouble(json['LAT']),
  longitude: _toDouble(json['LOT']),
  typeCode: json['SHLT_SE_CD'] as String?,
  typeName: json['SHLT_SE_NM'] as String?,
  managementNo: json['MNG_SN'] as String?,
  operatingHours: json['OPNNG_CLSE_HR'] as String?,
  phone: json['RST_TELNO'] as String?,
);

Map<String, dynamic> _$ShelterItemToJson(ShelterItem instance) =>
    <String, dynamic>{
      'REARE_NM': instance.name,
      'RONA_DADDR': instance.address,
      'LAT': instance.latitude,
      'LOT': instance.longitude,
      'SHLT_SE_CD': instance.typeCode,
      'SHLT_SE_NM': instance.typeName,
      'MNG_SN': instance.managementNo,
      'OPNNG_CLSE_HR': instance.operatingHours,
      'RST_TELNO': instance.phone,
    };
