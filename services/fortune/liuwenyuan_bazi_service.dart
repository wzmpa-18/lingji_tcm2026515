import '../models/fortune/bazi_chart.dart';

class BaziHePanResult {
  final String id;
  final DateTime analyzedAt;
  final BaziChart maleChart;
  final BaziChart femaleChart;
  final OverallCompatibility compatibility;
  final ElementCompatibility elementCompatibility;
  final TianyuanCompatibility tianyuanCompatibility;
  final DizhiCompatibility dizhiCompatibility;
  final MarriageAnalysis marriageAnalysis;
  final CareerAnalysis careerAnalysis;
  final YearlyPrediction yearlyPrediction;
  final String? advice;
  final bool isPremium;

  const BaziHePanResult({
    required this.id,
    required this.analyzedAt,
    required this.maleChart,
    required this.femaleChart,
    required this.compatibility,
    required this.elementCompatibility,
    required this.tianyuanCompatibility,
    required this.dizhiCompatibility,
    required this.marriageAnalysis,
    required this.careerAnalysis,
    required this.yearlyPrediction,
    this.advice,
    this.isPremium = false,
  });
}

class OverallCompatibility {
  final int score;
  final String level;
  final String summary;
  final List<String> strengths;
  final List<String> challenges;
  final String classicalReference;

  const OverallCompatibility({
    required this.score,
    required this.level,
    required this.summary,
    required this.strengths,
    required this.challenges,
    required this.classicalReference,
  });
}

class ElementCompatibility {
  final String maleElement;
  final String femaleElement;
  final int score;
  final String analysis;
  final List<String> suggestions;

  const ElementCompatibility({
    required this.maleElement,
    required this.femaleElement,
    required this.score,
    required this.analysis,
    required this.suggestions,
  });
}

class TianyuanCompatibility {
  final String maleTian;
  final String femaleTian;
  final int score;
  final String analysis;
  final String? favorableCombinations;

  const TianyuanCompatibility({
    required this.maleTian,
    required this.femaleTian,
    required this.score,
    required this.analysis,
    this.favorableCombinations,
  });
}

class DizhiCompatibility {
  final String maleZhi;
  final String femaleZhi;
  final String relation;
  final int score;
  final String analysis;

  const DizhiCompatibility({
    required this.maleZhi,
    required this.femaleZhi,
    required this.relation,
    required this.score,
    required this.analysis,
  });
}

class MarriageAnalysis {
  final String marriageAge;
  final String marriageQuality;
  final List<String> warnings;
  final List<String> suggestions;
  final String? marriageTiming;

  const MarriageAnalysis({
    required this.marriageAge,
    required this.marriageQuality,
    required this.warnings,
    required this.suggestions,
    this.marriageTiming,
  });
}

class CareerAnalysis {
  final String maleCareer;
  final String femaleCareer;
  final List<String> compatibleCareers;
  final String? conflictAnalysis;

  const CareerAnalysis({
    required this.maleCareer,
    required this.femaleCareer,
    required this.compatibleCareers,
    this.conflictAnalysis,
  });
}

class YearlyPrediction {
  final Map<String, String> yearlyFortune;
  final String bestYear;
  final String challengingYear;

  const YearlyPrediction({
    required this.yearlyFortune,
    required this.bestYear,
    required this.challengingYear,
  });
}

class LiuWenyuanBaziService {
  static final LiuWenyuanBaziService _instance = LiuWenyuanBaziService._internal();
  factory LiuWenyuanBaziService() => _instance;
  LiuWenyuanBaziService._internal();

  static const String classicalSource = '劉文元《八字命理學》';

  BaziHePanResult analyzeCompatibility({
    required BaziChart maleChart,
    required BaziChart femaleChart,
  }) {
    final compatibility = _analyzeOverallCompatibility(maleChart, femaleChart);
    final elementComp = _analyzeElementCompatibility(maleChart, femaleChart);
    final tianyuan = _analyzeTianyuanCompatibility(maleChart, femaleChart);
    final dizhiComp = _analyzeDizhiCompatibility(maleChart, femaleChart);
    final marriage = _analyzeMarriage(maleChart, femaleChart);
    final career = _analyzeCareer(maleChart, femaleChart);
    final yearly = _generateYearlyPrediction(maleChart, femaleChart);

    return BaziHePanResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      analyzedAt: DateTime.now(),
      maleChart: maleChart,
      femaleChart: femaleChart,
      compatibility: compatibility,
      elementCompatibility: elementComp,
      tianyuanCompatibility: tianyuan,
      dizhiCompatibility: dizhiComp,
      marriageAnalysis: marriage,
      careerAnalysis: career,
      yearlyPrediction: yearly,
      advice: _generateAdvice(compatibility, elementComp),
    );
  }

  OverallCompatibility _analyzeOverallCompatibility(BaziChart male, BaziChart female) {
    int score = 50;
    final strengths = <String>[];
    final challenges = <String>[];

    final tianyuanComp = _getTianyuanScore(male.dayTiangan, female.dayTiangan);
    score += tianyuanComp ~/ 10;

    final dizhiComp = _getDizhiHarmony(male.dayDizhi, female.dayDizhi);
    score += dizhiComp ~/ 10;

    if (tianyuanComp >= 80) {
      strengths.add('天干相合，感情基礎牢固');
    }

    if (dizhiComp >= 75) {
      strengths.add('地支三合/六合，婚姻穩定');
    }

    if (score < 40) {
      challenges.add('需注意溝通方式');
    }

    String level;
    if (score >= 85) level = '上等婚';
    else if (score >= 70) level = '中等婚';
    else if (score >= 50) level = '下等婚';
    else level = '需謹慎';

    return OverallCompatibility(
      score: score.clamp(0, 100),
      level: level,
      summary: '根據劉文元合盤理論，此配對為「$level」',
      strengths: strengths,
      challenges: challenges,
      classicalReference: '$classicalSource：「合婚之道，在於天合、地合、人合」',
    );
  }

  ElementCompatibility _analyzeElementCompatibility(BaziChart male, BaziChart female) {
    final maleElement = _getDayElement(male.dayTiangan);
    final femaleElement = _getDayElement(female.dayTiangan);

    int score = 50;
    String analysis;

    if (_isBeneficialCombination(maleElement, femaleElement)) {
      score = 85;
      analysis = '雙方五行互補，能夠相互促進';
    } else if (_isSameElement(maleElement, femaleElement)) {
      score = 70;
      analysis = '雙方五行相同，相處和諧但需注意各自發展';
    } else {
      score = 55;
      analysis = '雙方五行略有差異，需要相互理解';
    }

    return ElementCompatibility(
      maleElement: maleElement,
      femaleElement: femaleElement,
      score: score,
      analysis: analysis,
      suggestions: _getElementSuggestions(maleElement, femaleElement),
    );
  }

  TianyuanCompatibility _analyzeTianyuanCompatibility(BaziChart male, BaziChart female) {
    final maleTiangan = male.dayTiangan;
    final femaleTiangan = female.dayTiangan;

    int score = _getTianyuanScore(maleTiangan, femaleTiangan);
    String analysis;
    String? favorable;

    if (_isTianHe(maleTiangan, femaleTiangan)) {
      analysis = '天干合化，感情專一，婚姻穩定';
      favorable = '甲己化土：利於財運\n乙庚化金：利於義氣';
    } else if (_isTianChong(maleTiangan, femaleTiangan)) {
      analysis = '天干相沖，初期有波動但可化解';
      favorable = null;
    } else if (_isTianSheng(maleTiangan, femaleTiangan)) {
      analysis = '天干相生，一方助益另一方';
      favorable = '需注意付出平衡';
    } else {
      analysis = '天干關係平淡，相處需要時間磨合';
      favorable = null;
    }

    return TianyuanCompatibility(
      maleTian: maleTiangan.first.name,
      femaleTian: femaleTiangan.first.name,
      score: score,
      analysis: analysis,
      favorableCombinations: favorable,
    );
  }

  DizhiCompatibility _analyzeDizhiCompatibility(BaziChart male, BaziChart female) {
    final maleZhi = male.dayDizhi;
    final femaleZhi = female.dayDizhi;

    int score = _getDizhiHarmony(maleZhi.first, femaleZhi.first);
    String relation;
    String analysis;

    if (_isLiuHe(maleZhi.first, femaleZhi.first)) {
      relation = '六合';
      score = 90;
      analysis = '地支六合，婚姻美滿，子孫興旺';
    } else if (_isSanHe(maleZhi.first, femaleZhi.first)) {
      relation = '三合';
      score = 85;
      analysis = '地支三合，感情深厚，共同發展';
    } else if (_isXingChong(maleZhi.first, femaleZhi.first)) {
      relation = '刑沖';
      score = 40;
      analysis = '地支刑沖，需注意矛盾摩擦';
    } else if (_isHai(maleZhi.first, femaleZhi.first)) {
      relation = '相害';
      score = 45;
      analysis = '地支相害，相處有小摩擦';
    } else {
      relation = '平穩';
      score = 60;
      analysis = '地支關係一般，相處平淡';
    }

    return DizhiCompatibility(
      maleZhi: maleZhi.first.name,
      femaleZhi: femaleZhi.first.name,
      relation: relation,
      score: score,
      analysis: analysis,
    );
  }

  MarriageAnalysis _analyzeMarriage(BaziChart male, BaziChart female) {
    final warnings = <String>[];
    final suggestions = <String>[];

    if (_hasPoleStar(male) || _hasPoleStar(female)) {
      warnings.add('命中帶孤辰/寡宿，需注意感情表達');
      suggestions.add('主動表達情感，避免冷戰');
    }

    if (_has桃花(male) && !_has桃花(female)) {
      warnings.add('一方桃花旺盛，需建立信任');
      suggestions.add('坦誠溝通，互相尊重');
    }

    if (_hasXianchi(male) || _hasXianchi(female)) {
      suggestions.add('命中有鹹池桃花，感情豐富');
    }

    return MarriageAnalysis(
      marriageAge: _predictMarriageAge(male, female),
      marriageQuality: _predictMarriageQuality(male, female),
      warnings: warnings,
      suggestions: suggestions,
      marriageTiming: _getMarriageTiming(male, female),
    );
  }

  CareerAnalysis _analyzeCareer(BaziChart male, BaziChart female) {
    final maleCareer = _getCareerFromBazi(male);
    final femaleCareer = _getCareerFromBazi(female);

    return CareerAnalysis(
      maleCareer: maleCareer,
      femaleCareer: femaleCareer,
      compatibleCareers: _getCompatibleCareers(male, female),
      conflictAnalysis: _getCareerConflict(male, female),
    );
  }

  YearlyPrediction _generateYearlyPrediction(BaziChart male, BaziChart female) {
    return YearlyPrediction(
      yearlyFortune: {
        '第一年': '感情磨合期',
        '第三年': '關係穩定期',
        '第五年': '可能出現考驗',
        '第七年': '情感升溫期',
        '第十年': '婚姻鞏固期',
      },
      bestYear: '第三年',
      challengingYear: '第五年',
    );
  }

  String _generateAdvice(OverallCompatibility comp, ElementCompatibility elem) {
    final advice = StringBuffer();
    advice.writeln('【合盤建議】');
    advice.writeln('1. 珍惜彼此，共同成長');
    advice.writeln('2. 包容差異，理解對方');
    advice.writeln('3. 有效溝通，避免冷戰');
    advice.writeln('4. 共同規劃未來');
    advice.writeln('');
    advice.writeln('命運掌握在自己手中，經營比命格更重要');
    return advice.toString();
  }

  int _getTianyuanScore(List<Tiangan> male, List<Tiangan> female) {
    int score = 60;

    if (_isTianHe(male, female)) return 90;
    if (_isTianSheng(male, female)) return 75;
    if (_isTianKe(male, female)) return 50;
    if (_isTianChong(male, female)) return 40;

    return score;
  }

  bool _isTianHe(List<Tiangan> male, List<Tiangan> female) {
    for (final m in male) {
      for (final f in female) {
        if ((m == Tiangan.jia && f == Tiangan.ji) ||
            (m == Tiangan.yi && f == Tiangan.geng) ||
            (m == Tiangan.bing && f == Tiangan.xin) ||
            (m == Tiangan.ding && f == Tiangan.ren) ||
            (m == Tiangan.wu && f == Tiangan.gui)) {
          return true;
        }
      }
    }
    return false;
  }

  bool _isTianSheng(List<Tiangan> male, List<Tiangan> female) {
    for (final m in male) {
      for (final f in female) {
        if ((m == Tiangan.jia && f == Tiangan.bing) ||
            (m == Tiangan.yi && f == Tiangan.ding) ||
            (m == Tiangan.bing && f == Tiangan.wu) ||
            (m == Tiangan.ding && f == Tiangan.ji) ||
            (m == Tiangan.wu && f == Tiangan.geng) ||
            (m == Tiangan.ji && f == Tiangan.xin) ||
            (m == Tiangan.geng && f == Tiangan.ren) ||
            (m == Tiangan.xin && f == Tiangan.gui) ||
            (m == Tiangan.ren && f == Tiangan.jia) ||
            (m == Tiangan.gui && f == Tiangan.yi)) {
          return true;
        }
      }
    }
    return false;
  }

  bool _isTianKe(List<Tiangan> male, List<Tiangan> female) {
    for (final m in male) {
      for (final f in female) {
        if ((m == Tiangan.jia && f == Tiangan.geng) ||
            (m == Tiangan.yi && f == Tiangan.xin) ||
            (m == Tiangan.bing && f == Tiangan.ren) ||
            (m == Tiangan.ding && f == Tiangan.gui) ||
            (m == Tiangan.wu && f == Tiangan.jia) ||
            (m == Tiangan.ji && f == Tiangan.yi) ||
            (m == Tiangan.geng && f == Tiangan.bing) ||
            (m == Tiangan.xin && f == Tiangan.ding) ||
            (m == Tiangan.ren && f == Tiangan.wu) ||
            (m == Tiangan.gui && f == Tiangan.ji)) {
          return true;
        }
      }
    }
    return false;
  }

  bool _isTianChong(List<Tiangan> male, List<Tiangan> female) {
    for (final m in male) {
      for (final f in female) {
        if ((m == Tiangan.jia && f == Tiangan.yi) ||
            (m == Tiangan.bing && f == Tiangan.ding) ||
            (m == Tiangan.wu && f == Tiangan.ji) ||
            (m == Tiangan.geng && f == Tiangan.xin) ||
            (m == Tiangan.ren && f == Tiangan.gui)) {
          return true;
        }
      }
    }
    return false;
  }

  String _getDayElement(Tiangan tiangan) {
    switch (tiangan) {
      case Tiangan.jia:
      case Tiangan.yi:
        return '木';
      case Tiangan.bing:
      case Tiangan.ding:
        return '火';
      case Tiangan.wu:
      case Tiangan.ji:
        return '土';
      case Tiangan.geng:
      case Tiangan.xin:
        return '金';
      case Tiangan.ren:
      case Tiangan.gui:
        return '水';
    }
  }

  bool _isBeneficialCombination(String e1, String e2) {
    final combos = {
      {'木', '火'}, {'火', '土'}, {'土', '金'}, {'金', '水'}, {'水', '木'},
      {'木', '水'}, {'火', '木'}, {'土', '火'}, {'金', '土'}, {'水', '金'},
    };
    return combos.contains({e1, e2});
  }

  bool _isSameElement(String e1, String e2) => e1 == e2;

  List<String> _getElementSuggestions(String e1, String e2) {
    final suggestions = <String>[];
    if (_isBeneficialCombination(e1, e2)) {
      suggestions.add('五行互補，相處融洽');
    } else if (_isSameElement(e1, e2)) {
      suggestions.add('五行相同，有共同語言');
    } else {
      suggestions.add('五行略有差異，需要相互理解');
    }
    return suggestions;
  }

  int _getDizhiHarmony(Dizhi male, Dizhi female) {
    if (_isLiuHe(male, female)) return 90;
    if (_isSanHe(male, female)) return 85;
    if (_isSanChong(male, female)) return 35;
    if (_isXingChong(male, female)) return 40;
    if (_isHai(male, female)) return 45;
    return 60;
  }

  bool _isLiuHe(Dizhi a, Dizhi b) {
    return (a == Dizhi.zi && b == Dizhi.chou) ||
        (a == Dizhi.mao && b == Dizhi.xu) ||
        (a == Dizhi.chen && b == Dizhi.you) ||
        (a == Dizhi.si && b == Dizhi.shen) ||
        (a == Dizhi.wu && b == Dizhi.wei) ||
        (a == Dizhi.shen && b == Dizhi.yin);
  }

  bool _isSanHe(Dizhi a, Dizhi b) {
    final sanhe = {
      {Dizhi.chen, Dizhi.xi, Dizhi.gu},
      {Dizhi.shen, Dizhi.yu, Dizhi.cun},
      {Dizhi.hai, Dizhi.mao, Dizhi.xi},
      {Dizhi.yin, Dizhi.wu, Dizhi.xu},
    };
    for (final set in sanhe) {
      if (set.contains(a) && set.contains(b)) return true;
    }
    return false;
  }

  bool _isSanChong(Dizhi a, Dizhi b) {
    return (a == Dizhi.yin && b == Dizhi.shen) ||
        (a == Dizhi.mao && b == Dizhi.you) ||
        (a == Dizhi.chen && b == Dizhi.xu) ||
        (a == Dizhi.si && b == Dizhi.hai) ||
        (a == Dizhi.wu && b == Dizhi.zi) ||
        (a == Dizhi.wei && b == Dizhi.chou);
  }

  bool _isXingChong(Dizhi a, Dizhi b) {
    return (a == Dizhi.yin && b == Dizhi.chen) ||
        (a == Dizhi.chen && b == Dizhi.yin) ||
        (a == Dizhi.mao && b == Dizhi.xu) ||
        (a == Dizhi.si && b == Dizhi.shen) ||
        (a == Dizhi.wu && b == Dizhi.wei) ||
        (a == Dizhi.wei && b == Dizhi.wu) ||
        (a == Dizhi.shen && b == Dizhi.si) ||
        (a == Dizhi.xu && b == Dizhi.mao) ||
        (a == Dizhi.zi && b == Dizhi.wu) ||
        (a == Dizhi.chou && b == Dizhi.wei);
  }

  bool _isHai(Dizhi a, Dizhi b) {
    return (a == Dizhi.zi && b == Dizhi.chou) ||
        (a == Dizhi.chou && b == Dizhi.xu) ||
        (a == Dizhi.yin && b == Dizhi.shen) ||
        (a == Dizhi.mao && b == Dizhi.you) ||
        (a == Dizhi.chen && b == Dizhi.hai) ||
        (a == Dizhi.si && b == Dizhi.chen) ||
        (a == Dizhi.wu && b == Dizhi.shen) ||
        (a == Dizhi.wei && b == Dizhi.xu) ||
        (a == Dizhi.shen && b == Dizhi.wei) ||
        (a == Dizhi.you && b == Dizhi.mao) ||
        (a == Dizhi.xu && b == Dizhi.chou) ||
        (a == Dizhi.hai && b == Dizhi.xi);
  }

  bool _hasPoleStar(BaziChart chart) {
    return chart.hourPillar.dizhi.contains(Dizhi.xi) ||
        chart.hourPillar.dizhi.contains(Dizhi.hai);
  }

  bool _has桃花(BaziChart chart) {
    return chart.hourPillar.dizhi.contains(Dizhi.mao) ||
        chart.hourPillar.dizhi.contains(Dizhi.wei) ||
        chart.hourPillar.dizhi.contains(Dizhi.shen) ||
        chart.hourPillar.dizhi.contains(Dizhi.xi);
  }

  bool _hasXianchi(BaziChart chart) {
    return chart.hourPillar.dizhi.contains(Dizhi.mao) ||
        chart.hourPillar.dizhi.contains(Dizhi.wei);
  }

  String _predictMarriageAge(BaziChart male, BaziChart female) {
    return '28-32歲';
  }

  String _predictMarriageQuality(BaziChart male, BaziChart female) {
    return '中等偏上';
  }

  String? _getMarriageTiming(BaziChart male, BaziChart female) {
    return '注意鼠年、兔年、狗年';
  }

  String _getCareerFromBazi(BaziChart chart) {
    return '根據八字分析，事業發展方向';
  }

  List<String> _getCompatibleCareers(BaziChart male, BaziChart female) {
    return ['教育', '文化', '穩定型工作'];
  }

  String? _getCareerConflict(BaziChart male, BaziChart female) {
    return null;
  }

  String generateSimpleReport(BaziHePanResult result) {
    final buffer = StringBuffer();
    buffer.writeln('═══ 八字合盤分析報告 ═══');
    buffer.writeln('');
    buffer.writeln('【合盤結果】');
    buffer.writeln('契合度：${result.compatibility.score}分');
    buffer.writeln('匹配等級：${result.compatibility.level}');
    buffer.writeln('');
    buffer.writeln('【五行分析】');
    buffer.writeln('男方五行：${result.elementCompatibility.maleElement}');
    buffer.writeln('女方五行：${result.elementCompatibility.femaleElement}');
    buffer.writeln(result.elementCompatibility.analysis);
    buffer.writeln('');
    buffer.writeln('【天干關係】');
    buffer.writeln('${result.tianyuanCompatibility.maleTian} 配 ${result.tianyuanCompatibility.femaleTian}');
    buffer.writeln(result.tianyuanCompatibility.analysis);
    buffer.writeln('');
    buffer.writeln('【地支關係】');
    buffer.writeln('${result.dizhiCompatibility.maleZhi} 配 ${result.dizhiCompatibility.femaleZhi}');
    buffer.writeln('關係：${result.dizhiCompatibility.relation}');
    buffer.writeln(result.dizhiCompatibility.analysis);
    buffer.writeln('');
    buffer.writeln('【婚姻分析】');
    buffer.writeln('適婚年齡：${result.marriageAnalysis.marriageAge}');
    buffer.writeln('婚姻質量：${result.marriageAnalysis.marriageQuality}');
    buffer.writeln('');
    buffer.writeln('─────────────────────────');
    buffer.writeln('AI測算僅供參考');
    buffer.writeln('命運掌握在自己手中');
    return buffer.toString();
  }

  String generatePremiumReport(BaziHePanResult result) {
    final simple = generateSimpleReport(result);
    final buffer = StringBuffer(simple);
    
    buffer.writeln('');
    buffer.writeln('═══════════════════════════════');
    buffer.writeln('【深度完整分析】');
    buffer.writeln('═══════════════════════════════');
    buffer.writeln('');
    buffer.writeln('【劉文元理論要點】');
    buffer.writeln('劉文元先生為現代命理學大家');
    buffer.writeln('其合盤學說融合古法與現代實踐');
    buffer.writeln('強調「天合、地合、人合」三原則');
    buffer.writeln('');
    buffer.writeln('【天干合化詳解】');
    buffer.writeln('甲己合土：利於誠信、財運');
    buffer.writeln('乙庚合金：利於義氣、合作');
    buffer.writeln('丙辛合水：利於智謀、變通');
    buffer.writeln('丁壬合木：利於仁慈、情感');
    buffer.writeln('戊癸合火：利於禮儀、熱情');
    buffer.writeln('');
    buffer.writeln('【地支六合三合】');
    buffer.writeln('子丑合土：穩定、踏實');
    buffer.writeln('寅亥合木：生長、發展');
    buffer.writeln('卯戌合火：熱情、激情');
    buffer.writeln('辰酉合金：收斂、整理');
    buffer.writeln('巳申合水：智謀、流動');
    buffer.writeln('午未合火/土：禮儀、承載');
    buffer.writeln('');
    buffer.writeln('【逐年運勢預測】');
    for (final entry in result.yearlyPrediction.yearlyFortune.entries) {
      buffer.writeln('${entry.key}：${entry.value}');
    }
    buffer.writeln('');
    buffer.writeln('最佳年份：${result.yearlyPrediction.bestYear}');
    buffer.writeln('需注意年份：${result.yearlyPrediction.challengingYear}');
    buffer.writeln('');
    buffer.writeln('【合盤建議】');
    buffer.writeln(result.advice ?? '');
    buffer.writeln('');
    buffer.writeln('完整報告售價：80元/次');
    buffer.writeln('如需一對一專業解讀，請預約平台師傅');
    
    return buffer.toString();
  }
}
