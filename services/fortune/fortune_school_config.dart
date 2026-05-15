import 'package:flutter/material.dart';
import '../models/user.dart';

class FortuneSchoolConfig with ChangeNotifier {
  static final FortuneSchoolConfig _instance = FortuneSchoolConfig._internal();
  factory FortuneSchoolConfig() => _instance;
  FortuneSchoolConfig._internal();

  Map<String, String> _baziSettings = {
    'ganzhi_rule': 'standard',
    'kongwang_rule': 'table',
    'dayun_gender_rule': 'standard',
    'shishen_rule': 'standard',
  };

  Map<String, String> _ziweiSettings = {
    'sizheng_rule': 'wenmo',
    'baiyang_rule': 'wenmo',
    'tianma_rule': 'standard',
    'wenchang_rule': 'standard',
    'mingju_rule': 'standard',
  };

  Map<String, String> _qimenSettings = {
    'method': 'zheng',
    'kongwang_rule': 'standard',
    'jiuxing_rule': 'standard',
    'shouyu_rule': 'standard',
  };

  Map<String, String> _daliurenSettings = {
    'method': 'standard',
    'kongwang_rule': 'standard',
    'liuqin_rule': 'standard',
  };

  Map<String, String> _tiebanSettings = {
    'method': 'standard',
    'base_rule': 'birth',
  };

  Map<String, String> _meihuaSettings = {
    'method': 'standard',
    'dongyao_rule': 'time',
  };

  Map<String, String> get baziSettings => _baziSettings;
  Map<String, String> get ziweiSettings => _ziweiSettings;
  Map<String, String> get qimenSettings => _qimenSettings;
  Map<String, String> get daliurenSettings => _daliurenSettings;
  Map<String, String> get tiebanSettings => _tiebanSettings;
  Map<String, String> get meihuaSettings => _meihuaSettings;

  void setBaziSetting(String key, String value) {
    _baziSettings[key] = value;
    notifyListeners();
  }

  void setZiweiSetting(String key, String value) {
    _ziweiSettings[key] = value;
    notifyListeners();
  }

  void setQimenSetting(String key, String value) {
    _qimenSettings[key] = value;
    notifyListeners();
  }

  void setDaliurenSetting(String key, String value) {
    _daliurenSettings[key] = value;
    notifyListeners();
  }

  void setTiebanSetting(String key, String value) {
    _tiebanSettings[key] = value;
    notifyListeners();
  }

  void setMeihuaSetting(String key, String value) {
    _meihuaSettings[key] = value;
    notifyListeners();
  }

  void resetToDefault() {
    _baziSettings = {
      'ganzhi_rule': 'standard',
      'kongwang_rule': 'table',
      'dayun_gender_rule': 'standard',
      'shishen_rule': 'standard',
    };
    _ziweiSettings = {
      'sizheng_rule': 'wenmo',
      'baiyang_rule': 'wenmo',
      'tianma_rule': 'standard',
      'wenchang_rule': 'standard',
      'mingju_rule': 'standard',
    };
    _qimenSettings = {
      'method': 'zheng',
      'kongwang_rule': 'standard',
      'jiuxing_rule': 'standard',
      'shouyu_rule': 'standard',
    };
    _daliurenSettings = {
      'method': 'standard',
      'kongwang_rule': 'standard',
      'liuqin_rule': 'standard',
    };
    _tiebanSettings = {
      'method': 'standard',
      'base_rule': 'birth',
    };
    _meihuaSettings = {
      'method': 'standard',
      'dongyao_rule': 'time',
    };
    notifyListeners();
  }

  Map<String, dynamic> exportConfig() {
    return {
      'bazi': _baziSettings,
      'ziwei': _ziweiSettings,
      'qimen': _qimenSettings,
      'daliuren': _daliurenSettings,
      'tieban': _tiebanSettings,
      'meihua': _meihuaSettings,
    };
  }
}

class FortuneSchoolOptions {
  static const Map<String, SchoolOption> baziOptions = {
    'ganzhi_rule': SchoolOption(
      key: 'ganzhi_rule',
      name: '乾支起法',
      options: [
        OptionItem(value: 'standard', name: '標準起法', description: '常規五虎遁起月干'),
        OptionItem(value: 'wuxing', name: '五行起法', description: '以五行陰陽起干支'),
        OptionItem(value: 'yijing', name: '易經起法', description: '依易經卦象起干支'),
      ],
    ),
    'kongwang_rule': SchoolOption(
      key: 'kongwang_rule',
      name: '空亡取法',
      options: [
        OptionItem(value: 'table', name: '表準空亡', description: '以六十甲子表查空亡'),
        OptionItem(value: 'yan', name: '瞿曇空亡', description: '古法瞿曇空亡'),
        OptionItem(value: 'yi', name: '易隱空亡', description: '易隱占卜空亡法'),
        OptionItem(value: 'wai', name: '外五行空亡', description: '五行相沖取空亡'),
      ],
    ),
    'dayun_gender_rule': SchoolOption(
      key: 'dayun_gender_rule',
      name: '大運起法',
      options: [
        OptionItem(value: 'standard', name: '標準起運', description: '男陽年順行、陰年逆行'),
        OptionItem(value: 'precise', name: '精算起運', description: '精確計算月日'),
        OptionItem(value: 'wuxing', name: '五行起運', description: '依五行陰陽起運'),
      ],
    ),
  };

  static const Map<String, SchoolOption> ziweiOptions = {
    'sizheng_rule': SchoolOption(
      key: 'sizheng_rule',
      name: '四正起法',
      options: [
        OptionItem(value: 'wenmo', name: '文墨天機', description: '文墨天機派安星法'),
        OptionItem(value: 'tiandao', name: '天道派', description: '天道派紫微起法'),
        OptionItem(value: 'diyi', name: '第一正統', description: '劉文元正統派'),
        OptionItem(value: 'liushen', name: '六神社團', description: '六神社團派'),
      ],
    ),
    'baiyang_rule': SchoolOption(
      key: 'baiyang_rule',
      name: '白陽起法',
      options: [
        OptionItem(value: 'wenmo', name: '文墨白陽', description: '文墨天機白陽安法'),
        OptionItem(value: 'standard', name: '標準白陽', description: '傳統白陽安法'),
        OptionItem(value: 'liushen', name: '六神白陽', description: '六神社團白陽法'),
      ],
    ),
    'sihua_rule': SchoolOption(
      key: 'sihua_rule',
      name: '四化起法',
      options: [
        OptionItem(value: 'keji', name: '科忌法', description: '化科化忌為主'),
        OptionItem(value: 'quanlu', name: '權祿法', description: '化權化祿為主'),
        OptionItem(value: 'standard', name: '標準四化', description: '傳統四化飛星'),
      ],
    ),
    'miaowei_rule': SchoolOption(
      key: 'miaowei_rule',
      name: '廟旺利陷',
      options: [
        OptionItem(value: 'standard', name: '標準廟旺', description: '傳統廟旺表'),
        OptionItem(value: 'liushen', name: '六神社團', description: '六神社團廟旺法'),
        OptionItem(value: 'tianzhuren', name: '天璽仁心', description: '天璽仁心派'),
      ],
    ),
  };

  static const Map<String, SchoolOption> qimenOptions = {
    'method': SchoolOption(
      key: 'method',
      name: '奇門排法',
      options: [
        OptionItem(value: 'zheng', name: '陽盤奇門', description: '傳統陽盤奇門遁甲'),
        OptionItem(value: 'fan', name: '陰盤奇門', description: '陰盤奇門遁甲'),
        OptionItem(value: 'yangyi', name: '陽一派', description: '陽一派奇門'),
        OptionItem(value: 'yinyi', name: '陰一派', description: '陰一派奇門'),
        OptionItem(value: 'wai', name: '外應奇門', description: '外應派奇門'),
      ],
    ),
    'jiuxing_rule': SchoolOption(
      key: 'jiuxing_rule',
      name: '九星起法',
      options: [
        OptionItem(value: 'standard', name: '標準九星', description: '蓬芮沖輔禽心柱任英'),
        OptionItem(value: 'fan', name: '翻卦九星', description: '翻卦法起九星'),
        OptionItem(value: 'wuxing', name: '五行九星', description: '五行起九星'),
      ],
    ),
    'bamen_rule': SchoolOption(
      key: 'bamen_rule',
      name: '八門起法',
      options: [
        OptionItem(value: 'standard', name: '標準八門', description: '休生傷杜景死驚開'),
        OptionItem(value: 'fan', name: '翻卦八門', description: '翻卦法起八門'),
        OptionItem(value: 'wuxing', name: '五行八門', description: '五行起八門'),
      ],
    ),
    'kongwang_rule': SchoolOption(
      key: 'kongwang_rule',
      name: '空亡起法',
      options: [
        OptionItem(value: 'standard', name: '標準空亡', description: '依節氣起空亡'),
        OptionItem(value: 'liunian', name: '流年空亡', description: '依流年起空亡'),
        OptionItem(value: 'wai', name: '外五行', description: '外五行空亡'),
      ],
    ),
    'shensha_rule': SchoolOption(
      key: 'shensha_rule',
      name: '神煞起法',
      options: [
        OptionItem(value: 'standard', name: '標準神煞', description: '傳統奇門神煞'),
        OptionItem(value: 'gufeng', name: '古法神煞', description: '古法奇門神煞'),
        OptionItem(value: 'wenhua', name: '文化神煞', description: '文化派神煞'),
      ],
    ),
  };

  static const Map<String, SchoolOption> daliurenOptions = {
    'method': SchoolOption(
      key: 'method',
      name: '六壬排法',
      options: [
        OptionItem(value: 'standard', name: '標準六壬', description: '大六壬標準排法'),
        OptionItem(value: 'jiayou', name: '甲戊加會', description: '甲戊加會起課法'),
        OptionItem(value: 'yupei', name: '玉培派', description: '玉培派六壬'),
        OptionItem(value: 'fudou', name: '輔斗派', description: '輔斗派六壬'),
      ],
    ),
    'liuqin_rule': SchoolOption(
      key: 'liuqin_rule',
      name: '六親起法',
      options: [
        OptionItem(value: 'standard', name: '標準六親', description: '依干支起六親'),
        OptionItem(value: 'wuxing', name: '五行六親', description: '五行起六親'),
      ],
    ),
  };
}

class SchoolOption {
  final String key;
  final String name;
  final List<OptionItem> options;

  const SchoolOption({
    required this.key,
    required this.name,
    required this.options,
  });
}

class OptionItem {
  final String value;
  final String name;
  final String description;

  const OptionItem({
    required this.value,
    required this.name,
    required this.description,
  });
}

class FortuneRuleTutorial {
  final String id;
  final String category;
  final String title;
  final String titleCn;
  final String content;
  final String source;
  final String ruleJue;
  final String memorySong;
  final String principle;
  final bool isPremium;

  const FortuneRuleTutorial({
    required this.id,
    required this.category,
    required this.title,
    required this.titleCn,
    required this.content,
    required this.source,
    this.ruleJue = '',
    this.memorySong = '',
    this.principle = '',
    this.isPremium = true,
  });

  static const List<FortuneRuleTutorial> baziRules = [
    FortuneRuleTutorial(
      id: 'BAZI001',
      category: '八字',
      title: '五虎遁',
      titleCn: '月干起法',
      source: '《淵海子平》',
      memorySong: '甲己之年丙作首，乙庚之歲戊為頭，丙辛必定從庚起，丁壬壬位順行流，戊癸之年何方發，甲寅之上好追求。',
      principle: '''
【五虎遁原理】

五虎遁是起月干的方法，因為正月必是虎月，所以稱為五虎遁。

歌诀解讀：
甲己年起丙寅月
乙庚年起戊寅月
丙辛年起庚寅月
丁壬年起壬寅月
戊癸年起甲寅月

原理：
甲己合化土，土生金，所以甲己年正月從丙起
乙庚合化金，金生水，所以乙庚年正月從戊起
丙辛合化水，水生木，所以丙辛年正月從庚起
丁壬合化木，木生火，所以丁壬年正月從壬起
戊癸合化火，火生土，所以戊癸年正月從甲起
''',
    ),
    FortuneRuleTutorial(
      id: 'BAZI002',
      category: '八字',
      title: '五鼠遁',
      titleCn: '時干起法',
      source: '《淵海子平》',
      memorySong: '甲己還生甲，乙庚丙作初，丙辛從戊起，丁壬庚子居，戊癸何方發，壬子是無疑。',
      principle: '''
【五鼠遁原理】

五鼠遁是起時干的方法，因為子時必是鼠時，所以稱為五鼠遁。

歌诀解讀：
甲己日子時起甲
乙庚日子時起丙
丙辛日子時起戊
丁壬日子時起庚
戊癸日子時起壬

原理：
甲己日合化土，土生金，金生水，水生木，所以甲己日子時從甲起
其余同理。
''',
    ),
    FortuneRuleTutorial(
      id: 'BAZI003',
      category: '八字',
      title: '空亡',
      titleCn: '虛空之象',
      source: '《胎微經》',
      memorySong: '甲子旬中無戌亥，甲戌旬中無申酉，甲申旬中無午未，甲午旬中無辰巳，甲辰旬中無寅卯，甲寅旬中無子丑。',
      principle: '''
【空亡原理】

空亡是八字中重要的概念，代表暫時不顯現或力量不足。

表準空亡查法：
甲子旬：空戌、亥
甲戌旬：空申、酉
甲申旬：空午、未
甲午旬：空辰、巳
甲辰旬：空寅、卯
甲寅旬：空子、丑

瞿曇空亡：
另有瞿曇空亡法，與表準空亡略有不同。

應用：
1. 空亡的五行力量減弱
2. 空亡的宮位感情或財運不實
3. 填實或出空時應事
''',
    ),
  ];

  static const List<FortuneRuleTutorial> ziweiRules = [
    FortuneRuleTutorial(
      id: 'ZIWEI001',
      category: '紫微斗數',
      title: '安紫微星',
      titleCn: '紫微星安置法',
      source: '《紫微斗數全書》',
      memorySong: '紫微天府各依垣，丁乙戊庚辛壬循，貪狼巨門天機是，太陰文曲兼天同。',
      principle: '''
【紫微星安星原理】

紫微星是紫微斗數的主星，其位置決定整張命盤的基礎格局。

基本原則：
紫微星根據年和月支來安置

口诀：
甲乙丙丁戊己庚辛壬癸
子丑寅卯辰巳午未申酉戌亥

具體查法：
年生月落垣宮：
甲年生寅宮
乙年生卯宮
丙年生辰宮
丁年生巳宮
戊年生午宮
己年生未宮
庚年生申宮
辛年生酉宮
壬年生戌宮
癸年生亥宮

然後依月份遞加逆行。
''',
    ),
  ];

  static const List<FortuneRuleTutorial> qimenRules = [
    FortuneRuleTutorial(
      id: 'QIMEN001',
      category: '奇門遁甲',
      title: '陽遁',
      titleCn: '冬至陽遁起局',
      source: '《煙波釣叟歌》',
      memorySong: '冬至一七四，小寒二八五，大寒三九六，立春八五二，雨水九六三，驚蟄正二八，春分三九六，清明四一七，穀雨五四八，立夏四一七，小滿五二八，芒種六三九。',
      principle: '''
【陽遁原理】

陽遁用於冬至到夏至期間，此時陽氣漸長。

九宮飛泊：
陽遁順行，即從坎一宮開始，按數字順序飛行。

起局步驟：
1. 根據節氣確定上元、中元、下元
2. 根據日干支確定陽遁或陰遁
3. 陽遁從坎一宮起，按數字順序飛布九宮
4. 陰遁從離九宮起，按數字逆序飛布

口诀記憶：
冬至一七四 → 冬至節上元用一宮，中元用七宮，下元用四宮
其余節氣同理。
''',
    ),
    FortuneRuleTutorial(
      id: 'QIMEN002',
      category: '奇門遁甲',
      title: '八門',
      titleCn: '八門吉凶',
      source: '《奇門遁甲》',
      memorySong: '休門生門及開門，此三吉門永遠通，驚門傷門與杜門，死門景門皆屬凶。',
      principle: '''
【八門原理】

八門代表人事狀態，分別是：
休門、生門、傷門、杜門、景門、死門、驚門、開門

吉門：
休門：休閒、休息、贵人
生門：生財、產業、富裕
開門：事業、開拓、貴人

凶門：
傷門：傷災、競爭、破財
杜門：堵塞、保密、技術
景門：文書、口舌、視覺
死門：死亡、固執、凶事
驚門：驚恐、口舌是非

八門加臨：
八門根據時干和值使門加臨到九宮。
''',
    ),
  ];

  static List<FortuneRuleTutorial> getRulesByCategory(String category) {
    switch (category) {
      case '八字':
      case '四柱':
        return baziRules;
      case '紫微斗數':
      case '紫微':
        return ziweiRules;
      case '奇門遁甲':
      case '奇門':
        return qimenRules;
      default:
        return [...baziRules, ...ziweiRules, ...qimenRules];
    }
  }

  bool canAccess(User? user, FortuneRuleTutorial rule) {
    if (!rule.isPremium) return true;
    if (user == null) return false;
    return user.memberLevel >= 3;
  }
}

class FortuneAccessControl {
  static bool canAccessFreeFeatures(User? user) => true;

  static bool canAccessBasicChart(User? user) => true;

  static bool canAccessAdvancedInterpretation(User? user) {
    if (user == null) return false;
    return user.memberLevel >= 1;
  }

  static bool canAccessRuleTutorial(User? user) {
    if (user == null) return false;
    return user.memberLevel >= 3;
  }

  static bool canAccessNiHaixiaModule(User? user) => true;

  static bool canAccessAllSchools(User? user) {
    if (user == null) return false;
    return user.memberLevel >= 2;
  }

  static bool canCustomizeSchool(User? user) {
    if (user == null) return false;
    return user.memberLevel >= 2;
  }

  static String getAccessMessage(int requiredLevel) {
    switch (requiredLevel) {
      case 1:
        return '需要初級會員以上';
      case 2:
        return '需要中級會員以上';
      case 3:
        return '需要高級會員以上';
      case 4:
        return '需要至尊會員';
      case 5:
        return '需要金牌會員';
      default:
        return '權限不足';
    }
  }
}
