import 'package:json_annotation/json_annotation.dart';

part 'shelter_response.g.dart';

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
  });

  @JsonKey(name: 'REARE_NM')
  final String name;

  @JsonKey(name: 'RONA_DADDR')
  final String? address;

  @JsonKey(name: 'LAT')
  final String latitude;

  @JsonKey(name: 'LOT')
  final String longitude;

  @JsonKey(name: 'SHLT_SE_CD')
  final String? typeCode;

  @JsonKey(name: 'SHLT_SE_NM')
  final String? typeName;

  @JsonKey(name: 'MNG_SN')
  final String? managementNo;

  factory ShelterItem.fromJson(Map<String, dynamic> json) =>
      _$ShelterItemFromJson(json);

  Map<String, dynamic> toJson() => _$ShelterItemToJson(this);
}
