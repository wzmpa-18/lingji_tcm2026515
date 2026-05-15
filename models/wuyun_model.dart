class WuYunLiuQi {
  final int year;
  final String tianGan;
  final String diZhi;
  final String suYun;
  final List<String> zhuYun;
  final List<String> keYun;
  final List<String> zhuQi;
  final List<String> keQi;
  final String siTian;
  final String zaiQuan;
  final List<String> zuoYouJianQi;
  final String wuYunState;
  final String liuQiState;
  final String organEmphasis;
  final String diseaseRisk;
  final String dietAdvice;
  final String lifeAdvice;
  final String jieQi;
  final String douJian;
  final String taiSui;
  final String suiXing;
  final DateTime calculatedAt;

  WuYunLiuQi({
    required this.year,
    required this.tianGan,
    required this.diZhi,
    required this.suYun,
    required this.zhuYun,
    required this.keYun,
    required this.zhuQi,
    required this.keQi,
    required this.siTian,
    required this.zaiQuan,
    required this.zuoYouJianQi,
    required this.wuYunState,
    required this.liuQiState,
    required this.organEmphasis,
    required this.diseaseRisk,
    required this.dietAdvice,
    required this.lifeAdvice,
    required this.jieQi,
    required this.douJian,
    required this.taiSui,
    required this.suiXing,
    required this.calculatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'tian_gan': tianGan,
      'di_zhi': diZhi,
      'su_yun': suYun,
      'zhu_yun': zhuYun.join(','),
      'ke_yun': keYun.join(','),
      'zhu_qi': zhuQi.join(','),
      'ke_qi': keQi.join(','),
      'si_tian': siTian,
      'zai_quan': zaiQuan,
      'zuo_you_jian_qi': zuoYouJianQi.join(','),
      'wu_yun_state': wuYunState,
      'liu_qi_state': liuQiState,
      'organ_emphasis': organEmphasis,
      'disease_risk': diseaseRisk,
      'diet_advice': dietAdvice,
      'life_advice': lifeAdvice,
      'jie_qi': jieQi,
      'dou_jian': douJian,
      'tai_sui': taiSui,
      'sui_xing': suiXing,
      'calculated_at': calculatedAt.toIso8601String(),
    };
  }

  factory WuYunLiuQi.fromMap(Map<String, dynamic> map) {
    return WuYunLiuQi(
      year: map['year'] ?? DateTime.now().year,
      tianGan: map['tian_gan'] ?? '',
      diZhi: map['di_zhi'] ?? '',
      suYun: map['su_yun'] ?? '',
      zhuYun: (map['zhu_yun'] as String?)?.split(',') ?? [],
      keYun: (map['ke_yun'] as String?)?.split(',') ?? [],
      zhuQi: (map['zhu_qi'] as String?)?.split(',') ?? [],
      keQi: (map['ke_qi'] as String?)?.split(',') ?? [],
      siTian: map['si_tian'] ?? '',
      zaiQuan: map['zai_quan'] ?? '',
      zuoYouJianQi: (map['zuo_you_jian_qi'] as String?)?.split(',') ?? [],
      wuYunState: map['wu_yun_state'] ?? '',
      liuQiState: map['liu_qi_state'] ?? '',
      organEmphasis: map['organ_emphasis'] ?? '',
      diseaseRisk: map['disease_risk'] ?? '',
      dietAdvice: map['diet_advice'] ?? '',
      lifeAdvice: map['life_advice'] ?? '',
      jieQi: map['jie_qi'] ?? '',
      douJian: map['dou_jian'] ?? '',
      taiSui: map['tai_sui'] ?? '',
      suiXing: map['sui_xing'] ?? '',
      calculatedAt: DateTime.parse(map['calculated_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class JieQi {
  final String name;
  final DateTime date;
  final String solarTerm;
  final String wuYun;
  final String healthAdvice;

  JieQi({
    required this.name,
    required this.date,
    required this.solarTerm,
    required this.wuYun,
    required this.healthAdvice,
  });
}

class DouJian {
  final String month;
  final String startBranch;
  final String description;

  DouJian({
    required this.month,
    required this.startBranch,
    required this.description,
  });
}

class TaiSuiYear {
  final int year;
  final String location;
  final String avoid;
  final String suitable;

  TaiSuiYear({
    required this.year,
    required this.location,
    required this.avoid,
    required this.suitable,
  });
}

enum WuYunSchool {
  standard,
  huangDiNeiJing,
  suWen,
  nanJing,
}

enum MemberAccessLevel {
  free,
  basic,
  advanced,
  supreme,
}

class WuYunConfig {
  final WuYunSchool school;
  final bool includeDetailedAnalysis;
  final bool includeLifePrediction;
  final bool includeLongTermPlanning;

  WuYunConfig({
    this.school = WuYunSchool.standard,
    this.includeDetailedAnalysis = false,
    this.includeLifePrediction = false,
    this.includeLongTermPlanning = false,
  });

  WuYunConfig copyWith({
    WuYunSchool? school,
    bool? includeDetailedAnalysis,
    bool? includeLifePrediction,
    bool? includeLongTermPlanning,
  }) {
    return WuYunConfig(
      school: school ?? this.school,
      includeDetailedAnalysis: includeDetailedAnalysis ?? this.includeDetailedAnalysis,
      includeLifePrediction: includeLifePrediction ?? this.includeLifePrediction,
      includeLongTermPlanning: includeLongTermPlanning ?? this.includeLongTermPlanning,
    );
  }
}
