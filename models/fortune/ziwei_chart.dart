import 'dart:math';

enum Xingyao {
  piyao, biyao, jiyao, qiyue, luyao, quanye, fengge, honglu, longbao, tianfu
}

enum Sihuafang {
  piyaofang, biyaofang, jiyaofang, qiyuefang
}

enum Miaowei {
  dezheng, xuande, xuxu, tiande, feilian, liuchen, xianchi, youzheng, jianke, xiankui, yangren, fengzhu
}

class ZiweiChart {
  final String id;
  final DateTime birthTime;
  final String gender;
  final int nianzhu;
  final int yuezhu;
  final int rizhu;
  final int shizhu;

  final Map<String, int> mainStars;
  final Map<String, int> auxiliaryStars;
  final Map<String, List<String>> starPositions;
  final Map<String, String> fourTransformations;
  final Map<String, Miaowei> miaoweiStatus;
  final String palaceOfLife;
  final List<String> twelvePalaces;
  final String liunian;
  final List<String> fuxing;

  final String sizhengRule;
  final String baiyangRule;
  final String tianmaRule;
  final String wenchangRule;
  final DateTime createdAt;

  ZiweiChart({
    required this.id,
    required this.birthTime,
    required this.gender,
    required this.nianzhu,
    required this.yuezhu,
    required this.rizhu,
    required this.shizhu,
    required this.mainStars,
    required this.auxiliaryStars,
    required this.starPositions,
    required this.fourTransformations,
    required this.miaoweiStatus,
    required this.palaceOfLife,
    required this.twelvePalaces,
    required this.liunian,
    required this.fuxing,
    required this.sizhengRule,
    required this.baiyangRule,
    required this.tianmaRule,
    required this.wenchangRule,
    required this.createdAt,
  });

  static const Map<int, String> tianganNames = {
    0: '甲', 1: '乙', 2: '丙', 3: '丁', 4: '戊',
    5: '己', 6: '庚', 7: '辛', 8: '壬', 9: '癸',
  };

  static const Map<int, String> dizhiNames = {
    0: '子', 1: '丑', 2: '寅', 3: '卯', 4: '辰',
    5: '巳', 6: '午', 7: '未', 8: '申', 9: '酉',
    10: '戌', 11: '亥',
  };

  String get nianzhuName => tianganNames[nianzhu]!;
  String get yuezhuName => tianganNames[yuezhu]!;
  String get rizhuName => tianganNames[rizhu]!;
  String get shizhuName => tianganNames[shizhu]!;

  static const Map<String, String> mainStarNames = {
    'ziwei': '紫微', 'tianji': '天機', 'taiyang': '太陽', 'wuqu': '武曲',
    'tiangang': '天同', 'lianke': '廉貞', 'tianfu': '天府', 'tianxiang': '天相',
    'zhenke': '真機', 'yingkong': '映空', 'zuofu': '左輔', 'youbi': '右弼',
    'tiancai': '天財', 'tianku': '天庫', 'tianxiong': '天雄', 'tianci': '天雌',
  };

  static const Map<String, String> fourTransformNames = {
    'hua_ke': '化科', 'hua_ji': '化忌', 'hua_quan': '化權', 'hua_lu': '化祿',
  };

  static const Map<String, String> miaoweiNames = {
    'dezheng': '得地', 'xuande': '玄德', 'xuxu': '旭旭',
    'tiande': '天得', 'feilian': '飛廉', 'liuchen': '六晨',
    'xianchi': '賢癡', 'youzheng': '有正', 'jianke': '見可',
    'xiankui': '陷亏', 'yangren': '羊刃', 'fengzhu': '風燭',
  };

  String getStarDisplay(String starName) {
    return mainStarNames[starName] ?? starName;
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'birth_time': birthTime.toIso8601String(),
    'gender': gender,
    'nian_zhu': nianzhu,
    'yue_zhu': yuezhu,
    'ri_zhu': rizhu,
    'shi_zhu': shizhu,
    'main_stars': mainStars,
    'auxiliary_stars': auxiliaryStars,
    'star_positions': starPositions,
    'four_transformations': fourTransformations,
    'miaowei_status': miaoweiStatus.map((k, v) => MapEntry(k, v.index)),
    'palace_of_life': palaceOfLife,
    'twelve_palaces': twelvePalaces,
  };
}

class ZiweiCalculationService {
  static final ZiweiCalculationService _instance = ZiweiCalculationService._internal();
  factory ZiweiCalculationService() => _instance;
  ZiweiCalculationService._internal();

  String _sizhengRule = 'wenmo';
  String _baiyangRule = 'wenmo';
  String _tianmaRule = 'standard';

  void setCalculationRules({
    String? sizhengRule,
    String? baiyangRule,
    String? tianmaRule,
  }) {
    if (sizhengRule != null) _sizhengRule = sizhengRule;
    if (baiyangRule != null) _baiyangRule = baiyangRule;
    if (tianmaRule != null) _tianmaRule = tianmaRule;
  }

  ZiweiChart calculateZiwei({
    required DateTime birthTime,
    required String gender,
    String sizhengRule = 'wenmo',
    String baiyangRule = 'wenmo',
    String tianmaRule = 'standard',
    String wenchangRule = 'standard',
  }) {
    _sizhengRule = sizhengRule;
    _baiyangRule = baiyangRule;
    _tianmaRule = tianmaRule;

    final lunar = _convertToLunar(birthTime);
    final year = lunar['year'] as int;
    final month = lunar['month'] as int;
    final day = lunar['day'] as int;
    final hour = birthTime.hour;

    final nianzhu = _getNianzhu(year);
    final yuezhu = _getYuezhu(year, month);
    final rizhu = _getRizhu(day);
    final shizhu = _getShizhu(hour);

    final mainStars = _calculateMainStars(year, month, day, nianzhu);
    final auxiliaryStars = _calculateAuxiliaryStars(year, month, day, nianzhu);
    final starPositions = _arrangeStarPositions(mainStars, auxiliaryStars);
    final fourTransformations = _calculateFourTransformations(year, month, day, nianzhu, yuezhu);
    final miaoweiStatus = _calculateMiaoweiStatus(starPositions, fourTransformations);

    final palaceOfLife = _getPalaceOfLife(shizhu, gender);
    final twelvePalaces = _generateTwelvePalaces(palaceOfLife);

    final liunian = _calculateLiunian(year, gender);
    final fuxing = _calculateFuxing(year, gender);

    return ZiweiChart(
      id: 'ZW_${DateTime.now().millisecondsSinceEpoch}',
      birthTime: birthTime,
      gender: gender,
      nianzhu: nianzhu,
      yuezhu: yuezhu,
      rizhu: rizhu,
      shizhu: shizhu,
      mainStars: mainStars,
      auxiliaryStars: auxiliaryStars,
      starPositions: starPositions,
      fourTransformations: fourTransformations,
      miaoweiStatus: miaoweiStatus,
      palaceOfLife: palaceOfLife,
      twelvePalaces: twelvePalaces,
      liunian: liunian,
      fuxing: fuxing,
      sizhengRule: sizhengRule,
      baiyangRule: baiyangRule,
      tianmaRule: tianmaRule,
      wenchangRule: wenchangRule,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> _convertToLunar(DateTime date) {
    return {
      'year': date.year,
      'month': date.month,
      'day': date.day,
    };
  }

  int _getNianzhu(int year) {
    final baseYear = 1984;
    final baseIndex = 0;
    final diff = year - baseYear;
    return (baseIndex + diff) % 10;
  }

  int _getYuezhu(int year, int month) {
    final yearIndex = (year - 1984) % 10;
    final monthIndex = (month + 1) % 12;
    return (yearIndex + monthIndex + 10) % 10;
  }

  int _getRizhu(int day) {
    return (day - 1) % 10;
  }

  int _getShizhu(int hour) {
    final shiIndex = (hour ~/ 2) % 12;
    return shiIndex;
  }

  Map<String, int> _calculateMainStars(int year, int month, int day, int nianzhu) {
    final stars = <String, int>{};

    final ziweiPos = _getZiweiPosition(year, month, nianzhu);
    stars['ziwei'] = ziweiPos;

    final tianjiPos = (ziweiPos + 1) % 12;
    stars['tianji'] = tianjiPos;

    final shichen = _getShichenPosition(day);
    stars['taiyang'] = shichen;

    final wuquPos = (shichen + 2) % 12;
    stars['wuqu'] = wuquPos;

    final tiangangPos = (shichen + 3) % 12;
    stars['tiangang'] = tiangangPos;

    final liankePos = (shichen + 4) % 12;
    stars['lianke'] = liankePos;

    final tianfuPos = _getTianfuPosition(year, month, nianzhu);
    stars['tianfu'] = tianfuPos;

    return stars;
  }

  int _getZiweiPosition(int year, int month, int nianzhu) {
    final baseMonth = 11;
    final baseYear = 1984;
    final yearDiff = year - baseYear;

    int basePos;
    switch (nianzhu) {
      case 0:
      case 5:
        basePos = 2;
        break;
      case 1:
      case 6:
        basePos = 8;
        break;
      case 2:
      case 7:
        basePos = 5;
        break;
      case 3:
      case 8:
        basePos = 11;
        break;
      case 4:
      case 9:
        basePos = 2;
        break;
      default:
        basePos = 2;
    }

    final monthOffset = (month - baseMonth + 12) % 12;
    return (basePos + monthOffset) % 12;
  }

  int _getTianfuPosition(int year, int month, int nianzhu) {
    final ziweiPos = _getZiweiPosition(year, month, nianzhu);
    return (ziweiPos + 6) % 12;
  }

  int _getShichenPosition(int day) {
    final baseDay = 1;
    final basePos = 0;
    final diff = day - baseDay;
    return (basePos + diff) % 12;
  }

  Map<String, int> _calculateAuxiliaryStars(int year, int month, int day, int nianzhu) {
    final stars = <String, int>{};

    final tianmaPos = _getTianmaPosition(nianzhu);
    stars['tianma'] = tianmaPos;

    final wenchangPos = _getWenchangPosition(month, nianzhu);
    stars['wenchang'] = wenchangPos;

    final luPos = _getLuPosition(year, month);
    stars['lu'] = luPos;

    final quanPos = _getQuanPosition(year, month);
    stars['quan'] = quanPos;

    final jiPos = _getJiPosition(year, month);
    stars['ji'] = jiPos;

    final kePos = _getKePosition(year, month);
    stars['ke'] = kePos;

    return stars;
  }

  int _getTianmaPosition(int nianzhu) {
    final tianmaMap = {
      0: 4, 1: 9, 2: 6, 3: 10, 4: 2,
      5: 4, 6: 9, 7: 6, 8: 10, 9: 2,
    };
    return tianmaMap[nianzhu] ?? 4;
  }

  int _getWenchangPosition(int month, int nianzhu) {
    final wenchangMap = {
      0: {1: 3, 2: 4, 3: 5, 4: 6, 5: 7, 6: 8, 7: 9, 8: 10, 9: 11, 10: 0, 11: 1, 12: 2},
      1: {1: 4, 2: 5, 3: 6, 4: 7, 5: 8, 6: 9, 7: 10, 8: 11, 9: 0, 10: 1, 11: 2, 12: 3},
      2: {1: 5, 2: 6, 3: 7, 4: 8, 5: 9, 6: 10, 7: 11, 8: 0, 9: 1, 10: 2, 11: 3, 12: 4},
      3: {1: 6, 2: 7, 3: 8, 4: 9, 5: 10, 6: 11, 7: 0, 8: 1, 9: 2, 10: 3, 11: 4, 12: 5},
      4: {1: 7, 2: 8, 3: 9, 4: 10, 5: 11, 6: 0, 7: 1, 8: 2, 9: 3, 10: 4, 11: 5, 12: 6},
      5: {1: 3, 2: 4, 3: 5, 4: 6, 5: 7, 6: 8, 7: 9, 8: 10, 9: 11, 10: 0, 11: 1, 12: 2},
      6: {1: 4, 2: 5, 3: 6, 4: 7, 5: 8, 6: 9, 7: 10, 8: 11, 9: 0, 10: 1, 11: 2, 12: 3},
      7: {1: 5, 2: 6, 3: 7, 4: 8, 5: 9, 6: 10, 7: 11, 8: 0, 9: 1, 10: 2, 11: 3, 12: 4},
      8: {1: 6, 2: 7, 3: 8, 4: 9, 5: 10, 6: 11, 7: 0, 8: 1, 9: 2, 10: 3, 11: 4, 12: 5},
      9: {1: 7, 2: 8, 3: 9, 4: 10, 5: 11, 6: 0, 7: 1, 8: 2, 9: 3, 10: 4, 11: 5, 12: 6},
    };
    return wenchangMap[nianzhu]?[month] ?? 3;
  }

  int _getLuPosition(int year, int month) {
    final yearIndex = (year - 1984) % 10;
    final monthIndex = (month - 1) % 12;
    return (yearIndex + monthIndex) % 12;
  }

  int _getQuanPosition(int year, int month) {
    final yearIndex = (year - 1984) % 10;
    final monthIndex = (month - 1) % 12;
    return (yearIndex + monthIndex + 4) % 12;
  }

  int _getJiPosition(int year, int month) {
    final yearIndex = (year - 1984) % 10;
    final monthIndex = (month - 1) % 12;
    return (yearIndex + monthIndex + 8) % 12;
  }

  int _getKePosition(int year, int month) {
    final yearIndex = (year - 1984) % 10;
    final monthIndex = (month - 1) % 12;
    return (yearIndex + monthIndex + 2) % 12;
  }

  Map<String, List<String>> _arrangeStarPositions(
    Map<String, int> mainStars,
    Map<String, int> auxiliaryStars,
  ) {
    final positions = <String, List<String>>{};

    for (int i = 0; i < 12; i++) {
      positions[i.toString()] = [];
    }

    mainStars.forEach((star, pos) {
      positions[pos.toString()]!.add(star);
    });

    auxiliaryStars.forEach((star, pos) {
      positions[pos.toString()]!.add(star);
    });

    return positions;
  }

  Map<String, String> _calculateFourTransformations(
    int year,
    int month,
    int day,
    int nianzhu,
    int yuezhu,
  ) {
    final transformations = <String, String>{};

    final tianganIndex = (nianzhu + month - 1) % 10;

    final luTransform = _getLuTransform(tianganIndex);
    if (luTransform != null) {
      transformations['hua_lu'] = luTransform;
    }

    final quanTransform = _getQuanTransform(tianganIndex);
    if (quanTransform != null) {
      transformations['hua_quan'] = quanTransform;
    }

    final jiTransform = _getJiTransform(tianganIndex);
    if (jiTransform != null) {
      transformations['hua_ji'] = jiTransform;
    }

    final keTransform = _getKeTransform(tianganIndex);
    if (keTransform != null) {
      transformations['hua_ke'] = keTransform;
    }

    return transformations;
  }

  String? _getLuTransform(int tianganIndex) {
    final luTransforms = {
      0: '甲', 1: '乙', 2: '丙', 3: '丁', 4: '戊',
      5: '己', 6: '庚', 7: '辛', 8: '壬', 9: '癸',
    };
    return luTransforms[tianganIndex];
  }

  String? _getQuanTransform(int tianganIndex) {
    final quanTransforms = {
      0: '甲', 1: '乙', 2: '丙', 3: '丁', 4: '戊',
      5: '己', 6: '庚', 7: '辛', 8: '壬', 9: '癸',
    };
    return quanTransforms[tianganIndex];
  }

  String? _getJiTransform(int tianganIndex) {
    final jiTransforms = {
      0: '甲', 1: '乙', 2: '丙', 3: '丁', 4: '戊',
      5: '己', 6: '庚', 7: '辛', 8: '壬', 9: '癸',
    };
    return jiTransforms[tianganIndex];
  }

  String? _getKeTransform(int tianganIndex) {
    final keTransforms = {
      0: '甲', 1: '乙', 2: '丙', 3: '丁', 4: '戊',
      5: '己', 6: '庚', 7: '辛', 8: '壬', 9: '癸',
    };
    return keTransforms[tianganIndex];
  }

  Map<String, Miaowei> _calculateMiaoweiStatus(
    Map<String, List<String>> starPositions,
    Map<String, String> fourTransformations,
  ) {
    final status = <String, Miaowei>{};

    starPositions.forEach((position, stars) {
      if (stars.contains('ziwei')) {
        status['ziwei'] = Miaowei.dezheng;
      }
      if (stars.contains('tianji')) {
        status['tianji'] = Miaowei.xuande;
      }
      if (stars.contains('taiyang')) {
        status['taiyang'] = Miaowei.tiande;
      }
    });

    fourTransformations.forEach((star, transform) {
      if (transform == 'hua_lu') {
        status[star] = Miaowei.dezheng;
      } else if (transform == 'hua_ji') {
        status[star] = Miaowei.xiankui;
      }
    });

    return status;
  }

  String _getPalaceOfLife(int shizhu, String gender) {
    final lifePalaceMap = gender == '男'
        ? {0: '寅', 1: '卯', 2: '辰', 3: '巳', 4: '午', 5: '未',
           6: '申', 7: '酉', 8: '戌', 9: '亥', 10: '子', 11: '丑'}
        : {0: '申', 1: '酉', 2: '戌', 3: '亥', 4: '子', 5: '丑',
           6: '寅', 7: '卯', 8: '辰', 9: '巳', 10: '午', 11: '未'};

    return lifePalaceMap[shizhu] ?? '寅';
  }

  List<String> _generateTwelvePalaces(String lifePalace) {
    final palaceOrder = [
      '命宮', '兄弟宮', '夫妻宮', '子女宮',
      '財帛宮', '疾厄宮', '遷移宮', '僕役宮',
      '官祿宮', '田宅宮', '福德宮', '父母宮',
    ];

    final lifeIndex = palaceOrder.indexOf('命宮');
    final result = <String>[];

    for (int i = 0; i < 12; i++) {
      result.add(palaceOrder[(lifeIndex + i) % 12]);
    }

    return result;
  }

  String _calculateLiunian(int year, String gender) {
    return '$_year';
  }

  List<String> _calculateFuxing(int year, int gender) {
    return ['$_year', '${year + 1}', '${year + 2}'];
  }
}
