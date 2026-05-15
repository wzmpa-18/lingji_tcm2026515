import '../acupuncture/dong_acupoint.dart';
import '../acupuncture/nihaixia_acupoint.dart';
import '../acupuncture/acupoint.dart';

class AcupuncturePrescriptionService {
  static final AcupuncturePrescriptionService _instance = AcupuncturePrescriptionService._internal();
  factory AcupuncturePrescriptionService() => _instance;
  AcupuncturePrescriptionService._internal();

  List<AcupuncturePrescription> generatePrescription({
    required PatientSymptoms symptoms,
    required DiagnosisInfo diagnosis,
    required AcupointSelectionMode mode,
  }) {
    final prescriptions = <AcupuncturePrescription>[];

    if (mode.includeDongPoints || mode.includeAll) {
      prescriptions.addAll(_generateDongPrescription(symptoms, diagnosis));
    }

    if (mode.includeNiHaixiaPoints || mode.includeAll) {
      prescriptions.addAll(_generateNiHaixiaPrescription(symptoms, diagnosis));
    }

    if (mode.includeTraditionalPoints || mode.includeAll) {
      prescriptions.addAll(_generateTraditionalPrescription(symptoms, diagnosis));
    }

    return _prioritizeAndSortPrescriptions(prescriptions);
  }

  List<AcupuncturePrescription> _generateDongPrescription(
    PatientSymptoms symptoms,
    DiagnosisInfo diagnosis,
  ) {
    final prescriptions = <AcupuncturePrescription>[];

    for (final symptom in symptoms.mainSymptoms) {
      final dongPoints = DongAcupointCollection.findByIndication(symptom);
      for (final point in dongPoints) {
        prescriptions.add(AcupuncturePrescription(
          acupointId: point.id,
          acupointName: point.name,
          acupointNameEn: point.nameEn,
          acupointNamePinyin: point.namePinyin,
          acupointType: AcupointType.dongExtraordinary,
          acupointSource: '董氏奇穴',
          isMainPoint: _isMainPoint(point.indications, symptoms.mainSymptoms),
          isPairedPoint: !_isMainPoint(point.indications, symptoms.mainSymptoms),
          needleDepth: point.needleDepth,
          needleAngle: point.needleAngle,
          manipulation: point.manipulation,
          reinforcementReduction: point.reinforcementReduction,
          principle: _generateDongPrinciple(point, diagnosis),
          clinicalNote: point.clinicalApplication,
          sourceReference: point.sourceReferences.isNotEmpty 
              ? point.sourceReferences.first 
              : '丘雅昌董氏奇穴講座',
          qiArrival: point.qiArrival,
          timing: _calculateTiming(point, symptoms),
          contraindication: point.notes,
          combinationPoints: point.pairedAcupoints,
        ));
      }
    }

    return prescriptions;
  }

  List<AcupuncturePrescription> _generateNiHaixiaPrescription(
    PatientSymptoms symptoms,
    DiagnosisInfo diagnosis,
  ) {
    final prescriptions = <AcupuncturePrescription>[];

    for (final symptom in symptoms.mainSymptoms) {
      final niHaixiaPoints = NiHaixiaCollection.findByIndication(symptom);
      for (final point in niHaixiaPoints) {
        prescriptions.add(AcupuncturePrescription(
          acupointId: point.id,
          acupointName: point.name,
          acupointNameEn: point.nameEn,
          acupointNamePinyin: point.namePinyin,
          acupointType: AcupointType.niHaixiaSpecial,
          acupointSource: '倪海厦特效穴',
          isMainPoint: _isMainPoint(point.indications, symptoms.mainSymptoms),
          isPairedPoint: !_isMainPoint(point.indications, symptoms.mainSymptoms),
          needleDepth: point.needleDepth,
          needleAngle: point.needleAngle,
          manipulation: point.manipulation,
          reinforcementReduction: point.manipulation,
          principle: _generateNiHaixiaPrinciple(point, diagnosis),
          clinicalNote: point.niHaixiaInsight,
          sourceReference: '倪海厦《人紀》系列',
          qiArrival: point.needleResponse,
          timing: _calculateTiming(point, symptoms),
          contraindication: point.contraindication,
          combinationPoints: [point.combination],
        ));
      }
    }

    return prescriptions;
  }

  List<AcupuncturePrescription> _generateTraditionalPrescription(
    PatientSymptoms symptoms,
    DiagnosisInfo diagnosis,
  ) {
    final prescriptions = <AcupuncturePrescription>[];

    final syndrome = diagnosis.syndromeType;
    final prescriptionsBySyndrome = _getTraditionalPrescriptionsBySyndrome(syndrome);

    for (final pointData in prescriptionsBySyndrome) {
      prescriptions.add(AcupuncturePrescription(
        acupointId: pointData['id'] as String,
        acupointName: pointData['name'] as String,
        acupointNameEn: pointData['nameEn'] as String,
        acupointNamePinyin: pointData['namePinyin'] as String,
        acupointType: AcupointType.traditionalMeridian,
        acupointSource: '傳統經穴',
        isMainPoint: pointData['isMain'] as bool? ?? false,
        isPairedPoint: !(pointData['isMain'] as bool? ?? false),
        needleDepth: pointData['depth'] as String,
        needleAngle: '直刺或斜刺',
        manipulation: pointData['manipulation'] as String,
        reinforcementReduction: pointData['method'] as String,
        principle: _generateTraditionalPrinciple(pointData, diagnosis),
        clinicalNote: pointData['note'] as String,
        sourceReference: '《針灸大成》',
        qiArrival: pointData['response'] as String? ?? '酸脹感',
        timing: _calculateTimingTraditional(pointData, symptoms),
        contraindication: pointData['contraindication'] as String? ?? '',
      ));
    }

    return prescriptions;
  }

  Map<String, dynamic> _getTraditionalPrescriptionsBySyndrome(String syndrome) {
    final prescriptions = <Map<String, dynamic>>[];

    switch (syndrome) {
      case 'windColdInvasion':
        prescriptions.addAll([
          {'id': 'lg4', 'name': '合谷', 'nameEn': 'Hegu', 'namePinyin': 'Hé Gǔ', 'depth': '0.5-1寸', 'manipulation': '捻轉瀉法', 'method': '瀉法', 'isMain': true, 'note': '疏散風寒', 'response': '局部酸脹', 'contraindication': '孕婦禁針'},
          {'id': 'li11', 'name': '曲池', 'nameEn': 'Quchi', 'namePinyin': 'Qū Chí', 'depth': '1-1.5寸', 'manipulation': '捻轉瀉法', 'method': '瀉法', 'isMain': false, 'note': '清熱解表', 'response': '酸脹感'},
          {'id': 'bl12', 'name': '風門', 'nameEn': 'Fengmen', 'namePinyin': 'Fēng Mén', 'depth': '0.5-1寸', 'manipulation': '斜刺', 'method': '瀉法', 'isMain': false, 'note': '祛風散寒', 'response': '局部酸脹'},
          {'id': 'du14', 'name': '大椎', 'nameEn': 'Dazhui', 'namePinyin': 'Dà Zhuī', 'depth': '0.5-1寸', 'manipulation': '斜刺', 'method': '瀉法', 'isMain': false, 'note': '解表退熱', 'response': '酸脹感'},
        ]);
        break;
      case 'windHeatInvasion':
        prescriptions.addAll([
          {'id': 'li4', 'name': '合谷', 'nameEn': 'Hegu', 'namePinyin': 'Hé Gǔ', 'depth': '0.5-1寸', 'manipulation': '捻轉瀉法', 'method': '瀉法', 'isMain': true, 'note': '疏散風熱', 'response': '局部酸脹', 'contraindication': '孕婦禁針'},
          {'id': 'li11', 'name': '曲池', 'nameEn': 'Quchi', 'namePinyin': 'Qū Chí', 'depth': '1-1.5寸', 'manipulation': '大幅度捻轉', 'method': '瀉法', 'isMain': true, 'note': '清熱瀉火', 'response': '酸脹感'},
          {'id': 'du14', 'name': '大椎', 'nameEn': 'Dazhui', 'namePinyin': 'Dà Zhuī', 'depth': '0.5-1寸', 'manipulation': '刺絡拔罐', 'method': '瀉法', 'isMain': false, 'note': '清熱解表', 'response': '放血'},
        ]);
        break;
      case 'liverQiStagnation':
        prescriptions.addAll([
          {'id': 'lr3', 'name': '太衝', 'nameEn': 'Taichong', 'namePinyin': 'Tài Chōng', 'depth': '0.5-1寸', 'manipulation': '捻轉瀉法', 'method': '瀉法', 'isMain': true, 'note': '疏肝解鬱', 'response': '酸脹感'},
          {'id': 'lr13', 'name': '章門', 'nameEn': 'Zhangmen', 'namePinyin': 'Zhāng Mén', 'depth': '0.5-1寸', 'manipulation': '斜刺', 'method': '平補平瀉', 'isMain': false, 'note': '疏肝理氣', 'response': '局部酸脹'},
          {'id': 'gb34', 'name': '陽陵泉', 'nameEn': 'Yanglingquan', 'namePinyin': 'Yáng Líng Quán', 'depth': '1-1.5寸', 'manipulation': '捻轉瀉法', 'method': '瀉法', 'isMain': false, 'note': '疏筋利膽', 'response': '酸脹向下放射'},
        ]);
        break;
      case 'spleenQiDeficiency':
        prescriptions.addAll([
          {'id': 'sp6', 'name': '三陰交', 'nameEn': 'Sanyinjiao', 'namePinyin': 'Sān Yīn Jiāo', 'depth': '1-1.5寸', 'manipulation': '捻轉補法', 'method': '補法', 'isMain': true, 'note': '健脾益氣', 'response': '酸脹感', 'contraindication': '孕婦禁針'},
          {'id': 'st36', 'name': '足三里', 'nameEn': 'Zusanli', 'namePinyin': 'Zú Sān Lǐ', 'depth': '1-1.5寸', 'manipulation': '捻轉補法', 'method': '補法', 'isMain': true, 'note': '健脾和胃', 'response': '酸脹向下放射'},
          {'id': 'rn12', 'name': '中脘', 'nameEn': 'Zhongwan', 'namePinyin': 'Zhōng Wǎn', 'depth': '1-1.5寸', 'manipulation': '捻轉', 'method': '平補平瀉', 'isMain': false, 'note': '調理中焦', 'response': '局部酸脹'},
        ]);
        break;
      case 'kidneyYangDeficiency':
        prescriptions.addAll([
          {'id': 'ki3', 'name': '太谿', 'nameEn': 'Taixi', 'namePinyin': 'Tài Xī', 'depth': '0.5-1寸', 'manipulation': '捻轉補法', 'method': '補法', 'isMain': true, 'note': '補腎填精', 'response': '酸脹感'},
          {'id': 'du4', 'name': '命門', 'nameEn': 'Mingmen', 'namePinyin': 'Mìng Mén', 'depth': '0.5-1寸', 'manipulation': '捻轉補法', 'method': '補法', 'isMain': true, 'note': '溫補腎陽', 'response': '局部酸脹'},
          {'id': 'bl23', 'name': '腎俞', 'nameEn': 'Shenshu', 'namePinyin': 'Shèn Shū', 'depth': '0.5-1寸', 'manipulation': '斜刺', 'method': '補法', 'isMain': false, 'note': '補腎益精', 'response': '酸脹感'},
          {'id': 'rn6', 'name': '關元', 'nameEn': 'Guanyuan', 'namePinyin': 'Guān Yuán', 'depth': '1-2寸', 'manipulation': '艾灸', 'method': '補法', 'isMain': false, 'note': '補腎壯陽', 'response': '溫熱感'},
        ]);
        break;
      case 'bloodStasis':
        prescriptions.addAll([
          {'id': 'sp10', 'name': '血海', 'nameEn': 'Xuehai', 'namePinyin': 'Xuè Hǎi', 'depth': '1-1.5寸', 'manipulation': '捻轉', 'method': '平補平瀉', 'isMain': true, 'note': '活血化瘀', 'response': '酸脹感'},
          {'id': 'lr3', 'name': '太衝', 'nameEn': 'Taichong', 'namePinyin': 'Tài Chōng', 'depth': '0.5-1寸', 'manipulation': '捻轉瀉法', 'method': '瀉法', 'isMain': true, 'note': '行氣活血', 'response': '酸脹感'},
          {'id': 'bl17', 'name': '膈俞', 'nameEn': 'Geshu', 'namePinyin': 'Gé Shū', 'depth': '0.5-1寸', 'manipulation': '斜刺', 'method': '平補平瀉', 'isMain': false, 'note': '活血化瘀', 'response': '局部酸脹'},
        ]);
        break;
      default:
        prescriptions.addAll([
          {'id': 'st36', 'name': '足三里', 'nameEn': 'Zusanli', 'namePinyin': 'Zú Sān Lǐ', 'depth': '1-1.5寸', 'manipulation': '捻轉補法', 'method': '補法', 'isMain': true, 'note': '調理脾胃', 'response': '酸脹向下放射'},
          {'id': 'rn12', 'name': '中脘', 'nameEn': 'Zhongwan', 'namePinyin': 'Zhōng Wǎn', 'depth': '1-1.5寸', 'manipulation': '捻轉', 'method': '平補平瀉', 'isMain': true, 'note': '調理中焦', 'response': '局部酸脹'},
        ]);
    }

    return prescriptions;
  }

  List<AcupuncturePrescription> _prioritizeAndSortPrescriptions(
    List<AcupuncturePrescription> prescriptions,
  ) {
    final seen = <String>{};
    final unique = <AcupuncturePrescription>[];
    
    for (final p in prescriptions) {
      final key = '${p.acupointId}_${p.acupointType.name}';
      if (!seen.contains(key)) {
        seen.add(key);
        unique.add(p);
      }
    }

    unique.sort((a, b) {
      if (a.isMainPoint && !b.isMainPoint) return -1;
      if (!a.isMainPoint && b.isMainPoint) return 1;
      return 0;
    });

    return unique;
  }

  bool _isMainPoint(List<String> indications, List<String> symptoms) {
    for (final symptom in symptoms) {
      if (indications.any((i) => i.contains(symptom) || symptom.contains(i))) {
        return true;
      }
    }
    return false;
  }

  String _generateDongPrinciple(DongAcupoint point, DiagnosisInfo diagnosis) {
    return '董氏奇穴主治${point.indication}，配合辨證為${diagnosis.syndromeName}，選此穴以達到${diagnosis.therapeuticPrinciple}之效';
  }

  String _generateNiHaixiaPrinciple(NiHaixiaAcupoint point, DiagnosisInfo diagnosis) {
    return '倪師重用${point.name}治${point.indication}，配合辨證${diagnosis.syndromeName}，取其${point.niHaixiaInsight.split('，')[0]}之功';
  }

  String _generateTraditionalPrinciple(Map<String, dynamic> point, DiagnosisInfo diagnosis) {
    return '取${point['name']}以${point['note']}，配合辨證屬${diagnosis.syndromeName}，共奏${diagnosis.therapeuticPrinciple}之功';
  }

  String _calculateTiming(dynamic point, PatientSymptoms symptoms) {
    final timing = StringBuffer();
    if (symptoms.isAcute) {
      timing.write('每日或隔日治療，');
    } else {
      timing.write('每週2-3次，');
    }
    timing.write('留針20-30分鐘');
    return timing.toString();
  }

  String _calculateTimingTraditional(Map<String, dynamic> point, PatientSymptoms symptoms) {
    final timing = StringBuffer();
    if (symptoms.isAcute) {
      timing.write('每日治療，');
    } else {
      timing.write('每週2-3次，');
    }
    timing.write('留針20-30分鐘，');
    if (point['method'] == '補法') {
      timing.write('可用艾灸加強');
    } else {
      timing.write('可配合電針');
    }
    return timing.toString();
  }

  DiagnosisResult performDiagnosis(DiagnosisInfo info) {
    String syndromeType = '';
    String syndromeName = '';
    String therapeuticPrinciple = '';
    String treatmentStrategy = '';

    final symptomSummary = info.symptoms.join('、');
    final tongueSummary = info.tongueColor + (info.tongueCoating.isNotEmpty ? '苔${info.tongueCoating}' : '');
    final pulseSummary = info.pulseType;

    if (info.symptoms.contains('畏寒怕冷') || info.symptoms.contains('四肢冰涼')) {
      syndromeType = 'cold';
      syndromeName = '陽虛寒盛';
      therapeuticPrinciple = '溫陽散寒';
      treatmentStrategy = '以補法為主，配合艾灸溫陽';
    } else if (info.symptoms.contains('發熱') || info.symptoms.contains('口乾')) {
      syndromeType = 'heat';
      syndromeName = '內熱熾盛';
      therapeuticPrinciple = '清熱瀉火';
      treatmentStrategy = '以瀉法為主，慎用溫補';
    } else if (info.symptoms.contains('脅痛') || info.symptoms.contains('情緒低落')) {
      syndromeType = 'liverQiStagnation';
      syndromeName = '肝氣鬱結';
      therapeuticPrinciple = '疏肝解鬱';
      treatmentStrategy = '以瀉法為主，配合情志疏導';
    } else if (info.symptoms.contains('腹瀉') || info.symptoms.contains('食慾不振')) {
      syndromeType = 'spleenQiDeficiency';
      syndromeName = '脾氣虛弱';
      therapeuticPrinciple = '健脾益氣';
      treatmentStrategy = '以補法為主，忌食生冷';
    } else if (info.symptoms.contains('腰痛') || info.symptoms.contains('夜尿多')) {
      syndromeType = 'kidneyYangDeficiency';
      syndromeName = '腎陽不足';
      therapeuticPrinciple = '溫補腎陽';
      treatmentStrategy = '以補法為主，配合命門艾灸';
    } else if (info.symptoms.contains('疼痛固定') || info.symptoms.contains('刺痛')) {
      syndromeType = 'bloodStasis';
      syndromeName = '氣血瘀滯';
      therapeuticPrinciple = '活血化瘀';
      treatmentStrategy = '以瀉法為主，配合刺絡放血';
    } else if (info.symptoms.contains('眩暈') || info.symptoms.contains('頭痛')) {
      if (info.pulseType.contains('弦')) {
        syndromeType = 'liverYangRising';
        syndromeName = '肝陽上亢';
        therapeuticPrinciple = '平肝潛陽';
        treatmentStrategy = '以瀉法為主，配合頭部穴位';
      } else {
        syndromeType = 'phlegmDampness';
        syndromeName = '痰濕內阻';
        therapeuticPrinciple = '化痰祛濕';
        treatmentStrategy = '以瀉法為主，配合豐隆陰陵泉';
      }
    } else {
      syndromeType = 'general';
      syndromeName = '氣血不和';
      therapeuticPrinciple = '調和氣血';
      treatmentStrategy = '以平補平瀉為主';
    }

    return DiagnosisResult(
      syndromeType: syndromeType,
      syndromeName: syndromeName,
      therapeuticPrinciple: therapeuticPrinciple,
      treatmentStrategy: treatmentStrategy,
      symptomSummary: symptomSummary,
      tongueSummary: tongueSummary,
      pulseSummary: pulseSummary,
      riskFactors: _assessRiskFactors(info),
    );
  }

  List<String> _assessRiskFactors(DiagnosisInfo info) {
    final risks = <String>[];
    if (info.symptoms.contains('胸痛') && info.symptoms.contains('心悸')) {
      risks.add('注意心臟疾病');
    }
    if (info.symptoms.contains('高血壓')) {
      risks.add('血壓控制不佳者慎用頭部針刺');
    }
    if (info.symptoms.contains('孕')) {
      risks.add('孕婦禁用腹部及下肢遠端敏感穴位');
    }
    if (info.age != null && info.age! > 65) {
      risks.add('老年人用針宜輕淺');
    }
    return risks;
  }
}

class AcupuncturePrescription {
  final String acupointId;
  final String acupointName;
  final String acupointNameEn;
  final String acupointNamePinyin;
  final AcupointType acupointType;
  final String acupointSource;
  final bool isMainPoint;
  final bool isPairedPoint;
  final String needleDepth;
  final String needleAngle;
  final String manipulation;
  final String reinforcementReduction;
  final String principle;
  final String clinicalNote;
  final String sourceReference;
  final String qiArrival;
  final String timing;
  final String contraindication;
  final List<String> combinationPoints;

  const AcupuncturePrescription({
    required this.acupointId,
    required this.acupointName,
    required this.acupointNameEn,
    required this.acupointNamePinyin,
    required this.acupointType,
    required this.acupointSource,
    required this.isMainPoint,
    required this.isPairedPoint,
    required this.needleDepth,
    required this.needleAngle,
    required this.manipulation,
    required this.reinforcementReduction,
    required this.principle,
    required this.clinicalNote,
    required this.sourceReference,
    required this.qiArrival,
    required this.timing,
    this.contraindication = '',
    this.combinationPoints = const [],
  });
}

enum AcupointType {
  dongExtraordinary,
  niHaixiaSpecial,
  traditionalMeridian,
}

extension AcupointTypeExtension on AcupointType {
  String get name {
    switch (this) {
      case AcupointType.dongExtraordinary:
        return '董氏奇穴';
      case AcupointType.niHaixiaSpecial:
        return '倪海厦特效穴';
      case AcupointType.traditionalMeridian:
        return '傳統經穴';
    }
  }
}

class PatientSymptoms {
  final List<String> mainSymptoms;
  final List<String> secondarySymptoms;
  final String painLocation;
  final String painCharacter;
  final String painTiming;
  final bool isAcute;
  final int? durationDays;
  final List<String> accompanyingSymptoms;
  final String? tongueColor;
  final String? tongueCoating;
  final String? pulseType;
  final int? age;
  final bool isPregnant;
  final List<String> medicalHistory;

  const PatientSymptoms({
    required this.mainSymptoms,
    this.secondarySymptoms = const [],
    this.painLocation = '',
    this.painCharacter = '',
    this.painTiming = '',
    this.isAcute = false,
    this.durationDays,
    this.accompanyingSymptoms = const [],
    this.tongueColor,
    this.tongueCoating,
    this.pulseType,
    this.age,
    this.isPregnant = false,
    this.medicalHistory = const [],
  });
}

class DiagnosisInfo {
  final List<String> symptoms;
  final String tongueColor;
  final String tongueCoating;
  final String pulseType;
  final String syndromeType;
  final String syndromeName;
  final String therapeuticPrinciple;

  const DiagnosisInfo({
    required this.symptoms,
    this.tongueColor = '',
    this.tongueCoating = '',
    this.pulseType = '',
    this.syndromeType = '',
    this.syndromeName = '',
    this.therapeuticPrinciple = '',
  });
}

class DiagnosisResult {
  final String syndromeType;
  final String syndromeName;
  final String therapeuticPrinciple;
  final String treatmentStrategy;
  final String symptomSummary;
  final String tongueSummary;
  final String pulseSummary;
  final List<String> riskFactors;

  const DiagnosisResult({
    required this.syndromeType,
    required this.syndromeName,
    required this.therapeuticPrinciple,
    required this.treatmentStrategy,
    required this.symptomSummary,
    required this.tongueSummary,
    required this.pulseSummary,
    this.riskFactors = const [],
  });
}

class AcupointSelectionMode {
  final bool includeDongPoints;
  final bool includeNiHaixiaPoints;
  final bool includeTraditionalPoints;
  final bool includeAll;
  final int maxPointsPerType;

  const AcupointSelectionMode({
    this.includeDongPoints = true,
    this.includeNiHaixiaPoints = true,
    this.includeTraditionalPoints = true,
    this.includeAll = true,
    this.maxPointsPerType = 5,
  });
}
