class Herb {
  final String id;
  final String name;
  final String pinyin;
  final String latinName;
  final String taste;
  final String nature;
  final String meridian;
  final String effect;
  final String indication;
  final String preparation;
  final String contraindication;
  final String usage;
  final String dosage;
  final String famousUse;
  final String specialFunction;
  final Map<String, String>? inFormulaFunctions;

  Herb({
    required this.id,
    required this.name,
    required this.pinyin,
    this.latinName = '',
    required this.taste,
    required this.nature,
    required this.meridian,
    required this.effect,
    required this.indication,
    this.preparation = '',
    this.contraindication = '',
    this.usage = '',
    this.dosage = '',
    this.famousUse = '',
    this.specialFunction = '',
    this.inFormulaFunctions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pinyin': pinyin,
      'latin_name': latinName,
      'taste': taste,
      'nature': nature,
      'meridian': meridian,
      'effect': effect,
      'indication': indication,
      'preparation': preparation,
      'contraindication': contraindication,
      'usage': usage,
      'dosage': dosage,
      'famous_use': famousUse,
      'special_function': specialFunction,
      'in_formula_functions': inFormulaFunctions != null 
          ? inFormulaFunctions!.entries.map((e) => '${e.key}:${e.value}').join(';')
          : '',
    };
  }

  factory Herb.fromMap(Map<String, dynamic> map) {
    final functionsStr = map['in_formula_functions'] as String? ?? '';
    Map<String, String>? functions;
    if (functionsStr.isNotEmpty) {
      functions = {};
      for (var item in functionsStr.split(';')) {
        final parts = item.split(':');
        if (parts.length == 2) {
          functions[parts[0]] = parts[1];
        }
      }
    }

    return Herb(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      pinyin: map['pinyin'] ?? '',
      latinName: map['latin_name'] ?? '',
      taste: map['taste'] ?? '',
      nature: map['nature'] ?? '',
      meridian: map['meridian'] ?? '',
      effect: map['effect'] ?? '',
      indication: map['indication'] ?? '',
      preparation: map['preparation'] ?? '',
      contraindication: map['contraindication'] ?? '',
      usage: map['usage'] ?? '',
      dosage: map['dosage'] ?? '',
      famousUse: map['famous_use'] ?? '',
      specialFunction: map['special_function'] ?? '',
      inFormulaFunctions: functions,
    );
  }

  String get fullInfo {
    return '''
【$name】$pinyin
拉丁名：$latinName

性味：$taste
药性：$nature
归经：$meridian

功效：$effect

主治：$indication

炮制：$preparation

用法用量：$dosage
用法：$usage

配伍禁忌：$contraindication

名家用药心得：
$famousUse

专属作用：$specialFunction
''';
  }
}

class FormulaAnalysis {
  final String formulaName;
  final String origin;
  final String sixChannel;
  final String bingJi;
  final String hanReXuShi;
  final String selectReason;
  final String notOtherReasons;
  final List<HerbAnalysis> herbAnalyses;
  final String peiWuLogic;
  final String qiJiBalance;
  final String stageEffect;
  final String dietTaboo;
  final String bestTime;
  final String jiaJianGuidance;
  final bool isHighLevel;

  FormulaAnalysis({
    required this.formulaName,
    required this.origin,
    required this.sixChannel,
    required this.bingJi,
    required this.hanReXuShi,
    required this.selectReason,
    required this.notOtherReasons,
    required this.herbAnalyses,
    required this.peiWuLogic,
    required this.qiJiBalance,
    required this.stageEffect,
    required this.dietTaboo,
    required this.bestTime,
    required this.jiaJianGuidance,
    this.isHighLevel = false,
  });

  String toTeachingTemplate() {
    final buffer = StringBuffer();
    
    buffer.writeln('╔══════════════════════════════════════════╗');
    buffer.writeln('║     倪海厦经方教学解析 - $formulaName         ║');
    buffer.writeln('╚══════════════════════════════════════════╝');
    buffer.writeln();
    
    buffer.writeln('【出处】$origin');
    buffer.writeln();
    
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('  第一部分：六经辨证定位');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln();
    buffer.writeln('六经归属：$sixChannel');
    buffer.writeln();
    buffer.writeln('病机分析：');
    buffer.writeln(bingJi);
    buffer.writeln();
    
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('  第二部分：寒热虚实辨证');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln();
    buffer.writeln(hanReXuShi);
    buffer.writeln();
    
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('  第三部分：选方核心理由');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln();
    buffer.writeln(selectReason);
    buffer.writeln();
    
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('  第四部分：为何不用其他方剂');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln();
    buffer.writeln(notOtherReasons);
    buffer.writeln();
    
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('  第五部分：单味药详解');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln();
    
    for (var herb in herbAnalyses) {
      buffer.writeln('◆ ${herb.herbName}');
      buffer.writeln('  药性归经：${herb.nature}性，${herb.taste}味，归${herb.meridian}经');
      buffer.writeln('  单味功效：${herb.effect}');
      buffer.writeln('  在方中专属作用：${herb.specialRole}');
      buffer.writeln('  用量：${herb.dosage}');
      buffer.writeln();
    }
    
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('  第六部分：整方配伍逻辑');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln();
    buffer.writeln(peiWuLogic);
    buffer.writeln();
    
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('  第七部分：气机升降平衡原理');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln();
    buffer.writeln(qiJiBalance);
    buffer.writeln();
    
    if (isHighLevel) {
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      buffer.writeln('  第八部分：分阶段调理效果（高级会员专享）');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      buffer.writeln();
      buffer.writeln(stageEffect);
      buffer.writeln();
      
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      buffer.writeln('  第九部分：随证加减自学指导（高级会员专享）');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      buffer.writeln();
      buffer.writeln(jiaJianGuidance);
      buffer.writeln();
    }
    
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('  日常调理指导');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln();
    buffer.writeln('【最佳服药时辰】$bestTime');
    buffer.writeln();
    buffer.writeln('【日常忌口】');
    buffer.writeln(dietTaboo);
    buffer.writeln();
    
    if (isHighLevel) {
      buffer.writeln('═══════════════════════════════════════════');
      buffer.writeln('  高阶深度教学已解锁（高级会员专属内容）');
      buffer.writeln('═══════════════════════════════════════════');
    }
    
    return buffer.toString();
  }
}

class HerbAnalysis {
  final String herbName;
  final String nature;
  final String taste;
  final String meridian;
  final String effect;
  final String specialRole;
  final String dosage;

  HerbAnalysis({
    required this.herbName,
    required this.nature,
    required this.taste,
    required this.meridian,
    required this.effect,
    required this.specialRole,
    required this.dosage,
  });
}

class DiagnosisResult {
  final String channel;
  final String pattern;
  final String formula;
  final String prescription;
  final FormulaAnalysis analysis;
  final DateTime timestamp;

  DiagnosisResult({
    required this.channel,
    required this.pattern,
    required this.formula,
    required this.prescription,
    required this.analysis,
    required this.timestamp,
  });
}
