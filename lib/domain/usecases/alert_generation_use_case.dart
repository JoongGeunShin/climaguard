import '../entities/climate_alert.dart';
import '../entities/risk_level.dart';
import '../entities/season.dart';
import '../entities/shelter.dart';

class AlertGenerationUseCase {
  String generate({
    required ClimateAlert alert,
    List<Shelter> nearbyShelters = const [],
  }) {
    final buffer = StringBuffer();
    buffer.writeln(_riskMessage(alert));

    if (alert.personalRiskLevel != alert.officialRiskLevel) {
      final diff = alert.personalRiskLevel.index - alert.officialRiskLevel.index;
      final comparison = diff > 0 ? '더 높은' : '더 낮은';
      buffer.writeln(
        '공식 단계(${alert.officialRiskLevel.label})보다 $comparison 수준입니다.',
      );
    }

    if (!alert.season.isNormal &&
        alert.personalRiskLevel.index >= RiskLevel.warning.index &&
        nearbyShelters.isNotEmpty) {
      final nearest = nearbyShelters.first;
      final shelterType = alert.season.isHeat ? '무더위쉼터' : '한파쉼터';
      buffer.writeln(
        '가까운 $shelterType: ${nearest.name} (${nearest.distanceKm.toStringAsFixed(1)}km)',
      );
    }

    return buffer.toString().trim();
  }

  String _riskMessage(ClimateAlert alert) => switch (alert.season) {
        Season.heat   => _heatMessage(alert.personalRiskLevel),
        Season.cold   => _coldMessage(alert.personalRiskLevel),
        Season.normal => _normalMessage(alert.personalRiskLevel),
      };

  String _heatMessage(RiskLevel level) => switch (level) {
        RiskLevel.safe    => '현재 폭염 위험이 낮습니다. 수분 보충을 꾸준히 해주세요.',
        RiskLevel.caution => '폭염 주의 단계입니다. 야외 활동을 자제하고 그늘에서 휴식하세요.',
        RiskLevel.warning => '폭염 경고 단계입니다. 외출을 삼가고 시원한 실내에 머무르세요.',
        RiskLevel.danger  => '폭염 위험 단계입니다. 즉시 서늘한 장소로 이동하고 의료기관에 연락하세요.',
      };

  String _coldMessage(RiskLevel level) => switch (level) {
        RiskLevel.safe    => '현재 한파 위험이 낮습니다. 외출 시 따뜻하게 입으세요.',
        RiskLevel.caution => '한파 주의 단계입니다. 노출 부위를 보온하고 외출 시간을 줄이세요.',
        RiskLevel.warning => '한파 경고 단계입니다. 가급적 실내에 머무르고 난방을 유지하세요.',
        RiskLevel.danger  => '한파 위험 단계입니다. 외출을 삼가고 한파쉼터를 이용하세요. 고령자·독거인은 즉시 확인하세요.',
      };

  String _normalMessage(RiskLevel level) => switch (level) {
        RiskLevel.safe    => '현재 기온이 쾌적합니다. 야외 활동하기 좋은 날씨예요.',
        RiskLevel.caution => '체감온도가 경계 범위에 있습니다. 수분 보충과 보온에 유의하세요.',
        RiskLevel.warning => '날씨 변화에 주의하세요.',
        RiskLevel.danger  => '날씨 상태를 주의하세요.',
      };
}
