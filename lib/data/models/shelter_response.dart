import 'package:json_annotation/json_annotation.dart';

part 'shelter_response.g.dart';

double _toDouble(dynamic v) {
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0.0;
  return 0.0;
}

@JsonSerializable()
class ShelterApiResponse {
  ShelterApiResponse({
    required this.numOfRows,
    required this.pageNo,
    required this.totalCount,
    this.data = const [],
  });

  final int numOfRows;
  final int pageNo;
  final int totalCount;
  final List<ShelterItem> data;

  factory ShelterApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ShelterApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShelterApiResponseToJson(this);
}

@JsonSerializable()
class ShelterItem {
  ShelterItem({
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
    this.typeCode,
    this.typeName,
    this.managementNo,
    this.operatingHours,
    this.phone,
  });

  @JsonKey(name: 'REARE_NM')
  final String name;

  @JsonKey(name: 'RONA_DADDR')
  final String? address;

  @JsonKey(name: 'LAT', fromJson: _toDouble)
  final double latitude;

  @JsonKey(name: 'LOT', fromJson: _toDouble)
  final double longitude;

  @JsonKey(name: 'SHLT_SE_CD')
  final String? typeCode;

  @JsonKey(name: 'SHLT_SE_NM')
  final String? typeName;

  @JsonKey(name: 'MNG_SN')
  final String? managementNo;

  @JsonKey(name: 'OPNNG_CLSE_HR')
  final String? operatingHours;

  @JsonKey(name: 'RST_TELNO')
  final String? phone;

  factory ShelterItem.fromJson(Map<String, dynamic> json) =>
      _$ShelterItemFromJson(json);

  Map<String, dynamic> toJson() => _$ShelterItemToJson(this);
}
