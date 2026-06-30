import '../../core/constants/app_constants.dart';
import '../../data/datasources/gemini_data_source.dart';
import '../entities/climate_alert.dart';
import '../entities/risk_level.dart';
import '../entities/user_profile.dart';

class GetAiExplanationUseCase {
  GetAiExplanationUseCase(this._gemini);

  final GeminiDataSource _gemini;

  Future<String> execute({
    required UserProfile profile,
    required ClimateAlert alert,
  }) async {
    try {
      final text =
          await _gemini.getExplanation(prompt: _buildPrompt(profile, alert));
      if (text.isNotEmpty) return text;
    } catch (_) {}
    return _fallback(profile, alert);
  }

  String _buildPrompt(UserProfile profile, ClimateAlert alert) {
    final season = alert.season;
    final condStr = profile.conditions.isEmpty
        ? '없음'
        : profile.conditions.join(', ');
    final baseThreshold =
        season.isHeat ? AppConstants.heatAlert : AppConstants.coldAlert;
    final diff = (alert.personalThreshold - baseThreshold).abs();
    final sensitivity = season.isHeat
        ? (alert.personalThreshold < baseThreshold ? '더 민감' : '덜 민감')
        : (alert.personalThreshold > baseThreshold ? '더 민감' : '덜 민감');

    final seasonDesc = season.isHeat ? '폭염' : season.isCold ? '한파' : '일반';
    final riskDesc = _riskDesc(alert.personalRiskLevel);

    return '''
당신은 기상 건강 위험 안내 전문가입니다.
아래 정보를 바탕으로 2~3문장의 개인화된 위험 안내를 작성해주세요.

[사용자 정보]
나이: ${profile.age}세
기저질환: $condStr
개인 $seasonDesc 임계치: ${alert.personalThreshold.toStringAsFixed(1)}°C (일반 성인 ${baseThreshold.toStringAsFixed(0)}°C보다 ${diff.toStringAsFixed(1)}° $sensitivity)

[현재 날씨]
시즌: $seasonDesc
체감온도: ${alert.currentFeelsLike.toStringAsFixed(1)}°C
위험 단계: $riskDesc

[작성 규칙]
1. 나이와 기저질환을 자연스럽게 언급할 것 (기저질환 없으면 나이만)
2. 마지막 문장에 지금 당장 취해야 할 행동을 강하게 권고할 것
3. 친근하고 걱정스러운 경어체로 작성 (예: "~하세요", "~에요")
4. 200자 이내, 마크다운 없이 텍스트만
''';
  }

  String _fallback(UserProfile profile, ClimateAlert alert) {
    final season = alert.season;
    final age = profile.age;
    final conds = profile.conditions;
    final feelsLike = alert.currentFeelsLike.toStringAsFixed(1);
    final level = _riskDesc(alert.personalRiskLevel);

    if (season.isHeat) {
      final condMention =
          conds.contains('심혈관') || conds.contains('고혈압')
              ? '심혈관 질환이 있으시면 더위에 혈압 변동이 커질 수 있어요. '
              : conds.contains('당뇨')
                  ? '당뇨가 있으시면 더위로 인해 혈당 관리가 더 어려워질 수 있어요. '
                  : '';
      return '$age세이신 분께는 지금 체감 $feelsLike°C는 $level 수준이에요. '
          '$condMention지금 당장 시원한 실내로 이동하시고 물을 충분히 드세요.';
    } else if (season.isCold) {
      final condMention =
          conds.contains('심혈관') || conds.contains('고혈압')
              ? '심혈관 질환이 있으시면 급격한 기온 변화에 특히 주의하세요. '
              : '';
      return '$age세이신 분께는 지금 체감 $feelsLike°C가 $level 수준이에요. '
          '$condMention외출 시 충분히 따뜻하게 입으시고 가능하면 실내에 계세요.';
    } else {
      return '지금 기온은 쾌적한 범위예요. 가벼운 외출을 즐기시되 수분 보충을 잊지 마세요.';
    }
  }

  String _riskDesc(RiskLevel level) => switch (level) {
        RiskLevel.safe => '안전',
        RiskLevel.caution => '주의',
        RiskLevel.warning => '경고',
        RiskLevel.danger => '위험',
      };
}
