import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/season.dart';
import '../models/shelter_response.dart';
import 'dio_provider.dart';

part 'shelter_remote_data_source.g.dart';

@riverpod
ShelterRemoteDataSource shelterRemoteDataSource(Ref ref) {
  return ShelterRemoteDataSource(ref.watch(dioProvider));
}

class ShelterRemoteDataSource {
  ShelterRemoteDataSource(this._dio);

  final Dio _dio;

  /// season에 따라 무더위쉼터(heat=1) 또는 한파쉼터(cold=2) 조회
  Future<List<ShelterItem>> fetchNearby({
    required double startLat,
    required double endLat,
    required double startLot,
    required double endLot,
    required Season season,
    int numOfRows = 50,
  }) async {
    final typeCode = season.isHeat ? '1' : season.isCold ? '2' : '1';

    try {
      final params = {
        'serviceKey': Uri.decodeComponent(dotenv.env['SHELTER_API_KEY'] ?? ''),
        'numOfRows': numOfRows,
        'pageNo': 1,
        'returnType': 'json',
        'startLat': startLat.toString(),
        'endLat': endLat.toString(),
        'startLot': startLot.toString(),
        'endLot': endLot.toString(),
        'shlt_se_cd': typeCode,
      };

      if (kDebugMode) {
        debugPrint('[Shelter] 요청 bbox: lat($startLat ~ $endLat) lon($startLot ~ $endLot) type=$typeCode');
      }

      final response = await _dio.get<Map<String, dynamic>>(
        '${AppConstants.shelterBaseUrl}${AppConstants.shelterEndpoint}',
        queryParameters: params,
      );

      if (kDebugMode) {
        final raw = response.data;
        debugPrint('[Shelter] 응답 전체: $raw');
      }

      final raw = response.data;
      final data = raw?['body'];

      if (kDebugMode) {
        debugPrint('[Shelter] totalCount: ${raw?['totalCount']}, body 타입: ${data.runtimeType}, 건수: ${data is List ? data.length : 0}');
      }

      if (data == null || data is! List) return [];
      return data
          .map((e) => ShelterItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 429) {
        throw Exception('API 요청 한도를 초과했습니다. 잠시 후 다시 시도해주세요.');
      }
      if (status == 401 || status == 403) {
        throw Exception('대피소 API 인증에 실패했습니다. API 키를 확인해주세요.');
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('대피소 서버 응답이 없습니다. 네트워크 상태를 확인해주세요.');
      }
      throw Exception('대피소 정보를 불러오지 못했습니다. (${status ?? e.type.name})');
    }
  }
}
