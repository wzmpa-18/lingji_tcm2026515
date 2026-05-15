class AppConstants {
  static const String appName = '靈積學堂';
  static const String appNameEn = 'Lingji Academy';
  static const String appVersion = '1.0.0';

  static const String platformLocation = '香港';
  static const String platformEntity = '靈積國際文化有限公司';

  static const String platformSlogan = '弘揚傳統文化 · 傳承國學智慧';
  static const String platformDescription = '中國傳統文化學術交流平台';

  static const String academicDisclaimer = '本平台為中國傳統文化學術交流、國學命理科普、中醫古籍養生學習平台，所有內容僅供學習娛樂交流參考，不構成醫療及人生決策建議';

  static const String medicalDisclaimer = '本平台不具備醫療服務資質，有健康問題請前往正規醫院就診';

  static const int lingjiToYuan = 10;

  static const Map<int, String> memberLevels = {
    0: '免費會員',
    1: '初級會員',
    2: '中級會員',
    3: '高級會員',
    4: '至尊會員',
    5: '金牌會員',
  };

  static const Map<int, double> memberPrices = {
    1: 350.0,
    2: 700.0,
    3: 1000.0,
    4: 2000.0,
    5: 5000.0,
  };

  static const Map<int, int> lingjiBonus = {
    0: 0,
    1: 30,
    2: 60,
    3: 100,
    4: 150,
    5: 200,
  };

  static const Map<int, double> tradeFeeDiscount = {
    0: 1.0,
    1: 0.8,
    2: 0.5,
    3: 0.0,
    4: 0.0,
    5: 0.0,
  };

  static const Map<String, int> lingjiConsumptions = {
    '私聊陌生人': 10,
    '群內艾特全員': 50,
    '帖子置頂': 100,
    '付費諮詢': 200,
    '命理排盤': 100,
    '專業解答打賞': 50,
  };

  static const List<String> freeLingjiActions = [
    '每日簽到',
    '問診記錄',
    '命理排盤',
    '閱讀典籍',
    '基礎社交',
  ];

  static const Map<String, int> lingjiRewards = {
    '有效BUG': 50,
    '校正專業內容': 100,
    '優質建議採納': 200,
    '每日簽到': 5,
    '問診完成': 10,
    '排盤完成': 5,
  };

  static const List<String> socialFeaturesFree = [
    '加好友',
    '加群',
    '私聊',
    '群聊發圖文',
    '互動打賞',
    '付費提問',
    'C2C交易',
    '每日簽到',
    '推廣賺積分',
  ];

  static const List<String> socialFeaturesMid = [
    '基礎社交全部',
    '自建社群',
    '群管理特權',
  ];

  static const List<Map<String, dynamic>> masters = [
    {'id': 'master_1', 'name': '倪海厦', 'dynasty': '現代', 'is_default': true},
    {'id': 'master_2', 'name': '張仲景', 'dynasty': '東漢', 'is_default': true},
    {'id': 'master_3', 'name': '胡希恕', 'dynasty': '現代', 'is_default': false},
    {'id': 'master_4', 'name': '黃煌', 'dynasty': '現代', 'is_default': false},
    {'id': 'master_5', 'name': '李可', 'dynasty': '現代', 'is_default': false},
    {'id': 'master_6', 'name': '曹穎甫', 'dynasty': '近代', 'is_default': false},
    {'id': 'master_7', 'name': '許叔微', 'dynasty': '宋代', 'is_default': false},
    {'id': 'master_8', 'name': '葉天士', 'dynasty': '清代', 'is_default': false},
    {'id': 'master_9', 'name': '吳鞠通', 'dynasty': '清代', 'is_default': false},
    {'id': 'master_10', 'name': '傅青主', 'dynasty': '清代', 'is_default': false},
  ];

  static const List<String> meridians = [
    '手太陰肺經', '手陽明大腸經', '足陽明胃經', '足太陰脾經',
    '手少陰心經', '手太陽小腸經', '足太陽膀胱經', '足少陰腎經',
    '手厥陰心包經', '手少陽三焦經', '足少陽膽經', '足厥陰肝經',
    '任脈', '督脈',
  ];

  static const List<String> pulseTypes = [
    '浮脈', '沉脈', '遲脈', '數脈', '滑脈', '澀脈', '虛脈', '實脈',
    '長脈', '短脈', '洪脈', '微脈', '緊脈', '緩脈', '芤脈', '弦脈',
    '革脈', '牢脈', '濡脈', '弱脈', '散脈', '細脈', '伏脈', '動脈',
    '促脈', '結脈', '代脈', '疾脈',
  ];

  static const List<String> tongueColors = [
    '淡紅舌', '淡白舌', '紅舌', '絳舌', '紫舌', '青舌', '淡紫舌',
  ];

  static const List<String> tongueCoatings = [
    '薄白苔', '白苔', '薄黃苔', '黃苔', '黃膩苔', '灰黑苔', '少苔', '無苔',
  ];

  static const List<String> chartTypes = [
    '四柱八字', '紫微斗數', '奇門遁甲', '六爻', '風水羅盤',
  ];

  static const List<String> tiangan = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
  static const List<String> dizhi = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

  static const List<String> yunNames = [
    '木運', '火運', '土運', '金運', '水運',
  ];

  static const List<String> qiNames = [
    '厥陰風木', '少陰君火', '少陽相火', '太陰濕土', '陽明燥金', '太陽寒水',
  ];

  static const String paymentDescryption = '支持微信支付、支付寶，由香港正規企業資質申請海外商戶通道';
  static const String settlementNote = '資金結算留存香港賬戶，不回流內地個人賬戶';
}

class AffiliateConstants {
  static const String legalDisclaimer = '本推廣體系嚴格遵循香港法例，採用合規二級分銷模式，無層壓式營銷';

  static const double level1CommissionRate = 0.15;
  static const double level2CommissionRate = 0.05;
  static const double maxCommissionLevel = 2;

  static const bool requirePurchaseToPromote = false;
  static const bool requireFeeToPromote = false;

  static const String commissionRules = '零門檻免費註冊即可參與推廣，僅按真實成交訂單計算佣金，無拉人頭獎勵、無層級人頭計酬';
}

class PlatformConfig {
  static const String serverRegion = '香港';
  static const String dataStorage = '香港雲端伺服器';
  static const String backendManagement = '香港後台管理';

  static const bool isHKPlatform = true;
  static const bool脱离内地监管 = true;
}

class LanguageConfig {
  static const String defaultLanguage = 'zh_TW';
  static const List<String> supportedLanguages = ['zh_CN', 'zh_TW', 'en_US'];

  static const Map<String, String> languageNames = {
    'zh_CN': '简体中文',
    'zh_TW': '繁體中文',
    'en_US': 'English',
  };
}
