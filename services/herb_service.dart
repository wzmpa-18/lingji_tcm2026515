import 'dart:convert';
import '../models/herb.dart';
import '../models/consultation.dart';

class HerbService {
  static final HerbService _instance = HerbService._internal();
  factory HerbService() => _instance;
  HerbService._internal();

  final List<Herb> _herbs = [];

  Future<void> initHerbs() async {
    _loadHerbsFromDatabase();
  }

  void _loadHerbsFromDatabase() {
    _herbs.addAll(_getAllHerbs());
  }

  List<Herb> getAllHerbs() => _herbs;

  Herb? getHerbByName(String name) {
    return _herbs.firstWhere(
      (h) => h.name == name || h.pinyin == name,
      orElse: () => _herbs.first,
    );
  }

  List<Herb> searchHerbs(String query) {
    if (query.isEmpty) return _herbs;
    return _herbs.where((h) {
      return h.name.contains(query) ||
             h.pinyin.toLowerCase().contains(query.toLowerCase()) ||
             h.effect.contains(query);
    }).toList();
  }

  FormulaAnalysis generateFormulaAnalysis({
    required Prescription formula,
    required List<String> symptoms,
    required String? tongue,
    required String? pulse,
    required int memberLevel,
  }) {
    final herbs = formula.composition.map((c) => getHerbByName(c['herb'])).toList();
    
    final herbAnalyses = herbs.map((herb) {
      return HerbAnalysis(
        herbName: herb?.name ?? '',
        nature: herb?.nature ?? '',
        taste: herb?.taste ?? '',
        meridian: herb?.meridian ?? '',
        effect: herb?.effect ?? '',
        specialRole: herb?.specialFunction ?? '',
        dosage: herbs.indexOf(herb) < formula.composition.length 
            ? formula.composition[herbs.indexOf(herb)]['dosage'] ?? ''
            : '',
      );
    }).toList();

    final sixChannel = _determineSixChannel(formula.name, symptoms);
    final bingJi = _generateBingJi(formula.name, symptoms, tongue, pulse);
    final hanReXuShi = _analyzeHanReXuShi(tongue, pulse, symptoms);
    final selectReason = _generateSelectReason(formula);
    final notOtherReasons = _generateNotOtherReasons(formula);
    final peiWuLogic = _generatePeiWuLogic(formula);
    final qiJiBalance = _generateQiJiBalance(formula);
    final stageEffect = _generateStageEffect(formula);
    final dietTaboo = _generateDietTaboo(formula);
    final bestTime = _generateBestTime(formula);
    final jiaJianGuidance = _generateJiaJianGuidance(formula);

    return FormulaAnalysis(
      formulaName: formula.name,
      origin: formula.origin,
      sixChannel: sixChannel,
      bingJi: bingJi,
      hanReXuShi: hanReXuShi,
      selectReason: selectReason,
      notOtherReasons: notOtherReasons,
      herbAnalyses: herbAnalyses,
      peiWuLogic: peiWuLogic,
      qiJiBalance: qiJiBalance,
      stageEffect: stageEffect,
      dietTaboo: dietTaboo,
      bestTime: bestTime,
      jiaJianGuidance: jiaJianGuidance,
      isHighLevel: memberLevel >= 2,
    );
  }

  String _determineSixChannel(String formulaName, List<String> symptoms) {
    if (formulaName.contains('桂枝') || formulaName.contains('麻黄')) {
      return '太阳病';
    }
    if (formulaName.contains('柴胡')) {
      return '少阳病';
    }
    if (formulaName.contains('承气') || formulaName.contains('泻心')) {
      return '阳明病';
    }
    if (formulaName.contains('理中') || formulaName.contains('四逆')) {
      return '太阴病/少阴病';
    }
    if (formulaName.contains('吴茱萸')) {
      return '厥阴病';
    }
    if (symptoms.any((s) => s.contains('寒') || s.contains('发热'))) {
      return '太阳病';
    }
    if (symptoms.any((s) => s.contains('口苦') || s.contains('胁痛'))) {
      return '少阳病';
    }
    if (symptoms.any((s) => s.contains('便秘') || s.contains('腹胀'))) {
      return '阳明病';
    }
    return '需要根据四诊合参确定';
  }

  String _generateBingJi(String formulaName, List<String> symptoms, String? tongue, String? pulse) {
    final tongueAnalysis = tongue ?? '';
    final pulseAnalysis = pulse ?? '';
    
    StringBuffer sb = StringBuffer();
    
    sb.writeln('根据患者症状：${symptoms.join("、")}');
    sb.writeln();
    
    if (tongueAnalysis.contains('白') && !tongueAnalysis.contains('黄')) {
      sb.writeln('舌象显示：病在表位，邪气尚未入里化热');
    } else if (tongueAnalysis.contains('黄')) {
      sb.writeln('舌苔黄腻：提示邪气入里化热，湿热内蕴');
    } else if (tongueAnalysis.contains('淡')) {
      sb.writeln('舌色淡：提示气血不足，有虚证表现');
    }
    
    sb.writeln();
    
    if (pulseAnalysis.contains('浮')) {
      sb.writeln('脉象浮：病在表，正邪交争于体表');
    } else if (pulseAnalysis.contains('沉')) {
      sb.writeln('脉象沉：病在里，邪气入里');
    } else if (pulseAnalysis.contains('数')) {
      sb.writeln('脉象数：主热证');
    } else if (pulseAnalysis.contains('迟')) {
      sb.writeln('脉象迟：主寒证或阳虚');
    }
    
    sb.writeln();
    sb.writeln('综合分析：外邪侵袭，正气不足，营卫失调，');
    sb.writeln('导致表虚汗出、恶风发热等症候。');

    return sb.toString();
  }

  String _analyzeHanReXuShi(String? tongue, String? pulse, List<String> symptoms) {
    StringBuffer sb = StringBuffer();
    
    final tongueAnalysis = tongue ?? '';
    final pulseAnalysis = pulse ?? '';
    
    sb.writeln('【寒热辨证】');
    if (tongueAnalysis.contains('淡白') || tongueAnalysis.contains('白')) {
      sb.writeln('• 舌淡白属寒证');
    } else if (tongueAnalysis.contains('红') || tongueAnalysis.contains('黄')) {
      sb.writeln('• 舌红黄属热证');
    }
    if (pulseAnalysis.contains('迟')) {
      sb.writeln('• 脉迟主寒');
    } else if (pulseAnalysis.contains('数')) {
      sb.writeln('• 脉数主热');
    }
    if (symptoms.any((s) => s.contains('畏寒'))) {
      sb.writeln('• 患者畏寒明显，属寒证');
    }
    if (symptoms.any((s) => s.contains('发热'))) {
      sb.writeln('• 有发热症状');
    }
    
    sb.writeln();
    sb.writeln('【虚实辨证】');
    if (symptoms.any((s) => s.contains('汗'))) {
      sb.writeln('• 汗出异常：自汗为气虚，盗汗为阴虚');
    }
    if (pulseAnalysis.contains('虚') || pulseAnalysis.contains('弱')) {
      sb.writeln('• 脉虚无力，属虚证');
    } else if (pulseAnalysis.contains('实') || pulseAnalysis.contains('弦')) {
      sb.writeln('• 脉实有力，属实证');
    }
    
    return sb.toString();
  }

  String _generateSelectReason(Prescription formula) {
    StringBuffer sb = StringBuffer();
    
    sb.writeln('选用${formula.name}的理由：');
    sb.writeln();
    
    switch (formula.name) {
      case '桂枝汤':
        sb.writeln('1. 患者有汗出、恶风、脉浮缓等典型太阳中风证');
        sb.writeln('2. 病邪在表，正气尚能抗邪于外');
        sb.writeln('3. 需要调和营卫、解肌发表');
        sb.writeln('4. 桂枝汤为"群方之魁"，是治疗太阳中风的主方');
        break;
      case '麻黄汤':
        sb.writeln('1. 患者无汗、恶寒、脉浮紧，为典型太阳伤寒证');
        sb.writeln('2. 寒邪束表，肺气不宣');
        sb.writeln('3. 需要发汗解表、宣肺平喘');
        sb.writeln('4. 麻黄汤是治疗太阳伤寒无汗的主方');
        break;
      case '小柴胡汤':
        sb.writeln('1. 患者有寒热往来、胸胁苦满等少阳证');
        sb.writeln('2. 病邪在半表半里之间');
        sb.writeln('3. 需要和解少阳、疏利气机');
        sb.writeln('4. 小柴胡汤是治疗少阳病的主方');
        break;
      case '四君子汤':
        sb.writeln('1. 患者有气虚表现：倦怠乏力、食少便溏');
        sb.writeln('2. 脾胃气虚，运化失职');
        sb.writeln('3. 需要益气健脾');
        sb.writeln('4. 四君子汤是补气的基础方');
        break;
      case '补中益气汤':
        sb.writeln('1. 患者中气下陷，清阳不升');
        sb.writeln('2. 有气虚发热、脏器下垂等症状');
        sb.writeln('3. 需要补中益气、升阳举陷');
        sb.writeln('4. 补中益气汤是治疗气虚发热的代表方');
        break;
      default:
        sb.writeln('根据辨证论治原则，本方契合当前病机');
    }
    
    return sb.toString();
  }

  String _generateNotOtherReasons(Prescription formula) {
    StringBuffer sb = StringBuffer();
    
    sb.writeln('为何不选用其他方剂：');
    sb.writeln();
    
    switch (formula.name) {
      case '桂枝汤':
        sb.writeln('✗ 麻黄汤：患者已有汗出，不可再用麻黄发汗');
        sb.writeln('✗ 小柴胡汤：病不在少阳，不可过早使用柴胡');
        sb.writeln('✗ 银翘散：虽有解表，但调和营卫之力不及桂枝汤');
        break;
      case '麻黄汤':
        sb.writeln('✗ 桂枝汤：患者无汗，桂枝汤调和营卫但发汗力弱');
        sb.writeln('✗ 葛根汤：用于太阳病兼项背强几几，无强直则不必用');
        sb.writeln('✗ 大青龙汤：患者无内热烦躁，无需大发汗清热');
        break;
      case '小柴胡汤':
        sb.writeln('✗ 桂枝汤：病已离表，不可再用桂枝解肌');
        sb.writeln('✗ 柴胡桂枝汤：少阳证不典型，无需合用桂枝汤');
        sb.writeln('✗ 大柴胡汤：阳明腑实不明显，无需下法');
        break;
      case '四君子汤':
        sb.writeln('✗ 四物汤：重在补血，患者以气虚为主');
        sb.writeln('✗ 补中益气汤：用于中气下陷，非单纯气虚');
        sb.writeln('✗ 六君子汤：兼有痰湿时才用');
        break;
      default:
        sb.writeln('本方最为契合当前病机');
    }
    
    return sb.toString();
  }

  String _generatePeiWuLogic(Prescription formula) {
    StringBuffer sb = StringBuffer();
    
    sb.writeln('整方配伍逻辑分析：');
    sb.writeln();
    
    switch (formula.name) {
      case '桂枝汤':
        sb.writeln('桂枝汤由桂枝、芍药、生姜、大枣、甘草五味药组成：');
        sb.writeln();
        sb.writeln('• 桂枝 + 甘草：辛甘化阳，助卫解肌');
        sb.writeln('• 芍药 + 甘草：酸甘化阴，益阴敛营');
        sb.writeln('• 生姜 + 大枣：调和脾胃，助正祛邪');
        sb.writeln('• 桂枝 + 芍药：一散一收，调和营卫');
        sb.writeln();
        sb.writeln('全方配伍特点：发散与酸收并用，');
        sb.writeln('使辛散不伤阴，酸收不滞邪，共奏调和营卫之功。');
        break;
      case '小柴胡汤':
        sb.writeln('小柴胡汤由柴胡、黄芩、人参、半夏、甘草、生姜、大枣七味组成：');
        sb.writeln();
        sb.writeln('• 柴胡 + 黄芩：柴胡主升，疏解少阳经郁热；黄芩主降，清少阳胆腑之火');
        sb.writeln('• 人参 + 甘草 + 大枣：益气健脾，扶正祛邪，防止邪气内陷');
        sb.writeln('• 半夏 + 生姜：和胃降逆止呕');
        sb.writeln();
        sb.writeln('全方配伍特点：升降并用，补散结合，');
        sb.writeln('使少阳枢机得转，脾胃得和，正胜邪退。');
        break;
      default:
        sb.writeln('本方配伍遵循君臣佐使原则');
        sb.writeln('各药协同，共奏治疗之效');
    }
    
    return sb.toString();
  }

  String _generateQiJiBalance(Prescription formula) {
    StringBuffer sb = StringBuffer();
    
    sb.writeln('气机升降平衡原理：');
    sb.writeln();
    
    switch (formula.name) {
      case '桂枝汤':
        sb.writeln('桂枝汤调畅气机的特点：');
        sb.writeln();
        sb.writeln('【升】桂枝、生姜 → 辛温上行，宣发卫阳');
        sb.writeln('【降】芍药 → 酸苦下行，敛阴和营');
        sb.writeln();
        sb.writeln('通过桂枝之升与芍药之降的相互配合，');
        sb.writeln('使郁于体表之邪气得以外散，');
        sb.writeln('同时防止发散太过而伤及阴液，');
        sb.writeln('达到"阴平阳秘"的平衡状态。');
        break;
      case '小柴胡汤':
        sb.writeln('小柴胡汤调畅气机的特点：');
        sb.writeln();
        sb.writeln('【升】柴胡 → 升发少阳清气，透邪外出');
        sb.writeln('【降】黄芩、半夏 → 降泄胆胃郁火，和胃降逆');
        sb.writeln('【扶】人参、甘草 → 健脾益气，防止下陷');
        sb.writeln();
        sb.writeln('柴胡与黄芩配伍，一升一降，');
        sb.writeln('使少阳枢机得以转动；');
        sb.writeln('人参、甘草健脾固本，');
        sb.writeln('使升降有度，不伤正气。');
        break;
      case '四君子汤':
        sb.writeln('四君子汤补益气机的特点：');
        sb.writeln();
        sb.writeln('• 人参为君，大补元气，升提清阳');
        sb.writeln('• 白术为臣，健脾燥湿，助运中焦');
        sb.writeln('• 茯苓为佐，渗湿利水，使补而不滞');
        sb.writeln('• 甘草为使，调和诸药，益气和中');
        sb.writeln();
        sb.writeln('全方以补气为主，佐以渗利，');
        sb.writeln('使补而不滞，脾气健运，清阳上升。');
        break;
      default:
        sb.writeln('本方通过药物的升降浮沉作用，');
        sb.writeln('调理脏腑气机，恢复阴阳平衡。');
    }
    
    return sb.toString();
  }

  String _generateStageEffect(Prescription formula) {
    StringBuffer sb = StringBuffer();
    
    sb.writeln('【第一阶段：1-3天】祛邪期');
    sb.writeln('• 症状：原有症状可能略有加重，如微微汗出');
    sb.writeln('• 机理：正邪交争，药力助正祛邪');
    sb.writeln('• 舌脉：舌苔可能变薄，脉象趋于平和');
    sb.writeln();
    
    sb.writeln('【第二阶段：4-7天】调理期');
    sb.writeln('• 症状：主要症状明显改善');
    sb.writeln('• 机理：邪气渐退，正气得复');
    sb.writeln('• 舌脉：舌质转红润，脉象有力');
    sb.writeln();
    
    sb.writeln('【第三阶段：8-14天】恢复期');
    sb.writeln('• 症状：症状基本消失，体力恢复');
    sb.writeln('• 机理：脏腑功能恢复，气血调和');
    sb.writeln('• 舌脉：舌淡红苔薄白，脉平缓有力');
    sb.writeln();
    
    sb.writeln('【注意事项】');
    sb.writeln('• 每个阶段约3-7天，根据病情轻重有所差异');
    sb.writeln('• 症状消失后建议再服用3-5天巩固疗效');
    sb.writeln('• 若出现不适或症状加重，请及时就医');
    
    return sb.toString();
  }

  String _generateDietTaboo(Prescription formula) {
    StringBuffer sb = StringBuffer();
    
    sb.writeln('【忌口清单】');
    sb.writeln();
    
    if (formula.name.contains('桂枝') || formula.name.contains('麻黄')) {
      sb.writeln('• 生冷食物：冰品、冷饮、凉菜');
      sb.writeln('• 油腻食物：油炸、肥肉、奶油');
      sb.writeln('• 辛辣刺激：辣椒、胡椒、生姜（过量）');
      sb.writeln('• 发物：海鲜、羊肉、狗肉');
      sb.writeln();
      sb.writeln('【宜食】');
      sb.writeln('• 清淡易消化食物');
      sb.writeln('• 粥类、面条、蔬菜');
      sb.writeln('• 温热开水');
    } else if (formula.name.contains('柴胡')) {
      sb.writeln('• 油腻食物：加重肝胆负担');
      sb.writeln('• 辛辣刺激：助热生火');
      sb.writeln('• 酒类：伤肝助湿');
      sb.writeln('• 生冷食物：影响脾胃运化');
      sb.writeln();
      sb.writeln('【宜食】');
      sb.writeln('• 疏肝理气食物：山楂、陈皮、玫瑰花茶');
      sb.writeln('• 清淡蔬菜');
      sb.writeln('• 易消化食物');
    } else if (formula.name.contains('四君子') || formula.name.contains('补中')) {
      sb.writeln('• 生冷食物：伤脾胃阳气');
      sb.writeln('• 油腻食物：碍胃助湿');
      sb.writeln('• 难以消化的食物');
      sb.writeln();
      sb.writeln('【宜食】');
      sb.writeln('• 山药、莲子、薏苡仁');
      sb.writeln('• 红枣、桂圆');
      sb.writeln('• 温热易消化食物');
    } else {
      sb.writeln('• 生冷、油腻、辛辣刺激食物');
      sb.writeln('• 烟酒');
      sb.writeln();
      sb.writeln('【宜食】');
      sb.writeln('• 清淡、营养、易消化食物');
    }
    
    return sb.toString();
  }

  String _generateBestTime(Prescription formula) {
    StringBuffer sb = StringBuffer();
    
    sb.writeln('【最佳服药时辰】');
    sb.writeln();
    
    if (formula.name.contains('桂枝') || formula.name.contains('麻黄')) {
      sb.writeln('• 服药时间：上午9-11点（巳时）');
      sb.writeln('• 理由：此时为脾经主事，有助于药力发挥');
      sb.writeln('• 桂枝汤需"服已须臾，啜热稀粥"以助药力');
      sb.writeln('• 若病重可午后再服一次');
    } else if (formula.name.contains('柴胡')) {
      sb.writeln('• 服药时间：晚上9-11点（亥时）或上午7-9点');
      sb.writeln('• 理由：少阳病夜间症状加重，此时服药顺应气机');
      sb.writeln('• 小柴胡汤需"日三服"');
    } else if (formula.name.contains('四君子') || formula.name.contains('补中')) {
      sb.writeln('• 服药时间：饭前30分钟');
      sb.writeln('• 理由：补益剂空腹服用吸收更好');
      sb.writeln('• 可在上午9点、下午3点各服一次');
    } else {
      sb.writeln('• 一般建议：饭后30分钟服用');
      sb.writeln('• 若有胃不适，可分多次少量服用');
    }
    
    sb.writeln();
    sb.writeln('【温热服用】');
    sb.writeln('• 中药一般需要温热服用');
    sb.writeln('• 不可冷服，以免伤脾胃阳气');
    
    return sb.toString();
  }

  String _generateJiaJianGuidance(Prescription formula) {
    StringBuffer sb = StringBuffer();
    
    sb.writeln('【随证加减自学指导】');
    sb.writeln();
    sb.writeln('以下加减方法供学习参考，具体用药请遵医嘱：');
    sb.writeln();
    
    switch (formula.name) {
      case '桂枝汤':
        sb.writeln('【兼证加减】');
        sb.writeln('• 兼喘：加厚朴、杏仁（桂枝加厚朴杏子汤）');
        sb.writeln('• 兼项背强几几：加葛根（桂枝加葛根汤）');
        sb.writeln('• 兼汗出过多：加重芍药（桂枝加芍药汤）');
        sb.writeln('• 兼腹满时痛：加重芍药、大黄（桂枝加大黄汤）');
        sb.writeln();
        sb.writeln('【变通用量】');
        sb.writeln('• 体质壮实：桂枝可加量');
        sb.writeln('• 体质虚弱：减少桂枝用量，加大人参');
        break;
      case '小柴胡汤':
        sb.writeln('【兼证加减】');
        sb.writeln('• 兼胸闷胁痛：加枳壳、香附');
        sb.writeln('• 兼呕吐严重：加重半夏、生姜');
        sb.writeln('• 兼口苦咽干：加重黄芩');
        sb.writeln('• 兼便秘：加大黄（大柴胡汤）');
        sb.writeln();
        sb.writeln('【变通用量】');
        sb.writeln('• 年老体弱：减少柴胡用量，加大人参');
        sb.writeln('• 热象明显：减少人参，加重黄芩');
        break;
      case '四君子汤':
        sb.writeln('【兼证加减】');
        sb.writeln('• 兼腹胀：加陈皮（异功散）');
        sb.writeln('• 兼痰湿：加陈皮、半夏（六君子汤）');
        sb.writeln('• 兼食少纳呆：加山楂、神曲');
        sb.writeln('• 兼气滞：加木香、砂仁');
        sb.writeln();
        sb.writeln('【变通用量】');
        sb.writeln('• 病情重：人参可加倍');
        sb.writeln('• 兼湿重：加重茯苓、白术');
        break;
      default:
        sb.writeln('随证加减需根据具体病情决定');
        sb.writeln('建议在中医师指导下进行');
    }
    
    sb.writeln();
    sb.writeln('【重要提醒】');
    sb.writeln('✗ 以上加减仅供学习参考');
    sb.writeln('✗ 实际用药需四诊合参，随证变化');
    sb.writeln('✗ 若症状复杂或加重，请及时就医');
    
    return sb.toString();
  }

  List<Herb> _getAllHerbs() {
    return [
      Herb(
        id: 'herb_001',
        name: '桂枝',
        pinyin: 'guizhi',
        latinName: 'Cinnamomi Ramulus',
        taste: '辛、甘',
        nature: '温',
        meridian: '肺、心、膀胱',
        effect: '发汗解肌、温通经脉、助阳化气',
        indication: '外感风寒表证、胸痹、心悸、闭经、痛经',
        preparation: '生用',
        contraindication: '温热病、阴虚火旺、血热妄行、孕妇慎用',
        usage: '煎服，3-10g',
        dosage: '3-10g',
        famousUse: '倪海厦特别强调：桂枝是复方之魂，能温阳化气，解肌发表。用于太阳病必用桂枝。',
        specialFunction: '在桂枝汤中为君药，温卫阳以解肌祛风',
      ),
      Herb(
        id: 'herb_002',
        name: '白芍',
        pinyin: 'baishao',
        latinName: 'Paeoniae Radix Alba',
        taste: '苦、酸',
        nature: '微寒',
        meridian: '肝、脾',
        effect: '养血敛阴、柔肝止痛、平抑肝阳',
        indication: '血虚萎黄、月经不调、崩漏、盗汗、脘腹疼痛',
        preparation: '炒用',
        contraindication: '阳虚寒盛、腹满者不宜',
        usage: '煎服，6-15g',
        dosage: '6-15g',
        famousUse: '倪海厦重视白芍的养血柔肝之功，认为其能缓急止痛，与桂枝相配调和营卫。',
        specialFunction: '在桂枝汤中为臣药，益阴敛营，与桂枝一散一收，调和营卫',
      ),
      Herb(
        id: 'herb_003',
        name: '甘草',
        pinyin: 'gancao',
        latinName: 'Glycyrrhizae Radix',
        taste: '甘',
        nature: '平',
        meridian: '心、肺、脾、胃',
        effect: '补脾益气、清热解毒、祛痰止咳、缓急止痛、调和诸药',
        indication: '心悸、咳嗽、痰多、脘腹疼痛、疮疡肿毒',
        preparation: '生用或蜜炙',
        contraindication: '湿盛胀满、水肿者慎用。不宜与甘遂、大戟、芫花、海藻同用',
        usage: '煎服，2-10g',
        dosage: '2-10g',
        famousUse: '倪海厦称甘草为"国老"，能调和诸药，缓解药物烈性，使方剂作用平和。',
        specialFunction: '在桂枝汤中为使药，调和诸药，益气和中',
      ),
      Herb(
        id: 'herb_004',
        name: '生姜',
        pinyin: 'shengjiang',
        latinName: 'Zingiberis Rhizoma Recens',
        taste: '辛',
        nature: '微温',
        meridian: '肺、脾、胃',
        effect: '解表散寒、温中止呕、温肺止咳',
        indication: '风寒感冒、胃寒呕吐、肺寒咳嗽',
        preparation: '生用',
        contraindication: '阴虚内热、热盛者慎用',
        usage: '煎服，3-10g，或捣汁服',
        dosage: '3-10g',
        famousUse: '倪海厦指出：生姜辛温发散，能和胃止呕，配合桂枝增强解表之力。',
        specialFunction: '在桂枝汤中为佐药，助桂枝解表，和胃止呕',
      ),
      Herb(
        id: 'herb_005',
        name: '大枣',
        pinyin: 'dazao',
        latinName: 'Jujubae Fructus',
        taste: '甘',
        nature: '温',
        meridian: '脾、胃',
        effect: '补中益气、养血安神',
        indication: '脾虚食少、乏力便溏、妇人脏躁',
        preparation: '生用或炒用',
        contraindication: '湿盛、痰热、胃胀者慎用',
        usage: '劈破煎服，6-15g',
        dosage: '6-15g',
        famousUse: '倪海厦强调：大枣能补益脾胃，顾护正气，防止发散太过伤及正气。',
        specialFunction: '在桂枝汤中为佐药，补益脾胃，助正祛邪',
      ),
      Herb(
        id: 'herb_006',
        name: '麻黄',
        pinyin: 'mahuang',
        latinName: 'Ephedrae Herba',
        taste: '辛、微苦',
        nature: '温',
        meridian: '肺、膀胱',
        effect: '发汗解表、宣肺平喘、利水消肿',
        indication: '风寒感冒、胸闷喘咳、风水浮肿',
        preparation: '生用、蜜炙或捣绒',
        contraindication: '表虚自汗、阴虚盗汗、肺肾虚喘者慎用',
        usage: '煎服，2-10g',
        dosage: '2-10g',
        famousUse: '倪海厦特别强调：麻黄发汗力强，为发汗解表要药，用于太阳伤寒无汗证。',
        specialFunction: '在麻黄汤中为君药，发汗解表，宣肺平喘',
      ),
      Herb(
        id: 'herb_007',
        name: '杏仁',
        pinyin: 'xingren',
        latinName: 'Armeniacae Semen Amarum',
        taste: '苦',
        nature: '微温',
        meridian: '肺、大肠',
        effect: '降气止咳平喘、润肠通便',
        indication: '咳嗽气喘、肠燥便秘',
        preparation: '生用或炒用',
        contraindication: '阴虚咳喘、便溏者慎用。苦杏仁有小毒，用量不宜过大',
        usage: '煎服，5-10g',
        dosage: '5-10g',
        famousUse: '倪海厦指出：杏仁降气平喘，与麻黄一宣一降，恢复肺气宣发肃降功能。',
        specialFunction: '在麻黄汤中为佐药，宣利肺气，止咳平喘',
      ),
      Herb(
        id: 'herb_008',
        name: '柴胡',
        pinyin: 'chaihu',
        latinName: 'Bupleuri Radix',
        taste: '苦、辛',
        nature: '微寒',
        meridian: '肝、胆',
        effect: '疏散退热、疏肝解郁、升举阳气',
        indication: '感冒发热、胸胁胀痛、月经不调、子宫脱垂',
        preparation: '生用或醋炙',
        contraindication: '阴虚火旺、肝阳上亢者慎用',
        usage: '煎服，3-10g',
        dosage: '3-10g',
        famousUse: '倪海厦最重视柴胡，认为其为少阳经要药，能和解少阳，转动枢机。',
        specialFunction: '在小柴胡汤中为君药，升发少阳清气，透邪外出',
      ),
      Herb(
        id: 'herb_009',
        name: '黄芩',
        pinyin: 'huangqin',
        latinName: 'Scutellariae Radix',
        taste: '苦',
        nature: '寒',
        meridian: '肺、胆、脾、大肠、小肠',
        effect: '清热燥湿、泻火解毒、止血、安胎',
        indication: '肺热咳嗽、湿热泻痢、黄疸、痈肿疮毒、胎热不安',
        preparation: '生用、酒炙或炒炭',
        contraindication: '脾胃虚寒、食少便溏者慎用',
        usage: '煎服，3-10g',
        dosage: '3-10g',
        famousUse: '倪海厦强调：黄芩清少阳胆腑郁热，与柴胡配伍一升一降，使少阳枢机得转。',
        specialFunction: '在小柴胡汤中为臣药，清泄少阳胆腑郁热',
      ),
      Herb(
        id: 'herb_010',
        name: '人参',
        pinyin: 'renshen',
        latinName: 'Ginseng Radix et Rhizoma',
        taste: '甘、微苦',
        nature: '平',
        meridian: '脾、肺、心',
        effect: '大补元气、复脉固脱、补脾益肺、生津养血、安神益智',
        indication: '体虚欲脱、脾虚食少、肺虚喘咳、津伤口渴、惊悸失眠',
        preparation: '另煎兑服或研粉吞服',
        contraindication: '实热证、湿热证、正虚邪实证忌用。不宜与藜芦、五灵脂同用',
        usage: '煎服，3-9g',
        dosage: '3-9g',
        famousUse: '倪海厦最喜用红参（炮制后的人参），认为其温补之力更强，用于虚证有良效。',
        specialFunction: '在小柴胡汤中为佐药，益气健脾，扶正祛邪，防止邪气内陷',
      ),
      Herb(
        id: 'herb_011',
        name: '半夏',
        pinyin: 'banxia',
        latinName: 'Pinelliae Rhizoma',
        taste: '辛',
        nature: '温，有毒',
        meridian: '脾、胃、肺',
        effect: '燥湿化痰、降逆止呕、消痞散结',
        indication: '湿痰寒痰、呕吐、心下痞、梅核气',
        preparation: '法半夏、清半夏、姜半夏、生半夏',
        contraindication: '阴虚燥咳、热痰、出血症慎用。不宜与乌头类同用',
        usage: '煎服，3-10g',
        dosage: '3-10g',
        famousUse: '倪海厦指出：半夏能燥湿化痰、和胃降逆，是治疗呕吐的要药。',
        specialFunction: '在小柴胡汤中为佐药，和胃降逆止呕',
      ),
      Herb(
        id: 'herb_012',
        name: '白术',
        pinyin: 'baizhu',
        latinName: 'Atractylodis Macrocephalae Rhizoma',
        taste: '甘、苦',
        nature: '温',
        meridian: '脾、胃',
        effect: '健脾益气、燥湿利水、止汗、安胎',
        indication: '脾虚食少、腹胀泄泻、痰饮、水肿、自汗、胎动不安',
        preparation: '生用或炒用',
        contraindication: '阴虚内热、津伤口渴者慎用',
        usage: '煎服，6-12g',
        dosage: '6-12g',
        famousUse: '倪海厦强调：白术健脾燥湿，是治疗脾虚湿盛的要药，四君子汤中用为臣药。',
        specialFunction: '在四君子汤中为臣药，健脾燥湿，助运中焦',
      ),
      Herb(
        id: 'herb_013',
        name: '茯苓',
        pinyin: 'fuling',
        latinName: 'Poria',
        taste: '甘、淡',
        nature: '平',
        meridian: '心、肺、脾、肾',
        effect: '利水渗湿、健脾宁心',
        indication: '水肿尿少、痰饮眩悸、脾虚食少、便溏泄泻、心悸失眠',
        preparation: '生用',
        contraindication: '阴虚津伤、滑精遗精者慎用',
        usage: '煎服，10-15g',
        dosage: '10-15g',
        famousUse: '倪海厦指出：茯苓利水不伤正气，配合白术能健脾渗湿。',
        specialFunction: '在四君子汤中为佐药，渗湿利水，使补而不滞',
      ),
      Herb(
        id: 'herb_014',
        name: '黄芪',
        pinyin: 'huangqi',
        latinName: 'Astragali Radix',
        taste: '甘',
        nature: '微温',
        meridian: '脾、肺',
        effect: '补气升阳、益卫固表、利水消肿、生津养血、行滞通痹、托毒排脓、敛疮生肌',
        indication: '气虚乏力、食少便溏、中气下陷、久泻脱肛、便血崩漏、表虚自汗',
        preparation: '生用或蜜炙',
        contraindication: '表实邪盛、阴虚阳亢、疮疡初起溃后热毒尚盛者慎用',
        usage: '煎服，9-30g',
        dosage: '9-30g',
        famousUse: '倪海厦最喜用黄芪，认为其补气之力最强，能升阳举陷，用于气虚下陷证有良效。',
        specialFunction: '在补中益气汤中为君药，大补元气，升阳举陷',
      ),
      Herb(
        id: 'herb_015',
        name: '当归',
        pinyin: 'danggui',
        latinName: 'Angelicae Sinensis Radix',
        taste: '甘、辛',
        nature: '温',
        meridian: '肝、心、脾',
        effect: '补血活血、调经止痛、润肠通便',
        indication: '血虚萎黄、月经不调、闭经痛经、癥瘕腹痛、虚寒腹痛、风湿痹痛',
        preparation: '生用或酒炙',
        contraindication: '湿盛中满、大便泄泻、热盛出血、孕妇慎用',
        usage: '煎服，6-12g',
        dosage: '6-12g',
        famousUse: '倪海厦强调：当归补血活血，是治疗血虚的要药，补而不滞。',
        specialFunction: '在补中益气汤中为佐药，补血养血，使气有所附',
      ),
      Herb(
        id: 'herb_016',
        name: '陈皮',
        pinyin: 'chenpi',
        latinName: 'Citri Reticulatae Pericarpium',
        taste: '苦、辛',
        nature: '温',
        meridian: '脾、肺',
        effect: '理气健脾、燥湿化痰',
        indication: '脘腹胀满、食少吐泻、咳嗽痰多',
        preparation: '生用',
        contraindication: '阴虚燥咳、咯血症慎用',
        usage: '煎服，3-10g',
        dosage: '3-10g',
        famousUse: '倪海厦指出：陈皮理气燥湿，能使补药补而不滞，是常用的理气药。',
        specialFunction: '在补中益气汤中为佐药，理气和中，使补而不滞',
      ),
      Herb(
        id: 'herb_017',
        name: '升麻',
        pinyin: 'shengma',
        latinName: 'Cimicifugae Rhizoma',
        taste: '辛、微甘',
        nature: '微寒',
        meridian: '肺、脾、胃、大肠',
        effect: '发表透疹、清热解毒、升举阳气',
        indication: '风热头痛、齿痛、口疮、咽喉肿痛、中气下陷、久泻脱肛',
        preparation: '生用或蜜炙',
        contraindication: '阴虚阳浮、喘咳气逆、麻疹已透者忌用',
        usage: '煎服，3-6g',
        dosage: '3-6g',
        famousUse: '倪海厦强调：升麻升举阳气，能助黄芪升提下陷之中气。',
        specialFunction: '在补中益气汤中为使药，升举阳气，助举下陷之气',
      ),
      Herb(
        id: 'herb_018',
        name: '知母',
        pinyin: 'zhimu',
        latinName: 'Anemarrhenae Rhizoma',
        taste: '苦、甘',
        nature: '寒',
        meridian: '肺、胃、肾',
        effect: '清热泻火、滋阴润燥',
        indication: '热病烦渴、肺热咳嗽、骨蒸潮热、盗汗、内热消渴、肠燥便秘',
        preparation: '生用或盐炙',
        contraindication: '脾虚便溏者不宜用',
        usage: '煎服，6-12g',
        dosage: '6-12g',
        famousUse: '倪海厦指出：知母清热滋阴，用于阴虚发热有良效。',
        specialFunction: '清热滋阴，治气虚发热之本',
      ),
      Herb(
        id: 'herb_019',
        name: '石膏',
        pinyin: 'shigao',
        latinName: 'Gypsum Fibrosum',
        taste: '辛、甘',
        nature: '大寒',
        meridian: '肺、胃',
        effect: '清热泻火、除烦止渴',
        indication: '气分实热、高热烦渴、肺热喘咳、胃火牙痛',
        preparation: '生用，先煎',
        contraindication: '脾胃虚寒、阴虚内热者忌用',
        usage: '煎服，15-60g',
        dosage: '15-60g',
        famousUse: '倪海厦特别强调：石膏为清气分热之首药，用于高热、大汗、大渴、脉洪大四大症。',
        specialFunction: '清泻肺胃气分实热',
      ),
      Herb(
        id: 'herb_020',
        name: '附子',
        pinyin: 'fuzi',
        latinName: 'Aconiti Lateralis Radix Praeparata',
        taste: '辛、甘',
        nature: '大热，有毒',
        meridian: '心、肾、脾',
        effect: '回阳救逆、补火助阳、散寒止痛',
        indication: '亡阳虚脱、肢冷脉微、肾阳虚衰、阳痿宫冷、虚寒吐泻、阴寒水肿',
        preparation: '制用，先煎、久煎',
        contraindication: '阴虚阳亢、热证忌用。孕妇慎用。不宜与半夏、瓜蒌、贝母、白蔹、白及同用',
        usage: '煎服，3-15g',
        dosage: '3-15g',
        famousUse: '倪海厦最重视附子，称其为"回阳救逆第一药"，用于阳虚阴盛、生命垂危之证有起死回生之效。',
        specialFunction: '回阳救逆，补火助阳，散寒止痛',
      ),
    ];
  }
}
