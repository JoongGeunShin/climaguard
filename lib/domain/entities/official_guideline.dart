import 'package:freezed_annotation/freezed_annotation.dart';

part 'official_guideline.freezed.dart';

/// 행정안전부 등 공식 기관이 발간한 재난 대응 매뉴얼에서 발췌한 지침.
/// 지자체 대응 프로토콜 생성 시 근거(grounding) 자료로 프롬프트에 주입된다.
@freezed
abstract class OfficialGuideline with _$OfficialGuideline {
  const factory OfficialGuideline({
    required String hazardType, // 'heat' | 'cold'
    required String excerpt, // 매뉴얼 발췌 원문
    required String source, // 예: "행정안전부 재난유형별 위기관리 실무매뉴얼(폭염)"
    String? sourceUrl,
  }) = _OfficialGuideline;
}
