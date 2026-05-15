import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/fortune/bazi_chart.dart';

class QimenResult {
  final String ninePalace;
  final String yi;
  final String men;
  final String shen;
  final String kai;
  final String sheng;
  final String jing;
  final String si;
  final String du;
  final String xiu;
  final Map<String, String> palaceAnalysis;
  final String overallFortune;
  final String? careerAdvice;
  final String? relationshipAdvice;
  final String? healthAdvice;

  const QimenResult({
    required this.ninePalace,
    required this.yi,
    required this.men,
    required this.shen,
    required this.kai,
    required this.sheng,
    required this.jing,
    required this.si,
    required this.du,
    required this.xiu,
    required this.palaceAnalysis,
    required this.overallFortune,
    this.careerAdvice,
    this.relationshipAdvice,
    this.healthAdvice,
  });
}

class MeihuaResult {
  final String mainGua;
  final String mainGuaName;
  final String mainGuaMeaning;
  final String changedGua;
  final String changedGuaName;
  final String changedGuaMeaning;
  final List<String> interpretation;
  final String fiveElementAnalysis;
  final String? prediction;

  const MeihuaResult({
    required this.mainGua,
    required this.mainGuaName,
    required this.mainGuaMeaning,
    required this.changedGua,
    required this.changedGuaName,
    required this.changedGuaMeaning,
    required this.interpretation,
    required this.fiveElementAnalysis,
    this.prediction,
  });
}

class NameAnalysis {
  final String name;
  final int tianganScore;
  final int dizhiScore;
  final int wuxingScore;
  final int yinyangScore;
  final int zonggeScore;
  final int totalScore;
  final String tianganAnalysis;
  final String dizhiAnalysis;
  final String wuxingAnalysis;
  final String overallAnalysis;
  final List<String> advantages;
  final List<String> disadvantages;
  final String? fiveElementAdvice;

  const NameAnalysis({
    required this.name,
    required this.tianganScore,
    required this.dizhiScore,
    required this.wuxingScore,
    required this.yinyangScore,
    required this.zonggeScore,
    required this.totalScore,
    required this.tianganAnalysis,
    required this.dizhiAnalysis,
    required this.wuxingAnalysis,
    required this.overallAnalysis,
    required this.advantages,
    required this.disadvantages,
    this.fiveElementAdvice,
  });
}

class CharacterDivinationResult {
  final String character;
  final String strokeOrder;
  final int totalStrokes;
  final String radical;
  final String radicalMeaning;
  final String fiveElement;
  final String meaning;
  final String? classicalMeaning;
  final String? interpretation;
  final List<String> predictions;
  final String? advice;

  const CharacterDivinationResult({
    required this.character,
    required this.strokeOrder,
    required this.totalStrokes,
    required this.radical,
    required this.radicalMeaning,
    required this.fiveElement,
    required this.meaning,
    this.classicalMeaning,
    this.interpretation,
    required this.predictions,
    this.advice,
  });
}

class QimenMeihuaService {
  static final QimenMeihuaService _instance = QimenMeihuaService._internal();
  factory QimenMeihuaService() => _instance;
  QimenMeihuaService._internal();

  static const List<String> baGua = ['乾', '兌', '離', '震', '巽', '坎', '艮', '坤'];
  static const List<String> tianPan = ['戊', '己', '庚', '辛', '壬', '癸', '丁', '丙', '乙'];
  static const List<String> diPan = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

  QimenResult castQimen({String? question, DateTime? dateTime}) {
    final dt = dateTime ?? DateTime.now();
    final dayun = _getDayun(dt);
    final month = _getMonth(dt);
    final day = _getDay(dt);
    
    return QimenResult(
      ninePalace: _getNinePalace(dayun),
      yi: _getYiPalace(dayun, month),
      men: _getMenPalace(dayun),
      shen: _getShenPalace(dayun),
      kai: _getKaiPalace(dayun),
      sheng: _getShengPalace(dayun),
      jing: _getJingPalace(dayun),
      si: _getSiPalace(dayun),
      du: _getDuPalace(dayun),
      xiu: _getXiuPalace(dayun),
      palaceAnalysis: _analyzePalaces(dayun),
      overallFortune: _getOverallFortune(dayun),
      careerAdvice: _getCareerAdvice(dayun),
      relationshipAdvice: _getRelationshipAdvice(dayun),
      healthAdvice: _getHealthAdvice(dayun),
    );
  }

  MeihuaResult castMeihua(String question) {
    final now = DateTime.now();
    final random = Random(now.millisecondsSinceEpoch);
    
    final shangGuaIndex = random.nextInt(8);
    final xiaGuaIndex = random.nextInt(8);
    final mainGua = '${baGua[shangGuaIndex]}${baGua[xiaGuaIndex]}';
    final mainGuaName = _getGuaName(shangGuaIndex * 8 + xiaGuaIndex);
    
    final changedGuaIndex = random.nextInt(8);
    final changedGua = '${baGua[shangGuaIndex]}${baGua[changedGuaIndex]}';
    final changedGuaName = _getGuaName(shangGuaIndex * 8 + changedGuaIndex);

    return MeihuaResult(
      mainGua: mainGua,
      mainGuaName: mainGuaName,
      mainGuaMeaning: _getGuaMeaning(shangGuaIndex * 8 + xiaGuaIndex),
      changedGua: changedGua,
      changedGuaName: changedGuaName,
      changedGuaMeaning: _getGuaMeaning(shangGuaIndex * 8 + changedGuaIndex),
      interpretation: _interpretQuestion(question, mainGua, changedGua),
      fiveElementAnalysis: _analyzeFiveElement(shangGuaIndex, xiaGuaIndex),
      prediction: _generatePrediction(mainGua, changedGua, question),
    );
  }

  NameAnalysis analyzeName(String name, {String? gender, BaziChart? userBazi}) {
    final chars = name.runes.toList();
    if (chars.length < 2) {
      return NameAnalysis(
        name: name,
        tianganScore: 50,
        dizhiScore: 50,
        wuxingScore: 50,
        yinyangScore: 50,
        zonggeScore: 50,
        totalScore: 50,
        tianganAnalysis: '名字字數不足',
        dizhiAnalysis: '無法分析',
        wuxingAnalysis: '無法分析',
        overallAnalysis: '請輸入完整的姓名',
        advantages: [],
        disadvantages: ['名字長度不足'],
      );
    }

    final tianganScore = _calculateTianganScore(chars);
    final dizhiScore = _calculateDizhiScore(chars);
    final wuxingScore = _calculateWuxingScore(chars, userBazi);
    final yinyangScore = _calculateYinyangScore(chars);
    final zonggeScore = _calculateZonggeScore(name);
    final totalScore = (tianganScore * 0.25 + dizhiScore * 0.2 + wuxingScore * 0.25 + yinyangScore * 0.1 + zonggeScore * 0.2).round();

    return NameAnalysis(
      name: name,
      tianganScore: tianganScore,
      dizhiScore: dizhiScore,
      wuxingScore: wuxingScore,
      yinyangScore: yinyangScore,
      zonggeScore: zonggeScore,
      totalScore: totalScore,
      tianganAnalysis: _getTianganAnalysis(tianganScore),
      dizhiAnalysis: _getDizhiAnalysis(dizhiScore),
      wuxingAnalysis: _getWuxingAnalysis(wuxingScore, userBazi),
      overallAnalysis: _getOverallAnalysis(totalScore),
      advantages: _getAdvantages(totalScore, tianganScore, wuxingScore),
      disadvantages: _getDisadvantages(totalScore, tianganScore, wuxingScore),
      fiveElementAdvice: userBazi != null ? _getFiveElementAdvice(userBazi) : null,
    );
  }

  List<String> generateNameSuggestions({
    String? familyName,
    String? gender,
    BaziChart? userBazi,
    int count = 10,
  }) {
    final suggestions = <String>[];
    final random = Random();
    
    final boyNames = ['浩然', '宇軒', '天佑', '博文', '志遠', '澤宇', '晨曦', '明遠', '修文', '致遠', '弘毅', '志明', '子涵', '俊豪', '宇航'];
    final girlNames = ['詩涵', '雅婷', '雨萱', '欣怡', '思琪', '梓涵', '語桐', '詩琪', '雅靜', '欣悅', '思穎', '詩穎', '雅茹', '欣妍', '語彤'];

    final nameList = gender == '女' ? girlNames : boyNames;

    for (int i = 0; i < count; i++) {
      final givenName = nameList[random.nextInt(nameList.length)];
      if (familyName != null) {
        suggestions.add('$familyName$givenName');
      } else {
        suggestions.add(givenName);
      }
    }

    return suggestions;
  }

  CharacterDivinationResult divineCharacter(String character, {String? question}) {
    return CharacterDivinationResult(
      character: character,
      strokeOrder: _getStrokeOrder(character),
      totalStrokes: _countStrokes(character),
      radical: _getRadical(character),
      radicalMeaning: _getRadicalMeaning(character),
      fiveElement: _getCharacterElement(character),
      meaning: _getCharacterMeaning(character),
      classicalMeaning: _getClassicalMeaning(character),
      interpretation: _interpretCharacter(character, question),
      predictions: _generateCharacterPredictions(character),
      advice: _getCharacterAdvice(character),
    );
  }

  String _getDayun(DateTime dt) {
    final year = dt.year;
    final month = dt.month;
    final day = dt.day;
    final dayunIndex = (year - 1984 + (month * 30 + day) ~/ 365) % 9;
    return baGua[dayunIndex];
  }

  String _getMonth(DateTime dt) {
    return diPan[(dt.month - 1) % 12];
  }

  String _getDay(DateTime dt) {
    return diPan[(dt.day - 1) % 12];
  }

  String _getNinePalace(String dayun) => dayun;

  String _getYiPalace(String dayun, String month) {
    final dayunIndex = baGua.indexOf(dayun);
    final monthIndex = diPan.indexOf(month);
    return baGua[(dayunIndex + monthIndex) % 8];
  }

  String _getMenPalace(String dayun) {
    final dayunIndex = baGua.indexOf(dayun);
    return baGua[(dayunIndex + 4) % 8];
  }

  String _getShenPalace(String dayun) {
    final dayunIndex = baGua.indexOf(dayun);
    return baGua[(dayunIndex + 2) % 8];
  }

  String _getKaiPalace(String dayun) {
    final dayunIndex = baGua.indexOf(dayun);
    return baGua[(dayunIndex + 1) % 8];
  }

  String _getShengPalace(String dayun) {
    final dayunIndex = baGua.indexOf(dayun);
    return baGua[(dayunIndex + 3) % 8];
  }

  String _getJingPalace(String dayun) {
    final dayunIndex = baGua.indexOf(dayun);
    return baGua[(dayunIndex + 5) % 8];
  }

  String _getSiPalace(String dayun) {
    final dayunIndex = baGua.indexOf(dayun);
    return baGua[(dayunIndex + 6) % 8];
  }

  String _getDuPalace(String dayun) {
    final dayunIndex = baGua.indexOf(dayun);
    return baGua[(dayunIndex + 7) % 8];
  }

  String _getXiuPalace(String dayun) {
    final dayunIndex = baGua.indexOf(dayun);
    return baGua[(dayunIndex + 4) % 8];
  }

  Map<String, String> _analyzePalaces(String dayun) {
    final dayunIndex = baGua.indexOf(dayun);
    return {
      '休門': dayunIndex == 0 || dayunIndex == 7 ? '大吉，利休養' : '中平',
      '生門': dayunIndex == 1 || dayunIndex == 6 ? '大吉，利生長' : '中平',
      '傷門': dayunIndex == 2 || dayunIndex == 5 ? '凶，受傷' : '中平',
      '杜門': dayunIndex == 3 || dayunIndex == 4 ? '中平，保密' : '小凶',
      '景門': dayunIndex == 0 || dayunIndex == 3 ? '吉，利文書' : '中平',
      '死門': dayunIndex == 2 ? '大凶' : '中平',
      '驚門': dayunIndex == 1 || dayunIndex == 6 ? '凶，驚恐' : '中平',
      '開門': dayunIndex == 4 || dayunIndex == 7 ? '大吉，利事業' : '中平',
    };
  }

  String _getOverallFortune(String dayun) {
    switch (dayun) {
      case '乾': return '大吉：萬事亨通，宜進取';
      case '兌': return '中吉：口才有利，宜溝通';
      case '離': return '吉：光明照耀，宜展示';
      case '震': return '中平：動中求進，宜變革';
      case '巽': return '吉：風行水上，宜策劃';
      case '坎': return '平：險中有機，宜謹慎';
      case '艮': return '平：止於當止，宜保守';
      case '坤': return '大吉：厚德載物，宜包容';
      default: return '平：命運平常';
    }
  }

  String _getCareerAdvice(String dayun) {
    switch (dayun) {
      case '乾': return '宜開創新局，膽大心細';
      case '兌': return '宜靠口才致勝，謹慎合約';
      case '離': return '宜展示才華，把握機會';
      case '震': return '宜主動出擊，敢於變革';
      case '巽': return '宜策劃分析，柔性執行';
      case '坎': return '宜穩健前行，防範小人';
      case '艮': return '宜腳踏實地，守成待時';
      case '坤': return '宜廣結善緣，積累人脈';
      default: return '宜守常待机';
    }
  }

  String _getRelationshipAdvice(String dayun) {
    switch (dayun) {
      case '乾': return '宜主動表達，真誠以對';
      case '兌': return '宜多溝通，注意言語';
      case '離': return '宜熱情付出，收穫情感';
      case '震': return '宜製造驚喜，打破平淡';
      case '巽': return '宜體貼細心，柔性相處';
      case '坎': return '宜坦誠相待，共渡難關';
      case '艮': return '宜適度空間，給予尊重';
      case '坤': return '宜包容理解，溫柔以待';
      default: return '宜順其自然';
    }
  }

  String _getHealthAdvice(String dayun) {
    switch (dayun) {
      case '乾': return '注意頭部、肺部健康';
      case '兌': return '注意口腔、咽喉健康';
      case '離': return '注意心臟、眼睛健康';
      case '震': return '注意肝膽、筋骨健康';
      case '巽': return '注意膽囊、呼吸系統';
      case '坎': return '注意腎臟、泌尿系統';
      case '艮': return '注意脾胃、消化系統';
      case '坤': return '注意腹部、血液循環';
      default: return '注意保養身體';
    }
  }

  String _getGuaName(int index) {
    const names = [
      '乾為天', '天澤履', '天火同人', '天雷無妄', '天風姤', '天水讼', '天山遯', '天地否',
      '澤天夬', '澤為兌', '澤火革', '澤雷隨', '澤風大過', '澤水困', '澤山咸', '澤地萃',
      '火天大有', '火澤睽', '火為離', '火雷噬嗑', '火風鼎', '火水未濟', '火山旅', '火地晉',
      '雷天大壯', '雷澤歸妹', '雷火豐', '雷為震', '雷風恆', '雷水解', '雷山小過', '雷地豫',
      '風天小畜', '風澤中孚', '風火家人', '風雷益', '風為巽', '風水渙', '風山漸', '風地觀',
      '水天需', '水澤節', '水火既濟', '水雷屯', '水風井', '水為坎', '水山蹇', '水地比',
      '山天大畜', '山澤損', '山火賁', '山雷頤', '山風蠱', '山水蒙', '山為艮', '山地剝',
      '地天泰', '地澤臨', '地火明夷', '地雷復', '地風升', '地水師', '地山謙', '地為坤',
    ];
    return names[index.clamp(0, names.length - 1)];
  }

  String _getGuaMeaning(int index) {
    const meanings = [
      '純陽至健，運勢極佳，萬事亨通',
      '履卦，踏實前行，步步高陞',
      '同人卦，合作共贏，人際和諧',
      '無妄卦，不妄為，吉祥如意',
      '姤卦，意外相遇，需謹慎',
      '讼卦，是非口舌，宜協商',
      '遯卦，隱退待機，宜保守',
      '否卦，閉塞不通，宜堅持',
      '夬卦，果斷決策，大吉',
      '兌卦，喜悅和諧，人際美滿',
      '革卦，改革創新，煥然一新',
      '隨卦，順勢而為，吉祥',
      '大過卦，行動過度，需謹慎',
      '困卦，困境重重，宜忍耐',
      '咸卦，感情交流，心意相通',
      '萃卦，聚集精華，人脈旺盛',
      '大有卦，豐收在望，事業有成',
      '睽卦，分離孤單，宜謹慎',
      '離卦，光明照耀，名利雙收',
      '噬嗑卦，障礙消除，前途光明',
      '鼎卦，革故鼎新，事業穩固',
      '未濟卦，事未完成，需努力',
      '旅卦，漂泊不定，宜守成',
      '晉卦，前途光明，步步高陞',
      '大壯卦，聲勢浩大，吉祥',
      '歸妹卦，情感美滿，宜婚嫁',
      '豐卦，豐盛美滿，名利雙收',
      '震卦，震動不安，宜冷靜',
      '恆卦，持之以恆，長久吉祥',
      '解卦，困難化解，前途光明',
      '小過卦，小有過失，宜謹慎',
      '豫卦，歡樂和諧，吉祥如意',
      '小畜卦，小有積累，宜穩進',
      '中孚卦，誠信為本，吉祥',
      '家人卦，家庭和睦，溫馨美滿',
      '益卦，利益增加，大吉',
      '巽卦，柔性處事，吉祥',
      '渙卦，渙散不聚，宜凝聚',
      '漸卦，逐步前進，吉祥',
      '觀卦，觀察審視，吉祥',
      '需卦，等待時機，吉祥',
      '節卦，節制有度，吉祥',
      '既濟卦，功成名就，吉祥',
      '屯卦，艱難初始，宜穩健',
      '井卦，源源不絕，吉祥',
      '坎卦，陷於險境，宜謹慎',
      '蹇卦，艱難前行，宜等待',
      '比卦，親近和諧，吉祥',
      '大畜卦，積累豐厚，吉祥',
      '損卦，略有損失，宜節制',
      '賁卦，文飾修養，吉祥',
      '頤卦，休養生息，吉祥',
      '蠱卦，整飭革新，吉祥',
      '蒙卦，懵懂無知，需教育',
      '艮卦，靜止不動，宜保守',
      '剝卦，剝落衰敗，宜謹慎',
      '泰卦，天地交泰，大吉',
      '臨卦，親臨指導，吉祥',
      '明夷卦，光明受損，宜隱忍',
      '復卦，恢復元氣，吉祥',
      '升卦，步步高陞，吉祥',
      '師卦，兵將出動，吉祥',
      '謙卦，謙遜有禮，吉祥',
      '坤卦，厚德載物，大吉',
    ];
    return meanings[index.clamp(0, meanings.length - 1)];
  }

  List<String> _interpretQuestion(String question, String mainGua, String changedGua) {
    final interpretations = <String>[];
    interpretations.add('您所得卦象：$mainGua（$changedGua 變）');
    
    if (question.contains('事業') || question.contains('工作')) {
      interpretations.add('事業發展：目前局勢較為穩定');
      interpretations.add('建議：把握機會，勇於行動');
    } else if (question.contains('感情') || question.contains('愛情')) {
      interpretations.add('感情運勢：情感狀況需要耐心經營');
      interpretations.add('建議：真誠以對，順其自然');
    } else if (question.contains('財運') || question.contains('金錢')) {
      interpretations.add('財運走向：財運起伏，需理財謹慎');
      interpretations.add('建議：保守理財，避免冒險');
    } else if (question.contains('健康')) {
      interpretations.add('健康狀況：身體需要休養');
      interpretations.add('建議：規律作息，適度運動');
    } else {
      interpretations.add('總體運勢：運勢中等，需要耐心');
      interpretations.add('建議：積极行動，把握機遇');
    }

    return interpretations;
  }

  String _analyzeFiveElement(int shang, int xia) {
    const elements = ['金', '金', '火', '木', '木', '水', '土', '土'];
    final shangElement = elements[shang];
    final xiaElement = elements[xia];
    
    if (shangElement == xiaElement) {
      return '五行屬${shangElement}，上下相應，能量旺盛';
    } else {
      return '外五行屬${shangElement}，內五行屬${xiaElement}，陰陽相濟';
    }
  }

  String _generatePrediction(String mainGua, String changedGua, String question) {
    return '變卦$changedGua預示著局勢將有所轉變，事務可能出現新的發展方向。建議順勢而為，把握時機。';
  }

  int _calculateTianganScore(List<int> chars) {
    return 70 + (chars.length * 5).clamp(0, 20);
  }

  int _calculateDizhiScore(List<int> chars) {
    if (chars.length < 2) return 60;
    return 75;
  }

  int _calculateWuxingScore(List<int> chars, BaziChart? userBazi) {
    if (userBazi == null) return 70;
    return 80;
  }

  int _calculateYinyangScore(List<int> chars) {
    return 70;
  }

  int _calculateZonggeScore(String name) {
    final strokes = _countStrokes(name);
    return (100 - (strokes % 10) * 5).clamp(60, 95);
  }

  String _getTianganAnalysis(int score) {
    if (score >= 90) return '天格大吉，得天獨厚';
    if (score >= 75) return '天格中吉，運勢不錯';
    return '天格平穩';
  }

  String _getDizhiAnalysis(int score) {
    if (score >= 90) return '地格大吉，根基穩固';
    if (score >= 75) return '地格中吉，事業有成';
    return '地格平穩';
  }

  String _getWuxingAnalysis(int score, BaziChart? userBazi) {
    if (userBazi != null) {
      return '五行與命局契合度高，能助益命運';
    }
    return '五行配置均衡';
  }

  String _getOverallAnalysis(int score) {
    if (score >= 90) return '此名大吉，天生貴命';
    if (score >= 80) return '此名中吉，命運順遂';
    if (score >= 70) return '此名平穩，吉凶參半';
    return '此名需謹慎，建議請專業人士把關';
  }

  List<String> _getAdvantages(int total, int tiangan, int wuxing) {
    final advantages = <String>[];
    if (total >= 80) advantages.add('總格分數高，命運較佳');
    if (tiangan >= 80) advantages.add('天格吉利，得天時之利');
    if (wuxing >= 80) advantages.add('五行配置得當');
    return advantages;
  }

  List<String> _getDisadvantages(int total, int tiangan, int wuxing) {
    final disadvantages = <String>[];
    if (total < 70) disadvantages.add('總格分數偏低');
    if (tiangan < 70) disadvantages.add('天格需注意');
    if (wuxing < 70) disadvantages.add('五行配置需調整');
    return disadvantages;
  }

  String _getFiveElementAdvice(BaziChart userBazi) {
    return '根據您的八字命局，建議選擇五行屬木或火的漢字，以助益您的命運發展';
  }

  String _getStrokeOrder(String char) {
    return '笔画顺序：横、竖、撇、捺';
  }

  int _countStrokes(String char) {
    final strokes = [1, 1, 2, 3, 3, 4, 5, 6, 7, 8, 9, 10];
    var total = 0;
    for (var rune in char.runes) {
      total += strokes[rune % 12];
    }
    return total;
  }

  String _getRadical(String char) {
    return char.substring(0, 1);
  }

  String _getRadicalMeaning(String char) {
    return '此字偏旁含有特定含義';
  }

  String _getCharacterElement(String char) {
    return '木';
  }

  String _getCharacterMeaning(String char) {
    return '此字含義深遠，寓意吉祥';
  }

  String _getClassicalMeaning(String char) {
    return '《說文解字》記載：此字古義如何如何';
  }

  String _interpretCharacter(String char, String? question) {
    if (question != null && question.isNotEmpty) {
      return '測字「$char」：與您所問之事相關，預示著...';
    }
    return '測字「$char」：此字筆畫$totalStrokes數，結構穩定，含義...';
  }

  List<String> _generateCharacterPredictions(String char) {
    return [
      '此字預示著事業發展順利',
      '人際關係和諧美滿',
      '財運有穩步增長之象',
    ];
  }

  String _getCharacterAdvice(String char) {
    return '建議您把握時機，積极行動';
  }
}
