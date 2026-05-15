class PediatricCondition {
  final String id;
  final String name;
  final String nameEn;
  final String symptomSummary;
  final List<String> symptoms;
  final String tongue;
  final String pulse;
  final String syndromeType;
  final List<String> massageTechniques;
  final List<String> acupoints;
  final List<String> precautions;
  final String? niHaixiaNote;
  final String? nursingAdvice;
  final int memberLevelRequired;

  const PediatricCondition({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.symptomSummary,
    required this.symptoms,
    required this.tongue,
    required this.pulse,
    required this.syndromeType,
    required this.massageTechniques,
    required this.acupoints,
    required this.precautions,
    this.niHaixiaNote,
    this.nursingAdvice,
    this.memberLevelRequired = 0,
  });
}

class MassageTechnique {
  final String id;
  final String name;
  final String nameEn;
  final String description;
  final String operation;
  final String duration;
  final String frequency;
  final List<String> indications;
  final List<String> contraindications;
  final String? niHaixiaGuidance;
  final String? videoUrl;
  final String? imageUrl;

  const MassageTechnique({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.description,
    required this.operation,
    required this.duration,
    required this.frequency,
    required this.indications,
    required this.contraindications,
    this.niHaixiaGuidance,
    this.videoUrl,
    this.imageUrl,
  });
}

class AcupointPediatric {
  final String id;
  final String name;
  final String location;
  final String indication;
  final String technique;
  final String dosage;
  final String? niHaixiaNote;

  const AcupointPediatric({
    required this.id,
    required this.name,
    required this.location,
    required this.indication,
    required this.technique,
    required this.dosage,
    this.niHaixiaNote,
  });
}

class PediatricCollection {
  static const List<MassageTechnique> techniques = [
    MassageTechnique(
      id: 'tianheshui',
      name: '開天河水',
      nameEn: 'Opening the Heavenly Water River',
      description: '天河水穴位於前臂正中，腕橫紋至肘橫紋之間。倪師特别强调此穴為小兒退熱第一要穴，操作時需注意方向與次數。',
      operation: '用食指、中指蘸溫水從腕推向肘，速度要均勻，每分鐘約200次',
      duration: '5-15分鐘（根據年齡調整）',
      frequency: '發熱時可每2小時一次',
      indications: ['外感發熱', '肺熱咳嗽', '咽喉腫痛', '暑熱煩躁'],
      contraindications: ['皮膚破損', '骨折', '出血傾向'],
      niHaixiaGuidance: '倪師強調：天河水是老天給我們的恩賜，退熱效果顯著。操作時需蘸溫水，推動時要有節奏，不可操之過急。一般推300-500次即可見效。',
    ),
    MassageTechnique(
      id: 'fuxianfeng',
      name: '清胃經',
      nameEn: 'Clearing the Stomach Meridian',
      description: '胃經位於拇指掌面第二節，常用於消化系統疾病。',
      operation: '用拇指端自拇指根向指端方向直推',
      duration: '3-5分鐘',
      frequency: '每日1-2次',
      indications: ['積食腹脹', '嘔吐腹瀉', '食慾不振', '胃熱口臭'],
      contraindications: ['虛寒泄瀉'],
      niHaixiaGuidance: '倪師說：清胃經可清除胃腸積熱，但要注意虛寒型泄瀉不可用此法。',
    ),
    MassageTechnique(
      id: 'tuifei',
      name: '退六腑',
      nameEn: 'Clearing the Six Fu Organs',
      description: '六腑位於前臂尺側，肘至腕之間。主要用於清除實熱。',
      operation: '用拇指或食指、中指自肘向腕方向直推',
      duration: '5-10分鐘',
      frequency: '發熱嚴重時可增加頻率',
      indications: ['高熱不退', '實熱便秘', '咽喉腫痛', '腮腺炎'],
      contraindications: ['虛寒證', '腹瀉'],
      niHaixiaGuidance: '倪師強調：退六腑為大寒之法，非實熱證不可妄用。用後需注意避風寒。',
    ),
    MassageTechnique(
      id: 'bushou-sanweilian',
      name: '運八卦',
      nameEn: 'Moving the Eight Trigrams',
      description: '八卦穴位於掌心周圍，操作時需順時針或逆時針運作。',
      operation: '用拇指運八卦，順時針為補，逆時針為瀉',
      duration: '3-5分鐘',
      frequency: '每日1-2次',
      indications: ['咳嗽痰多', '腹脹嘔吐', '消化不良', '心悸不安'],
      contraindications: ['皮膚過敏'],
      niHaixiaGuidance: '倪師說：運八卦是調理氣機的好方法，順時針可溫補，逆時針可清瀉。',
    ),
    MassageTechnique(
      id: 'qingganjing',
      name: '清肝經',
      nameEn: 'Clearing the Liver Meridian',
      description: '肝經位於食指掌面，順時針或逆時針操作。',
      operation: '用拇指自指根向指尖方向直推',
      duration: '3-5分鐘',
      frequency: '每日1-2次',
      indications: ['肝火旺盛', '脾氣暴躁', '眼屎多', '驚風抽搐'],
      contraindications: ['虛證'],
      niHaixiaGuidance: '倪師強調：小兒肝常有餘，清肝經可瀉肝火，但不可過度。',
    ),
    MassageTechnique(
      id: 'feitui',
      name: '清肺經',
      nameEn: 'Clearing the Lung Meridian',
      description: '肺經位於無名指掌面，常用於呼吸系統疾病。',
      operation: '用拇指自指根向指尖方向直推',
      duration: '3-5分鐘',
      frequency: '每日1-2次',
      indications: ['咳嗽痰多', '感冒發熱', '鼻炎流涕', '咽喉紅腫'],
      contraindications: ['虛寒咳嗽'],
      niHaixiaGuidance: '倪師說：清肺經可宣肺解表，疏散風熱，是治療感冒咳嗽的要穴。',
    ),
    MassageTechnique(
      id: 'tianmen',
      name: '推天門',
      nameEn: 'Pushing the Heavenly Gate',
      description: '天門穴位於兩眉之間至前髮際正中。',
      operation: '用拇指自眉心向上直推至前髮際',
      duration: '50-100次',
      frequency: '每日1-2次',
      indications: ['感冒發熱', '頭疼鼻塞', '驚悸不安', '外感風寒'],
      contraindications: ['頭部外傷'],
      niHaixiaGuidance: '倪師強調：推天門可開竅醒神，是治療外感的常用手法。',
    ),
    MassageTechnique(
      id: 'kanongyan',
      name: '坎宮',
      nameEn: 'Kan Gong - Eye Region',
      description: '坎宮位於眉心至眉梢，呈橫線分佈。',
      operation: '用兩拇指自眉心向眉梢分推',
      duration: '50次',
      frequency: '每日1-2次',
      indications: ['外感發熱', '頭疼頭暈', '眼乾眼澀', '驚風抽搐'],
      contraindications: ['眼部疾病急性期'],
      niHaixiaGuidance: '倪師說：分推坎宮可疏風解表，明目醒腦。',
    ),
    MassageTechnique(
      id: 'yinyang',
      name: '分手陰陽',
      nameEn: 'Separating Yin and Yang',
      description: '陰陽穴位於手掌根部，橫紋兩端。',
      operation: '用兩拇指自掌根部向兩側分推',
      duration: '50-100次',
      frequency: '每日1-2次',
      indications: ['發熱不退', '寒熱往來', '感冒初期', '陰陽失衡'],
      contraindications: ['無特殊禁忌'],
      niHaixiaGuidance: '倪師強調：分手陰陽可調和陰陽，是治療發熱的重要手法。發熱時先分陽熱重的一邊。',
    ),
    MassageTechnique(
      id: 'laogong',
      name: '揉湧泉',
      nameEn: 'Pressing Yongquan',
      description: '湧泉穴位於足底前1/3與後2/3交界處。',
      operation: '用拇指端揉湧泉穴，每側50-100次',
      duration: '3-5分鐘',
      frequency: '每日1-2次',
      indications: ['發熱盜汗', '虛火上炎', '嘔吐腹瀉', '發育不良'],
      contraindications: ['足部外傷'],
      niHaixiaGuidance: '倪師說：湧泉為人身最下穴位，揉之可引火歸元，退虛熱。',
    ),
  ];

  static const List<PediatricCondition> conditions = [
    PediatricCondition(
      id: 'ganmao',
      name: '小兒感冒',
      nameEn: 'Pediatric Common Cold',
      symptomSummary: '發熱、鼻塞、流涕、咳嗽',
      symptoms: ['發熱', '鼻塞流涕', '咳嗽', '噴嚏', '咽紅咽痛', '倦怠乏力'],
      tongue: '舌尖紅，苔薄白或薄黃',
      pulse: '浮數',
      syndromeType: '風寒/風熱襲表',
      massageTechniques: ['推天門', '揉坎宮', '開天河水', '清肺經', '分手陰陽'],
      acupoints: ['天門', '坎宮', '天河水', '肺經', '太陽'],
      precautions: ['注意避風寒', '飲食清淡', '多飲溫水', '保持室內通風'],
      niHaixiaNote: '倪師特別強調：小兒感冒初期，及時處理可縮短病程。風寒感冒用蔥白生薑水泡腳，風熱感冒用金銀花泡水喝。',
      nursingAdvice: '保證充足睡眠，飲食清淡易消化，適當補充水分。',
    ),
    PediatricCondition(
      id: 'fashao',
      name: '小兒發熱',
      nameEn: 'Pediatric Fever',
      symptomSummary: '體溫升高（38.5°C以上）',
      symptoms: ['體溫升高', '面紅耳赤', '口乾喜飲', '煩躁不安', '食欲不振', '小便短赤'],
      tongue: '舌質紅，苔黃',
      pulse: '數脈',
      syndromeType: '外感發熱/食積發熱/虛熱',
      massageTechniques: ['開天河水', '退六腑', '分手陰陽', '清肝經', '揉湧泉'],
      acupoints: ['天河水', '六腑', '陰陽', '肝經', '湧泉'],
      precautions: ['體溫超39°C需就醫', '注意補充水分', '不可過度發汗'],
      niHaixiaNote: '倪師強調：發熱是小兒的正邪相爭，不要過度退熱。但持續高熱不退需及時就醫。天河水是退熱第一要穴。',
      nursingAdvice: '室溫保持在24-26°C，穿著寬鬆透氣，多飲溫開水，體溫超38.5°C可物理降溫。',
    ),
    PediatricCondition(
      id: 'kesou',
      name: '小兒咳嗽',
      nameEn: 'Pediatric Cough',
      symptomSummary: '咳嗽、有痰或乾咳',
      symptoms: ['咳嗽', '有痰或乾咳', '氣喘', '咽癢', '鼻塞流涕'],
      tongue: '咳嗽有痰：舌淡苔白；乾咳少痰：舌紅少苔',
      pulse: '咳嗽有痰：滑；乾咳：數',
      syndromeType: '風寒咳嗽/風熱咳嗽/痰濕咳嗽/陰虛咳嗽',
      massageTechniques: ['清肺經', '運八卦', '揉天突', '開天河水', '揉肺俞'],
      acupoints: ['肺經', '八卦', '天突', '肺俞'],
      precautions: ['少吃甜食', '忌冰冷', '保持空氣清新'],
      niHaixiaNote: '倪師說：咳嗽是肺的宣發肅降功能失常，首先要分寒熱。寒咳用烤橘子，熱咳用川貝蒸梨。',
      nursingAdvice: '保持室內空氣濕潤，避免刺激性氣味，適量飲用溫開水。',
    ),
    PediatricCondition(
      id: 'jishi',
      name: '小兒積食',
      nameEn: 'Pediatric Indigestion',
      symptomSummary: '腹脹、食慾不振、口臭',
      symptoms: ['腹脹', '食欲不振', '口臭', '噁心嘔吐', '大便乾結或酸臭', '睡不安穩'],
      tongue: '舌苔厚膩微黃',
      pulse: '滑',
      syndromeType: '乳食停滯/脾胃虛弱',
      massageTechniques: ['清胃經', '揉板門', '運八卦', '摩腹', '捏脊'],
      acupoints: ['胃經', '板門', '八卦', '中脘'],
      precautions: ['控制食量', '定時定量', '少吃油膩'],
      niHaixiaNote: '倪師特別強調：現在小孩問題，十個有九個是吃出來的！家長要狠心讓孩子餓一餓，不要過度餵養。',
      nursingAdvice: '飲食定時定量，七八分飽為宜，少吃零食和冷飲。',
    ),
    PediatricCondition(
      id: 'fuxie',
      name: '小兒腹瀉',
      nameEn: 'Pediatric Diarrhea',
      symptomSummary: '大便次數增多、性狀改變',
      symptoms: ['大便次數增多', '大便稀薄或水樣', '腹脹腹痛', '食慾不振', '嘔吐'],
      tongue: '風寒：舌淡苔白；濕熱：舌紅苔黃；脾虛：舌淡苔白',
      pulse: '風寒：浮；濕熱：滑數；脾處：緩',
      syndromeType: '風寒瀉/濕熱瀉/脾虛瀉/傷食瀉',
      massageTechniques: ['揉臍', '摩腹', '推七節骨', '清大腸', '補脾經'],
      acupoints: ['臍', '腹', '七節骨', '大腸', '脾經'],
      precautions: ['注意補液', '清淡飲食', '注意臀部護理'],
      niHaixiaNote: '倪師說：腹瀉不可盲目止瀉，要分清原因。腹瀉是身體排毒的過程，要讓它排乾淨再止。',
      nursingAdvice: '腹瀉期間給予清淡流質飲食，少量多餐，注意補充水分和電解質。',
    ),
    PediatricCondition(
      id: 'bianmi',
      name: '小兒便秘',
      nameEn: 'Pediatric Constipation',
      symptomSummary: '大便乾結、排便困難',
      symptoms: ['大便乾結如羊屎', '排便困難', '腹脹腹痛', '食欲不振', '脾氣暴躁'],
      tongue: '舌紅苔黃燥',
      pulse: '數',
      syndromeType: '實熱便秘/陰虛便秘/氣虛便秘',
      massageTechniques: ['退六腑', '清大腸', '摩腹', '揉天樞', '推下七節骨'],
      acupoints: ['六腑', '大腸', '腹', '天樞', '七節骨'],
      precautions: ['多吃蔬菜水果', '定時排便', '適當運動'],
      niHaixiaNote: '倪師強調：便秘多是熱證或陰虛，要多吃蔬菜水果，少吃加工食品。嚴重時可用蜜煎導法。',
      nursingAdvice: '增加膳食纖維攝入，培養定時排便習慣，適量飲水。',
    ),
    PediatricCondition(
      id: 'baojing',
      name: '小兒驚風',
      nameEn: 'Pediatric Convulsion',
      symptomSummary: '四肢抽搐、意識障礙',
      symptoms: ['突然發作', '四肢抽搐', '牙關緊閉', '意識障礙', '眼睛上翻'],
      tongue: '舌質紅，苔黃',
      pulse: '弦數',
      syndromeType: '熱極生風/痰熱閉竅/脾虛肝旺',
      massageTechniques: ['清肝經', '搗小天心', '揉百會', '掐人中', '開天河水'],
      acupoints: ['肝經', '小天心', '百會', '人中'],
      precautions: ['側臥防窒息', '保持呼吸道通暢', '及時就醫'],
      niHaixiaNote: '倪師特別強調：驚風發作時要冷靜，先將孩子側臥，防止窒息，然後立即就醫。小兒推拿可作為輔助治療。',
      nursingAdvice: '驚風緩解後要查明原因，保持環境安靜，避免刺激。',
    ),
    PediatricCondition(
      id: 'xiaochou',
      name: '小兒遺尿',
      nameEn: 'Pediatric Enuresis',
      symptomSummary: '5歲以上仍不能控制排尿',
      symptoms: ['夜間遺尿', '尿床後沉睡不醒', '白天尿頻', '小便清長'],
      tongue: '舌淡苔白',
      pulse: '遲緩',
      syndromeType: '腎氣不固/脾肺氣虛/肝經濕熱',
      massageTechniques: ['補腎經', '揉丹田', '揉命門', '揉三陰交', '捏脊'],
      acupoints: ['腎經', '丹田', '命門', '三陰交'],
      precautions: ['睡前少飲水', '定時叫醒排尿', '不要責罵'],
      niHaixiaNote: '倪師說：遺尿多與腎氣不足有關，要補腎固澀。同時要培養良好的排尿習慣。',
      nursingAdvice: '睡前2小時限制飲水，睡前排尿，家長可在夜間定時叫醒孩子排尿。',
    ),
  ];

  static const List<AcupointPediatric> specialAcupoints = [
    AcupointPediatric(
      id: 'tianheshui_pei',
      name: '天河水（小兒）',
      location: '前臂正中，腕橫紋至肘橫紋之間',
      indication: '外感發熱、咳嗽、暑熱',
      technique: '蘸溫水直推向肘方向',
      dosage: '每分鐘200次，3-5分鐘',
      niHaixiaNote: '倪師說：這是大自然給我們的禮物，退熱效果非常好！',
    ),
    AcupointPediatric(
      id: 'banmen_pei',
      name: '板門（小兒）',
      location: '拇指根部，赤白肉際處',
      indication: '食積、嘔吐、腹脹',
      technique: '揉法或推法',
      dosage: '每側50-100次',
      niHaixiaNote: '板門為脾胃之門，揉之可調理脾胃功能。',
    ),
    AcupointPediatric(
      id: 'xiaotianxin_pei',
      name: '小天心（小兒）',
      location: '大小魚際交界凹陷處',
      indication: '驚風抽搐、夜啼、遺尿',
      technique: '搗法或揉法',
      dosage: '50-100次',
      niHaixiaNote: '小天心可安神鎮驚，是治療小兒驚風的要穴。',
    ),
    AcupointPediatric(
      id: 'tianmen_pei',
      name: '天門（小兒）',
      location: '兩眉心至前髮際正中',
      indication: '感冒發熱、頭疼鼻塞',
      technique: '推法，從下向上',
      dosage: '50-100次',
      niHaixiaNote: '推天門可開竅醒神，是外感的常用穴。',
    ),
    AcupointPediatric(
      id: 'xiaoertian_pei',
      name: '小橫紋（小兒）',
      location: '掌面食指、中指、無名指、小指根節橫紋處',
      indication: '腹脹、口瘡、驚躁',
      technique: '揉法',
      dosage: '每指50次',
    ),
  ];
}
