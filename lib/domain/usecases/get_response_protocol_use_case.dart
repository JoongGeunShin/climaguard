import '../../core/constants/app_constants.dart';
import '../../data/datasources/gemini_data_source.dart';
import '../../data/datasources/official_guideline_data_source.dart';
import '../entities/official_guideline.dart';
import 'regional_risk_projection_use_case.dart';

/// 지자체 대시보드에 표시된 위험 인원 분포를 바탕으로, 그 지역 담당자가
/// 참고할 수 있는 대응 프로토콜(요령)을 생성한다. 화면에 실제 지역 데이터가
/// 표시되든 시연용 더미 데이터가 표시되든 상관없이, 현재 보여진 분포를
/// 그대로 입력으로 받는다.
///
/// 행정안전부 등 공식 매뉴얼 발췌(`OfficialGuideline`)를 Firestore에서 조회해
/// 근거 자료로 프롬프트에 주입한다 — 조회에 실패하거나 문서가 없으면 근거
/// 없이 기존 방식대로 생성한다.
class GetResponseProtocolUseCase {
  GetResponseProtocolUseCase(this._gemini, this._guidelines);

  final GeminiDataSource _gemini;
  final OfficialGuidelineDataSource _guidelines;

  Future<String> execute({
    required String regionLabel,
    required bool isHeat,
    required RegionRiskProjection projection,
  }) async {
    try {
      final guideline =
          await _guidelines.fetch(isHeat ? 'heat' : 'cold');
      final text = await _gemini.getExplanation(
        prompt: _buildPrompt(regionLabel, isHeat, projection, guideline),
        maxOutputTokens: 600,
      );
      if (text.isNotEmpty) return text;
    } catch (_) {}
    return _fallback(regionLabel, isHeat, projection);
  }

  String _buildPrompt(
    String regionLabel,
    bool isHeat,
    RegionRiskProjection p,
    OfficialGuideline? guideline,
  ) {
    final seasonDesc = isHeat ? '폭염' : '한파';
    final guidelineSection = guideline == null
        ? ''
        : '''

[공식 지침 발췌 (출처: ${guideline.source})]
${guideline.excerpt}
''';
    final kmaLine = _kmaAlertLine(isHeat, p);
    final kmaSection = kmaLine == null ? '' : '\n[기상청 특보 기준 대조]\n$kmaLine\n';

    return '''
당신은 지자체 재난안전 담당자를 위한 대응 프로토콜 작성 전문가입니다.
아래 지역의 $seasonDesc 위험 인원 현황을 바탕으로, 담당자가 바로 실행할 수 있는
대응 프로토콜을 작성해주세요.

[지역]
$regionLabel

[$seasonDesc 위험 인원 현황 (전체 ${p.totalPopulation}명)]
위험: ${p.danger}명
경고: ${p.warning}명
주의: ${p.caution}명
안전: ${p.safe}명
$kmaSection$guidelineSection
[작성 규칙]
1. 위험·경고 단계 인원 비중이 높으면 더 시급하고 구체적인 조치를 우선 제시할 것
2. 3~5개의 실행 항목을 번호 목록으로 작성할 것 (예: 1. ~~, 2. ~~)
3. 각 항목은 한 문장으로, 담당자가 바로 실행 가능한 구체적 행동으로 작성할 것
4. 마크다운 강조(**, #) 없이 순수 텍스트만 사용할 것
5. 400자 이내
${kmaLine == null ? '' : '6. [기상청 특보 기준 대조]는 관측 사실 인용에만 쓰고, "관심/주의/경계/심각" 같은 공식 위기경보 단계 용어는 임의로 판정해서 쓰지 말 것 (그 판정은 정부 고유 권한)\n'}${guideline == null ? '' : '''
7. 반드시 위 공식 지침 발췌에 근거해서 작성하고, 지침에 없는 내용을 임의로 지어내지 말 것
8. 각 실행 항목이 공식 지침과 부합하는지 스스로 점검한 뒤 최종본만 출력할 것
9. 마지막 줄에 "※ 출처: ${guideline.source}"를 그대로 추가할 것
'''}
''';
  }

  /// 지역 대표 기온을 기상청 공식 특보 발표기준과 대조한 문장.
  /// 폭염은 체감온도, 한파는 기온(체감 아님) 기준 — 관측치가 없으면 null.
  String? _kmaAlertLine(bool isHeat, RegionRiskProjection p) {
    if (isHeat) {
      final t = p.feelsLike;
      if (t == null) return null;
      final level = t >= AppConstants.kmaHeatWarning
          ? '폭염경보(${AppConstants.kmaHeatWarning}℃ 이상)'
          : t >= AppConstants.kmaHeatAdvisory
              ? '폭염주의보(${AppConstants.kmaHeatAdvisory}℃ 이상)'
              : null;
      if (level == null) return null;
      return '현재 체감온도 ${t.toStringAsFixed(1)}℃는 기상청 $level 기준을 충족합니다.';
    } else {
      final t = p.temperature;
      if (t == null) return null;
      final level = t <= AppConstants.kmaColdWarning
          ? '한파경보(${AppConstants.kmaColdWarning}℃ 이하)'
          : t <= AppConstants.kmaColdAdvisory
              ? '한파주의보(${AppConstants.kmaColdAdvisory}℃ 이하)'
              : null;
      if (level == null) return null;
      return '현재 기온 ${t.toStringAsFixed(1)}℃는 기상청 $level 기준(아침 최저기온 기준값)에 근접·충족하는 수준입니다.';
    }
  }

  String _fallback(String regionLabel, bool isHeat, RegionRiskProjection p) {
    final seasonDesc = isHeat ? '폭염' : '한파';
    final atRisk = p.danger + p.warning;
    final shelterLine = isHeat ? '무더위쉼터' : '한파쉼터';

    final lines = <String>[
      '1. $regionLabel 내 위험·경고 단계 대상자 $atRisk명에게 우선 안내 문자를 발송하세요.',
      '2. 인근 $shelterLine 운영 현황을 점검하고 개방 시간을 연장하세요.',
      '3. 취약계층(고령자·기저질환자) 명단을 확인해 방문 또는 전화 확인을 진행하세요.',
    ];
    if (atRisk > p.safe) {
      lines.add('4. 위험군 비중이 높으니 인근 의료기관과 비상 연락 체계를 재확인하세요.');
    }
    return '$regionLabel $seasonDesc 대응 프로토콜:\n${lines.join('\n')}';
  }
}
