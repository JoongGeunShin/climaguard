import '../../data/datasources/gemini_data_source.dart';
import 'regional_risk_projection_use_case.dart';

/// 지자체 대시보드에 표시된 위험 인원 분포를 바탕으로, 그 지역 담당자가
/// 참고할 수 있는 대응 프로토콜(요령)을 생성한다. 화면에 실제 지역 데이터가
/// 표시되든 시연용 더미 데이터가 표시되든 상관없이, 현재 보여진 분포를
/// 그대로 입력으로 받는다.
class GetResponseProtocolUseCase {
  GetResponseProtocolUseCase(this._gemini);

  final GeminiDataSource _gemini;

  Future<String> execute({
    required String regionLabel,
    required bool isHeat,
    required RegionRiskProjection projection,
  }) async {
    try {
      final text = await _gemini.getExplanation(
        prompt: _buildPrompt(regionLabel, isHeat, projection),
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
  ) {
    final seasonDesc = isHeat ? '폭염' : '한파';

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

[작성 규칙]
1. 위험·경고 단계 인원 비중이 높으면 더 시급하고 구체적인 조치를 우선 제시할 것
2. 3~5개의 실행 항목을 번호 목록으로 작성할 것 (예: 1. ~~, 2. ~~)
3. 각 항목은 한 문장으로, 담당자가 바로 실행 가능한 구체적 행동으로 작성할 것
4. 마크다운 강조(**, #) 없이 순수 텍스트만 사용할 것
5. 400자 이내
''';
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
