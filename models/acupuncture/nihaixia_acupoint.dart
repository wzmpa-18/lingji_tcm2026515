class NiHaixiaAcupoint {
  final String id;
  final String name;
  final String nameEn;
  final String namePinyin;
  final String standardName;
  final String region;
  final NiHaixiaRegion bodyRegion;
  final String location;
  final String locationMethod;
  final String indication;
  final List<String> indications;
  final String symptomPattern;
  final String needleDepth;
  final String needleAngle;
  final String manipulation;
  final String needleResponse;
  final String clinicalNote;
  final String niHaixiaInsight;
  final String classicalReference;
  final String combination;
  final String contraindication;
  final List<String> diseaseFormulas;
  final String imageUrl;
  final String videoUrl;
  final int memberLevelRequired;

  const NiHaixiaAcupoint({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.namePinyin,
    required this.standardName,
    required this.region,
    required this.bodyRegion,
    required this.location,
    required this.locationMethod,
    required this.indication,
    required this.indications,
    required this.symptomPattern,
    required this.needleDepth,
    required this.needleAngle,
    required this.manipulation,
    required this.needleResponse,
    required this.clinicalNote,
    required this.niHaixiaInsight,
    required this.classicalReference,
    required this.combination,
    this.contraindication = '',
    this.diseaseFormulas = const [],
    this.imageUrl = '',
    this.videoUrl = '',
    this.memberLevelRequired = 0,
  });
}

enum NiHaixiaRegion {
  head,
  face,
  neck,
  chest,
  back,
  abdomen,
  arm,
  hand,
  leg,
  foot,
}

extension NiHaixiaRegionExtension on NiHaixiaRegion {
  String get name {
    switch (this) {
      case NiHaixiaRegion.head:
        return '頭部';
      case NiHaixiaRegion.face:
        return '面部';
      case NiHaixiaRegion.neck:
        return '頸部';
      case NiHaixiaRegion.chest:
        return '胸部';
      case NiHaixiaRegion.back:
        return '背部';
      case NiHaixiaRegion.abdomen:
        return '腹部';
      case NiHaixiaRegion.arm:
        return '手臂';
      case NiHaixiaRegion.hand:
        return '手部';
      case NiHaixiaRegion.leg:
        return '腿部';
      case NiHaixiaRegion.foot:
        return '足部';
    }
  }

  String get nameEn {
    switch (this) {
      case NiHaixiaRegion.head:
        return 'Head';
      case NiHaixiaRegion.face:
        return 'Face';
      case NiHaixiaRegion.neck:
        return 'Neck';
      case NiHaixiaRegion.chest:
        return 'Chest';
      case NiHaixiaRegion.back:
        return 'Back';
      case NiHaixiaRegion.abdomen:
        return 'Abdomen';
      case NiHaixiaRegion.arm:
        return 'Arm';
      case NiHaixiaRegion.hand:
        return 'Hand';
      case NiHaixiaRegion.leg:
        return 'Leg';
      case NiHaixiaRegion.foot:
        return 'Foot';
    }
  }
}

class NiHaixiaCollection {
  static const List<NiHaixiaAcupoint> specialPoints = [
    NiHaixiaAcupoint(
      id: 'nihai_001',
      name: '公孫',
      nameEn: 'Gongsun',
      namePinyin: 'Gōng Sūn',
      standardName: '公孫穴',
      region: '足部',
      bodyRegion: NiHaixiaRegion.foot,
      location: '第一蹠骨基底部前緣凹陷中',
      locationMethod: '足大趾內側，赤白肉際處取穴',
      indication: '胃痛、腹痛、嘔吐、腹瀉、月經病',
      indications: ['胃痛', '腹痛', '嘔吐', '腹瀉', '月經失調', '不孕'],
      symptomPattern: '脾胃虛弱、消化不良、腹部脹滿',
      needleDepth: '0.5-1寸',
      needleAngle: '直刺或斜刺',
      manipulation: '捻轉補法',
      needleResponse: '酸脹感向足底放射',
      clinicalNote: '公孫為脾經絡穴，通沖脈，調理脾胃要穴',
      niHaixiaInsight: '倪師特別強調公孫穴治胃病特效，配合內關效果更佳，可治一切胃部不適',
      classicalReference: '《針灸甲乙經》：公孫，主虛勞裡急',
      combination: '配合內關、中脘、足三里',
      contraindication: '孕婦慎用',
      diseaseFormulas: ['公孫內關方', '公孫足三里方'],
      memberLevelRequired: 0,
    ),
    NiHaixiaAcupoint(
      id: 'nihai_002',
      name: '內關',
      nameEn: 'Neiguan',
      namePinyin: 'Nèi Guān',
      standardName: '內關穴',
      region: '前臂',
      bodyRegion: NiHaixiaRegion.arm,
      location: '掌長肌腱與橈側腕屈肌腱之間，腕橫紋上2寸',
      locationMethod: '腕橫紋正中上2寸，兩筋之間取穴',
      indication: '心悸、胸悶、胃痛、嘔吐、失眠',
      indications: ['心悸', '胸悶', '胃痛', '嘔吐', '失眠', '眩暈', '心痛'],
      symptomPattern: '心胸胃部症狀、精神情緒問題',
      needleDepth: '0.5-1寸',
      needleAngle: '直刺',
      manipulation: '捻轉，平補平瀉',
      needleResponse: '酸麻感向手指放射',
      clinicalNote: '內關為心包絡穴，通陰維脈，治心胸胃要穴',
      niHaixiaInsight: '倪師常用內關治心悸失眠，強調此穴可安定心神，配合神門效果更好',
      classicalReference: '《針灸大成》：內關，主心痛、腹痛',
      combination: '配合公孫、神門、足三里',
      diseaseFormulas: ['內關公孫方', '內關神門方', '寬胸理氣方'],
      memberLevelRequired: 0,
    ),
    NiHaixiaAcupoint(
      id: 'nihai_003',
      name: '中脘',
      nameEn: 'Zhongwan',
      namePinyin: 'Zhōng Wǎn',
      standardName: '中脘穴',
      region: '腹部',
      bodyRegion: NiHaixiaRegion.abdomen,
      location: '前正中線上，臍上4寸',
      locationMethod: '胸劍聯合與臍中連線中點取穴',
      indication: '胃痛、腹脹、消化不良',
      indications: ['胃痛', '腹脹', '消化不良', '嘔吐', '便秘', '肥胖'],
      symptomPattern: '脾胃運化失常、胃腸積滯',
      needleDepth: '1-1.5寸',
      needleAngle: '直刺',
      manipulation: '捻轉瀉法或平補平瀉',
      needleResponse: '局部酸脹或有向下傳導感',
      clinicalNote: '中脘為胃之募穴，八會穴之腑會',
      niHaixiaInsight: '倪師重視中脘治胃病，強調此穴可調理中焦氣機，是治胃第一要穴',
      classicalReference: '《針灸甲乙經》：中脘，主胃脹、腹脹',
      combination: '配合足三里、公孫、內關',
      diseaseFormulas: ['中脘足三里方', '和胃方'],
      memberLevelRequired: 0,
    ),
    NiHaixiaAcupoint(
      id: 'nihai_004',
      name: '足三里',
      nameEn: 'Zusanli',
      namePinyin: 'Zú Sān Lǐ',
      standardName: '足三里穴',
      region: '小腿',
      bodyRegion: NiHaixiaRegion.leg,
      location: '犢鼻穴下3寸，脛骨前肌外側',
      locationMethod: '外膝眼（犢鼻）下3寸，脛骨前緣旁開一橫指',
      indication: '胃腸疾病、虛弱體質、免疫力提升',
      indications: ['胃痛', '腹痛', '腹瀉', '便秘', '虛弱', '免疫力低下', '高血壓'],
      symptomPattern: '脾胃虛弱、氣血不足、免疫力下降',
      needleDepth: '1-1.5寸',
      needleAngle: '直刺',
      manipulation: '捻轉補法，強刺激可瀉',
      needleResponse: '酸脹感向足背或小腿放射',
      clinicalNote: '足三里為胃之下合穴，四總穴之一，強壯要穴',
      niHaixiaInsight: '倪師強調足三里為強壯穴，常用於提升免疫力，孕婦禁針',
      classicalReference: '《針灸大成》：足三里，主胃痛、腹痛',
      combination: '配合中脘、公孫、合谷',
      contraindication: '孕婦禁針',
      diseaseFormulas: ['足三里強壯方', '和胃健脾方', '免疫提升方'],
      memberLevelRequired: 0,
    ),
    NiHaixiaAcupoint(
      id: 'nihai_005',
      name: '合谷',
      nameEn: 'Hegu',
      namePinyin: 'Hé Gǔ',
      standardName: '合谷穴',
      region: '手部',
      bodyRegion: NiHaixiaRegion.hand,
      location: '第二掌骨橈側中點處',
      locationMethod: '手背，第一、二掌骨之間，第二掌骨橈側中點',
      indication: '面口疾病、疼痛、發熱',
      indications: ['頭痛', '牙痛', '面癱', '發熱', '汗證', '閉經', '滯產'],
      symptomPattern: '面部、五官疾病，各種疼痛，發熱汗證',
      needleDepth: '0.5-1寸',
      needleAngle: '斜刺或直刺',
      manipulation: '捻轉瀉法',
      needleResponse: '局部酸脹',
      clinicalNote: '合谷為大腸經原穴，四總穴之一',
      niHaixiaInsight: '倪師常用合谷治面口疾病，強調此穴為止痛要穴，孕婦慎用',
      classicalReference: '《針灸大成》：合谷，主頭痛、牙痛',
      combination: '配合列缺、曲池、迎香',
      contraindication: '孕婦禁針',
      diseaseFormulas: ['合谷止痛方', '面口疾病方'],
      memberLevelRequired: 0,
    ),
    NiHaixiaAcupoint(
      id: 'nihai_006',
      name: '委中',
      nameEn: 'Weizhong',
      namePinyin: 'Wěi Zhōng',
      standardName: '委中穴',
      region: '膝窩',
      bodyRegion: NiHaixiaRegion.leg,
      location: '膝窩橫紋中點，股二頭肌腱與半腱肌腱之間',
      locationMethod: '膕窩橫紋中點取穴',
      indication: '腰痛、背痛、下肢疼痛',
      indications: ['腰痛', '背痛', '腿痛', '腹痛', '丹毒', '蕁麻疹'],
      symptomPattern: '腰背部疼痛，下肢經脈不通',
      needleDepth: '1-1.5寸',
      needleAngle: '直刺',
      manipulation: '大幅度捻轉瀉法，或三稜針點刺放血',
      needleResponse: '酸脹感或觸電感向下肢放射',
      clinicalNote: '委中為膀胱經合穴，四總穴之一，腰背委中求',
      niHaixiaInsight: '倪師特別強調委中治腰痛特效，常用放血療法效果顯著',
      classicalReference: '《四總穴歌》：腰背委中求',
      combination: '配合腎俞、大腸俞、環跳',
      diseaseFormulas: ['腰背疼痛方', '委中放血方'],
      memberLevelRequired: 0,
    ),
    NiHaixiaAcupoint(
      id: 'nihai_007',
      name: '列缺',
      nameEn: 'Lieque',
      namePinyin: 'Liè Quē',
      standardName: '列缺穴',
      region: '前臂',
      bodyRegion: NiHaixiaRegion.arm,
      location: '橈骨莖突上方，腕橫紋上1.5寸',
      locationMethod: '兩手虎口交叉，食指尖所指凹陷處',
      indication: '咳嗽、氣喘、咽喉痛、頭痛',
      indications: ['咳嗽', '氣喘', '咽喉痛', '頭痛', '面癱', '遺尿'],
      symptomPattern: '肺系疾病，頭項疾病',
      needleDepth: '0.3-0.5寸',
      needleAngle: '向上斜刺',
      manipulation: '捻轉瀉法',
      needleResponse: '酸脹感向肘部或手腕放射',
      clinicalNote: '列缺為肺經絡穴，通任脈，八脈交會穴',
      niHaixiaInsight: '倪師用列缺治咳嗽氣喘，強調可調理任脈，治頭項疾病',
      classicalReference: '《針灸大成》：列缺，主咳嗽、咽喉痛',
      combination: '配合合谷、尺澤、天突',
      diseaseFormulas: ['咳嗽方', '咽喉痛方'],
      memberLevelRequired: 0,
    ),
    NiHaixiaAcupoint(
      id: 'nihai_008',
      name: '風池',
      nameEn: 'Fengchi',
      namePinyin: 'Fēng Chí',
      standardName: '風池穴',
      region: '頸部',
      bodyRegion: NiHaixiaRegion.neck,
      location: '枕骨粗隆直下凹陷與乳突之間',
      locationMethod: '項部，枕骨粗隆下凹陷處，與風府穴相平',
      indication: '感冒、頭痛、眩暈、頸項強痛',
      indications: ['感冒', '頭痛', '眩暈', '頸項強痛', '鼻炎', '高血壓'],
      symptomPattern: '外感風邪，肝陽上亢',
      needleDepth: '0.5-1寸',
      needleAngle: '向鼻尖方向斜刺',
      manipulation: '捻轉瀉法',
      needleResponse: '酸脹感向頭部放射',
      clinicalNote: '風池為膽經穴，祛風要穴',
      niHaixiaInsight: '倪師常用風池治感冒頭痛，強調向鼻尖方向刺較安全',
      classicalReference: '《針灸大成》：風池，主感冒、頭痛',
      combination: '配合風府、大椎、合谷',
      contraindication: '不可向對側眼窩方向深刺',
      diseaseFormulas: ['感冒疏風方', '頭痛眩暈方'],
      memberLevelRequired: 0,
    ),
    NiHaixiaAcupoint(
      id: 'nihai_009',
      name: '百會',
      nameEn: 'Baihui',
      namePinyin: 'Bǎi Huì',
      standardName: '百會穴',
      region: '頭部',
      bodyRegion: NiHaixiaRegion.head,
      location: '前髮際正中直上5寸，兩耳尖連線中點',
      locationMethod: '頭頂正中，兩耳尖連線中點',
      indication: '頭痛、眩暈、失眠、脫肛、昏厥',
      indications: ['頭痛', '眩暈', '失眠', '脫肛', '昏厥', '中風', '耳鳴'],
      symptomPattern: '清陽不升，腦竅不開',
      needleDepth: '0.3-0.5寸',
      needleAngle: '平刺或向前後左右斜刺',
      manipulation: '捻轉補法',
      needleResponse: '局部酸脹或頭部輕鬆感',
      clinicalNote: '百會為督脈穴，陽脈之海',
      niHaixiaInsight: '倪師重視百會治腦部疾病，強調此穴可升提陽氣',
      classicalReference: '《針灸大成》：百會，主眩暈、頭痛',
      combination: '配合風池、足三里、氣海',
      diseaseFormulas: ['升陽舉陷方', '健腦方'],
      memberLevelRequired: 0,
    ),
    NiHaixiaAcupoint(
      id: 'nihai_010',
      name: '太衝',
      nameEn: 'Taichong',
      namePinyin: 'Tài Chōng',
      standardName: '太衝穴',
      region: '足部',
      bodyRegion: NiHaixiaRegion.foot,
      location: '足背，第一、二蹠骨結合部前方凹陷中',
      locationMethod: '足背，第一、二蹠骨間凹陷處',
      indication: '頭痛、眩暈、脅痛、情緒病',
      indications: ['頭痛', '眩暈', '脅痛', '情緒抑鬱', '月經失調', '高血壓'],
      symptomPattern: '肝氣鬱結，肝陽上亢',
      needleDepth: '0.5-1寸',
      needleAngle: '直刺或斜刺',
      manipulation: '捻轉瀉法',
      needleResponse: '酸脹感向足背或足底放射',
      clinicalNote: '太衝為肝經原穴、輸穴',
      niHaixiaInsight: '倪師常用太衝治情緒病，強調此穴可疏肝解鬱',
      classicalReference: '《針灸大成》：太衝，主眩暈、脅痛',
      combination: '配合合谷（開四關）、肝俞、三陰交',
      diseaseFormulas: ['疏肝解鬱方', '太衝合谷方'],
      memberLevelRequired: 0,
    ),
    NiHaixiaAcupoint(
      id: 'nihai_011',
      name: '三陰交',
      nameEn: 'Sanyinjiao',
      namePinyin: 'Sān Yīn Jiāo',
      standardName: '三陰交穴',
      region: '小腿',
      bodyRegion: NiHaixiaRegion.leg,
      location: '內踝尖上3寸，脛骨內側緣後方',
      locationMethod: '內踝高點上3寸，脛骨內側後緣',
      indication: '婦科病、泌尿系統、失眠',
      indications: ['月經失調', '痛經', '不孕', '遺精', '失眠', '腹瀉', '高血壓'],
      symptomPattern: '肝脾腎三經同病，婦科泌尿問題',
      needleDepth: '1-1.5寸',
      needleAngle: '直刺',
      manipulation: '捻轉補法',
      needleResponse: '酸脹感向膝部或足底放射',
      clinicalNote: '三陰交為脾經穴，三條陰經交會穴',
      niHaixiaInsight: '倪師特別強調三陰交治婦科病要穴，孕婦禁針',
      classicalReference: '《針灸大成》：三陰交，主月經病、失眠',
      combination: '配合血海、地機、關元',
      contraindication: '孕婦禁針',
      diseaseFormulas: ['調經方', '三陰交方'],
      memberLevelRequired: 0,
    ),
    NiHaixiaAcupoint(
      id: 'nihai_012',
      name: '豐隆',
      nameEn: 'Fenglong',
      namePinyin: 'Fēng Lóng',
      standardName: '豐隆穴',
      region: '小腿',
      bodyRegion: NiHaixiaRegion.leg,
      location: '外踝尖上8寸，條口穴外1寸',
      locationMethod: '外踝高點與外膝眼連線中點，條口穴外1寸',
      indication: '咳嗽痰多、眩暈、肥胖',
      indications: ['咳嗽痰多', '眩暈', '肥胖', '頭痛', '便秘'],
      symptomPattern: '痰濕內阻，脾胃不和',
      needleDepth: '1-1.5寸',
      needleAngle: '直刺或斜刺',
      manipulation: '大幅度捻轉瀉法',
      needleResponse: '酸脹感向足背放射',
      clinicalNote: '豐隆為胃經絡穴，化痰要穴',
      niHaixiaInsight: '倪師常用豐隆治痰濕證，強調此穴化痰效果顯著',
      classicalReference: '《針灸大成》：豐隆，主痰多、眩暈',
      combination: '配合陰陵泉、中脘、足三里',
      diseaseFormulas: ['化痰方', '減肥方'],
      memberLevelRequired: 0,
    ),
    NiHaixiaAcupoint(
      id: 'nihai_013',
      name: '陰陵泉',
      nameEn: 'Yinlingquan',
      namePinyin: 'Yīn Líng Quán',
      standardName: '陰陵泉穴',
      region: '小腿',
      bodyRegion: NiHaixiaRegion.leg,
      location: '脛骨內側髁下凹陷中',
      locationMethod: '小腿內側，脛骨內側髁後下方凹陷處',
      indication: '水腫、腹瀉、小便不利、膝痛',
      indications: ['水腫', '腹瀉', '小便不利', '膝蓋痛', '遺精', '帶下'],
      symptomPattern: '脾虛濕盛，水濕內停',
      needleDepth: '1-1.5寸',
      needleAngle: '直刺',
      manipulation: '捻轉補法或平補平瀉',
      needleResponse: '酸脹感向膝部放射',
      clinicalNote: '陰陵泉為脾經合穴，利水滲濕要穴',
      niHaixiaInsight: '倪師用陰陵泉治水濕證，強調此穴可健脾利水',
      classicalReference: '《針灸大成》：陰陵泉，主水腫、腹瀉',
      combination: '配合豐隆、水分、腎俞',
      diseaseFormulas: ['利水滲濕方', '健脾方'],
      memberLevelRequired: 0,
    ),
    NiHaixiaAcupoint(
      id: 'nihai_014',
      name: '復溜',
      nameEn: 'Fuliu',
      namePinyin: 'Fù Liū',
      standardName: '復溜穴',
      region: '小腿',
      bodyRegion: NiHaixiaRegion.leg,
      location: '太溪穴上2寸，跟腱前方',
      locationMethod: '內踝與跟腱之間，太溪穴上2寸',
      indication: '盜汗、自汗、水腫、腰痛',
      indications: ['盜汗', '自汗', '水腫', '腰痛', '腹瀉', '陽痿'],
      symptomPattern: '腎氣不足，水液代謝失常',
      needleDepth: '0.5-1寸',
      needleAngle: '直刺',
      manipulation: '捻轉補法',
      needleResponse: '酸脹感向足底放射',
      clinicalNote: '復溜為腎經經穴，治汗證要穴',
      niHaixiaInsight: '倪師常用復溜治盜汗自汗，強調補腎益氣',
      classicalReference: '《針灸大成》：復溜，主盜汗、自汗',
      combination: '配合合谷、陰陵泉、關元',
      diseaseFormulas: ['止汗方', '補腎方'],
      memberLevelRequired: 0,
    ),
    NiHaixiaAcupoint(
      id: 'nihai_015',
      name: '飛揚',
      nameEn: 'Feiyang',
      namePinyin: 'Fēi Yáng',
      standardName: '飛揚穴',
      region: '小腿',
      bodyRegion: NiHaixiaRegion.leg,
      location: '昆侖穴上7寸，承山穴外下方',
      locationMethod: '外踝後方，昆侖穴上7寸，外踝後外側',
      indication: '腰痛、痔瘡、眩暈',
      indications: ['腰痛', '痔瘡', '眩暈', '小腿痙攣', '腳氣'],
      symptomPattern: '膀胱經氣血不和',
      needleDepth: '1-1.5寸',
      needleAngle: '直刺',
      manipulation: '捻轉瀉法',
      needleResponse: '酸脹感向足底放射',
      clinicalNote: '飛揚為膀胱經絡穴，治痔要穴',
      niHaixiaInsight: '倪師用飛揚治痔瘡腰痛，強調此穴通督脈',
      classicalReference: '《針灸大成》：飛揚，主痔瘡、腰痛',
      combination: '配合承山、長強、委中',
      diseaseFormulas: ['治痔方', '腰痛方'],
      memberLevelRequired: 0,
    ),
    NiHaixiaAcupoint(
      id: 'nihai_016',
      name: '俠谿',
      nameEn: 'Jiaxi',
      namePinyin: 'Xiá Xī',
      standardName: '俠谿穴',
      region: '足部',
      bodyRegion: NiHaixiaRegion.foot,
      location: '足背，第四、五趾縫間，趾蹼緣後方',
      locationMethod: '足背第四、五趾間，趾蹼緣後方赤白肉際處',
      indication: '頭痛、眩暈、耳鳴、胸脅痛',
      indications: ['偏頭痛', '眩暈', '耳鳴', '胸脅痛', '脅間神經痛'],
      symptomPattern: '膽經火熱，上擾清竅',
      needleDepth: '0.3-0.5寸',
      needleAngle: '斜刺',
      manipulation: '捻轉瀉法',
      needleResponse: '局部酸脹',
      clinicalNote: '俠谿為膽經滎穴，治膽火上炎',
      niHaixiaInsight: '倪師用俠谿治偏頭痛，強調清瀉膽火',
      classicalReference: '《針灸大成》：俠谿，主偏頭痛、耳鳴',
      combination: '配合風池、聽會、足臨泣',
      diseaseFormulas: ['清膽瀉火方'],
      memberLevelRequired: 0,
    ),
    NiHaixiaAcupoint(
      id: 'nihai_017',
      name: '地機',
      nameEn: 'Diji',
      namePinyin: 'Dì Jī',
      standardName: '地機穴',
      region: '小腿',
      bodyRegion: NiHaixiaRegion.leg,
      location: '陰陵泉穴下3寸，脛骨內側',
      locationMethod: '小腿內側，陰陵泉下3寸',
      indication: '痛經、月經失調、腹痛',
      indications: ['痛經', '月經失調', '腹痛', '洩瀉', '水腫'],
      symptomPattern: '脾虛濕盛，婦科疾病',
      needleDepth: '1-1.5寸',
      needleAngle: '直刺',
      manipulation: '捻轉補法或平補平瀉',
      needleResponse: '酸脹感向小腿或足底放射',
      clinicalNote: '地機為脾經郄穴，治急性痛證',
      niHaixiaInsight: '倪師用地機治痛經，強調健脾利濕',
      classicalReference: '《針灸大成》：地機，主痛經、腹痛',
      combination: '配合三陰交、血海、關元',
      diseaseFormulas: ['調經止痛方'],
      memberLevelRequired: 0,
    ),
    NiHaixiaAcupoint(
      id: 'nihai_018',
      name: '中都',
      nameEn: 'Zhongdu',
      namePinyin: 'Zhōng Dū',
      standardName: '中都穴',
      region: '小腿',
      bodyRegion: NiHaixiaRegion.leg,
      location: '內踝尖上7寸，脛骨內側',
      locationMethod: '小腿內側，內踝尖上7寸',
      indication: '崩漏、疝氣、脅痛',
      indications: ['崩漏', '疝氣', '脅痛', '腹痛', '惡露不盡'],
      symptomPattern: '肝經氣血失調',
      needleDepth: '0.5-1寸',
      needleAngle: '直刺',
      manipulation: '捻轉瀉法',
      needleResponse: '酸脹感',
      clinicalNote: '中都為肝經郄穴，治急性血症',
      niHaixiaInsight: '倪師用中都治崩漏，強調調理肝經',
      classicalReference: '《針灸大成》：中都，主崩漏、疝氣',
      combination: '配合血海、三陰交、隱白',
      diseaseFormulas: ['止血方'],
      memberLevelRequired: 0,
    ),
    NiHaixiaAcupoint(
      id: 'nihai_019',
      name: '水泉',
      nameEn: 'Shuiquan',
      namePinyin: 'Shuǐ Quán',
      standardName: '水泉穴',
      region: '足部',
      bodyRegion: NiHaixiaRegion.foot,
      location: '太溪穴直下1寸，跟骨結節內側',
      locationMethod: '足跟，內踝與跟腱之間，太溪穴直下1寸',
      indication: '月經失調、痛經、小便不利',
      indications: ['月經失調', '痛經', '小便不利', '尿頻', '目昏'],
      symptomPattern: '腎氣不足，水道不利',
      needleDepth: '0.3-0.5寸',
      needleAngle: '直刺',
      manipulation: '捻轉補法',
      needleResponse: '酸脹感向足底放射',
      clinicalNote: '水泉為腎經郄穴',
      niHaixiaInsight: '倪師用水泉治泌尿系統疾病',
      classicalReference: '《針灸大成》：水泉，主月經病、小便不利',
      combination: ['配合三陰交、關元、腎俞'],
      diseaseFormulas: ['泌尿方'],
      memberLevelRequired: 0,
    ),
    NiHaixiaAcupoint(
      id: 'nihai_020',
      name: '築賓',
      nameEn: 'Zhubin',
      namePinyin: 'Zhù Bīn',
      standardName: '築賓穴',
      region: '小腿',
      bodyRegion: NiHaixiaRegion.leg,
      location: '太溪穴上5寸，腓腸肌內側肌腹',
      locationMethod: '小腿內側，太溪與陰谷連線上，太溪上5寸',
      indication: '陽痿、遺精、失眠、精神症狀',
      indications: ['陽痿', '遺精', '失眠', '精神恍惚', '癲癇', '嘔吐'],
      symptomPattern: '心腎不交，神志不安',
      needleDepth: '1-1.5寸',
      needleAngle: '直刺',
      manipulation: '捻轉補法',
      needleResponse: '酸脹感向大腿內側放射',
      clinicalNote: '築賓為腎經穴，陰維脈之郄穴',
      niHaixiaInsight: '倪師用築賓治失眠神志病，強調交通心腎',
      classicalReference: '《針灸大成》：築賓，主癲狂、嘔吐',
      combination: '配合神門、三陰交、心俞',
      diseaseFormulas: ['安神方', '交通心腎方'],
      memberLevelRequired: 0,
    ),
  ];

  static NiHaixiaAcupoint? findById(String id) {
    try {
      return specialPoints.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<NiHaixiaAcupoint> findByRegion(NiHaixiaRegion region) {
    return specialPoints.where((p) => p.bodyRegion == region).toList();
  }

  static List<NiHaixiaAcupoint> findByIndication(String symptom) {
    return specialPoints.where((p) =>
      p.indications.any((i) => i.contains(symptom)) ||
      p.indication.contains(symptom)
    ).toList();
  }

  static List<NiHaixiaAcupoint> search(String query) {
    final lowerQuery = query.toLowerCase();
    return specialPoints.where((p) =>
      p.name.contains(query) ||
      p.nameEn.toLowerCase().contains(lowerQuery) ||
      p.indication.contains(query) ||
      p.indications.any((i) => i.contains(query))
    ).toList();
  }
}
