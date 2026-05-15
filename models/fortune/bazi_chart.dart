import 'dart:math';

enum Tiangan { jia, yi, bing, ding, wu, ji, geng, xin, ren, gui }

enum Dizhi { zi, chou, yin, mao, chen, si, wu, wei, shen, you, xu, hai }

enum Wuxing { wood, fire, earth, metal, water }

enum Shenti { taiyang, taiyin, shaoyang, shaoyin, yangming, jueyin }

class BaziChart {
  final String id;
  final DateTime birthTime;
  final Tiangan nianzhu;
  final Tiangan yuezhu;
  final Tiangan rizhu;
  final Tiangan shizhu;
  final Dizhi nianzhi;
  final Dizhi yuezhi;
  final Dizhi rizhi;
  final Dizhi shizhi;
  final int nianSheng;
  final int yueSheng;
  final int riSheng;
  final int shiSheng;
  final String dayun;
  final List<String> dais;
  final List<Tiangan> dayunNianzhu;
  final List<Dizhi> dayunNianzhi;
  final List<String> liunian;
  final List<String> fuxing;
  final String gender;
  final String ganzhiRule;
  final String kongwangRule;
  final DateTime createdAt;

  BaziChart({
    required this.id,
    required this.birthTime,
    required this.nianzhu,
    required this.yuezhu,
    required this.rizhu,
    required this.shizhu,
    required this.nianzhi,
    required this.yuezhi,
    required this.rizhi,
    required this.shizhi,
    required this.nianSheng,
    required this.yueSheng,
    required this.riSheng,
    required this.shiSheng,
    required this.dayun,
    required this.dais,
    required this.dayunNianzhu,
    required this.dayunNianzhi,
    required this.liunian,
    required this.fuxing,
    required this.gender,
    required this.ganzhiRule,
    required this.kongwangRule,
    required this.createdAt,
  });

  String get nianzhuName => tianganNames[nianzhu]!;
  String get yuezhuName => tianganNames[yuezhu]!;
  String get rizhuName => tianganNames[rizhu]!;
  String get shizhuName => tianganNames[shizhu]!;
  String get nianzhiName => dizhiNames[nianzhi]!;
  String get yuezhiName => dizhiNames[yuezhi]!;
  String get rizhiName => dizhiNames[rizhi]!;
  String get shizhiName => dizhiNames[shizhi]!;

  String get nianGanzhi => nianzhuName + nianzhiName;
  String get yueGanzhi => yuezhuName + yuezhiName;
  String get riGanzhi => rizhuName + rizhiName;
  String get shiGanzhi => shizhuName + shizhiName;

  String get nianzhiWuxing => wuxingByDizhi[nianzhi]!;
  String get yuezhiWuxing => wuxingByDizhi[yuezhi]!;
  String get rizhiWuxing => wuxingByDizhi[rizhi]!;
  String get shizhiWuxing => wuxingByDizhi[shizhi]!;

  String get riElement => wuxingByTiangan[rizhu]!;

  String get shishen => _getShishen(rizhu);

  String get dayunDisplay => '大運: $dayun';

  String _getShishen(Tiangan dayMaster) {
    final tianganIndex = dayMaster.index;
    final shishenMap = {
      0: '比', 1: '劫', 2: '食', 3: '傷', 4: '財',
      5: '才', 6: '官', 7: '殺', 8: '印', 9: '梟',
    };
    return shishenMap[tianganIndex] ?? '';
  }

  static const Map<Tiangan, String> tianganNames = {
    Tiangan.jia: '甲',
    Tiangan.yi: '乙',
    Tiangan.bing: '丙',
    Tiangan.ding: '丁',
    Tiangan.wu: '戊',
    Tiangan.ji: '己',
    Tiangan.geng: '庚',
    Tiangan.xin: '辛',
    Tiangan.ren: '壬',
    Tiangan.gui: '癸',
  };

  static const Map<Dizhi, String> dizhiNames = {
    Dizhi.zi: '子',
    Dizhi.chou: '丑',
    Dizhi.yin: '寅',
    Dizhi.mao: '卯',
    Dizhi.chen: '辰',
    Dizhi.si: '巳',
    Dizhi.wu: '午',
    Dizhi.wei: '未',
    Dizhi.shen: '申',
    Dizhi.you: '酉',
    Dizhi.xu: '戌',
    Dizhi.hai: '亥',
  };

  static const Map<Tiangan, String> wuxingByTiangan = {
    Tiangan.jia: '木', Tiangan.yi: '木',
    Tiangan.bing: '火', Tiangan.ding: '火',
    Tiangan.wu: '土', Tiangan.ji: '土',
    Tiangan.geng: '金', Tiangan.xin: '金',
    Tiangan.ren: '水', Tiangan.gui: '水',
  };

  static const Map<Dizhi, String> wuxingByDizhi = {
    Dizhi.zi: '水', Dizhi.chou: '土',
    Dizhi.yin: '木', Dizhi.mao: '木',
    Dizhi.chen: '土', Dizhi.si: '火',
    Dizhi.wu: '火', Dizhi.wei: '土',
    Dizhi.shen: '金', Dizhi.you: '金',
    Dizhi.xu: '土', Dizhi.hai: '水',
  };

  static const Map<Dizhi, String> shichenNames = {
    Dizhi.zi: '子时', Dizhi.chou: '丑时', Dizhi.yin: '寅时',
    Dizhi.mao: '卯时', Dizhi.chen: '辰时', Dizhi.si: '巳时',
    Dizhi.wu: '午时', Dizhi.wei: '未时', Dizhi.shen: '申时',
    Dizhi.you: '酉时', Dizhi.xu: '戌时', Dizhi.hai: '亥时',
  };

  static const Map<Tiangan, String> tianganYinYang = {
    Tiangan.jia: '陽', Tiangan.yi: '陰',
    Tiangan.bing: '陽', Tiangan.ding: '陰',
    Tiangan.wu: '陽', Tiangan.ji: '陰',
    Tiangan.geng: '陽', Tiangan.xin: '陰',
    Tiangan.ren: '陽', Tiangan.gui: '陰',
  };

  static const Map<Dizhi, String> dizhiYinYang = {
    Dizhi.zi: '陽', Dizhi.chou: '陰', Dizhi.yin: '陽',
    Dizhi.mao: '陰', Dizhi.chen: '陽', Dizhi.si: '陰',
    Dizhi.wu: '陽', Dizhi.wei: '陰', Dizhi.shen: '陽',
    Dizhi.you: '陰', Dizhi.xu: '陽', Dizhi.hai: '陰',
  };

  Map<String, dynamic> toMap() => {
    'id': id,
    'birth_time': birthTime.toIso8601String(),
    'nian_zhu': nianzhu.index,
    'yue_zhu': yuezhu.index,
    'ri_zhu': rizhu.index,
    'shi_zhu': shizhu.index,
    'nian_zhi': nianzhi.index,
    'yue_zhi': yuezhi.index,
    'ri_zhi': rizhi.index,
    'shi_zhi': shizhi.index,
    'nian_sheng': nianSheng,
    'yue_sheng': yueSheng,
    'ri_sheng': riSheng,
    'shi_sheng': shiSheng,
    'dayun': dayun,
    'dais': dais,
    'gender': gender,
    'ganzhi_rule': ganzhiRule,
    'kongwang_rule': kongwangRule,
  };
}

class BaziCalculationService {
  static final BaziCalculationService _instance = BaziCalculationService._internal();
  factory BaziCalculationService() => _instance;
  BaziCalculationService._internal();

  String _ganzhiRule = 'standard';
  String _kongwangRule = 'table';

  void setCalculationRules({String? ganzhiRule, String? kongwangRule}) {
    if (ganzhiRule != null) _ganzhiRule = ganzhiRule;
    if (kongwangRule != null) _kongwangRule = kongwangRule;
  }

  BaziChart calculateBazi({
    required DateTime birthTime,
    required String gender,
    String ganzhiRule = 'standard',
    String kongwangRule = 'table',
  }) {
    _ganzhiRule = ganzhiRule;
    _kongwangRule = kongwangRule;

    final lunar = _convertToLunar(birthTime);
    final year = lunar['year'] as int;
    final month = lunar['month'] as int;
    final day = lunar['day'] as int;
    final hour = birthTime.hour;

    final nianzhu = _getNianzhu(year);
    final yuezhu = _getYuezhu(year, month);
    final rizhu = _get Rizhu(day);
    final shizhu = _getShizhu(hour, nianzhu);

    final nianzhi = _getNianzhi(year, nianzhu);
    final yuezhi = _getYuezhi(month);
    final rizhi = _getDizhiFromDay(day);
    final shizhi = _getShizhi(hour);

    final nianSheng = _getSheng(nianzhu);
    final yueSheng = _getSheng(yuezhu);
    final riSheng = _getSheng(rizhu);
    final shiSheng = _getSheng(shizhu);

    final dayun = _calculateDayun(year, gender);

    final dais = _generateDais(dayun, nianSheng);
    final dayunNianzhu = _generateDayunNianzhu(dais);
    final dayunNianzhi = _generateDayunNianzhi(dais);
    final liunian = _generateLiunian(dais);
    final fuxing = _generateFuxing(dais);

    return BaziChart(
      id: 'BZI_${DateTime.now().millisecondsSinceEpoch}',
      birthTime: birthTime,
      nianzhu: nianzhu,
      yuezhu: yuezhu,
      rizhu: rizhu,
      shizhu: shizhu,
      nianzhi: nianzhi,
      yuezhi: yuezhi,
      rizhi: rizhi,
      shizhi: shizhi,
      nianSheng: nianSheng,
      yueSheng: yueSheng,
      riSheng: riSheng,
      shiSheng: shiSheng,
      dayun: dayun,
      dais: dais,
      dayunNianzhu: dayunNianzhu,
      dayunNianzhi: dayunNianzhi,
      liunian: liunian,
      fuxing: fuxing,
      gender: gender,
      ganzhiRule: ganzhiRule,
      kongwangRule: kongwangRule,
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

  Tiangan _getNianzhu(int year) {
    final baseYear = 1984;
    final baseIndex = Tiangan.jia.index;
    final diff = year - baseYear;
    final index = (baseIndex + diff) % 10;
    return Tiangan.values[index];
  }

  Dizhi _getNianzhi(int year, Tiangan nianzhu) {
    final baseYear = 1984;
    final baseIndex = Dizhi.zi.index;
    final diff = year - baseYear;
    final index = (baseIndex + diff) % 12;
    return Dizhi.values[index];
  }

  Tiangan _getYuezhu(int year, int month) {
    final baseMonth = 2;
    final baseNianzhu = Tiangan.yi.index;
    final yearDiff = year - 1984;
    final yearOffset = yearDiff % 10;
    final monthOffset = (month - baseMonth + 12) % 12;
    final index = (baseNianzhu + yearOffset + monthOffset) % 10;
    return Tiangan.values[index];
  }

  Dizhi _getYuezhi(int month) {
    final baseMonth = 2;
    final baseIndex = Dizhi.yin.index;
    final offset = (month - baseMonth + 12) % 12;
    return Dizhi.values[(baseIndex + offset) % 12];
  }

  Tiangan _getRizhu(int day) {
    final baseDay = 1;
    final baseIndex = Tiangan.jia.index;
    final diff = day - baseDay;
    final index = (baseIndex + diff) % 10;
    return Tiangan.values[index];
  }

  Dizhi _getDizhiFromDay(int day) {
    final baseDay = 1;
    final baseIndex = Dizhi.zi.index;
    final diff = day - baseDay;
    return Dizhi.values[(baseIndex + diff) % 12];
  }

  Tiangan _getShizhu(int hour, Tiangan rizhu) {
    final shiIndex = (hour ~/ 2) % 12;
    final riIndex = rizhu.index;

    if (hour % 2 == 1) {
      final index = (riIndex + shiIndex + 1) % 10;
      return Tiangan.values[index];
    } else {
      final index = (riIndex + shiIndex) % 10;
      return Tiangan.values[index];
    }
  }

  Dizhi _getShizhi(int hour) {
    final index = (hour ~/ 2) % 12;
    return Dizhi.values[index];
  }

  int _getSheng(Tiangan ganzhu) {
    final element = BaziChart.wuxingByTiangan[ganzhu]!;
    final shengRelations = {'木': '水', '火': '木', '土': '火', '金': '土', '水': '金'};
    return _getElementIndex(shengRelations[element]!);
  }

  int _getElementIndex(String element) {
    final elements = ['木', '火', '土', '金', '水'];
    return elements.indexOf(element);
  }

  String _calculateDayun(int year, String gender) {
    final startYear = gender == '男' ? (year ~/ 10) * 10 + 1 : (year ~/ 10) * 10 + 6;
    final dayunStart = Tiangan.values[(startYear - 1984 + Tiangan.jia.index) % 10];
    return BaziChart.tianganNames[dayunStart]!;
  }

  List<String> _generateDais(String dayun, int nianSheng) {
    return List.generate(10, (i) {
      final index = (dayun.indexOf(dayun[0]) + i) % 10;
      return BaziChart.tianganNames[Tiangan.values[index]]!;
    });
  }

  List<Tiangan> _generateDayunNianzhu(List<String> dais) {
    return dais.map((d) {
      final index = BaziChart.tianganNames.values.toList().indexOf(d);
      return Tiangan.values[index];
    }).toList();
  }

  List<Dizhi> _generateDayunNianzhi(List<String> dais) {
    return List.generate(10, (i) => Dizhi.values[i % 12]);
  }

  List<String> _generateLiunian(List<String> dais) {
    return dais.sublist(0, 5);
  }

  List<String> _generateFuxing(List<String> dais) {
    return dais.sublist(0, 3);
  }

  String getKongwang(Dizhi dizhi, String rule) {
    switch (rule) {
      case 'table':
        return _getKongwangByTable(dizhi);
      case 'yan':
        return _getKongwangByYan(dizhi);
      case 'yi':
        return _getKongwangByYi(dizhi);
      default:
        return _getKongwangByTable(dizhi);
    }
  }

  String _getKongwangByTable(Dizhi dizhi) {
    final tableKongwang = {
      Dizhi.zi: '亥', Dizhi.chou: '午',
      Dizhi.yin: '申', Dizhi.mao: '酉',
      Dizhi.chen: '卯', Dizhi.si: '子',
      Dizhi.wu: '亥', Dizhi.wei: '午',
      Dizhi.shen: '寅', Dizhi.you: '卯',
      Dizhi.xu: '辰', Dizhi.hai: '巳',
    };
    return tableKongwang[dizhi] ?? '';
  }

  String _getKongwangByYan(Dizhi dizhi) {
    final yanKongwang = {
      Dizhi.zi: '亥', Dizhi.chou: '寅',
      Dizhi.yin: '酉', Dizhi.mao: '申',
      Dizhi.chen: '巳', Dizhi.si: '午',
      Dizhi.wu: '亥', Dizhi.wei: '寅',
      Dizhi.shen: '酉', Dizhi.you: '申',
      Dizhi.xu: '巳', Dizhi.hai: '午',
    };
    return yanKongwang[dizhi] ?? '';
  }

  String _getKongwangByYi(Dizhi dizhi) {
    final yiKongwang = {
      Dizhi.zi: '戌', Dizhi.chou: '亥',
      Dizhi.yin: '子', Dizhi.mao: '丑',
      Dizhi.chen: '寅', Dizhi.si: '卯',
      Dizhi.wu: '辰', Dizhi.wei: '巳',
      Dizhi.shen: '午', Dizhi.you: '未',
      Dizhi.xu: '申', Dizhi.hai: '酉',
    };
    return yiKongwang[dizhi] ?? '';
  }
}
