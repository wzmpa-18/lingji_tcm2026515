import 'package:uuid/uuid.dart';

class FaceReadingResult {
  final String id;
  final String userId;
  final DateTime analyzedAt;
  final OverallFaceAnalysis overallAnalysis;
  final ForeheadAnalysis forehead;
  final EyebrowAnalysis eyebrows;
  final EyeAnalysis eyes;
  final NoseAnalysis nose;
  final MouthAnalysis mouth;
  final ChinAnalysis chin;
  final EarAnalysis ears;
  final FiveSenseAnalysis fiveSense;
  final bool isPremium;
  final String? premiumReportUrl;

  const FaceReadingResult({
    required this.id,
    required this.userId,
    required this.analyzedAt,
    required this.overallAnalysis,
    required this.forehead,
    required this.eyebrows,
    required this.eyes,
    required this.nose,
    required this.mouth,
    required this.chin,
    required this.ears,
    required this.fiveSense,
    this.isPremium = false,
    this.premiumReportUrl,
  });
}

class PalmReadingResult {
  final String id;
  final String userId;
  final DateTime analyzedAt;
  final PalmShapeAnalysis palmShape;
  final LifeLineAnalysis lifeLine;
  final HeartLineAnalysis heartLine;
  final HeadLineAnalysis headLine;
  final MarriageLineAnalysis marriageLine;
  final WealthLineAnalysis wealthLine;
  final MountAnalysis mounts;
  final FingerAnalysis fingers;
  final bool isPremium;

  const PalmReadingResult({
    required this.id,
    required this.userId,
    required this.analyzedAt,
    required this.palmShape,
    required this.lifeLine,
    required this.heartLine,
    required this.headLine,
    required this.marriageLine,
    required this.wealthLine,
    required this.mounts,
    required this.fingers,
    this.isPremium = false,
  });
}

class OverallFaceAnalysis {
  final String faceShape;
  final String faceShapeMeaning;
  final String fiveElementType;
  final String overallFortune;
  final int fortuneScore;
  final List<String> strengths;
  final List<String> weaknesses;
  final String classicalReference;

  const OverallFaceAnalysis({
    required this.faceShape,
    required this.faceShapeMeaning,
    required this.fiveElementType,
    required this.overallFortune,
    required this.fortuneScore,
    required this.strengths,
    required this.weaknesses,
    required this.classicalReference,
  });
}

class ForeheadAnalysis {
  final String height;
  final String width;
  final String fullness;
  final String meaning;
  final List<String> careerPrediction;
  final List<String> wisdomPrediction;

  const ForeheadAnalysis({
    required this.height,
    required this.width,
    required this.fullness,
    required this.meaning,
    required this.careerPrediction,
    required this.wisdomPrediction,
  });
}

class EyebrowAnalysis {
  final String shape;
  final String length;
  final String density;
  final String meaning;
  final List<String> personalityTraits;
  final List<String> relationshipPrediction;

  const EyebrowAnalysis({
    required this.shape,
    required this.length,
    required this.density,
    required this.meaning,
    required this.personalityTraits,
    required this.relationshipPrediction,
  });
}

class EyeAnalysis {
  final String eyeType;
  final String size;
  final String spiritLevel;
  final String meaning;
  final List<String> wealthPrediction;
  final List<String> healthPrediction;

  const EyeAnalysis({
    required this.eyeType,
    required this.size,
    required this.spiritLevel,
    required this.meaning,
    required this.wealthPrediction,
    required this.healthPrediction,
  });
}

class NoseAnalysis {
  final String noseType;
  final String bridgeShape;
  final String tipShape;
  final String meaning;
  final List<String> wealthPrediction;
  final List<String> healthPrediction;

  const NoseAnalysis({
    required this.noseType,
    required this.bridgeShape,
    required this.tipShape,
    required this.meaning,
    required this.wealthPrediction,
    required this.healthPrediction,
  });
}

class MouthAnalysis {
  final String lipShape;
  final String lipColor;
  final String size;
  final String meaning;
  final List<String> relationshipPrediction;
  final List<String> fortunePrediction;

  const MouthAnalysis({
    required this.lipShape,
    required this.lipColor,
    required this.size,
    required this.meaning,
    required this.relationshipPrediction,
    required this.fortunePrediction,
  });
}

class ChinAnalysis {
  final String shape;
  final String length;
  final String meaning;
  final List<String> lateFortunePrediction;

  const ChinAnalysis({
    required this.shape,
    required this.length,
    required this.meaning,
    required this.lateFortunePrediction,
  });
}

class EarAnalysis {
  final String size;
  final String shape;
  final String lobeType;
  final String meaning;
  final List<String> destinyPrediction;

  const EarAnalysis({
    required this.size,
    required this.shape,
    required this.lobeType,
    required this.meaning,
    required this.destinyPrediction,
  });
}

class FiveSenseAnalysis {
  final int overallScore;
  final String overallMeaning;
  final Map<String, int> senseScores;
  final String? fiveElementAdvice;

  const FiveSenseAnalysis({
    required this.overallScore,
    required this.overallMeaning,
    required this.senseScores,
    this.fiveElementAdvice,
  });
}

class PalmShapeAnalysis {
  final String shapeType;
  final String meaning;
  final List<String> personalityTraits;

  const PalmShapeAnalysis({
    required this.shapeType,
    required this.meaning,
    required this.personalityTraits,
  });
}

class LifeLineAnalysis {
  final String length;
  final String depth;
  final String shape;
  final String meaning;
  final List<String> healthPredictions;
  final String classicalReference;

  const LifeLineAnalysis({
    required this.length,
    required this.depth,
    required this.shape,
    required this.meaning,
    required this.healthPredictions,
    required this.classicalReference,
  });
}

class HeartLineAnalysis {
  final String length;
  final String shape;
  final String position;
  final String meaning;
  final List<String> emotionalPredictions;

  const HeartLineAnalysis({
    required this.length,
    required this.shape,
    required this.position,
    required this.meaning,
    required this.emotionalPredictions,
  });
}

class HeadLineAnalysis {
  final String length;
  final String shape;
  final String clarity;
  final String meaning;
  final List<String> intelligencePredictions;

  const HeadLineAnalysis({
    required this.length,
    required this.shape,
    required this.clarity,
    required this.meaning,
    required this.intelligencePredictions,
  });
}

class MarriageLineAnalysis {
  final String count;
  final String clarity;
  final String meaning;
  final List<String> relationshipPredictions;

  const MarriageLineAnalysis({
    required this.count,
    required this.clarity,
    required this.meaning,
    required this.relationshipPredictions,
  });
}

class WealthLineAnalysis {
  final String presence;
  final String clarity;
  final String meaning;
  final List<String> wealthPredictions;

  const WealthLineAnalysis({
    required this.presence,
    required this.clarity,
    required this.meaning,
    required this.wealthPredictions,
  });
}

class MountAnalysis {
  final Map<String, String> mountMeanings;
  final List<String> overallPredictions;

  const MountAnalysis({
    required this.mountMeanings,
    required this.overallPredictions,
  });
}

class FingerAnalysis {
  final Map<String, String> fingerMeanings;
  final List<String> overallPredictions;

  const FingerAnalysis({
    required this.fingerMeanings,
    required this.overallPredictions,
  });
}

class MaitaiFaceReadingService {
  static final MaitaiFaceReadingService _instance = MaitaiFaceReadingService._internal();
  factory MaitaiFaceReadingService() => _instance;
  MaitaiFaceReadingService._internal();

  static const String classicalSource = '《麻衣神相》';

  FaceReadingResult analyzeFace({
    required String userId,
    String? faceShape,
    String? foreheadType,
    String? eyebrowType,
    String? eyeType,
    String? noseType,
    String? mouthType,
    String? chinType,
    String? earType,
  }) {
    final overall = _analyzeOverallFace(faceShape ?? '圓形');
    final forehead = _analyzeForehead(foreheadType ?? '飽滿');
    final eyebrows = _analyzeEyebrows(eyebrowType ?? '標準');
    final eyes = _analyzeEyes(eyeType ?? '有神');
    final nose = _analyzeNose(noseType ?? '端正');
    final mouth = _analyzeMouth(mouthType ?? '紅潤');
    final chin = _analyzeChin(chinType ?? '飽滿');
    final ears = _analyzeEars(earType ?? '分明');
    final fiveSense = _analyzeFiveSense(overall, forehead, eyes, nose, mouth);

    return FaceReadingResult(
      id: const Uuid().v4(),
      userId: userId,
      analyzedAt: DateTime.now(),
      overallAnalysis: overall,
      forehead: forehead,
      eyebrows: eyebrows,
      eyes: eyes,
      nose: nose,
      mouth: mouth,
      chin: chin,
      ears: ears,
      fiveSense: fiveSense,
    );
  }

  OverallFaceAnalysis _analyzeOverallFace(String faceShape) {
    String shapeMeaning;
    String fiveElement;
    String fortune;
    int score;
    final strengths = <String>[];
    final weaknesses = <String>[];

    switch (faceShape) {
      case '圓形':
        shapeMeaning = '圓形面者，性情温和，人緣極佳，善於社交，一生福澤深厚';
        fiveElement = '土形人';
        fortune = '福壽雙全，子孫滿堂';
        score = 85;
        strengths.addAll(['人緣好', '性格溫和', '福氣深厚']);
        weaknesses.add('有時過於隨和');
        break;
      case '方形':
        shapeMeaning = '方形面者，性格剛毅，有領導才能，事業心強，敢作敢當';
        fiveElement = '木形人';
        fortune = '事業發達，權柄在握';
        score = 82;
        strengths.addAll(['有魄力', '事業心強', '領導才能']);
        weaknesses.add('脾氣固執');
        break;
      case '長形':
        shapeMeaning = '長形面者，思維敏捷，聰明伶俐，適合學術研究';
        fiveElement = '木形人';
        fortune = '智慧超群，學業有成';
        score = 78;
        strengths.addAll(['智商高', '思維敏捷', '專注力強']);
        weaknesses.add('身體較弱');
        break;
      case '瓜子形':
        shapeMeaning = '瓜子面者，相貌秀美，感情豐富，藝術天賦高';
        fiveElement = '金形人';
        fortune = '才貌雙全，桃花運旺';
        score = 88;
        strengths.addAll(['相貌出眾', '藝術氣質', '情感細膩']);
        weaknesses.add('有時過於理想化');
        break;
      case '橢圓形':
        shapeMeaning = '橢圓形面者，中庸平和，適應力強，各方面均衡發展';
        fiveElement = '水形人';
        fortune = '一生平穩，福禍相抵';
        score = 75;
        strengths.addAll(['適應力強', '性格穩定', '運勢平穩']);
        weaknesses.add('缺乏突出特點');
        break;
      default:
        shapeMeaning = '此面相者，命運獨特，需細觀各部位';
        fiveElement = '土形人';
        fortune = '命運中等';
        score = 70;
    }

    return OverallFaceAnalysis(
      faceShape: faceShape,
      faceShapeMeaning: shapeMeaning,
      fiveElementType: fiveElement,
      overallFortune: fortune,
      fortuneScore: score,
      strengths: strengths,
      weaknesses: weaknesses,
      classicalReference: '$classicalSource：「面相者，心之鏡也」',
    );
  }

  ForeheadAnalysis _analyzeForehead(String type) {
    String meaning;
    final career = <String>[];
    final wisdom = <String>[];

    switch (type) {
      case '飽滿':
        meaning = '額頭飽滿者，早年運勢佳，事業心強，有遠大抱負';
        career.add('30歲前事業有成');
        career.add('適合創業或管理崗位');
        wisdom.add('思維清晰，判斷力強');
        wisdom.add('學習能力出眾');
        break;
      case '光滑':
        meaning = '額頭光滑者，聰明伶俐，反應敏捷，適應能力強';
        career.add('適合技術類工作');
        career.add('學術研究有成就');
        wisdom.add('悟性高，舉一反三');
        break;
      case '有紋':
        meaning = '額頭有紋者，歷經磨練，但意志堅強';
        career.add('中年後事業穩定');
        career.add('需防小人是非');
        wisdom.add('經驗豐富，處事老練');
        break;
      default:
        meaning = '此額相者，運勢中等';
    }

    return ForeheadAnalysis(
      height: type,
      width: '標准',
      fullness: type,
      meaning: meaning,
      careerPrediction: career,
      wisdomPrediction: wisdom,
    );
  }

  EyebrowAnalysis _analyzeEyebrows(String type) {
    String meaning;
    final personality = <String>[];
    final relationship = <String>[];

    switch (type) {
      case '柳葉眉':
        meaning = '柳葉眉者，感情細膩，異性緣佳，家庭美滿';
        personality.add('溫柔體貼');
        personality.add('藝術氣質');
        relationship.add('婚姻美滿');
        relationship.add('異性相助');
        break;
      case '劍眉':
        meaning = '劍眉者，有俠義之心，事業心強，敢作敢當';
        personality.add('正義感強');
        personality.add('執行力高');
        relationship.add('朋友眾多');
        relationship.add('需注意感情表達');
        break;
      case '粗眉':
        meaning = '粗眉者，性格豪爽，精力充沛，意志堅定';
        personality.add('魄力十足');
        personality.add('不服輸');
        relationship.add('人際關係廣泛');
        relationship.add('兄弟朋友多');
        break;
      case '細眉':
        meaning = '細眉者，心思細密，觀察力強，略有神秘感';
        personality.add('觀察敏銳');
        personality.add('做事細心');
        relationship.add('知心朋友少');
        relationship.add('需多表達情感');
        break;
      default:
        meaning = '眉毛代表兄弟姐妹緣和感情運';
    }

    return EyebrowAnalysis(
      shape: type,
      length: '標準',
      density: '均勻',
      meaning: meaning,
      personalityTraits: personality,
      relationshipPrediction: relationship,
    );
  }

  EyeAnalysis _analyzeEyes(String type) {
    String meaning;
    final wealth = <String>[];
    final health = <String>[];

    switch (type) {
      case '有神':
        meaning = '眼神有神者，精力充沛，意志堅強，有貴人運';
        wealth.add('財運亨通');
        wealth.add('善於理財');
        health.add('身體健康');
        health.add('精力旺盛');
        break;
      case '清澈':
        meaning = '眼神清澈者，心地善良，智商較高，學業有成';
        wealth.add('適合技術類工作');
        wealth.add('薪資穩定');
        health.add('注意用眼衛生');
        break;
      case '深邃':
        meaning = '眼神深邃者，城府較深，思考周全，有領導才能';
        wealth.add('適合成為管理者');
        wealth.add('理財觀念強');
        health.add('注意心腦血管健康');
        break;
      default:
        meaning = '眼睛為五官之神，，眼神主宰命運';
    }

    return EyeAnalysis(
      eyeType: type,
      size: '標準',
      spiritLevel: type,
      meaning: meaning,
      wealthPrediction: wealth,
      healthPrediction: health,
    );
  }

  NoseAnalysis _analyzeNose(String type) {
    String meaning;
    final wealth = <String>[];
    final health = <String>[];

    switch (type) {
      case '端正':
        meaning = '鼻子端正者，為人正直，信用良好，財運穩定';
        wealth.add('正財運佳');
        wealth.add('善於積累');
        health.add('呼吸系統健康');
        break;
      case '挺直':
        meaning = '鼻子挺直者，有魄力，決斷力強，事業心重';
        wealth.add('事業成功財運');
        wealth.add('善於把握機會');
        health.add('注意肺部健康');
        break;
      case '豐滿':
        meaning = '鼻子豐滿者，財運旺盛，善於理財，享受生活';
        wealth.add('財庫充盈');
        wealth.add('理財能力強');
        health.add('消化系統良好');
        break;
      default:
        meaning = '鼻子為財帛宮，掌管財運';
    }

    return NoseAnalysis(
      noseType: type,
      bridgeShape: '挺直',
      tipShape: type,
      meaning: meaning,
      wealthPrediction: wealth,
      healthPrediction: health,
    );
  }

  MouthAnalysis _analyzeMouth(String type) {
    String meaning;
    final relationship = <String>[];
    final fortune = <String>[];

    switch (type) {
      case '紅潤':
        meaning = '嘴唇紅潤者，氣血充足，感情豐富，人際關係好';
        relationship.add('感情美滿');
        relationship.add('桃花運旺');
        fortune.add('口才好，適合計劃類工作');
        fortune.add('善於溝通協調');
        break;
      case '飽滿':
        meaning = '嘴唇飽滿者，意志堅強，執行力高，有領導力';
        relationship.add('有責任心');
        relationship.add('家庭觀念強');
        fortune.add('事業心重');
        fortune.add('善於帶團隊');
        break;
      case '適中':
        meaning = '嘴唇厚薄適中者，中庸平和，各方面運勢均衡';
        relationship.add('感情穩定');
        relationship.add('婚姻美滿');
        fortune.add('一生平穩');
        fortune.add('無大起大落');
        break;
      default:
        meaning = '嘴巴為出納官，掌管衣祿';
    }

    return MouthAnalysis(
      lipShape: type,
      lipColor: type,
      size: '標準',
      meaning: meaning,
      relationshipPrediction: relationship,
      fortunePrediction: fortune,
    );
  }

  ChinAnalysis _analyzeChin(String type) {
    String meaning;
    final lateFortune = <String>[];

    switch (type) {
      case '飽滿':
        meaning = '下巴飽滿者，晚景昌隆，子孫孝順，晚年享福';
        lateFortune.add('晚年運勢佳');
        lateFortune.add('子女有出息');
        lateFortune.add('健康長壽');
        break;
      case '方正':
        meaning = '下巴方正者，有魄力，意志堅強，晚年事業有成';
        lateFortune.add('事業持續發展');
        lateFortune.add('積累財富');
        break;
      case '尖削':
        meaning = '下巴尖削者，晚運稍弱，需提前做好規劃';
        lateFortune.add('注意財務規劃');
        lateFortune.add('防範晚年疾病');
        break;
      default:
        meaning = '下巴為奴僕宮，掌管晚年運勢';
    }

    return ChinAnalysis(
      shape: type,
      length: '標準',
      meaning: meaning,
      lateFortunePrediction: lateFortune,
    );
  }

  EarAnalysis _analyzeEars(String type) {
    String meaning;
    final destiny = <String>[];

    switch (type) {
      case '分明':
        meaning = '耳朵分明者，腎氣充足，精力旺盛，壽命較長';
        destiny.add('身體健康');
        destiny.add('晚年有福');
        destiny.add('與祖上有緣');
        break;
      case '厚實':
        meaning = '耳朵厚實者，精力充沛，意志堅強，有魄力';
        destiny.add('事業有成');
        destiny.add('財運穩定');
        break;
      default:
        meaning = '耳朵為採听官，掌管腎氣和壽命';
    }

    return EarAnalysis(
      size: type,
      shape: '標準',
      lobeType: '分明',
      meaning: meaning,
      destinyPrediction: destiny,
    );
  }

  FiveSenseAnalysis _analyzeFiveSense(
    OverallFaceAnalysis overall,
    ForeheadAnalysis forehead,
    EyeAnalysis eyes,
    NoseAnalysis nose,
    MouthAnalysis mouth,
  ) {
    final senseScores = {
      '眼': eyes.spiritLevel == '有神' ? 90 : 75,
      '耳': 80,
      '鼻': nose.noseType == '端正' ? 85 : 70,
      '口': mouth.mouthType == '紅潤' ? 88 : 72,
      '額': forehead.height == '飽滿' ? 85 : 70,
    };

    final overallScore = (senseScores['眼']! + senseScores['耳']! + 
        senseScores['鼻']! + senseScores['口']! + senseScores['額']!) ~/ 5;

    String overallMeaning;
    if (overallScore >= 85) {
      overallMeaning = '五官端正，精神充沛，為富貴之相';
    } else if (overallScore >= 75) {
      overallMeaning = '五官勻稱，運勢中等，可通過努力改變命運';
    } else {
      overallMeaning = '五官略有不足，但命運掌握在自己手中';
    }

    return FiveSenseAnalysis(
      overallScore: overallScore,
      overallMeaning: overallMeaning,
      senseScores: senseScores,
      fiveElementAdvice: '建議通過修身養性彌補面相不足',
    );
  }

  PalmReadingResult analyzePalm({
    required String userId,
    String? palmShape,
    String? lifeLineType,
    String? heartLineType,
    String? headLineType,
    String? marriageLineType,
  }) {
    final palm = _analyzePalmShape(palmShape ?? '方形');
    final lifeLine = _analyzeLifeLine(lifeLineType ?? '深長');
    final heartLine = _analyzeHeartLine(heartLineType ?? '彎曲');
    final headLine = _analyzeHeadLine(headLineType ?? '清晰');
    final marriageLine = _analyzeMarriageLine(marriageLineType ?? '一條');
    final wealthLine = _analyzeWealthLine('有');
    final mounts = _analyzeMounts();
    final fingers = _analyzeFingers();

    return PalmReadingResult(
      id: const Uuid().v4(),
      userId: userId,
      analyzedAt: DateTime.now(),
      palmShape: palm,
      lifeLine: lifeLine,
      heartLine: heartLine,
      headLine: headLine,
      marriageLine: marriageLine,
      wealthLine: wealthLine,
      mounts: mounts,
      fingers: fingers,
    );
  }

  PalmShapeAnalysis _analyzePalmShape(String type) {
    String meaning;
    final personality = <String>[];

    switch (type) {
      case '方形':
        meaning = '方形掌者，性格務實，做事有規劃，適合技術類工作';
        personality.addAll(['務實', '踏實', '有條理']);
        break;
      case '圓形':
        meaning = '圓形掌者，性格靈活，善於變通，適應能力強';
        personality.addAll(['靈活', '適應力強', '社交能力好']);
        break;
      case '長形':
        meaning = '長形掌者，思維敏銳，想像力豐富，適合藝術類工作';
        personality.addAll(['創意足', '想像力豐富', '藝術氣質']);
        break;
      default:
        meaning = '手掌形態反映性格特點';
    }

    return PalmShapeAnalysis(
      shapeType: type,
      meaning: meaning,
      personalityTraits: personality,
    );
  }

  LifeLineAnalysis _analyzeLifeLine(String type) {
    String meaning;
    final health = <String>[];

    switch (type) {
      case '深長':
        meaning = '生命線深長者，精力充沛，身體健康，壽命較長';
        health.add('身體素質好');
        health.add('恢復能力強');
        health.add('晚年健康');
        break;
      case '清晰':
        meaning = '生命線清晰者，健康運勢良好';
        health.add('注意保養');
        health.add('定期體檢');
        break;
      default:
        meaning = '生命線掌管健康和壽命';
    }

    return LifeLineAnalysis(
      length: type,
      depth: '中等',
      shape: type,
      meaning: meaning,
      healthPredictions: health,
      classicalReference: '$classicalSource：「生命線者，壽夭之別也」',
    );
  }

  HeartLineAnalysis _analyzeHeartLine(String type) {
    String meaning;
    final emotional = <String>[];

    switch (type) {
      case '彎曲':
        meaning = '感情線彎曲者，感情豐富，善於表達';
        emotional.add('感情細膩');
        emotional.add('善於浪漫');
        break;
      case '直線':
        meaning = '感情線直線者，感情專一，踏實可靠';
        emotional.add('專一痴情');
        emotional.add('責任心強');
        break;
      default:
        meaning = '感情線掌管愛情和情感';
    }

    return HeartLineAnalysis(
      length: '標準',
      shape: type,
      position: '中等',
      meaning: meaning,
      emotionalPredictions: emotional,
    );
  }

  HeadLineAnalysis _analyzeHeadLine(String type) {
    String meaning;
    final intelligence = <String>[];

    switch (type) {
      case '清晰':
        meaning = '智慧線清晰者，思維清晰，判斷力強';
        intelligence.add('學習能力強');
        intelligence.add('善於分析');
        break;
      case '深長':
        meaning = '智慧線深長者，智商高，邏輯思維強';
        intelligence.add('學術有成');
        intelligence.add('策劃能力強');
        break;
      default:
        meaning = '智慧線掌管思維和智慧';
    }

    return HeadLineAnalysis(
      length: '標準',
      shape: type,
      clarity: type,
      meaning: meaning,
      intelligencePredictions: intelligence,
    );
  }

  MarriageLineAnalysis _analyzeMarriageLine(String type) {
    String meaning;
    final relationship = <String>[];

    switch (type) {
      case '一條':
        meaning = '婚姻線一條者，感情專一，婚姻穩定';
        relationship.add('婚姻美滿');
        relationship.add('家庭和睦');
        break;
      case '多條':
        meaning = '婚姻線多條者，桃花運旺，感情經歷豐富';
        relationship.add('異性緣好');
        relationship.add('需慎選伴侶');
        break;
      default:
        meaning = '婚姻線掌管愛情和婚姻';
    }

    return MarriageLineAnalysis(
      count: type,
      clarity: '清晰',
      meaning: meaning,
      relationshipPredictions: relationship,
    );
  }

  WealthLineAnalysis _analyzeWealthLine(String presence) {
    return WealthLineAnalysis(
      presence: presence,
      clarity: '中等',
      meaning: presence == '有' ? '有財運線，財富積累能力強' : '需努力創造財富',
      wealthPredictions: presence == '有' 
          ? ['善於理財', '有偏財運'] 
          : ['正財運穩定', '理財觀念需加強'],
    );
  }

  MountAnalysis _analyzeMounts() {
    return MountAnalysis(
      mountMeanings: {
        '金星丘': '代表精力和活力',
        '木星丘': '代表野心和事業',
        '土星丘': '代表思維和智慧',
        '太陽丘': '代表財富和名聲',
        '水星丘': '代表溝通和商務',
        '月丘': '代表想像力和藝術',
      },
      overallPredictions: ['各丘飽滿者各方面運勢佳'],
    );
  }

  FingerAnalysis _analyzeFingers() {
    return FingerAnalysis(
      fingerMeanings: {
        '拇指': '代表意志和魄力',
        '食指': '代表野心和權力',
        '中指': '代表責任感和運勢',
        '無名指': '代表藝術和婚姻',
        '小指': '代表溝通和智慧',
      },
      overallPredictions: ['手指修長者聰明伶俐'],
    );
  }

  String generateSimpleFaceReport(FaceReadingResult result) {
    final buffer = StringBuffer();
    buffer.writeln('═══ 面相分析報告 ═══');
    buffer.writeln('');
    buffer.writeln('【整體面相】');
    buffer.writeln('面型：${result.overallAnalysis.faceShape}');
    buffer.writeln('五行：${result.overallAnalysis.fiveElementType}');
    buffer.writeln('福氣指數：${result.overallAnalysis.fortuneScore}/100');
    buffer.writeln(result.overallAnalysis.faceShapeMeaning);
    buffer.writeln('');
    buffer.writeln('【五官分析】');
    buffer.writeln('額：${result.forehead.meaning}');
    buffer.writeln('眉：${result.eyebrows.meaning}');
    buffer.writeln('眼：${result.eyes.meaning}');
    buffer.writeln('鼻：${result.nose.meaning}');
    buffer.writeln('口：${result.mouth.meaning}');
    buffer.writeln('下巴：${result.chin.meaning}');
    buffer.writeln('');
    buffer.writeln('─────────────────────────');
    buffer.writeln('AI測算僅供參考');
    return buffer.toString();
  }

  String generatePremiumFaceReport(FaceReadingResult result) {
    final simple = generateSimpleFaceReport(result);
    final buffer = StringBuffer(simple);
    
    buffer.writeln('');
    buffer.writeln('═══════════════════════════════');
    buffer.writeln('【深度完整分析】');
    buffer.writeln('═══════════════════════════════');
    buffer.writeln('');
    buffer.writeln('【面相淵源】');
    buffer.writeln('$classicalSource為我國傳統面相學經典之作');
    buffer.writeln('相學認為：面者，心之苗也；心者，五臟之宗也');
    buffer.writeln('');
    buffer.writeln('【五行面相學說】');
    buffer.writeln('木形人：面長而青，仁慈好學');
    buffer.writeln('火形人：面尖而紅，禮讓好客');
    buffer.writeln('土形人：面方而黃，誠信務實');
    buffer.writeln('金形人：面白而方，果斷剛毅');
    buffer.writeln('水形人：面黑而圓，聰明靈活');
    buffer.writeln('');
    buffer.writeln('【各宮位詳細分析】');
    buffer.writeln('命宮（兩眉之間）：主宰命運起伏');
    buffer.writeln('財帛宮（鼻子）：主宰財運多寡');
    buffer.writeln('夫妻宮（眼角）：主宰婚姻情感');
    buffer.writeln('子女宮（眼下）：主宰子嗣緣分');
    buffer.writeln('疾厄宮（山根）：主宰健康吉凶');
    buffer.writeln('遷移宮（額角）：主宰外出運勢');
    buffer.writeln('');
    buffer.writeln('【改運建議】');
    buffer.writeln('• 修養心性：面相可隨心境改變');
    buffer.writeln('• 積德行善：善相源於善心');
    buffer.writeln('• 注意保養：面相反映健康');
    buffer.writeln('');
    buffer.writeln('完整報告售價：80元/次');
    buffer.writeln('如需一對一專業解讀，請預約平台師傅');
    
    return buffer.toString();
  }
}
