import 'package:uuid/uuid.dart';
import '../models/fortune/number_energy.dart';
import '../models/fortune/bazi_chart.dart';

class NumberEnergyService {
  static final NumberEnergyService _instance = NumberEnergyService._internal();
  factory NumberEnergyService() => _instance;
  NumberEnergyService._internal();

  NumberEnergyAnalysis analyzeNumber({
    required String number,
    required NumberType numberType,
    required String userId,
    BaziChart? userBazi,
    String? userFiveElementNeed,
  }) {
    final cleanNumber = _cleanNumber(number);
    final numbers = _extractNumbers(cleanNumber);
    
    final fiveElementResult = _analyzeFiveElement(numbers, userBazi, userFiveElementNeed);
    final eightStarResult = _analyzeEightStars(cleanNumber);
    final baziMatchResult = _analyzeBaziMatch(fiveElementResult, userBazi);

    return NumberEnergyAnalysis(
      id: const Uuid().v4(),
      number: number,
      numberType: numberType,
      userId: userId,
      analyzedAt: DateTime.now(),
      fiveElementResult: fiveElementResult,
      eightStarResult: eightStarResult,
      baziMatch: baziMatchResult,
    );
  }

  String _cleanNumber(String number) {
    return number.replaceAll(RegExp(r'[^0-9A-Za-z]'), '');
  }

  List<int> _extractNumbers(String number) {
    final digits = <int>[];
    for (int i = 0; i < number.length; i++) {
      final char = number[i];
      if (RegExp(r'[0-9]').hasMatch(char)) {
        digits.add(int.parse(char));
      }
    }
    return digits;
  }

  FiveElementResult _analyzeFiveElement(
    List<int> numbers,
    BaziChart? userBazi,
    String? userFiveElementNeed,
  ) {
    final mainElement = NumberEnergyCollection.calculateMainElement(numbers);
    final supportElement = _calculateSupportElement(numbers, mainElement);
    final numberElements = NumberEnergyCollection.analyzeEachNumber(numbers);
    
    NumberFiveElement? userNeedElement;
    if (userFiveElementNeed != null) {
      userNeedElement = _parseElement(userFiveElementNeed);
    } else if (userBazi != null) {
      userNeedElement = _inferUserNeedFromBazi(userBazi);
    }

    final totalScore = NumberEnergyCollection.calculateFiveElementScore(mainElement, userNeedElement);

    return FiveElementResult(
      mainElement: mainElement,
      supportElement: supportElement,
      numbers: numbers,
      numberElements: numberElements,
      totalScore: totalScore,
      briefAnalysis: _generateFiveElementBrief(mainElement, supportElement),
      auspiciousCombinations: _findAuspiciousCombinations(numbers),
      inauspiciousCombinations: _findInauspiciousCombinations(numbers),
    );
  }

  NumberFiveElement _calculateSupportElement(List<int> numbers, NumberFiveElement mainElement) {
    final elementCounts = <NumberFiveElement, int>{};
    for (final num in numbers) {
      final element = NumberEnergyCollection.numberToElement[num % 10] ?? NumberFiveElement.earth;
      if (element != mainElement) {
        elementCounts[element] = (elementCounts[element] ?? 0) + 1;
      }
    }
    if (elementCounts.isEmpty) return NumberFiveElement.earth;
    return elementCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  NumberFiveElement? _parseElement(String element) {
    switch (element) {
      case '木': return NumberFiveElement.wood;
      case '火': return NumberFiveElement.fire;
      case '土': return NumberFiveElement.earth;
      case '金': return NumberFiveElement.metal;
      case '水': return NumberFiveElement.water;
      default: return null;
    }
  }

  NumberFiveElement _inferUserNeedFromBazi(BaziChart bazi) {
    int wood = 0, fire = 0, earth = 0, metal = 0, water = 0;
    
    for (final pillar in [bazi.yearPillar, bazi.monthPillar, bazi.dayPillar, bazi.hourPillar]) {
      wood += pillar.tiangan.contains(Tiangan.jia) ? 1 : 0;
      wood += pillar.tiangan.contains(Tiangan.yi) ? 1 : 0;
      fire += pillar.tiangan.contains(Tiangan.bing) ? 1 : 0;
      fire += pillar.tiangan.contains(Tiangan.ding) ? 1 : 0;
      earth += pillar.tiangan.contains(Tiangan.wu) ? 1 : 0;
      earth += pillar.tiangan.contains(Tiangan.ji) ? 1 : 0;
      metal += pillar.tiangan.contains(Tiangan.geng) ? 1 : 0;
      metal += pillar.tiangan.contains(Tiangan.xin) ? 1 : 0;
      water += pillar.tiangan.contains(Tiangan.ren) ? 1 : 0;
      water += pillar.tiangan.contains(Tiangan.gui) ? 1 : 0;
      
      wood += pillar.dizhi.contains(Dizhi.yin) ? 1 : 0;
      wood += pillar.dizhi.contains(Dizhi.mao) ? 1 : 0;
      fire += pillar.dizhi.contains(Dizhi.si) ? 1 : 0;
      fire += pillar.dizhi.contains(Dizhi.wu) ? 1 : 0;
      earth += pillar.dizhi.contains(Dizhi.chou) ? 1 : 0;
      earth += pillar.dizhi.contains(Dizhi.wei) ? 1 : 0;
      earth += pillar.dizhi.contains(Dizhi.chou) ? 1 : 0;
      earth += pillar.dizhi.contains(Dizhi.wei) ? 1 : 0;
      metal += pillar.dizhi.contains(Dizhi.shen) ? 1 : 0;
      metal += pillar.dizhi.contains(Dizhi.you) ? 1 : 0;
      water += pillar.dizhi.contains(Dizhi.hai) ? 1 : 0;
      water += pillar.dizhi.contains(Dizhi.zi) ? 1 : 0;
    }

    final counts = {'木': wood, '火': fire, '土': earth, '金': metal, '水': water};
    final sorted = counts.entries.toList()..sort((a, b) => a.value.compareTo(b.value));
    
    return _parseElement(sorted.first.key) ?? NumberFiveElement.earth;
  }

  String _generateFiveElementBrief(NumberFiveElement main, NumberFiveElement support) {
    return '此號碼五行屬${main.name}，${support.name}為輔。${main.auspicious}\n${main.inauspicious}';
  }

  List<String> _findAuspiciousCombinations(List<int> numbers) {
    final combos = <String>[];
    for (int i = 0; i < numbers.length - 1; i++) {
      final pair = '${numbers[i]}${numbers[i + 1]}';
      if (['13', '31', '68', '86', '49', '94', '27', '72', '88', '99', '11', '22', '77'].contains(pair)) {
        combos.add(pair);
      }
    }
    return combos;
  }

  List<String> _findInauspiciousCombinations(List<int> numbers) {
    final combos = <String>[];
    for (int i = 0; i < numbers.length - 1; i++) {
      final pair = '${numbers[i]}${numbers[i + 1]}';
      if (['21', '12', '69', '96', '47', '74', '58', '85'].contains(pair)) {
        combos.add(pair);
      }
    }
    return combos;
  }

  EightStarResult _analyzeEightStars(String number) {
    final stars = NumberEnergyCollection.extractEightStars(number);
    final rating = NumberEnergyCollection.rateOverall(stars);
    
    int auspicious = 0, neutral = 0, inauspicious = 0;
    for (final star in stars) {
      if (star.isAuspicious) auspicious++;
      else inauspicious++;
    }

    final starPositions = <EightStarType, List<int>>{};
    final cleanNumber = number.replaceAll(RegExp(r'[^0-9]'), '');
    for (int i = 0; i < cleanNumber.length - 1; i++) {
      final pair = cleanNumber.substring(i, i + 2);
      if (NumberEnergyCollection.twoDigitToStar.containsKey(pair)) {
        final star = NumberEnergyCollection.twoDigitToStar[pair]!;
        starPositions[star] = [...(starPositions[star] ?? []), i];
      }
    }

    return EightStarResult(
      stars: stars,
      auspiciousStarCount: auspicious,
      neutralStarCount: neutral,
      inauspiciousStarCount: inauspicious,
      overallRating: rating,
      briefAnalysis: _generateEightStarBrief(stars, rating),
      starPositions: starPositions,
    );
  }

  String _generateEightStarBrief(List<EightStarType> stars, String rating) {
    final goodStars = stars.where((s) => s.isAuspicious).toList();
    final badStars = stars.where((s) => !s.isAuspicious).toList();
    
    final buffer = StringBuffer();
    buffer.write('本號碼四象能量：$rating\n');
    if (goodStars.isNotEmpty) {
      buffer.write('吉利象位：${goodStars.map((s) => s.name).join('、')}\n');
    }
    if (badStars.isNotEmpty) {
      buffer.write('需注意：${badStars.map((s) => s.name).join('、')}');
    }
    return buffer.toString();
  }

  BaziMatchResult _analyzeBaziMatch(FiveElementResult fiveElement, BaziChart? bazi) {
    if (bazi == null) {
      return BaziMatchResult(
        compatibilityScore: 70,
        compatibilityLevel: '待補充八字信息以獲得完整分析',
        fiveElementMatch: '無法確定，需提供生辰八字',
        suitableElements: ['木', '火', '土', '金', '水'],
        avoidElements: [],
        recommendations: ['建議完善生辰八字信息以獲得精準分析'],
        lifeGuidance: '數字能量僅供參考，命運掌握在自己手中',
      );
    }

    final score = fiveElement.totalScore;
    final level = _getCompatibilityLevel(score);
    final userNeedElement = _inferUserNeedFromBazi(bazi);
    final isMatch = fiveElement.mainElement == userNeedElement;

    return BaziMatchResult(
      compatibilityScore: score,
      compatibilityLevel: level,
      fiveElementMatch: isMatch ? '完美匹配' : '基本匹配',
      suitableElements: [userNeedElement.name],
      avoidElements: _getOppositeElements(userNeedElement),
      recommendations: _generateRecommendations(fiveElement, userNeedElement, isMatch),
      lifeGuidance: _generateLifeGuidance(fiveElement, bazi),
    );
  }

  String _getCompatibilityLevel(int score) {
    if (score >= 90) return '極度契合';
    if (score >= 80) return '非常契合';
    if (score >= 70) return '較為契合';
    if (score >= 50) return '一般';
    return '需謹慎使用';
  }

  List<String> _getOppositeElements(NumberFiveElement element) {
    switch (element) {
      case NumberFiveElement.wood:
        return ['金'];
      case NumberFiveElement.fire:
        return ['水'];
      case NumberFiveElement.earth:
        return ['木'];
      case NumberFiveElement.metal:
        return ['火'];
      case NumberFiveElement.water:
        return ['土'];
    }
  }

  List<String> _generateRecommendations(
    FiveElementResult fiveElement,
    NumberFiveElement needElement,
    bool isMatch,
  ) {
    final recommendations = <String>[];
    
    if (isMatch) {
      recommendations.add('此號碼五行能有效補益您的命局');
      recommendations.add('建議長期使用此號碼');
    } else {
      recommendations.add('此號碼五行與您命局需求略有差異');
      recommendations.add('建議選擇五行屬${needElement.name}的數字組合');
    }

    if (fiveElement.auspiciousCombinations.isNotEmpty) {
      recommendations.add('吉祥數位組合：${fiveElement.auspiciousCombinations.join("、")}');
    }

    if (fiveElement.inauspiciousCombinations.isNotEmpty) {
      recommendations.add('需避開的數位組合：${fiveElement.inauspiciousCombinations.join("、")}');
    }

    return recommendations;
  }

  String _generateLifeGuidance(FiveElementResult fiveElement, BaziChart bazi) {
    final element = fiveElement.mainElement;
    switch (element) {
      case NumberFiveElement.wood:
        return '木性數字助您事業發展、思維敏捷，建議從事文化、教育、創意相關行業';
      case NumberFiveElement.fire:
        return '火性數字助您名聲遠揚，建議從事銷售、演說、網紅相關行業';
      case NumberFiveElement.earth:
        return '土性數字助您積累財富，建議從事建築、農業、傳統行業';
      case NumberFiveElement.metal:
        return '金性數字助您果斷堅強，建議從事金融、法律、管理相關行業';
      case NumberFiveElement.water:
        return '水性數字助您智慧聰明，建議從事技術、貿易、物流相關行業';
    }
  }

  String generateSimpleReport(NumberEnergyAnalysis analysis) {
    final buffer = StringBuffer();
    buffer.writeln('═══ 數字能量分析報告 ═══');
    buffer.writeln('');
    buffer.writeln('【號碼】${analysis.number}');
    buffer.writeln('');
    buffer.writeln('【五行分析】');
    buffer.writeln('主五行：${analysis.fiveElementResult.mainElement.name}');
    buffer.writeln('輔五行：${analysis.fiveElementResult.supportElement.name}');
    buffer.writeln(analysis.fiveElementResult.briefAnalysis);
    buffer.writeln('');
    buffer.writeln('【八星能量】');
    buffer.writeln('星象評級：${analysis.eightStarResult.overallRating}');
    for (final star in analysis.eightStarResult.stars) {
      buffer.writeln('• ${star.name}：${star.description}');
    }
    buffer.writeln('');
    buffer.writeln('【命格匹配】');
    buffer.writeln('契合度：${analysis.baziMatch.compatibilityScore}分');
    buffer.writeln('匹配等級：${analysis.baziMatch.compatibilityLevel}');
    buffer.writeln('五行匹配：${analysis.baziMatch.fiveElementMatch}');
    buffer.writeln('');
    buffer.writeln('【使用建議】');
    for (final rec in analysis.baziMatch.recommendations) {
      buffer.writeln('• $rec');
    }
    buffer.writeln('');
    buffer.writeln('【命理指引】');
    buffer.writeln(analysis.baziMatch.lifeGuidance);
    buffer.writeln('');
    buffer.writeln('─────────────────────────');
    buffer.writeln('AI測算僅供參考');
    buffer.writeln('如有疑問請諮詢專業師傅');
    return buffer.toString();
  }

  String generatePremiumReport(NumberEnergyAnalysis analysis) {
    final simpleReport = generateSimpleReport(analysis);
    final buffer = StringBuffer(simpleReport);
    
    buffer.writeln('');
    buffer.writeln('═══════════════════════════════');
    buffer.writeln('【深度完整分析】');
    buffer.writeln('═══════════════════════════════');
    buffer.writeln('');
    buffer.writeln('【五行深度解析】');
    buffer.writeln(analysis.fiveElementResult.mainElement.description);
    buffer.writeln('');
    buffer.writeln('各數位五行歸屬：');
    for (final entry in analysis.fiveElementResult.numberElements.entries) {
      buffer.writeln('  第${entry.key}位：${entry.value.name}');
    }
    buffer.writeln('');
    buffer.writeln('吉利數位組合分析：');
    for (final combo in analysis.fiveElementResult.auspiciousCombinations) {
      buffer.writeln('  $combo - 旺財');
    }
    buffer.writeln('');
    buffer.writeln('需避開數位組合：');
    for (final combo in analysis.fiveElementResult.inauspiciousCombinations) {
      buffer.writeln('  $combo - 損耗');
    }
    buffer.writeln('');
    buffer.writeln('【八星深度解析】');
    for (final star in analysis.eightStarResult.stars) {
      buffer.writeln('${star.name}象位：${star.description}');
      buffer.writeln('  吉利指數：${star.isAuspicious ? "★★★★★" : "★★"}');
    }
    buffer.writeln('');
    buffer.writeln('【命格深度匹配】');
    buffer.writeln(analysis.baziMatch.detailedAnalysis ?? '');
    buffer.writeln('');
    buffer.writeln('適宜五行：${analysis.baziMatch.suitableElements.join("、")}');
    buffer.writeln('需避五行：${analysis.baziMatch.avoidElements.join("、")}');
    buffer.writeln('');
    buffer.writeln('【古籍依據】');
    buffer.writeln('《易經》：「天數五，地數五，五位相得而各有合」');
    buffer.writeln('《河圖》：「天一生水，地六成之；地二生火，天七成之...」');
    buffer.writeln('');
    buffer.writeln('本報告基於傳統數字能量學說，結合現代生活實際應用');
    buffer.writeln('');
    buffer.writeln('完整報告售價：80元/次');
    buffer.writeln('如需一對一專業解讀，請預約平台師傅');
    
    return buffer.toString();
  }
}
