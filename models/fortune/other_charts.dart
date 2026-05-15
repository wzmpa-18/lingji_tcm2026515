import 'dart:math';

enum QimenType { jiazi, yiji }

enum QimenMethod { zheng, fan, ren }

enum Jiuxing { tianpeng, tianyi, efang, liuren, baoshimen, xumu, jinshi, tuoluo }

class QimenChart {
  final String id;
  final DateTime birthTime;
  final String type;
  final String method;
  final int dayangan;
  final int digan;
  final List<List<String>> pan;
  final Map<String, String> men;
  final Map<String, String> xing;
  final Map<String, String> shen;
  final String kongwang;
  final String fugua;
  final String benggua;
  final String methodRule;
  final DateTime createdAt;

  QimenChart({
    required this.id,
    required this.birthTime,
    required this.type,
    required this.method,
    required this.dayangan,
    required this.digan,
    required this.pan,
    required this.men,
    required this.xing,
    required this.shen,
    required this.kongwang,
    required this.fugua,
    required this.benggua,
    required this.methodRule,
    required this.createdAt,
  });

  static const List<String> tianganNames = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
  static const List<String> dizhiNames = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

  static const List<String> baguaNames = ['乾', '坤', '震', '巽', '坎', '離', '艮', '兌'];

  static const Map<int, String> jiuGongNames = {
    0: '蓬', 1: '芮', 2: '沖', 3: '輔', 4: '禽',
    5: '心', 6: '柱', 7: '任', 8: '英', 9: '天任',
  };

  static const Map<int, String> menNames = {
    0: '休', 1: '生', 2: '傷', 3: '杜', 4: '景',
    5: '死', 6: '驚', 7: '開', 8: '休', 9: '生',
  };

  static const Map<int, String> xingNames = {
    0: '天蓬', 1: '天芮', 2: '天沖', 3: '天輔', 4: '天禽',
    5: '天心', 6: '天柱', 7: '天任', 8: '天英', 9: '天任',
  };

  String get dayanganName => tianganNames[dayangan];
  String get diganName => tianganNames[digan];

  Map<String, dynamic> toMap() => {
    'id': id,
    'birth_time': birthTime.toIso8601String(),
    'type': type,
    'method': method,
    'day_angan': dayangan,
    'di_gan': digan,
    'pan': pan,
    'men': men,
    'xing': xing,
    'shen': shen,
    'kongwang': kongwang,
    'method_rule': methodRule,
  };
}

class QimenCalculationService {
  static final QimenCalculationService _instance = QimenCalculationService._internal();
  factory QimenCalculationService() => _instance;
  QimenCalculationService._internal();

  String _method = 'zheng';
  String _kongwangRule = 'standard';

  void setMethod(String method) => _method = method;
  void setKongwangRule(String rule) => _kongwangRule = rule;

  QimenChart calculate({
    required DateTime dateTime,
    required String type,
    String method = 'zheng',
    String kongwangRule = 'standard',
  }) {
    _method = method;
    _kongwangRule = kongwangRule;

    final dayangan = _getDayangan(dateTime);
    final digan = _getDigan(dateTime);
    final pan = _generatePan(dayangan, digan, method);
    final men = _calculateMen(pan, method);
    final xing = _calculateXing(pan);
    final shen = _calculateShen(pan);
    final kongwang = _getKongwang(pan, kongwangRule);
    final fugua = _generateFugua(pan);
    final benggua = _generateBenggua(pan);

    return QimenChart(
      id: 'QM_${DateTime.now().millisecondsSinceEpoch}',
      birthTime: dateTime,
      type: type,
      method: method,
      dayangan: dayangan,
      digan: digan,
      pan: pan,
      men: men,
      xing: xing,
      shen: shen,
      kongwang: kongwang,
      fugua: fugua,
      benggua: benggua,
      methodRule: method,
      createdAt: DateTime.now(),
    );
  }

  int _getDayangan(DateTime dateTime) {
    final baseDay = 1;
    final baseIndex = 0;
    final diff = dateTime.day - baseDay;
    return (baseIndex + diff) % 10;
  }

  int _getDigan(DateTime dateTime) {
    final baseDay = 1;
    final baseIndex = 0;
    final diff = dateTime.day - baseDay;
    return (baseIndex + diff) % 10;
  }

  List<List<String>> _generatePan(int dayangan, int digan, String method) {
    final pan = List.generate(9, (_) => List.filled(9, ''));

    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        pan[i][j] = QimenChart.tianganNames[(dayangan + i + j) % 10];
      }
    }

    return pan;
  }

  Map<String, String> _calculateMen(List<List<String>> pan, String method) {
    final men = <String, String>{};
    for (int i = 0; i < 9; i++) {
      men[i.toString()] = QimenChart.menNames[(i + 1) % 10];
    }
    return men;
  }

  Map<String, String> _calculateXing(List<List<String>> pan) {
    final xing = <String, String>{};
    for (int i = 0; i < 9; i++) {
      xing[i.toString()] = QimenChart.jiuGongNames[(i + 1) % 10] ?? '';
    }
    return xing;
  }

  Map<String, String> _calculateShen(List<List<String>> pan) {
    return <String, String>{};
  }

  String _getKongwang(List<List<String>> pan, String rule) {
    return '空';
  }

  String _generateFugua(List<List<String>> pan) {
    return '乾為天';
  }

  String _generateBenggua(List<List<String>> pan) {
    return '坤為地';
  }
}

enum DaliurenType { yupei, fudou }

class DaliurenChart {
  final String id;
  final DateTime birthTime;
  final String type;
  final int riagan;
  final int rizhi;
  final List<String> liuqing;
  final Map<String, String> tianganRelation;
  final Map<String, String> dizhiRelation;
  final String shengshen;
  final String kongwang;
  final String methodRule;
  final DateTime createdAt;

  DaliurenChart({
    required this.id,
    required this.birthTime,
    required this.type,
    required this.riagan,
    required this.rizhi,
    required this.liuqing,
    required this.tianganRelation,
    required this.dizhiRelation,
    required this.shengshen,
    required this.kongwang,
    required this.methodRule,
    required this.createdAt,
  });

  String get riaganName => QimenChart.tianganNames[riagan];
  String get rizhiName => QimenChart.dizhiNames[rizhi];

  static const List<String> tianganNames = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
  static const List<String> dizhiNames = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

  static const List<String> liuqingNames = ['大安', '留连', '速喜', '赤口', '小吉', '空亡'];

  Map<String, dynamic> toMap() => {
    'id': id,
    'birth_time': birthTime.toIso8601String(),
    'type': type,
    'ri_agan': riagan,
    'ri_zhi': rizhi,
    'liuqing': liuqing,
    'kongwang': kongwang,
    'method_rule': methodRule,
  };
}

class DaliurenCalculationService {
  static final DaliurenCalculationService _instance = DaliurenCalculationService._internal();
  factory DaliurenCalculationService() => _instance;
  DaliurenCalculationService._internal();

  String _method = 'standard';

  void setMethod(String method) => _method = method;

  DaliurenChart calculate({
    required DateTime dateTime,
    required String type,
    String method = 'standard',
  }) {
    _method = method;

    final riagan = _getRiagan(dateTime);
    final rizhi = _getRizhi(dateTime);
    final liuqing = _calculateLiuqing(riagan, rizhi);
    final tianganRelation = _calculateTianganRelation(riagan);
    final dizhiRelation = _calculateDizhiRelation(rizhi);
    final shengshen = _calculateShengshen(riagan);
    final kongwang = _calculateKongwang(rizhi);

    return DaliurenChart(
      id: 'DLR_${DateTime.now().millisecondsSinceEpoch}',
      birthTime: dateTime,
      type: type,
      riagan: riagan,
      rizhi: rizhi,
      liuqing: liuqing,
      tianganRelation: tianganRelation,
      dizhiRelation: dizhiRelation,
      shengshen: shengshen,
      kongwang: kongwang,
      methodRule: method,
      createdAt: DateTime.now(),
    );
  }

  int _getRiagan(DateTime dateTime) {
    final baseDay = 1;
    final diff = dateTime.day - baseDay;
    return diff % 10;
  }

  int _getRizhi(DateTime dateTime) {
    final baseDay = 1;
    final diff = dateTime.day - baseDay;
    return diff % 12;
  }

  List<String> _calculateLiuqing(int riagan, int rizhi) {
    final index = (riagan + rizhi) % 6;
    return DaliurenChart.liuqingNames;
  }

  Map<String, String> _calculateTianganRelation(int riagan) {
    final relations = <String, String>{};
    relations['ri'] = _getTianganShishen(riagan);
    return relations;
  }

  Map<String, String> _calculateDizhiRelation(int rizhi) {
    final relations = <String, String>{};
    relations['ri'] = _getDizhiShishen(rizhi);
    return relations;
  }

  String _getTianganShishen(int tiangan) {
    final shishen = ['比', '劫', '食', '傷', '財', '才', '官', '殺', '印', '梟'];
    return shishen[tiangan % 10];
  }

  String _getDizhiShishen(int dizhi) {
    return '本氣';
  }

  String _calculateShengshen(int riagan) {
    final sheng = ['水', '木', '水', '火', '土', '火', '土', '金', '土', '金'];
    return sheng[riagan % 10];
  }

  String _calculateKongwang(int rizhi) {
    final kongwang = ['亥', '午', '申', '酉', '卯', '巳', '亥', '寅', '子', '丑', '辰', '戌'];
    return kongwang[rizhi % 12];
  }
}

class TiebanChart {
  final String id;
  final DateTime birthTime;
  final int baseNumber;
  final List<int> calculations;
  final String result;
  final String interpretation;
  final String methodRule;
  final DateTime createdAt;

  TiebanChart({
    required this.id,
    required this.birthTime,
    required this.baseNumber,
    required this.calculations,
    required this.result,
    required this.interpretation,
    required this.methodRule,
    required this.createdAt,
  });

  static const List<String> tianganNames = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
  static const List<String> dizhiNames = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

  Map<String, dynamic> toMap() => {
    'id': id,
    'birth_time': birthTime.toIso8601String(),
    'base_number': baseNumber,
    'calculations': calculations,
    'result': result,
    'method_rule': methodRule,
  };
}

class TiebanCalculationService {
  static final TiebanCalculationService _instance = TiebanCalculationService._internal();
  factory TiebanCalculationService() => _instance;
  TiebanCalculationService._internal();

  TiebanChart calculate({
    required DateTime birthTime,
    required int baseNumber,
    String methodRule = 'standard',
  }) {
    final calculations = _performCalculations(birthTime, baseNumber);
    final result = _getResult(calculations);
    final interpretation = _getInterpretation(result);

    return TiebanChart(
      id: 'TB_${DateTime.now().millisecondsSinceEpoch}',
      birthTime: birthTime,
      baseNumber: baseNumber,
      calculations: calculations,
      result: result.toString(),
      interpretation: interpretation,
      methodRule: methodRule,
      createdAt: DateTime.now(),
    );
  }

  List<int> _performCalculations(DateTime birthTime, int baseNumber) {
    return [
      birthTime.year,
      birthTime.month,
      birthTime.day,
      birthTime.hour,
      baseNumber,
    ];
  }

  int _getResult(List<int> calculations) {
    return calculations.fold(0, (sum, num) => sum + num) % 10000;
  }

  String _getInterpretation(int result) {
    return '鐵板神數結果：$result';
  }
}

class MeihuaChart {
  final String id;
  final DateTime consultTime;
  final String question;
  final int shangGua;
  final int xiaGua;
  final int dongYao;
  final String guaName;
  final String yaoDesc;
  final String interpretation;
  final String methodRule;
  final DateTime createdAt;

  MeihuaChart({
    required this.id,
    required this.consultTime,
    required this.question,
    required this.shangGua,
    required this.xiaGua,
    required this.dongYao,
    required this.guaName,
    required this.yaoDesc,
    required this.interpretation,
    required this.methodRule,
    required this.createdAt,
  });

  static const List<String> baguaNames = ['乾', '兌', '離', '震', '巽', '坎', '艮', '坤'];
  static const List<String> tianganNames = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
  static const List<String> dizhiNames = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

  Map<String, dynamic> toMap() => {
    'id': id,
    'consult_time': consultTime.toIso8601String(),
    'question': question,
    'shang_gua': shangGua,
    'xia_gua': xiaGua,
    'dong_yao': dongYao,
    'gua_name': guaName,
    'method_rule': methodRule,
  };
}

class MeihuaCalculationService {
  static final MeihuaCalculationService _instance = MeihuaCalculationService._internal();
  factory MeihuaCalculationService() => _instance;
  MeihuaCalculationService._internal();

  MeihuaChart calculate({
    required DateTime consultTime,
    required String question,
    String methodRule = 'standard',
  }) {
    final shangGua = _getShangGua(consultTime);
    final xiaGua = _getXiaGua(consultTime);
    final dongYao = _getDongYao(consultTime);
    final guaName = _getGuaxming(shangGua, xiaGua);
    final yaoDesc = _getYaoDescription(dongYao);
    final interpretation = _getInterpretation(shangGua, xiaGua, dongYao);

    return MeihuaChart(
      id: 'MH_${DateTime.now().millisecondsSinceEpoch}',
      consultTime: consultTime,
      question: question,
      shangGua: shangGua,
      xiaGua: xiaGua,
      dongYao: dongYao,
      guaName: guaName,
      yaoDesc: yaoDesc,
      interpretation: interpretation,
      methodRule: methodRule,
      createdAt: DateTime.now(),
    );
  }

  int _getShangGua(DateTime time) {
    return (time.hour % 8);
  }

  int _getXiaGua(DateTime time) {
    return (time.minute % 8);
  }

  int _getDongYao(DateTime time) {
    final second = time.second;
    if (second < 10) return 0;
    if (second < 20) return 1;
    if (second < 30) return 2;
    if (second < 40) return 3;
    if (second < 50) return 4;
    return 5;
  }

  String _getGuaxming(int shang, int xia) {
    final index = (shang * 8 + xia) % 64;
    return '${MeihuaChart.baguaNames[shang]}${MeihuaChart.baguaNames[xia]}';
  }

  String _getYaoDescription(int dongYao) {
    final yaos = ['初爻', '二爻', '三爻', '四爻', '五爻', '上爻'];
    return yaos[dongYao % 6];
  }

  String _getInterpretation(int shang, int xia, int dong) {
    return '梅花易數解讀：上卦${MeihuaChart.baguaNames[shang]}，下卦${MeihuaChart.baguaNames[xia]}，動${dong + 1}爻';
  }
}
