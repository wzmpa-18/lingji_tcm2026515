import '../models/acupuncture_class.dart';
import '../models/acupoint.dart';
import '../models/herb.dart';

class AcupunctureService {
  static final AcupunctureService _instance = AcupunctureService._internal();
  factory AcupunctureService() => _instance;
  AcupunctureService._internal();

  List<AcupunctureClassic> getClassics() {
    return [
      AcupunctureClassic(
        id: 'classic_001',
        name: '黄帝内经',
        dynasty: '战国至西汉',
        author: '托名黄帝',
        description: '现存最早的中医理论典籍',
        content: '''
《黄帝内经》分为《素问》和《灵枢》两部分，是中医学的奠基之作。

《灵枢》又称《针经》，主要论述针灸学理论：
• 九针论述：镵针、员针、鍉针、锋针、铍针、员利针、毫针、长针、大针
• 刺法原则：补泻手法、迎随呼吸
• 穴位理论：井荥输经合五腧穴
• 治疗法则：上病下取、左病右取

《素问》论述阴阳五行、脏腑经络、病因病机、诊法治则。

核心理念："上医治未病"，强调"圣人不治已病治未病"。
''',
        category: '古籍',
      ),
      AcupunctureClassic(
        id: 'classic_002',
        name: '难经',
        dynasty: '东汉',
        author: '秦越人（扁鹊）',
        description: '对《黄帝内经》疑难问题的阐释',
        content: '''
《难经》全称《黄帝八十一难经》，对《内经》进行深入阐释：

• 脉学：独取寸口诊法，寸关尺三部九候
• 经络：奇经八脉的循行和病证
• 腧穴：俞募穴、原穴、下合穴的论述
• 针法：补泻手法的发展和创新

特别强调："望闻问切"四诊合参，针刺"迎而夺之，随而济之"。
''',
        category: '古籍',
      ),
      AcupunctureClassic(
        id: 'classic_003',
        name: '针灸甲乙经',
        dynasty: '魏晋',
        author: '皇甫谧',
        description: '现存最早的针灸学专著',
        content: '''
《针灸甲乙经》是第一部针灸学专著，系统整理了针灸理论：

• 腧穴：记载349个穴位，详细定位
• 主治：每个穴位的主治病证
• 刺灸：针刺深度、艾灸壮数
• 治疗：各科疾病的针灸治疗

奠定了针灸学的学科体系，影响深远。
''',
        category: '古籍',
      ),
      AcupunctureClassic(
        id: 'classic_004',
        name: '针灸大成',
        dynasty: '明代',
        author: '杨继洲',
        description: '集明代以前针灸学之大成',
        content: '''
《针灸大成》是针灸学百科全书：

• 理论：经络、腧穴、针法灸法
• 歌赋：大量针灸歌诀便于记忆
• 医案：名家医案医话
• 图谱：穴位图、经络图

收载《标幽赋》《通玄指要赋》等经典歌赋，是针灸学习必读之作。
''',
        category: '古籍',
      ),
    ];
  }

  List<AcupunctureSchool> getSchools() {
    return [
      AcupunctureSchool(
        id: 'school_001',
        name: '倪海厦针灸',
        description: '倪海厦医师的针灸体系',
        theory: '以《伤寒论》为根基，融合经方思维',
        features: [
          '强调六经辨证配穴',
          '重视特定穴的应用',
          '简化配穴思路',
        ],
        keyPoints: [
          '开四关（合谷、太冲）通调气机',
          '循经取穴与远端取穴结合',
          '重视俞募配穴',
        ],
        techniques: [
          '浅刺得气为要',
          '留针30分钟',
          '配合艾灸温通',
        ],
      ),
      AcupunctureSchool(
        id: 'school_002',
        name: '董氏奇穴',
        description: '董景昌医师创立的独特针灸体系',
        theory: '脏腑别通论、体应针法、对应针法',
        features: [
          '穴位分布特殊，以全息投影为基础',
          '倒马针法、动气针法',
          '治疗病种广泛',
        ],
        keyPoints: [
          '重视穴位全息对应',
          '动气针法即时止痛',
          '倒马针法加强疗效',
        ],
        techniques: [
          '贴骨进针',
          '动气针法',
          '倒马针法',
        ],
      ),
      AcupunctureSchool(
        id: 'school_003',
        name: '十四经正统',
        description: '以十四经为主的传统针灸',
        theory: '经络辨证、循经取穴',
        features: [
          '严格遵循十四经循行',
          '以经穴为主',
          '强调手法操作',
        ],
        keyPoints: [
          '循经取穴',
          '郄穴、募穴的应用',
          '五腧穴的补泻',
        ],
        techniques: [
          '提插捻转',
          '呼吸补泻',
          '迎随补泻',
        ],
      ),
      AcupunctureSchool(
        id: 'school_004',
        name: '子午流注',
        description: '时间针灸学，以气血按时循行为理论',
        theory: '人体气血随时间流注经络脏腑',
        features: [
          '按时间开穴',
          '纳甲法、纳子法',
          '灵龟八法、飞腾八法',
        ],
        keyPoints: [
          '天干地支配经络',
          '五腧穴按时开穴',
          '气血流注规律',
        ],
        techniques: [
          '按时开穴',
          '养子时刻注穴',
          '同宗开穴法',
        ],
      ),
      AcupunctureSchool(
        id: 'school_005',
        name: '灵龟八法',
        description: '八脉交会穴的时间针法',
        theory: '八脉交会穴与九宫八卦的结合',
        features: [
          '八个特效穴配合时间',
          '治疗急症、重症效果好',
          '需要推算开穴时间',
        ],
        keyPoints: [
          '公孙、内关',
          '后溪、申脉',
          '列缺、照海',
          '外关、临泣',
        ],
        techniques: [
          '先开主穴',
          '后开配穴',
          '按九宫八卦推算',
        ],
      ),
      AcupunctureSchool(
        id: 'school_006',
        name: '飞腾八法',
        description: '另一种八脉交会穴的时间针法',
        theory: '以天干配八脉交会穴',
        features: [
          '以天干为主',
          '开穴方法与灵龟不同',
          '同样治疗疑难杂症',
        ],
        keyPoints: [
          '壬时开公孙',
          '配穴随日期变化',
          '十天干循环',
        ],
        techniques: [
          '按天干开穴',
          '配合纳甲法',
          '辨证取穴',
        ],
      ),
    ];
  }

  List<Zibufaluzhu> getZibufaluzhu() {
    return [
      Zibufaluzhu(hour: '子(23-1)', meridian: '胆经', acupoint: '足窍阴', function: '井穴', indication: '胆经实证'),
      Zibufaluzhu(hour: '丑(1-3)', meridian: '肝经', acupoint: '大敦', function: '井穴', indication: '肝经实证'),
      Zibufaluzhu(hour: '寅(3-5)', meridian: '肺经', acupoint: '少商', function: '井穴', indication: '肺经实证'),
      Zibufaluzhu(hour: '卯(5-7)', meridian: '大肠经', acupoint: '商阳', function: '井穴', indication: '大肠经实证'),
      Zibufaluzhu(hour: '辰(7-9)', meridian: '胃经', acupoint: '厉兑', function: '井穴', indication: '胃经实证'),
      Zibufaluzhu(hour: '巳(9-11)', meridian: '脾经', acupoint: '隐白', function: '井穴', indication: '脾经实证'),
      Zibufaluzhu(hour: '午(11-13)', meridian: '心经', acupoint: '少冲', function: '井穴', indication: '心经实证'),
      Zibufaluzhu(hour: '未(13-15)', meridian: '小肠经', acupoint: '少泽', function: '井穴', indication: '小肠经实证'),
      Zibufaluzhu(hour: '申(15-17)', meridian: '膀胱经', acupoint: '至阴', function: '井穴', indication: '膀胱经实证'),
      Zibufaluzhu(hour: '酉(17-19)', meridian: '肾经', acupoint: '涌泉', function: '井穴', indication: '肾经虚证'),
      Zibufaluzhu(hour: '戌(19-21)', meridian: '心包经', acupoint: '中冲', function: '井穴', indication: '心包经实证'),
      Zibufaluzhu(hour: '亥(21-23)', meridian: '三焦经', acupoint: '关冲', function: '井穴', indication: '三焦经实证'),
    ];
  }

  List<BoneMeasurement> getBoneMeasurements() {
    return [
      BoneMeasurement(name: '头面部', location: '前发际至后发际', measurement: '12寸', application: '用于头部纵向定位'),
      BoneMeasurement(name: '胸腹部', location: '两乳头之间', measurement: '8寸', application: '用于胸部横向定位'),
      BoneMeasurement(name: '胸腹部', location: '胸剑联合至脐中', measurement: '8寸', application: '用于腹部纵向定位'),
      BoneMeasurement(name: '背部', location: '大椎至尾椎', measurement: '21椎', application: '用于背部纵向定位'),
      BoneMeasurement(name: '上肢', location: '腋窝横纹至肘横纹', measurement: '9寸', application: '用于上臂定位'),
      BoneMeasurement(name: '上肢', location: '肘横纹至腕横纹', measurement: '12寸', application: '用于前臂定位'),
      BoneMeasurement(name: '下肢', location: '耻骨联合至股骨内上髁', measurement: '18寸', application: '用于大腿定位'),
      BoneMeasurement(name: '下肢', location: '胫骨内侧髁至内踝尖', measurement: '13寸', application: '用于小腿定位'),
      BoneMeasurement(name: '下肢', location: '髂前上棘至膝中', measurement: '19寸', application: '用于大腿外侧定位'),
      BoneMeasurement(name: '同身寸', location: '中指第二节', measurement: '1.5寸', application: '手指同身寸'),
      BoneMeasurement(name: '同身寸', location: '拇指第一节', measurement: '1寸', application: '拇指同身寸'),
      BoneMeasurement(name: '同身寸', location: '食指、中指并拢', measurement: '1.5寸', application: '二指同身寸'),
    ];
  }

  String getMnemonic(String acupointName) {
    final mnemonics = {
      '足三里': '三里膝眼下，三寸两筋间，能消心腹胀，善治胃中寒',
      '合谷': '合谷在虎口，两指歧骨间，头面诸疾此穴针',
      '内关': '内关心胸膈，功能愈心疾，呕吐胃痛皆能止',
      '三阴交': '三阴交在小腿，三寸胫骨旁，妇科男科皆可用',
      '涌泉': '涌泉足心凹，肾经井穴首，昏厥急救用此穴',
      '百会': '百会头顶凹，诸阳之会穴，头晕失眠皆可医',
      '大椎': '大椎颈七椎，热病特效穴，感冒发烧用它灵',
      '关元': '关元脐下三，补肾固本元，虚劳诸疾皆可灸',
      '气海': '气海脐下半，益气助元阳，日常保健常用穴',
      '中脘': '中脘脐上四，胃病特效穴，消化不良用它好',
    };
    return mnemonics[acupointName] ?? '体表标志来定位，结合骨度更准确';
  }

  AIZuoxue generateZuoxue({
    required List<String> symptoms,
    required String pulse,
    required String tongue,
  }) {
    if (symptoms.any((s) => s.contains('头痛') || s.contains('头晕'))) {
      return AIZuoxue(
        disease: '头痛/头晕',
        symptom: '头部不适',
        meridian: '肝经、胆经、督脉',
        mainPoints: ['百会', '太阳', '风池'],
        secondaryPoints: ['合谷', '太冲', '足三里'],
        adjunctPoints: ['根据部位加用：额痛加印堂，巅顶痛加涌泉，侧痛加中渚'],
        principle: '通络止痛，宁心安神',
        explanation: '百会为诸阳之会，太阳、风池祛风通络，合谷太冲开四关调气机。',
      );
    }
    
    if (symptoms.any((s) => s.contains('失眠') || s.contains('多梦'))) {
      return AIZuoxue(
        disease: '失眠',
        symptom: '睡眠障碍',
        meridian: '心经、脾经、肾经',
        mainPoints: ['神门', '内关', '三阴交'],
        secondaryPoints: ['百会', '安眠', '照海'],
        adjunctPoints: ['心脾两虚加心俞、脾俞，心肾不交加太溪、涌泉'],
        principle: '宁心安神，交通心肾',
        explanation: '神门为心经原穴，安眠穴为经外奇穴，二者配合调节睡眠。三阴交健脾养血，照海滋阴安神。',
      );
    }
    
    if (symptoms.any((s) => s.contains('咳嗽') || s.contains('气喘'))) {
      return AIZuoxue(
        disease: '咳嗽/哮喘',
        symptom: '呼吸系统症状',
        meridian: '肺经、脾经、肾经',
        mainPoints: ['列缺', '肺俞', '膻中'],
        secondaryPoints: ['天突', '定喘', '足三里'],
        adjunctPoints: ['风寒加风池、风门，痰多加丰隆，肾虚加肾俞、太溪'],
        principle: '宣肺止咳，化痰平喘',
        explanation: '列缺为肺经络穴，通调肺气。肺俞为肺的背俞穴，膻中为气会，宽胸理气。',
      );
    }
    
    if (symptoms.any((s) => s.contains('胃痛') || s.contains('腹胀'))) {
      return AIZuoxue(
        disease: '胃痛/腹胀',
        symptom: '消化系统症状',
        meridian: '胃经、脾经、任脉',
        mainPoints: ['中脘', '足三里', '内关'],
        secondaryPoints: ['胃俞', '梁丘', '公孙'],
        adjunctPoints: ['寒邪加神阙隔姜灸，饮食伤胃加梁门，肝气犯胃加太冲'],
        principle: '和胃止痛，理气消胀',
        explanation: '中脘为胃的募穴，足三里为胃经合穴，二者配合调理胃肠功能。内关和胃止呕。',
      );
    }
    
    if (symptoms.any((s) => s.contains('腰痛') || s.contains('背痛'))) {
      return AIZuoxue(
        disease: '腰痛/背痛',
        symptom: '腰背部不适',
        meridian: '膀胱经、督脉、肾经',
        mainPoints: ['肾俞', '大肠俞', '委中'],
        secondaryPoints: ['腰阳关', '命门', '阿是穴'],
        adjunctPoints: ['寒湿加腰俞、昆仑，肾虚加太溪，血瘀加膈俞'],
        principle: '通经活络，补肾强腰',
        explanation: '"腰背委中求"，委中为膀胱经合穴，调理腰背。肾俞补肾强腰，腰阳关温通经脉。',
      );
    }
    
    if (symptoms.any((s) => s.contains('月经不调') || s.contains('痛经'))) {
      return AIZuoxue(
        disease: '月经不调/痛经',
        symptom: '妇科症状',
        meridian: '肝经、脾经、任脉',
        mainPoints: ['关元', '三阴交', '血海'],
        secondaryPoints: ['地机', '太冲', '归来'],
        adjunctPoints: ['经前加期门、气海，经后加足三里、脾俞'],
        principle: '调经止痛，活血化瘀',
        explanation: '关元为任脉要穴，三阴交为肝脾肾三经交汇，血海活血化瘀，三穴配合调理月经。',
      );
    }
    
    return AIZuoxue(
      disease: '综合调理',
      symptom: '全身症状',
      meridian: '根据辨证选择',
      mainPoints: ['足三里', '关元', '三阴交'],
      secondaryPoints: ['百会', '内关'],
      adjunctPoints: ['根据具体症状加减'],
      principle: '扶正祛邪，调和阴阳',
      explanation: '足三里为保健要穴，关元补益元气，三阴交健脾养血，综合调理全身气血。',
    );
  }

  List<String> getBodyLayers() {
    return ['皮肤', '筋膜', '肌肉', '骨骼', '脏腑'];
  }

  List<String> getRotationViews() {
    return ['正面', '背面', '侧面左', '侧面右', '上面', '下面'];
  }
}
