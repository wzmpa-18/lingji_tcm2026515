import '../models/user.dart';

enum NiHaixiaModule {
  tcmBasics,
 针灸入门,
  经方学习,
  案例分析,
}

class NiHaixiaLesson {
  final String id;
  final String title;
  final String titleEn;
  final String description;
  final String category;
  final String module;
  final String content;
  final String videoUrl;
  final String thumbnailUrl;
  final int duration;
  final String difficulty;
  final String source;
  final List<String> tags;
  final bool isFree;
  final DateTime createdAt;

  NiHaixiaLesson({
    required this.id,
    required this.title,
    required this.titleEn,
    required this.description,
    required this.category,
    required this.module,
    required this.content,
    this.videoUrl = '',
    this.thumbnailUrl = '',
    this.duration = 0,
    this.difficulty = '初級',
    this.source = '倪海厦',
    this.tags = const [],
    this.isFree = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'title_en': titleEn,
    'description': description,
    'category': category,
    'module': module,
    'content': content,
    'video_url': videoUrl,
    'thumbnail_url': thumbnailUrl,
    'duration': duration,
    'difficulty': difficulty,
    'source': source,
    'tags': tags,
    'is_free': isFree,
    'created_at': createdAt.toIso8601String(),
  };
}

class NiHaixiaFourPieceSet {
  static const String moduleName = '倪海厦四件套';
  static const String description = '倪師經典課程，全套永久免費開放';

  static const Map<String, String> modules = {
    'tcm_basics': '天紀學習',
    ' acupuncture_basics': '人紀針灸',
    ' classical_prescriptions': '地紀經方',
    ' case_studies': '案例研討',
  };

  static const List<NiHaixiaLesson> sampleLessons = [
    NiHaixiaLesson(
      id: 'NH001',
      title: '易經概論',
      titleEn: 'Yijing Introduction',
      description: '深入淺出講解易經基礎理論',
      category: '天紀',
      module: 'tcm_basics',
      content: '''
【易經基礎理論】

一、易經起源
易經是我國古代最重要的一部經典，相傳為伏羲氏仰觀天文、俯察地理而作。

二、八卦基礎
乾三連 ☰ 坤三斷 ☷
震仰盂 ☳ 艮覆盌 ☶
離中虛 ☲ 坎中滿 ☵
兌上缺 ☱ 巽下斷 ☴

三、陰陽之道
太極生兩儀，兩儀生四象，四象生八卦。

四、天干地支
十天干：甲乙丙丁戊己庚辛壬癸
十二地支：子丑寅卯辰巳午未申酉戌亥

五、五行生剋
木生火、火生土、土生金、金生水、水生木
木剋土、土剋水、水剋火、火剋金、金剋木
''',
      duration: 3600,
      difficulty: '初級',
      tags: ['易經', '基礎', '陰陽'],
      createdAt: null,
    ),
    NiHaixiaLesson(
      id: 'NH002',
      title: '紫微斗數基礎',
      titleEn: 'Ziwei Basics',
      description: '詳解紫微斗數排盤與基本概念',
      category: '天紀',
      module: 'tcm_basics',
      content: '''
【紫微斗數基礎】

一、紫微斗數起源
紫微斗數為宋代陳希夷所創，與八字合稱兩大命理學。

二、十四主星
紫微、天機、太陽、武曲、天同、廉貞
天府、天相、七殺、破軍、貪狼、巨門
天梁、天府

三、十二宮位
命宮、兄弟宮、夫妻宮、子女宮、財帛宮、疾厄宮
遷移宮、僕役宮、官祿宮、田宅宮、福德宮、父母宮

四、四化原理
化祿、化權、化科、化忌

五、安星法
依農曆生日，依宮位順序安置各星。
''',
      duration: 4200,
      difficulty: '中級',
      tags: ['紫微斗數', '命理', '排盤'],
      createdAt: null,
    ),
    NiHaixiaLesson(
      id: 'NH003',
      title: '針灸大成',
      titleEn: 'Acupuncture Essentials',
      description: '針灸穴位與針法詳解',
      category: '人紀',
      module: ' acupuncture_basics',
      content: '''
【針灸大成精要】

一、針灸原理
針灸源自《黃帝內經》，以經絡學說為基礎，通過刺激穴位調節人體陰陽氣血。

二、十二經脈
手三陰經：肺經、心經、心包經
手三陽經：大腸經、小腸經、三焦經
足三陽經：胃經、膀胱經、膽經
足三陰經：脾經、腎經、肝經

三、奇經八脈
任脈、督脈、衝脈、帶脈、陰蹻脈、陽蹻脈、陰維脈、陽維脈

四、重要穴位
五腧穴：井、滎、輸、經、合
原穴、絡穴、郄穴、募穴、背俞穴

五、針法要點
進針手法、補瀉原則、留針時間
''',
      duration: 5400,
      difficulty: '中級',
      tags: ['針灸', '經絡', '穴位'],
      createdAt: null,
    ),
    NiHaixiaLesson(
      id: 'NH004',
      title: '傷寒論導讀',
      titleEn: 'Shanghan Lun Guide',
      description: '張仲景傷寒論核心內容講解',
      category: '地紀',
      module: ' classical_prescriptions',
      content: '''
【傷寒論導讀】

一、傷寒論概況
東漢張仲景所著，為中醫臨床之祖典。

二、六經辨證
太陽病 → 陽明病 → 少陽病
太陰病 → 少陰病 → 厥陰病

三、太陽病脈證
太陽之為病，脈浮，頭項強痛而惡寒。
桂枝湯：桂枝、芍藥、甘草、生薑、大棗
麻黃湯：麻黃、桂枝、杏仁、甘草

四、陽明病脈證
陽明之為病，胃家實是也。
白虎湯：石膏、知母、甘草、粳米
承氣湯系列：調胃承氣湯、小承氣湯、大承氣湯

五、少陽病脈證
少陽之為病，口苦、咽乾、目眩也。
小柴胡湯：柴胡、黃芩、人參、半夏、甘草、生薑、大棗
''',
      duration: 7200,
      difficulty: '高級',
      tags: ['傷寒論', '經方', '張仲景'],
      createdAt: null,
    ),
    NiHaixiaLesson(
      id: 'NH005',
      title: '金匱要略選讀',
      titleEn: 'Jingui Yaolue Selection',
      description: '金匱要略精選內容解讀',
      category: '地紀',
      module: ' classical_prescriptions',
      content: '''
【金匱要略選讀】

一、金匱要略概況
東漢張仲景所著，與傷寒論並稱中醫臨床經典。

二、臟腑辨證
肝著證、脾約證、心傷證

三、痰飲咳嗽病脈證
苓桂朮甘湯：茯苓、桂枝、白朮、甘草
腎氣丸：乾地黃、山茱萸、山藥、澤瀉、茯苓、丹皮、桂枝、附子

四、婦科病脈證
溫經湯：吳茱萸、當歸、川芎、芍藥、人參、桂枝、阿膠、牡丹皮、生薑、甘草、半夏、麥門冬
當歸芍藥散：當歸、芍藥、川芎、澤瀉、茯苓、白朮

五、雜病脈證
百合病、狐惑病、陰陽毒
''',
      duration: 5400,
      difficulty: '高級',
      tags: ['金匱要略', '經方', '雜病'],
      createdAt: null,
    ),
    NiHaixiaLesson(
      id: 'NH006',
      title: '案例分析：肝癌',
      titleEn: 'Case Study: Liver Cancer',
      description: '倪師臨床案例分析與思路',
      category: '案例',
      module: ' case_studies',
      content: '''
【肝癌案例分析】

一、案例背景
患者性別、年齡、主訴、病史

二、辨證思路
四診合參：
望：面色、舌象
聞：語聲、氣息
問：症狀、生活習慣
切：脈象

三、病因病機
肝病傳脾、木鬱乘土
濕熱蘊結、肝鬱氣滯

四、處方思路
以疏肝理氣、健脾祛濕為主
兼顧清熱解毒、軟堅散結

五、臨床心得
中醫治重症，需膽大心細
重視脾胃功能、固護正氣
''',
      duration: 4800,
      difficulty: '高級',
      tags: ['肝癌', '重症', '臨床'],
      createdAt: null,
    ),
  ];

  static List<NiHaixiaLesson> getLessonsByModule(String module) {
    return sampleLessons.where((l) => l.module == module).toList();
  }

  static List<NiHaixiaLesson> getLessonsByCategory(String category) {
    return sampleLessons.where((l) => l.category == category).toList();
  }

  static NiHaixiaLesson? getLessonById(String id) {
    try {
      return sampleLessons.firstWhere((l) => l.id == id);
    } catch (e) {
      return null;
    }
  }
}

class NiHaixiaService {
  static final NiHaixiaService _instance = NiHaixiaService._internal();
  factory NiHaixiaService() => _instance;
  NiHaixiaService._internal();

  static const bool allContentFree = true;
  static const bool noMembershipRequired = true;

  bool isLessonAccessible(User? user, NiHaixiaLesson lesson) {
    return lesson.isFree || allContentFree;
  }

  bool canAccessRules(User? user) {
    if (user == null) return false;
    return user.memberLevel >= 3;
  }

  List<NiHaixiaLesson> getAllLessons() {
    return NiHaixiaFourPieceSet.sampleLessons;
  }

  List<NiHaixiaLesson> searchLessons(String keyword) {
    return NiHaixiaFourPieceSet.sampleLessons.where((lesson) {
      return lesson.title.contains(keyword) ||
          lesson.titleEn.contains(keyword) ||
          lesson.description.contains(keyword) ||
          lesson.tags.any((tag) => tag.contains(keyword));
    }).toList();
  }

  Map<String, int> getModuleStats() {
    final stats = <String, int>{};
    for (final module in NiHaixiaFourPieceSet.modules.keys) {
      stats[module] = getLessonsByModule(module).length;
    }
    return stats;
  }
}

class FortuneInterpretationLibrary {
  static const Map<String, Map<String, String>> baziInterpretations = {
    '比': {
      'name': '比肩',
      'description': '代表兄弟姐妹、同事朋友、同輩競爭',
      'source': '《淵海子平》',
      'characteristic': '獨立、自主、競爭、固執',
    },
    '劫': {
      'name': '劫財',
      'description': '代表破耗、競爭、剋妻',
      'source': '《淵海子平》',
      'characteristic': '不服輸、講義氣、固執',
    },
    '食': {
      'name': '食神',
      'description': '代表福氣、才華、子女、思想的流露',
      'source': '《淵海子平》',
      'characteristic': '溫和、善良、聰明、有口福',
    },
    '傷': {
      'name': '傷官',
      'description': '代表創意、才華、叛逆、表演',
      'source': '《淵海子平》',
      'characteristic': '聰明、叛逆、有才華、口齒伶俐',
    },
    '財': {
      'name': '正財',
      'description': '代表正當收入、財物、妻子',
      'source': '《淵海子平》',
      'characteristic': '務實、理財、保守、辛勤',
    },
    '才': {
      'name': '偏財',
      'description': '代表意外之財、理財能力',
      'source': '《淵海子平》',
      'characteristic': '大方、慷慨、善交際、理財',
    },
    '官': {
      'name': '正官',
      'description': '代表官運、貴人、丈夫、規矩',
      'source': '《淵海子平》',
      'characteristic': '正直、有責任心、保守、守法',
    },
    '殺': {
      'name': '七殺',
      'description': '代表壓力、權威、意外、災難',
      'source': '《淵海子平》',
      'characteristic': '果斷、有魄力、剛烈、冒險',
    },
    '印': {
      'name': '正印',
      'description': '代表學業、母親、權力、庇護',
      'source': '《淵海子平》',
      'characteristic': '慈悲、包容、善良、有愛心',
    },
    '梟': {
      'name': '偏印',
      'description': '代表繼母、偏門學問、意外',
      'source': '《淵海子平》',
      'characteristic': '敏感、直覺、孤僻、有特殊才能',
    },
  };

  static const Map<String, Map<String, String>> ganzhiCombinations = {
    '甲子': {
      'name': '甲子納音金',
      'description': '納音金，代表始開創、事物之始',
      'source': '《滴天髓》',
      'personality': '心地光明、性情剛毅',
    },
    '乙丑': {
      'name': '乙丑納音金',
      'description': '納音金，代表積累、收藏',
      'source': '《滴天髓》',
      'personality': '穩重、有耐心、保守',
    },
    '丙寅': {
      'name': '丙寅納音火',
      'description': '納音火，代表陽光、積極、主動',
      'source': '《滴天髓》',
      'personality': '熱情、積極、有行動力',
    },
    '丁卯': {
      'name': '丁卯納音火',
      'description': '納音火，代表柔中帶剛',
      'source': '《滴天髓》',
      'personality': '溫柔、敏感、有藝術氣息',
    },
  };

  static String getInterpretation(String shishen) {
    return baziInterpretations[shishen]?['description'] ?? '';
  }

  static String getSource(String shishen) {
    return baziInterpretations[shishen]?['source'] ?? '古籍不詳';
  }

  static String getCharacteristic(String shishen) {
    return baziInterpretations[shishen]?['characteristic'] ?? '';
  }

  static Map<String, String> getCombinationInterpretation(String ganzhi) {
    return ganzhiCombinations[ganzhi] ?? {};
  }
}
