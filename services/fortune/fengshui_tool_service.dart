import 'dart:math';

class CompassData {
  final double heading;
  final String direction;
  final String bagua;
  final String element;
  final String fortune;
  final List<String> recommendations;
  final String? classicalReference;

  const CompassData({
    required this.heading,
    required this.direction,
    required this.bagua,
    required this.element,
    required this.fortune,
    required this.recommendations,
    this.classicalReference,
  });
}

class LubanMeasureResult {
  final double measurement;
  final String sizeCategory;
  final String meaning;
  final List<String> auspiciousMeanings;
  final List<String> inauspiciousMeanings;
  final String application;

  const LubanMeasureResult({
    required this.measurement,
    required this.sizeCategory,
    required this.meaning,
    required this.auspiciousMeanings,
    required this.inauspiciousMeanings,
    required this.application,
  });
}

class LijieMeasureResult {
  final double length;
  final String position;
  final String luck;
  final List<String> analysis;
  final String? suggestion;

  const LijieMeasureResult({
    required this.length,
    required this.position,
    required this.luck,
    required this.analysis,
    this.suggestion,
  });
}

class FengShuiAnalysis {
  final String id;
  final DateTime analyzedAt;
  final String propertyType;
  final String location;
  final CompassData front;
  final CompassData back;
  final CompassData left;
  final CompassData right;
  final String overallFortune;
  final String? niHaixiaAnalysis;
  final String? baixiaAnalysis;
  final String? xuankongAnalysis;
  final List<String> suggestions;
  final bool isPremium;

  const FengShuiAnalysis({
    required this.id,
    required this.analyzedAt,
    required this.propertyType,
    required this.location,
    required this.front,
    required this.back,
    required this.left,
    required this.right,
    required this.overallFortune,
    this.niHaixiaAnalysis,
    this.baixiaAnalysis,
    this.xuankongAnalysis,
    required this.suggestions,
    this.isPremium = false,
  });
}

class FengShuiToolService {
  static final FengShuiToolService _instance = FengShuiToolService._internal();
  factory FengShuiToolService() => _instance;
  FengShuiToolService._internal();

  static const List<String> directions = ['北', '東北', '東', '東南', '南', '西南', '西', '西北'];
  static const List<String> bagua = ['坎', '艮', '震', '巽', '離', '坤', '兌', '乾'];
  static const List<String> elements = ['水', '土', '木', '木', '火', '土', '金', '金'];

  CompassData getCompassData(double heading) {
    final normalizedHeading = ((heading % 360) + 360) % 360;
    final index = _getDirectionIndex(normalizedHeading);
    
    return CompassData(
      heading: normalizedHeading,
      direction: directions[index],
      bagua: bagua[index],
      element: elements[index],
      fortune: _getFortune(index),
      recommendations: _getRecommendations(index),
      classicalReference: '《黃帝內經》：「陰陽者，天地之道也」',
    );
  }

  int _getDirectionIndex(double heading) {
    final adjusted = (heading + 22.5) % 360;
    return (adjusted / 45).floor();
  }

  String _getFortune(int index) {
    final fortunes = [
      '坎位：主智慧、財運，北方屬水，利於從事水類或流動性行業',
      '艮位：主事業、誠信，東北屬土，利於房產或穩定行業',
      '震位：主事業、發展，東方屬木，利於創意或發展中行業',
      '巽位：主文昌、桃花，東南屬木，利於文教或女性行業',
      '離位：主名聲、光明，南方屬火，利於展示或熱情行業',
      '坤位：主順利、品德，西南屬土，利於服務或公共行業',
      '兌位：主人際、口才，西方屬金，利於銷售或演說行業',
      '乾位：主領導、貴人，西北屬金，利於管理或權威行業',
    ];
    return fortunes[index];
  }

  List<String> _getRecommendations(int index) {
    final recommendations = [
      ['北方宜擺放水景或黑色物品', '忌擺放紅色或火類物品'],
      ['東北宜保持整潔', '忌雜物堆積'],
      ['東方宜擺放綠色植物', '忌擺放金屬物品'],
      ['東南宜擺放文昌物品', '忌擺放雜物'],
      ['南方宜擺放燈光或紅色物品', '忌擺放黑色物品'],
      ['西南宜擺放陶瓷或土類物品', '忌擺放尖銳物品'],
      ['西方宜擺放金屬或白色物品', '忌擺放綠色植物'],
      ['西北宜保持開闊', '忌擺放雜物或垃圾桶'],
    ];
    return recommendations[index];
  }

  LubanMeasureResult measureLuban(double centimeters) {
    final chiCun = centimeters / 3.33;
    final remainder = chiCun % 9;
    
    String category;
    String meaning;
    List<String> auspicious = [];
    List<String> inauspicious = [];
    String application;

    if (remainder >= 1 && remainder <= 3) {
      category = '財';
      meaning = '財運之星，利於積累財富';
      auspicious = ['旺財運', '助事業', '積累財富'];
      inauspicious = [];
      application = '適合測量門寬、窗寬、書桌高度';
    } else if (remainder >= 4 && remainder <= 6) {
      category = '義';
      meaning = '義氣之星，利於人際關係';
      auspicious = ['旺人際', '得貴人', '事業順遂'];
      inauspicious = [];
      application = '適合測量會議桌、沙發長度';
    } else {
      category = '官';
      meaning = '官運之星，利於事業發展';
      auspicious = ['旺事業', '利考試', '得提拔'];
      inauspicious = ['感情方面需注意'];
      application = '適合測量書桌高度、椅子高度';
    }

    return LubanMeasureResult(
      measurement: centimeters,
      sizeCategory: category,
      meaning: meaning,
      auspiciousMeanings: auspicious,
      inauspiciousMeanings: inauspicious,
      application: application,
    );
  }

  LijieMeasureResult measureLijie(double centimeters) {
    final chiCun = centimeters / 3.33;
    final position = (chiCun % 8).floor() + 1;
    
    String luck;
    List<String> analysis = [];
    String? suggestion;

    switch (position) {
      case 1:
        luck = '大吉';
        analysis = ['魯班尺第一位：財德', '利於財運和品德'];
        suggestion = '適合門、窗、書桌等';
        break;
      case 2:
        luck = '大吉';
        analysis = ['魯班尺第二位：寶庫', '利於積累和收藏'];
        suggestion = '適合書櫃、儲物櫃';
        break;
      case 3:
        luck = '大吉';
        analysis = ['魯班尺第三位：及時雨', '利於順暢和時機'];
        suggestion = '適合門、通道';
        break;
      case 4:
        luck = '大吉';
        analysis = ['魯班尺第四位：登科', '利於學業和考試'];
        suggestion = '適合書桌、文昌位';
        break;
      case 5:
        luck = '小吉';
        analysis = ['魯班尺第五位：興旺', '利於事業發展'];
        suggestion = '適合辦公桌、會議桌';
        break;
      case 6:
        luck = '中平';
        analysis = ['魯班尺第六位：庫樓', '利於收藏和儲存'];
        suggestion = '適合書櫃、貨架';
        break;
      case 7:
        luck = '小凶';
        analysis = ['魯班尺第七位：退財', '需注意財務'];
        suggestion = '需避免或化解';
        break;
      case 8:
        luck = '大凶';
        analysis = ['魯班尺第八位：官事', '需注意是非'];
        suggestion = '需化解或請專業人士處理';
        break;
      default:
        luck = '平';
        analysis = ['魯班尺測量結果'];
        suggestion = '一般測量';
    }

    return LijieMeasureResult(
      length: centimeters,
      position: '$position',
      luck: luck,
      analysis: analysis,
      suggestion: suggestion,
    );
  }

  FengShuiAnalysis analyzeProperty({
    required String propertyType,
    required String location,
    required double frontHeading,
    required double backHeading,
    required double leftHeading,
    required double rightHeading,
    String? niHaixiaStyle,
  }) {
    final front = getCompassData(frontHeading);
    final back = getCompassData(backHeading);
    final left = getCompassData(leftHeading);
    final right = getCompassData(rightHeading);

    final overall = _calculateOverallFortune(front, back, left, right);

    return FengShuiAnalysis(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      analyzedAt: DateTime.now(),
      propertyType: propertyType,
      location: location,
      front: front,
      back: back,
      left: left,
      right: right,
      overallFortune: overall,
      niHaixiaAnalysis: niHaixiaStyle != null ? _getNiHaixiaAnalysis(front, niHaixiaStyle) : null,
      baixiaAnalysis: _getBaixiaAnalysis(front, back, left, right),
      xuankongAnalysis: _getXuankongAnalysis(front),
      suggestions: _generateSuggestions(front, back, left, right),
    );
  }

  String _calculateOverallFortune(
    CompassData front,
    CompassData back,
    CompassData left,
    CompassData right,
  ) {
    int score = 0;
    
    if (front.element == '木' || front.element == '火') score += 2;
    if (back.element == '土' || back.element == '金') score += 2;
    if (left.element == '木') score += 1;
    if (right.element == '金') score += 1;

    if (score >= 6) return '大吉：風水寶地，財丁兩旺';
    if (score >= 4) return '中吉：風水良好，運勢平穩';
    if (score >= 2) return '小吉：風水尚可，需適當調整';
    return '平：風水一般，建議請專業人士指導';
  }

  String _getNiHaixiaAnalysis(CompassData front, String style) {
    return '''倪海厦风水体系分析：
    
倪師強調：「风水的核心在于让气场与人的命格相合」

按倪師理论：
1. 大门朝向宜朝向主人的喜用神方位
2. 客厅布局宜方正，避免缺角
3. 卧室床位宜靠实墙，避开横梁压顶
4. 厨房灶位宜与水槽相距一定距离

本案分析：
- 面向${front.direction}，属${front.bagua}卦，${front.element}气
- 建议根据主人八字调整室内布局''';
  }

  String _getBaixiaAnalysis(
    CompassData front,
    CompassData back,
    CompassData left,
    CompassData right,
  ) {
    return '''八宅风水分析：

八宅派以大门朝向为基准，分为：
- 东四宅：坎、离、震、巽
- 西四宅：乾、坤、艮、兌

本案分析：
- 大门朝向${front.direction}（${front.bagua}）
- 此为${_isEastFour(front.bagua!) ? '东四宅' : '西四宅'}
- 主人命卦宜与宅卦相配

吉位：生气、延年、天医、伏位
凶位：绝命、五鬼、六煞、祸害''';
  }

  String _getXuankongAnalysis(CompassData front) {
    return '''玄空风水分析：

玄空风水以运星飞布判断吉凶：
- 现为下元八运（2004-2023）
- 需结合具体山向盘分析

本案朝向${front.direction}（${front.bagua}卦）：
- 需配合山星、向星飞布综合判断
- 建议请专业风水师实地勘测''';
  }

  bool _isEastFour(String bagua) {
    return bagua == '坎' || bagua == '離' || bagua == '震' || bagua == '巽';
  }

  List<String> _generateSuggestions(
    CompassData front,
    CompassData back,
    CompassData left,
    CompassData right,
  ) {
    final suggestions = <String>[];

    suggestions.add('大门朝向${front.direction}，宜保持清洁明亮');
    
    if (front.element == '木') {
      suggestions.add('东方属木，可摆放绿色植物增强木气');
    } else if (front.element == '火') {
      suggestions.add('南方属火，可摆放红色物品增强火气');
    }

    if (left.element == '金') {
      suggestions.add('左侧为金，适合摆放金属装饰');
    }

    if (right.element == '木') {
      suggestions.add('右侧为木，宜保持绿化');
    }

    suggestions.add('定期清理杂物，保持气场流通');
    suggestions.add('如需专业风水调整，建议预约平台师傅');

    return suggestions;
  }

  String generateCompassReport(CompassData data) {
    final buffer = StringBuffer();
    buffer.writeln('═══ 羅盤測量報告 ═══');
    buffer.writeln('');
    buffer.writeln('【方位】${data.direction}');
    buffer.writeln('【卦象】${data.bagua}');
    buffer.writeln('【五行】${data.element}');
    buffer.writeln('');
    buffer.writeln('【吉凶分析】');
    buffer.writeln(data.fortune);
    buffer.writeln('');
    buffer.writeln('【建議】');
    for (final rec in data.recommendations) {
      buffer.writeln('• $rec');
    }
    buffer.writeln('');
    buffer.writeln(data.classicalReference ?? '');
    return buffer.toString();
  }

  String generateFengShuiReport(FengShuiAnalysis analysis) {
    final buffer = StringBuffer();
    buffer.writeln('═══ 風水分析報告 ═══');
    buffer.writeln('');
    buffer.writeln('【房屋類型】${analysis.propertyType}');
    buffer.writeln('【朝向位置】${analysis.location}');
    buffer.writeln('');
    buffer.writeln('【四象分析】');
    buffer.writeln('前方（${analysis.front.direction}）：${analysis.front.bagua}卦，${analysis.front.element}氣');
    buffer.writeln('後方（${analysis.back.direction}）：${analysis.back.bagua}卦，${analysis.back.element}氣');
    buffer.writeln('左方（${analysis.left.direction}）：${analysis.left.bagua}卦，${analysis.left.element}氣');
    buffer.writeln('右方（${analysis.right.direction}）：${analysis.right.bagua}卦，${analysis.right.element}氣');
    buffer.writeln('');
    buffer.writeln('【總體評價】');
    buffer.writeln(analysis.overallFortune);
    buffer.writeln('');
    if (analysis.niHaixiaAnalysis != null) {
      buffer.writeln('【倪海厦風水體系】');
      buffer.writeln(analysis.niHaixiaAnalysis);
    }
    buffer.writeln('');
    buffer.writeln('【風水建議】');
    for (final suggestion in analysis.suggestions) {
      buffer.writeln('• $suggestion');
    }
    buffer.writeln('');
    buffer.writeln('─────────────────────────');
    buffer.writeln('AI測算僅供參考');
    buffer.writeln('如需專業風水服務，請預約平台師傅');
    return buffer.toString();
  }
}
