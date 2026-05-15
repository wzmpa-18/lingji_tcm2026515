class NumberEnergyAnalysis {
  final String id;
  final String number;
  final NumberType numberType;
  final String userId;
  final DateTime analyzedAt;
  final FiveElementResult fiveElementResult;
  final EightStarResult eightStarResult;
  final BaziMatchResult baziMatch;
  final bool isPremium;
  final String? fullReportUrl;

  const NumberEnergyAnalysis({
    required this.id,
    required this.number,
    required this.numberType,
    required this.userId,
    required this.analyzedAt,
    required this.fiveElementResult,
    required this.eightStarResult,
    required this.baziMatch,
    this.isPremium = false,
    this.fullReportUrl,
  });
}

enum NumberType {
  phone,
  carPlate,
}

enum NumberFiveElement {
  wood,
  fire,
  earth,
  metal,
  water,
}

enum EightStarType {
  tianYi,
  shengQi,
  tianRen,
  fuWei,
  zhiKe,
  xueXing,
  wuGua,
  huMen,
}

enum NumberMagneticField {
  shengCi,
  tianYi,
  shengQi,
  fuWei,
  huanYing,
  tianRen,
  jueSong,
  huMen,
  xueXing,
  wuGua,
  lianMeng,
  xieSha,
  xiePo,
  xueWei,
}

extension NumberFiveElementExtension on NumberFiveElement {
  String get name {
    switch (this) {
      case NumberFiveElement.wood:
        return '木';
      case NumberFiveElement.fire:
        return '火';
      case NumberFiveElement.earth:
        return '土';
      case NumberFiveElement.metal:
        return '金';
      case NumberFiveElement.water:
        return '水';
    }
  }

  String get description {
    switch (this) {
      case NumberFiveElement.wood:
        return '木代表生長、條達、東方青色，對應數字3、4';
      case NumberFiveElement.fire:
        return '火代表炎熱、向上、南方赤色，對應數字9';
      case NumberFiveElement.earth:
        return '土代表生化、承載、中央黃色，對應數字5、0';
      case NumberFiveElement.metal:
        return '金代表肅殺、收斂、西方白色，對應數字6、7';
      case NumberFiveElement.water:
        return '水代表滋潤、下行、北方黑色，對應數字1';
    }
  }

  String get auspicious {
    switch (this) {
      case NumberFiveElement.wood:
        return '木氣旺者：事業發展、思維敏捷、財運亨通';
      case NumberFiveElement.fire:
        return '火氣旺者：名聲遠揚、社交活躍、領導能力強';
      case NumberFiveElement.earth:
        return '土氣旺者：信用為本、踏實穩重、積累財富';
      case NumberFiveElement.metal:
        return '金氣旺者：果斷堅強、義氣豪爽、財運丰厚';
      case NumberFiveElement.water:
        return '水氣旺者：智慧聰明、適應力強、理財能力佳';
    }
  }

  String get inauspicious {
    switch (this) {
      case NumberFiveElement.wood:
        return '木氣過旺：固執己見、競爭激烈、脾胃受傷';
      case NumberFiveElement.fire:
        return '火氣過旺：脾氣暴躁、財來財去、心血管問題';
      case NumberFiveElement.earth:
        return '土氣過旺：思慮過重、固執遲緩、消化系統問題';
      case NumberFiveElement.metal:
        return '金氣過旺：過於剛硬、肺部呼吸系統問題';
      case NumberFiveElement.water:
        return '水氣過旺：膽小怕事、腎泌尿系統問題';
    }
  }
}

extension EightStarTypeExtension on EightStarType {
  String get name {
    switch (this) {
      case EightStarType.tianYi:
        return '天醫';
      case EightStarType.shengQi:
        return '生氣';
      case EightStarType.tianRen:
        return '天人';
      case EightStarType.fuWei:
        return '伏位';
      case EightStarType.zhiKe:
        return '制克';
      case EightStarType.xueXing:
        return '血光';
      case EightStarType.wuGua:
        return '五鬼';
      case EightStarType.huMen:
        return '戶門';
    }
  }

  String get description {
    switch (this) {
      case EightStarType.tianYi:
        return '天醫財星，財運、事業、健康各方面都能得到助力';
      case EightStarType.shengQi:
        return '生氣勃勃，活力充沛，利於事業發展和創新';
      case EightStarType.tianRen:
        return '天人合一，人際關係和諧，貴人相助';
      case EightStarType.fuWei:
        return '伏位守成，穩定保守，不易有太大波動';
      case EightStarType.zhiKe:
        return '制克壓力，事業發展受阻，需謹慎行事';
      case EightStarType.xueXing:
        return '血光之災，意外風險增加，謹防受傷';
      case EightStarType.wuGua:
        return '五鬼小人，暗中算計，破財損耗，需防範小人';
      case EightStarType.huMen:
        return '戶門耗財，開支增大，理財需謹慎';
    }
  }

  bool get isAuspicious {
    return this == EightStarType.tianYi ||
        this == EightStarType.shengQi ||
        this == EightStarType.tianRen ||
        this == EightStarType.fuWei;
  }
}

extension NumberMagneticFieldExtension on NumberMagneticField {
  String get name {
    switch (this) {
      case NumberMagneticField.shengCi:
        return '生氣';
      case NumberMagneticField.tianYi:
        return '天醫';
      case NumberMagneticField.shengQi:
        return '延年';
      case NumberMagneticField.fuWei:
        return '伏位';
      case NumberMagneticField.huanYing:
        return '絕命';
      case NumberMagneticField.tianRen:
        return '天人';
      case NumberMagneticField.jueSong:
        return '絕命';
      case NumberMagneticField.huMen:
        return '禍害';
      case NumberMagneticField.xueXing:
        return '六煞';
      case NumberMagneticField.wuGua:
        return '五鬼';
      case NumberMagneticField.lianMeng:
        return '遍盡';
      case NumberMagneticField.xieSha:
        return '洩煞';
      case NumberMagneticField.xiePo:
        return '洩破';
      case NumberMagneticField.xueWei:
        return '血位';
    }
  }

  String get description {
    switch (this) {
      case NumberMagneticField.shengCi:
        return '生氣勃勃，充滿活力，利於事業開拓、財運增長';
      case NumberMagneticField.tianYi:
        return '天醫吉星，財運亨通，健康、事業、感情全面助力';
      case NumberMagneticField.shengQi:
        return '延年長壽，健康穩定，利於長期發展';
      case NumberMagneticField.fuWei:
        return '伏位守成，保守穩定，不易有大變動';
      case NumberMagneticField.huanYing:
        return '凶星，投資理財需謹慎，破財損耗';
      case NumberMagneticField.tianRen:
        return '天人合一，人際和諧，貴人多助';
      case NumberMagneticField.jueSong:
        return '凶星，事業受阻，情感糾葛，健康受損';
      case NumberMagneticField.huMen:
        return '小人是非，口舌官非，理財需防範';
      case NumberMagneticField.xueXing:
        return '桃花煞，情感波動，健康需注意';
      case NumberMagneticField.wuGua:
        return '小人作祟，暗中破財，需防範小人';
      case NumberMagneticField.lianMeng:
        return '旺財之星，利於合作投資';
      case NumberMagneticField.xieSha:
        return '泄氣之星，能量損耗，需補氣';
      case NumberMagneticField.xiePo:
        return '破耗之星，財產損失，健康受損';
      case NumberMagneticField.xueWei:
        return '血光之星，意外血光之災，慎防受傷';
    }
  }

  bool get isAuspicious {
    return this == NumberMagneticField.shengCi ||
        this == NumberMagneticField.tianYi ||
        this == NumberMagneticField.shengQi ||
        this == NumberMagneticField.fuWei ||
        this == NumberMagneticField.tianRen ||
        this == NumberMagneticField.lianMeng;
  }
}

class FiveElementResult {
  final NumberFiveElement mainElement;
  final NumberFiveElement supportElement;
  final List<int> numbers;
  final Map<int, NumberFiveElement> numberElements;
  final int totalScore;
  final String briefAnalysis;
  final String? detailedAnalysis;
  final List<String> auspiciousCombinations;
  final List<String> inauspiciousCombinations;

  const FiveElementResult({
    required this.mainElement,
    required this.supportElement,
    required this.numbers,
    required this.numberElements,
    required this.totalScore,
    required this.briefAnalysis,
    this.detailedAnalysis,
    required this.auspiciousCombinations,
    required this.inauspiciousCombinations,
  });
}

class EightStarResult {
  final List<EightStarType> stars;
  final int auspiciousStarCount;
  final int neutralStarCount;
  final int inauspiciousStarCount;
  final String overallRating;
  final String briefAnalysis;
  final String? detailedAnalysis;
  final Map<EightStarType, List<int>> starPositions;

  const EightStarResult({
    required this.stars,
    required this.auspiciousStarCount,
    required this.neutralStarCount,
    required this.inauspiciousStarCount,
    required this.overallRating,
    required this.briefAnalysis,
    this.detailedAnalysis,
    required this.starPositions,
  });
}

class BaziMatchResult {
  final int compatibilityScore;
  final String compatibilityLevel;
  final String fiveElementMatch;
  final String? detailedAnalysis;
  final List<String> suitableElements;
  final List<String> avoidElements;
  final List<String> recommendations;
  final String lifeGuidance;

  const BaziMatchResult({
    required this.compatibilityScore,
    required this.compatibilityLevel,
    required this.fiveElementMatch,
    this.detailedAnalysis,
    required this.suitableElements,
    required this.avoidElements,
    required this.recommendations,
    required this.lifeGuidance,
  });
}

class NumberEnergyCollection {
  static const Map<int, NumberFiveElement> numberToElement = {
    1: NumberFiveElement.water,
    2: NumberFiveElement.earth,
    3: NumberFiveElement.wood,
    4: NumberFiveElement.wood,
    5: NumberFiveElement.earth,
    6: NumberFiveElement.metal,
    7: NumberFiveElement.metal,
    8: NumberFiveElement.earth,
    9: NumberFiveElement.fire,
    0: NumberFiveElement.earth,
  };

  static const Map<String, EightStarType> twoDigitToStar = {
    '13': EightStarType.tianYi,
    '31': EightStarType.tianYi,
    '68': EightStarType.shengQi,
    '86': EightStarType.shengQi,
    '49': EightStarType.tianRen,
    '94': EightStarType.tianRen,
    '27': EightStarType.fuWei,
    '72': EightStarType.fuWei,
    '76': EightStarType.zhiKe,
    '67': EightStarType.zhiKe,
    '21': EightStarType.xueXing,
    '12': EightStarType.xueXing,
    '18': EightStarType.wuGua,
    '81': EightStarType.wuGua,
    '57': EightStarType.huMen,
    '75': EightStarType.huMen,
  };

  static const Map<int, NumberMagneticField> magneticFieldMap = {
    14: NumberMagneticField.tianYi,
    41: NumberMagneticField.tianYi,
    19: NumberMagneticField.tianYi,
    91: NumberMagneticField.tianYi,
    67: NumberMagneticField.shengCi,
    76: NumberMagneticField.shengCi,
    28: NumberMagneticField.shengCi,
    82: NumberMagneticField.shengCi,
    73: NumberMagneticField.shengQi,
    37: NumberMagneticField.shengQi,
    89: NumberMagneticField.shengQi,
    98: NumberMagneticField.shengQi,
    11: NumberMagneticField.fuWei,
    22: NumberMagneticField.fuWei,
    33: NumberMagneticField.fuWei,
    44: NumberMagneticField.fuWei,
    55: NumberMagneticField.fuWei,
    66: NumberMagneticField.fuWei,
    77: NumberMagneticField.fuWei,
    88: NumberMagneticField.fuWei,
    99: NumberMagneticField.fuWei,
    69: NumberMagneticField.huanYing,
    96: NumberMagneticField.huanYing,
    12: NumberMagneticField.jueSong,
    21: NumberMagneticField.jueSong,
    47: NumberMagneticField.jueSong,
    74: NumberMagneticField.jueSong,
    58: NumberMagneticField.jueSong,
    85: NumberMagneticField.jueSong,
    26: NumberMagneticField.jueSong,
    62: NumberMagneticField.jueSong,
    39: NumberMagneticField.xieSha,
    93: NumberMagneticField.xieSha,
    17: NumberMagneticField.xiePo,
    71: NumberMagneticField.xiePo,
    23: NumberMagneticField.wuGua,
    32: NumberMagneticField.wuGua,
    68: NumberMagneticField.wuGua,
    86: NumberMagneticField.wuGua,
    14: NumberMagneticField.xueXing,
    41: NumberMagneticField.xueXing,
    25: NumberMagneticField.xueXing,
    52: NumberMagneticField.xueXing,
    36: NumberMagneticField.xueWei,
    63: NumberMagneticField.xueWei,
    78: NumberMagneticField.xueWei,
    87: NumberMagneticField.xueWei,
  };

  static NumberFiveElement calculateMainElement(List<int> numbers) {
    final elementCounts = <NumberFiveElement, int>{};
    for (final num in numbers) {
      final element = numberToElement[num % 10] ?? NumberFiveElement.earth;
      elementCounts[element] = (elementCounts[element] ?? 0) + 1;
    }
    return elementCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  static Map<int, NumberFiveElement> analyzeEachNumber(List<int> numbers) {
    final result = <int, NumberFiveElement>{};
    for (final num in numbers) {
      result[num] = numberToElement[num % 10] ?? NumberFiveElement.earth;
    }
    return result;
  }

  static int calculateFiveElementScore(NumberFiveElement numberElement, NumberFiveElement? userNeedElement) {
    if (userNeedElement == null) return 50;
    if (numberElement == userNeedElement) return 100;
    final interaction = _getWuXingInteraction(numberElement, userNeedElement);
    switch (interaction) {
      case WuXingRelation.wealth:
        return 85;
      case WuXingRelation.official:
        return 75;
      case WuXingRelation.same:
        return 70;
      case WuXingRelation.peer:
        return 50;
      case WuXingRelation. harm:
        return 30;
    }
  }

  static WuXingRelation _getWuXingInteraction(NumberFiveElement a, NumberFiveElement b) {
    if (a == b) return WuXingRelation.same;
    if ((a == NumberFiveElement.wood && b == NumberFiveElement.fire) ||
        (a == NumberFiveElement.fire && b == NumberFiveElement.earth) ||
        (a == NumberFiveElement.earth && b == NumberFiveElement.metal) ||
        (a == NumberFiveElement.metal && b == NumberFiveElement.water) ||
        (a == NumberFiveElement.water && b == NumberFiveElement.wood)) {
      return WuXingRelation.wealth;
    }
    if ((a == NumberFiveElement.wood && b == NumberFiveElement.earth) ||
        (a == NumberFiveElement.fire && b == NumberFiveElement.metal) ||
        (a == NumberFiveElement.earth && b == NumberFiveElement.water) ||
        (a == NumberFiveElement.metal && b == NumberFiveElement.wood) ||
        (a == NumberFiveElement.water && b == NumberFiveElement.fire)) {
      return WuXingRelation.official;
    }
    if ((a == NumberFiveElement.wood && b == NumberFiveElement.water) ||
        (a == NumberFiveElement.fire && b == NumberFiveElement.wood) ||
        (a == NumberFiveElement.earth && b == NumberFiveElement.fire) ||
        (a == NumberFiveElement.metal && b == NumberFiveElement.earth) ||
        (a == NumberFiveElement.water && b == NumberFiveElement.metal)) {
      return WuXingRelation.peer;
    }
    return WuXingRelation. harm;
  }

  static List<EightStarType> extractEightStars(String number) {
    final stars = <EightStarType>[];
    final cleanNumber = number.replaceAll(RegExp(r'[^0-9]'), '');
    for (int i = 0; i < cleanNumber.length - 1; i++) {
      final pair = cleanNumber.substring(i, i + 2);
      if (twoDigitToStar.containsKey(pair)) {
        stars.add(twoDigitToStar[pair]!);
      }
    }
    while (stars.length < 4) {
      stars.add(EightStarType.fuWei);
    }
    return stars.take(4).toList();
  }

  static String rateOverall(List<EightStarType> stars) {
    final auspiciousCount = stars.where((s) => s.isAuspicious).length;
    if (auspiciousCount >= 3) return '大吉';
    if (auspiciousCount == 2) return '吉';
    if (auspiciousCount == 1) return '平';
    return '凶';
  }
}

enum WuXingRelation {
  wealth,
  official,
  same,
  peer,
  harm,
}
