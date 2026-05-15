class DongAcupoint {
  final String id;
  final String name;
  final String nameEn;
  final String namePinyin;
  final String region;
  final DongRegion mainRegion;
  final String location;
  final String locationDescription;
  final String indication;
  final List<String> indications;
  final String needleAngle;
  final String needleDepth;
  final String manipulation;
  final String reinforcementReduction;
  final String qiArrival;
  final String clinicalApplication;
  final String mingLiConnection;
  final List<String> pairedAcupoints;
  final List<String> formulas;
  final String notes;
  final List<String> sourceReferences;
  final String imageUrl;
  final String videoUrl;
  final Map<String, String> languageNames;

  const DongAcupoint({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.namePinyin,
    required this.region,
    required this.mainRegion,
    required this.location,
    required this.locationDescription,
    required this.indication,
    required this.indications,
    required this.needleAngle,
    required this.needleDepth,
    required this.manipulation,
    required this.reinforcementReduction,
    required this.qiArrival,
    required this.clinicalApplication,
    required this.mingLiConnection,
    this.pairedAcupoints = const [],
    this.formulas = const [],
    this.notes = '',
    this.sourceReferences = const [],
    this.imageUrl = '',
    this.videoUrl = '',
    this.languageNames = const {},
  });
}

enum DongRegion {
  head,
  face,
  neck,
  chest,
  back,
  abdomen,
  armUpper,
  armLower,
  hand,
  legUpper,
  legLower,
  foot,
}

extension DongRegionExtension on DongRegion {
  String get name {
    switch (this) {
      case DongRegion.head:
        return '頭部';
      case DongRegion.face:
        return '面部';
      case DongRegion.neck:
        return '頸部';
      case DongRegion.chest:
        return '胸部';
      case DongRegion.back:
        return '背部';
      case DongRegion.abdomen:
        return '腹部';
      case DongRegion.armUpper:
        return '上臂';
      case DongRegion.armLower:
        return '前臂';
      case DongRegion.hand:
        return '手部';
      case DongRegion.legUpper:
        return '大腿';
      case DongRegion.legLower:
        return '小腿';
      case DongRegion.foot:
        return '足部';
    }
  }

  String get nameEn {
    switch (this) {
      case DongRegion.head:
        return 'Head';
      case DongRegion.face:
        return 'Face';
      case DongRegion.neck:
        return 'Neck';
      case DongRegion.chest:
        return 'Chest';
      case DongRegion.back:
        return 'Back';
      case DongRegion.abdomen:
        return 'Abdomen';
      case DongRegion.armUpper:
        return 'Upper Arm';
      case DongRegion.armLower:
        return 'Forearm';
      case DongRegion.hand:
        return 'Hand';
      case DongRegion.legUpper:
        return 'Thigh';
      case DongRegion.legLower:
        return 'Lower Leg';
      case DongRegion.foot:
        return 'Foot';
    }
  }

  String get pinyin {
    switch (this) {
      case DongRegion.head:
        return 'tóubù';
      case DongRegion.face:
        return 'miànbù';
      case DongRegion.neck:
        return 'jǐngbù';
      case DongRegion.chest:
        return 'xiōngbù';
      case DongRegion.back:
        return 'bèibù';
      case DongRegion.abdomen:
        return 'fùbù';
      case DongRegion.armUpper:
        return 'shàngbì';
      case DongRegion.armLower:
        return 'qiánbì';
      case DongRegion.hand:
        return 'shǒubù';
      case DongRegion.legUpper:
        return 'dàtuǐ';
      case DongRegion.legLower:
        return 'xiǎotuǐ';
      case DongRegion.foot:
        return 'zúbù';
    }
  }
}

class DongAcupointCollection {
  static const List<DongAcupoint> dongPoints = [
    DongAcupoint(
      id: 'dong_001',
      name: '肩五穴',
      nameEn: 'Jian Wu Xue',
      namePinyin: 'Jiān Wǔ Xué',
      region: '肩背部',
      mainRegion: DongRegion.back,
      location: '肩峰後側，當肩髃穴向後凹陷中',
      locationDescription: '位於肩關節後側，肩髃穴向後一寸凹陷中',
      indication: '肩周炎、肩背痛、手不能舉',
      indications: ['肩周炎', '肩背疼痛', '手臂麻木', '頸椎病'],
      needleAngle: '直刺或斜刺',
      needleDepth: '0.5-1.5寸',
      manipulation: '提插捻轉，強刺激',
      reinforcementReduction: '瀉法為主',
      qiArrival: '局部酸脹或有麻電感向下放射',
      clinicalApplication: '治療五十肩、肩關節周圍炎特效穴，配合足千金五金更佳',
      mingLiConnection: '與坤卦相應，治脾虛濕盛之肩痛',
      pairedAcupoints: ['足千金', '五金', '陽陵泉'],
      formulas: ['肩五穴配足千金五金方'],
      sourceReferences: ['董氏奇穴正宗', '丘雅昌董氏奇穴講座'],
      notes: '孕婦慎用',
    ),
    DongAcupoint(
      id: 'dong_002',
      name: '足千金',
      nameEn: 'Zu Qian Jin',
      namePinyin: 'Zú Qiān Jīn',
      region: '小腿部',
      mainRegion: DongRegion.legLower,
      location: '腓骨外側，陽陵泉穴直下2寸',
      locationDescription: '位於小腿外側，腓骨小頭前下方，陽陵泉穴直下2寸處',
      indication: '急性腰痛、坐骨神經痛、腿痛',
      indications: ['急性腰痛', '坐骨神經痛', '腿痛', '膝關節炎', '腳踝扭傷'],
      needleAngle: '直刺',
      needleDepth: '1-2寸',
      manipulation: '大幅度捻轉',
      reinforcementReduction: '瀉法',
      qiArrival: '酸麻脹感向下放射至足',
      clinicalApplication: '治一切急性腰痛特效，配合五金效果更佳',
      mingLiConnection: '屬金，瀉肝木之氣，治肝氣鬱結腰痛',
      pairedAcupoints: ['五金', '陽陵泉', '委中'],
      formulas: ['足千金五金湯針法'],
      sourceReferences: ['董氏奇穴正宗', '丘雅昌董氏奇穴講座'],
      notes: '孕婦禁用',
    ),
    DongAcupoint(
      id: 'dong_003',
      name: '五金',
      nameEn: 'Wu Jin',
      namePinyin: 'Wǔ Jīn',
      region: '小腿部',
      mainRegion: DongRegion.legLower,
      location: '足千金穴直下2寸',
      locationDescription: '位於小腿外側，足千金穴直下2寸處',
      indication: '急性腰痛、肩背痛',
      indications: ['急性腰痛', '肩背痛', '咽喉腫痛', '甲狀腺腫'],
      needleAngle: '直刺',
      needleDepth: '1-2寸',
      manipulation: '提插捻轉',
      reinforcementReduction: '平補平瀉',
      qiArrival: '酸脹感向下放射',
      clinicalApplication: '加強千金穴效果，治急性腰背痛常用配穴',
      mingLiConnection: '加強金氣，肅降肺氣',
      pairedAcupoints: ['足千金', '陽陵泉'],
      formulas: ['五金配千金方'],
      sourceReferences: ['董氏奇穴正宗'],
      notes: '',
    ),
    DongAcupoint(
      id: 'dong_004',
      name: '靈骨',
      nameEn: 'Ling Gu',
      namePinyin: 'Líng Gǔ',
      region: '手背部',
      mainRegion: DongRegion.hand,
      location: '第一、二掌骨結合處微前方凹陷中',
      locationDescription: '位於手背拇指與食指歧骨間，第一掌骨與第二掌骨結合部微前方凹陷處',
      indication: '坐骨神經痛、腰痛、腹痛、婦科病',
      indications: ['坐骨神經痛', '腰痛', '腹痛', '月經失調', '不孕', '頭痛', '眩暈'],
      needleAngle: '直刺，透向后溪方向',
      needleDepth: '1-2寸',
      manipulation: '大幅度捻轉，強刺激',
      reinforcementReduction: '瀉法',
      qiArrival: '強烈酸麻脹感',
      clinicalApplication: '為董氏第一要穴，治坐骨神經痛特效，配合大白更佳',
      mingLiConnection: '通督脈，調腎氣，治命門火衰',
      pairedAcupoints: ['大白', '後溪', '腕順'],
      formulas: ['靈骨大白方', '靈骨配伍方'],
      sourceReferences: ['董氏奇穴正宗', '丘雅昌董氏奇穴講座', '董氏針灸大成'],
      notes: '孕婦禁針',
    ),
    DongAcupoint(
      id: 'dong_005',
      name: '大白',
      nameEn: 'Da Bai',
      namePinyin: 'Dà Bái',
      region: '手背部',
      mainRegion: DongRegion.hand,
      location: '第二掌骨小頭橈側凹陷中',
      locationDescription: '位於手背第二掌骨小頭橈側凹陷處，握拳取穴',
      indication: '坐骨神經痛、腰痛、腹痛、小兒發熱',
      indications: ['坐骨神經痛', '腰痛', '腹痛', '發熱', '咳嗽', '哮喘'],
      needleAngle: '斜刺，針尖向腕部',
      needleDepth: '0.5-1寸',
      manipulation: '捻轉加強',
      reinforcementReduction: '瀉法',
      qiArrival: '局部酸脹',
      clinicalApplication: '為靈骨之配穴，治坐骨神經痛常用',
      mingLiConnection: '大腸經穴，通調肺氣',
      pairedAcupoints: ['靈骨', '後溪'],
      formulas: ['靈骨大白方'],
      sourceReferences: ['董氏奇穴正宗', '丘雅昌董氏奇穴講座'],
      notes: '',
    ),
    DongAcupoint(
      id: 'dong_006',
      name: '重子穴',
      nameEn: 'Zhong Zi',
      namePinyin: 'Zhòng Zǐ',
      region: '手背部',
      mainRegion: DongRegion.hand,
      location: '虎口下約一寸，第一掌骨與第二掌骨間',
      locationDescription: '位於手背面，第一掌骨與第二掌骨之間，虎口下約一寸處',
      indication: '感冒、咳嗽、氣喘、肩背痛',
      indications: ['感冒', '咳嗽', '氣喘', '肩背痛', '咽喉炎', '鼻炎'],
      needleAngle: '斜刺，針尖向上',
      needleDepth: '0.5-1.5寸',
      manipulation: '捻轉瀉法',
      reinforcementReduction: '瀉法',
      qiArrival: '酸脹感向上傳導',
      clinicalApplication: '治感冒咳嗽特效穴，配重仙效果更佳',
      mingLiConnection: '肺經所過，調理肺氣',
      pairedAcupoints: ['重仙', '曲池', '合谷'],
      formulas: ['感冒咳嗽方'],
      sourceReferences: ['董氏奇穴正宗', '丘雅昌董氏奇穴講座'],
      notes: '',
    ),
    DongAcupoint(
      id: 'dong_007',
      name: '重仙穴',
      nameEn: 'Zhong Xian',
      namePinyin: 'Zhòng Xiān',
      region: '手背部',
      mainRegion: DongRegion.hand,
      location: '靈骨穴下1寸',
      locationDescription: '位於手背面，靈骨穴下1寸處',
      indication: '感冒、咳嗽、氣喘、肩背痛',
      indications: ['感冒', '咳嗽', '氣喘', '肩背痛', '肺炎'],
      needleAngle: '斜刺',
      needleDepth: '0.5-1寸',
      manipulation: '捻轉',
      reinforcementReduction: '瀉法',
      qiArrival: '酸脹感',
      clinicalApplication: '加強重子穴效果，治肺系疾病',
      mingLiConnection: '配合靈骨調補肺氣',
      pairedAcupoints: ['重子穴', '靈骨'],
      formulas: ['重子重仙方'],
      sourceReferences: ['董氏奇穴正宗'],
      notes: '',
    ),
    DongAcupoint(
      id: 'dong_008',
      name: '心門穴',
      nameEn: 'Xin Men',
      namePinyin: 'Xīn Mén',
      region: '手臂部',
      mainRegion: DongRegion.armLower,
      location: '尺骨鷹嘴下2寸',
      locationDescription: '位於前臂尺側，尺骨鷹嘴突下2寸處',
      indication: '心臟病、胸悶、胸痛、心悸',
      indications: ['心臟病', '胸悶', '胸痛', '心悸', '心律不整', '心絞痛'],
      needleAngle: '直刺',
      needleDepth: '0.5-1寸',
      manipulation: '輕度捻轉',
      reinforcementReduction: '補法為主',
      qiArrival: '心胸部舒適感',
      clinicalApplication: '治心臟疾病常用穴，配合心常穴更佳',
      mingLiConnection: '心經循行，調理心氣心血',
      pairedAcupoints: ['心常穴', '內關'],
      formulas: ['心臟保養方'],
      sourceReferences: ['董氏奇穴正宗', '丘雅昌董氏奇穴講座'],
      notes: '心臟病患者慎用強刺激',
    ),
    DongAcupoint(
      id: 'dong_009',
      name: '木枝穴',
      nameEn: 'Mu Zhi',
      namePinyin: 'Mù Zhī',
      region: '小腿部',
      mainRegion: DongRegion.legLower,
      location: '小腿內側，脛骨內側髁下3寸',
      locationDescription: '位於小腿內側，脛骨內側髁下方3寸處',
      indication: '肝膽疾病、脅痛、口苦',
      indications: ['肝炎', '膽囊炎', '脅痛', '口苦', '黃疸', '眩暈'],
      needleAngle: '直刺',
      needleDepth: '1-1.5寸',
      manipulation: '捻轉瀉法',
      reinforcementReduction: '瀉法',
      qiArrival: '局部酸脹',
      clinicalApplication: '治肝膽濕熱證',
      mingLiConnection: '肝經所過，疏肝利膽',
      pairedAcupoints: ['肝門穴', '膽穴'],
      formulas: ['肝膽調理方'],
      sourceReferences: ['董氏奇穴正宗'],
      notes: '',
    ),
    DongAcupoint(
      id: 'dong_010',
      name: '天皇穴',
      nameEn: 'Tian Huang',
      namePinyin: 'Tiān Huáng',
      region: '小腿部',
      mainRegion: DongRegion.legLower,
      location: '脛骨頭內側凹陷中',
      locationDescription: '位於小腿內側，脛骨內側髁頭部下凹陷處',
      indication: '腎虛腰痛、陽痿、遺精、不孕',
      indications: ['腎虛腰痛', '陽痿', '遺精', '不孕', '月經失調', '耳鳴'],
      needleAngle: '直刺',
      needleDepth: '1-2寸',
      manipulation: '輕度捻轉',
      reinforcementReduction: '補法',
      qiArrival: '酸脹感向膝部放射',
      clinicalApplication: '治腎虛諸證常用穴',
      mingLiConnection: '腎經所過，補腎填精',
      pairedAcupoints: ['腎關穴', '水金穴'],
      formulas: ['補腎壯陽方'],
      sourceReferences: ['董氏奇穴正宗', '丘雅昌董氏奇穴講座'],
      notes: '孕婦慎用',
    ),
    DongAcupoint(
      id: 'dong_011',
      name: '腎關穴',
      nameEn: 'Shen Guan',
      namePinyin: 'Shèn Guān',
      region: '小腿部',
      mainRegion: DongRegion.legLower,
      location: '天皇穴直下1.5寸',
      locationDescription: '位於小腿內側，天皇穴直下1.5寸處',
      indication: '腎虛腰痛、陽痿、遺尿',
      indications: ['腎虛腰痛', '陽痿', '遺尿', '尿頻', '夜尿', '水腫'],
      needleAngle: '直刺或斜刺',
      needleDepth: '1-2寸',
      manipulation: '捻轉補法',
      reinforcementReduction: '補法',
      qiArrival: '酸脹感',
      clinicalApplication: '配合天皇穴治腎虛',
      mingLiConnection: '補腎益精',
      pairedAcupoints: ['天皇穴', '水分穴'],
      formulas: ['補腎方'],
      sourceReferences: ['董氏奇穴正宗'],
      notes: '',
    ),
    DongAcupoint(
      id: 'dong_012',
      name: '光明穴',
      nameEn: 'Guang Ming',
      namePinyin: 'Guāng Míng',
      region: '小腿部',
      mainRegion: DongRegion.legLower,
      location: '內踝尖上4寸，脛骨內側',
      locationDescription: '位於小腿內側，內踝尖上4寸處',
      indication: '眼疾、視力模糊、夜盲',
      indications: ['近視', '遠視', '視力模糊', '夜盲', '目赤腫痛', '青光眼'],
      needleAngle: '直刺',
      needleDepth: '1-1.5寸',
      manipulation: '輕度刺激',
      reinforcementReduction: '平補平瀉',
      qiArrival: '局部酸脹',
      clinicalApplication: '治眼疾常用穴',
      mingLiConnection: '膽經穴，清肝明目',
      pairedAcupoints: ['木穴', '睛明穴'],
      formulas: ['明目方'],
      sourceReferences: ['董氏奇穴正宗'],
      notes: '',
    ),
    DongAcupoint(
      id: 'dong_013',
      name: '上三黃',
      nameEn: 'Shang San Huang',
      namePinyin: 'Shàng Sān Huáng',
      region: '大腿部',
      mainRegion: DongRegion.legUpper,
      location: '大腿前側，肝經循行線上',
      locationDescription: '明黃穴、其黃穴、木黃穴三穴總稱，位於大腿前側',
      indication: '肝膽疾病、脅痛、肝炎',
      indications: ['肝炎', '肝硬化', '膽囊炎', '脅痛', '黃疸'],
      needleAngle: '直刺',
      needleDepth: '2-3寸',
      manipulation: '大幅度捻轉',
      reinforcementReduction: '瀉法',
      qiArrival: '酸脹感向上傳導',
      clinicalApplication: '治肝膽重症要穴',
      mingLiConnection: '肝經所主，瀉肝膽濕熱',
      pairedAcupoints: ['木枝穴', '肝門穴'],
      formulas: ['上三黃瀉肝方'],
      sourceReferences: ['董氏奇穴正宗', '丘雅昌董氏奇穴講座'],
      notes: '體弱者慎用',
    ),
    DongAcupoint(
      id: 'dong_014',
      name: '通背穴',
      nameEn: 'Tong Bei',
      namePinyin: 'Tōng Bèi',
      region: '肩背部',
      mainRegion: DongRegion.back,
      location: '肩胛骨上，秉風穴內側',
      locationDescription: '位於肩背部，肩胛骨上緣，秉風穴內側凹陷處',
      indication: '肩背痛、五十肩、手臂麻木',
      indications: ['肩背痛', '五十肩', '手臂麻木', '頸椎病', '落枕'],
      needleAngle: '直刺或斜刺',
      needleDepth: '0.5-1.5寸',
      manipulation: '提插捻轉',
      reinforcementReduction: '瀉法',
      qiArrival: '酸脹感向前胸放射',
      clinicalApplication: '治肩背痛特效',
      mingLiConnection: '大腸經循行，調理肩背',
      pairedAcupoints: ['肩五穴', '陽陵泉'],
      formulas: ['肩背康復方'],
      sourceReferences: ['董氏奇穴正宗'],
      notes: '',
    ),
    DongAcupoint(
      id: 'dong_015',
      name: '通胃穴',
      nameEn: 'Tong Wei',
      namePinyin: 'Tōng Wèi',
      region: '大腿部',
      mainRegion: DongRegion.legUpper,
      location: '大腿前側，胃經循行線上',
      locationDescription: '位於大腿前側，胃經與脾經之間',
      indication: '胃病、腹痛、消化不良',
      indications: ['胃炎', '胃痛', '腹痛', '消化不良', '嘔吐', '腹瀉'],
      needleAngle: '直刺',
      needleDepth: '1-2寸',
      manipulation: '輕度刺激',
      reinforcementReduction: '平補平瀉',
      qiArrival: '腹部舒適感',
      clinicalApplication: '治胃腸疾病常用',
      mingLiConnection: '脾胃經之間，調理脾胃',
      pairedAcupoints: ['四花穴', '門金穴'],
      formulas: ['胃腸調理方'],
      sourceReferences: ['董氏奇穴正宗'],
      notes: '',
    ),
    DongAcupoint(
      id: 'dong_016',
      name: '腕順穴組',
      nameEn: 'Wan Shun',
      namePinyin: 'Wàn Shùn',
      region: '手腕部',
      mainRegion: DongRegion.hand,
      location: '手腕尺側，腕豆骨旁',
      locationDescription: '腕順一穴、腕順二穴位於手腕尺側，腕豆骨旁開處',
      indication: '腎虛腰痛、坐骨神經痛、耳鳴',
      indications: ['腎虛腰痛', '坐骨神經痛', '耳鳴', '聽力減退', '頸椎病'],
      needleAngle: '斜刺，針尖向上',
      needleDepth: '0.5-1寸',
      manipulation: '捻轉',
      reinforcementReduction: '補法',
      qiArrival: '酸脹感向上傳導',
      clinicalApplication: '治腎虛及督脈病症',
      mingLiConnection: '通督脈，補腎填精',
      pairedAcupoints: ['靈骨大白', '後溪'],
      formulas: ['腕順壯腰方'],
      sourceReferences: ['董氏奇穴正宗', '丘雅昌董氏奇穴講座'],
      notes: '',
    ),
    DongAcupoint(
      id: 'dong_017',
      name: '小節穴',
      nameEn: 'Xiao Jie',
      namePinyin: 'Xiǎo Jié',
      region: '手踝部',
      mainRegion: DongRegion.hand,
      location: '手腕尺側，養老穴微下方',
      locationDescription: '位於手腕尺側，養老穴微下方凹陷處',
      indication: '腳踝扭傷、膝痛、腰痛',
      indications: ['腳踝扭傷', '膝關節炎', '腰痛', '坐骨神經痛'],
      needleAngle: '向手腕方向斜刺',
      needleDepth: '0.5-1寸',
      manipulation: '大幅度捻轉',
      reinforcementReduction: '瀉法',
      qiArrival: '強烈酸脹感',
      clinicalApplication: '治腳踝扭傷特效，配陽陵泉更佳',
      mingLiConnection: '通調下肢經絡',
      pairedAcupoints: ['陽陵泉', '委中'],
      formulas: ['踝痛康復方'],
      sourceReferences: ['董氏奇穴正宗'],
      notes: '急性扭傷宜瀉法',
    ),
    DongAcupoint(
      id: 'dong_018',
      name: '水金穴',
      nameEn: 'Shui Jin',
      namePinyin: 'Shuǐ Jīn',
      region: '小腿部',
      mainRegion: DongRegion.legLower,
      location: '小腿內側，水分穴外開1寸',
      locationDescription: '位於小腿內側，水分穴外開1寸處',
      indication: '水腫、腹瀉、小便不利',
      indications: ['水腫', '腹瀉', '小便不利', '腹脹', '腎炎'],
      needleAngle: '直刺',
      needleDepth: '1-1.5寸',
      manipulation: '輕度刺激',
      reinforcementReduction: '平補平瀉',
      qiArrival: '局部酸脹',
      clinicalApplication: '治水濕內停',
      mingLiConnection: '通調水道',
      pairedAcupoints: ['水分穴', '腎關穴'],
      formulas: ['利水方'],
      sourceReferences: ['董氏奇穴正宗'],
      notes: '',
    ),
    DongAcupoint(
      id: 'dong_019',
      name: '四花穴',
      nameEn: 'Si Hua',
      namePinyin: 'Sì Huā',
      region: '大腿部',
      mainRegion: DongRegion.legUpper,
      location: '大腿前側，胃經循行線上',
      locationDescription: '四花上穴、四花中穴、四花下穴，位於大腿前側胃經循行線上',
      indication: '胃病、腸病、哮喘',
      indications: ['胃炎', '胃潰瘍', '十二指腸潰瘍', '哮喘', '咳嗽'],
      needleAngle: '直刺',
      needleDepth: '2-3寸',
      manipulation: '大幅度捻轉',
      reinforcementReduction: '平補平瀉',
      qiArrival: '酸脹感向腹部傳導',
      clinicalApplication: '治胃腸疾病及肺系疾病要穴',
      mingLiConnection: '胃經所過，調理脾胃肺氣',
      pairedAcupoints: ['門金穴', '通胃穴'],
      formulas: ['四花調理方'],
      sourceReferences: ['董氏奇穴正宗', '丘雅昌董氏奇穴講座'],
      notes: '',
    ),
    DongAcupoint(
      id: 'dong_020',
      name: '腑巢穴',
      nameEn: 'Fu Chao',
      namePinyin: 'Fǔ Cháo',
      region: '腹部',
      mainRegion: DongRegion.abdomen,
      location: '腹部中央，任脈旁開2寸',
      locationDescription: '位於腹部，任脈兩側旁開2寸處',
      indication: '婦科病、泌尿系統疾病',
      indications: ['月經失調', '痛經', '、子宮肌瘤', '卵巢囊腫', '膀胱炎'],
      needleAngle: '直刺或斜刺',
      needleDepth: '1-2寸',
      manipulation: '輕度刺激',
      reinforcementReduction: '平補平瀉',
      qiArrival: '局部酸脹或有向下放射感',
      clinicalApplication: '治婦科疾病常用',
      mingLiConnection: '調理任脈，溫宮散寒',
      pairedAcupoints: ['鳳巢穴', '婦科穴'],
      formulas: ['婦科調理方'],
      sourceReferences: ['董氏奇穴正宗'],
      notes: '孕婦禁針腹部',
    ),
  ];

  static DongAcupoint? findById(String id) {
    try {
      return dongPoints.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<DongAcupoint> findByRegion(DongRegion region) {
    return dongPoints.where((p) => p.mainRegion == region).toList();
  }

  static List<DongAcupoint> findByIndication(String symptom) {
    return dongPoints.where((p) => 
      p.indications.any((i) => i.contains(symptom)) ||
      p.indication.contains(symptom)
    ).toList();
  }

  static List<DongAcupoint> search(String query) {
    final lowerQuery = query.toLowerCase();
    return dongPoints.where((p) =>
      p.name.contains(query) ||
      p.nameEn.toLowerCase().contains(lowerQuery) ||
      p.namePinyin.toLowerCase().contains(lowerQuery) ||
      p.indication.contains(query) ||
      p.indications.any((i) => i.contains(query))
    ).toList();
  }
}
