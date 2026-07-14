import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/official_guideline.dart';

part 'official_guideline_data_source.g.dart';

@Riverpod(keepAlive: true)
OfficialGuidelineDataSource officialGuidelineDataSource(Ref ref) {
  return OfficialGuidelineDataSource(FirebaseFirestore.instance);
}

/// `response_guidelines` 컬렉션(문서ID: 'heat' | 'cold')에서 공식 매뉴얼
/// 발췌 지침을 조회한다. Firestore SDK의 오프라인 캐시를 그대로 활용하므로
/// 별도 로컬 캐싱 레이어는 두지 않는다 — 문서 수가 2개뿐이라 매 호출마다
/// 읽어도 비용·지연이 무시할 수준이다.
class OfficialGuidelineDataSource {
  OfficialGuidelineDataSource(this._db);

  final FirebaseFirestore _db;

  CollectionReference get _collection => _db.collection('response_guidelines');

  Future<OfficialGuideline?> fetch(String hazardType) async {
    try {
      final snap = await _collection.doc(hazardType).get();
      if (!snap.exists) return null;
      final data = snap.data() as Map<String, dynamic>;
      final excerpt = data['excerpt'] as String? ?? '';
      if (excerpt.isEmpty) return null;

      return OfficialGuideline(
        hazardType: hazardType,
        excerpt: excerpt,
        source: data['source'] as String? ?? '',
        sourceUrl: data['sourceUrl'] as String?,
      );
    } catch (_) {
      return null;
    }
  }
}
