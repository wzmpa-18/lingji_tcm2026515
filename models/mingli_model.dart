enum MingLiType {
  baZi,
  qiMenDunJia,
  ziWeiDouShu,
  daLiuRen,
  liuYaoNaJia,
  meiHuaYiShu,
  wuYunLiuQi,
}

class BaZi {
  final String year;
  final String month;
  final String day;
  final String hour;
  final List<String> ganZhiYear;
  final List<String> ganZhiMonth;
  final List<String> ganZhiDay;
  final List<String> ganZhiHour;
  final List<String> naYin;
  final List<String> shenSha;
  final List<String> cangGan;
  final List<String> riYuan;
  final String wuXing;
  final String mingGong;
  final String ziWei;
  final String shiShen;
  final String jiaCai;
  final String guanYuan;
  final String biJian;
  final String nianShang;
  final String jiE;
  final String boShi;
  final DateTime calculatedAt;

  BaZi({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.ganZhiYear,
    required this.ganZhiMonth,
    required this.ganZhiDay,
    required this.ganZhiHour,
    required this.naYin,
    required this.shenSha,
    required this.cangGan,
    required this.riYuan,
    required this.wuXing,
    required this.mingGong,
    required this.ziWei,
    required this.shiShen,
    required this.jiaCai,
    required this.guanYuan,
    required this.biJian,
    required this.nianShang,
    required this.jiE,
    required this.boShi,
    required this.calculatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'hour': hour,
      'gan_zhi_year': ganZhiYear.join(','),
      'gan_zhi_month': ganZhiMonth.join(','),
      'gan_zhi_day': ganZhiDay.join(','),
      'gan_zhi_hour': ganZhiHour.join(','),
      'na_yin': naYin.join(','),
      'shen_sha': shenSha.join(','),
      'cang_gan': cangGan.join(','),
      'ri_yuan': riYuan.join(','),
      'wu_xing': wuXing,
      'ming_gong': mingGong,
      'zi_wei': ziWei,
      'shi_shen': shiShen.join(','),
      'jia_cai': jiaCai.join(','),
      'guan_yuan': guanYuan.join(','),
      'bi_jian': biJian.join(','),
      'nian_shang': nianShang.join(','),
      'jie': jiE.join(','),
      'bo_shi': boShi.join(','),
      'calculated_at': calculatedAt.toIso8601String(),
    };
  }
}

class QiMenDunJia {
  final String year;
  final String month;
  final String day;
  final String hour;
  final String gong;
  final String men;
  final String shen;
  final List<String> baGua;
  final List<String> tianPan;
  final List<String> diPan;
  final String zhenWu;
  final String xiuChen;
  final String sanChuan;
  final String yiGua;
  final String panXing;
  final DateTime calculatedAt;

  QiMenDunJia({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.gong,
    required this.men,
    required this.shen,
    required this.baGua,
    required this.tianPan,
    required this.diPan,
    required this.zhenWu,
    required this.xiuChen,
    required this.sanChuan,
    required this.yiGua,
    required this.panXing,
    required this.calculatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'hour': hour,
      'gong': gong,
      'men': men,
      'shen': shen,
      'ba_gua': baGua.join(','),
      'tian_pan': tianPan.join(','),
      'di_pan': diPan.join(','),
      'zhen_wu': zhenWu,
      'xiu_chen': xiuChen,
      'san_chuan': sanChuan.join(','),
      'yi_gua': yiGua,
      'pan_xing': panXing,
      'calculated_at': calculatedAt.toIso8601String(),
    };
  }
}

class ZiWeiDouShu {
  final String year;
  final String month;
  final String day;
  final String hour;
  final String mingGong;
  final String shenGong;
  final List<String> mainStars;
  final List<String> assistantStars;
  final List<String> literaryStars;
  final List<String> martialStars;
  final List<String> transformStars;
  final List<String> luCunStars;
  final String tianGong;
  final String diGong;
  final String jiYang;
  final String kongWang;
  final String xianChi;
  final String longChi;
  final String poYang;
  final String yangRen;
  final DateTime calculatedAt;

  ZiWeiDouShu({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.mingGong,
    required this.shenGong,
    required this.mainStars,
    required this.assistantStars,
    required this.literaryStars,
    required this.martialStars,
    required this.transformStars,
    required this.luCunStars,
    required this.tianGong,
    required this.diGong,
    required this.jiYang,
    required this.kongWang,
    required this.xianChi,
    required this.longChi,
    required this.poYang,
    required this.yangRen,
    required this.calculatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'hour': hour,
      'ming_gong': mingGong,
      'shen_gong': shenGong,
      'main_stars': mainStars.join(','),
      'assistant_stars': assistantStars.join(','),
      'literary_stars': literaryStars.join(','),
      'martial_stars': martialStars.join(','),
      'transform_stars': transformStars.join(','),
      'lu_cun_stars': luCunStars.join(','),
      'tian_gong': tianGong,
      'di_gong': diGong,
      'ji_yang': jiYang,
      'kong_wang': kongWang,
      'xian_chi': xianChi,
      'long_chi': longChi,
      'po_yang': poYang,
      'yang_ren': yangRen,
      'calculated_at': calculatedAt.toIso8601String(),
    };
  }
}

class DaLiuRen {
  final String year;
  final String month;
  final String day;
  final String hour;
  final String diShen;
  final String riShen;
  final List<String> shenSha;
  final List<String> liuShen;
  final List<String> riYuan;
  final String wangWang;
  final String faWei;
  final String chaoKe;
  final String siCha;
  final String faRen;
  final String youBi;
  final String guanCai;
  final String shangGuan;
  final String faGuan;
  final String benBo;
  final String yiMa;
  final String luMa;
  final String tiANhu;
  final String diHu;
  final String yueMa;
  final String jiMen;
  final DateTime calculatedAt;

  DaLiuRen({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.diShen,
    required this.riShen,
    required this.shenSha,
    required this.liuShen,
    required this.riYuan,
    required this.wangWang,
    required this.faWei,
    required this.chaoKe,
    required this.siCha,
    required this.faRen,
    required this.youBi,
    required this.guanCai,
    required this.shangGuan,
    required this.faGuan,
    required this.benBo,
    required this.yiMa,
    required this.luMa,
    required this.tiANhu,
    required this.diHu,
    required this.yueMa,
    required this.jiMen,
    required this.calculatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'hour': hour,
      'di_shen': diShen,
      'ri_shen': riShen,
      'shen_sha': shenSha.join(','),
      'liu_shen': liuShen.join(','),
      'ri_yuan': riYuan.join(','),
      'wang_wang': wangWang,
      'fa_wei': faWei,
      'chao_ke': chaoKe,
      'si_cha': siCha,
      'fa_ren': faRen,
      'you_bi': youBi,
      'guan_cai': guanCai,
      'shang_guan': shangGuan,
      'fa_guan': faGuan,
      'ben_bo': benBo,
      'yi_ma': yiMa,
      'lu_ma': luMa,
      'tian_hu': tiANhu,
      'di_hu': diHu,
      'yue_ma': yueMa,
      'ji_men': jiMen,
      'calculated_at': calculatedAt.toIso8601String(),
    };
  }
}

class LiuYaoNaJia {
  final String year;
  final String month;
  final String day;
  final String hour;
  final String guaName;
  final List<String> yaoGua;
  final String dongYaoy;
  final String fuYao;
  final String bianYao;
  final String neiGua;
  final String waiGua;
  final String cuoGua;
  final String zongGua;
  final String biGua;
  final String shiGua;
  final String yingShen;
  final String yongShen;
  final String changSheng;
  final String muGua;
  final String guanTou;
  final String yiJing;
  final DateTime calculatedAt;

  LiuYaoNaJia({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.guaName,
    required this.yaoGua,
    required this.dongYaoy,
    required this.fuYao,
    required this.bianYao,
    required this.neiGua,
    required this.waiGua,
    required this.cuoGua,
    required this.zongGua,
    required this.biGua,
    required this.shiGua,
    required this.yingShen,
    required this.yongShen,
    required this.changSheng,
    required this.muGua,
    required this.guanTou,
    required this.yiJing,
    required this.calculatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'hour': hour,
      'gua_name': guaName,
      'yao_gua': yaoGua.join(','),
      'dong_yao': dongYaoy,
      'fu_yao': fuYao.join(','),
      'bian_yao': bianYao.join(','),
      'nei_gua': neiGua,
      'wai_gua': waiGua,
      'cuo_gua': cuoGua,
      'zong_gua': zongGua,
      'bi_gua': biGua,
      'shi_gua': shiGua,
      'ying_shen': yingShen,
      'yong_shen': yongShen,
      'chang_sheng': changSheng,
      'mu_gua': muGua,
      'guan_tou': guanTou,
      'yi_jing': yiJing,
      'calculated_at': calculatedAt.toIso8601String(),
    };
  }
}

class MeiHuaYiShu {
  final String year;
  final String month;
  final String day;
  final String hour;
  final String shangGua;
  final String xiaGua;
  final String zongGua;
  final String mouGua;
  final String tiANpan;
  final String diPan;
  final String wangWang;
  final String shengKe;
  final String dongChen;
  final String yiShen;
  final String jingWei;
  final String xuKong;
  final DateTime calculatedAt;

  MeiHuaYiShu({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.shangGua,
    required this.xiaGua,
    required this.zongGua,
    required this.mouGua,
    required this.tiANpan,
    required this.diPan,
    required this.wangWang,
    required this.shengKe,
    required this.dongChen,
    required this.yiShen,
    required this.jingWei,
    required this.xuKong,
    required this.calculatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'hour': hour,
      'shang_gua': shangGua,
      'xia_gua': xiaGua,
      'zong_gua': zongGua,
      'mou_gua': mouGua,
      'tian_pan': tiANpan,
      'di_pan': diPan,
      'wang_wang': wangWang,
      'sheng_ke': shengKe,
      'dong_chen': dongChen,
      'yi_shen': yiShen,
      'jing_wei': jingWei,
      'xu_kong': xuKong,
      'calculated_at': calculatedAt.toIso8601String(),
    };
  }
}

class MingLiSettings {
  final bool useKongWang;
  final bool useTrueSunTime;
  final bool useJieQiStartMonth;
  final bool useSheHaiRule;
  final bool useGuiRenArrangement;
  final bool useLiuShenOrder;
  final bool useShunYunQiFu;

  MingLiSettings({
    this.useKongWang = true,
    this.useTrueSunTime = false,
    this.useJieQiStartMonth = false,
    this.useSheHaiRule = false,
    this.useGuiRenArrangement = true,
    this.useLiuShenOrder = true,
    this.useShunYunQiFu = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'use_kong_wang': useKongWang,
      'use_true_sun_time': useTrueSunTime,
      'use_jie_qi_start_month': useJieQiStartMonth,
      'use_she_hai_rule': useSheHaiRule,
      'use_gui_ren_arrangement': useGuiRenArrangement,
      'use_liu_shen_order': useLiuShenOrder,
      'use_shun_yun_qi_fu': useShunYunQiFu,
    };
  }

  factory MingLiSettings.fromMap(Map<String, dynamic> map) {
    return MingLiSettings(
      useKongWang: map['use_kong_wang'] ?? true,
      useTrueSunTime: map['use_true_sun_time'] ?? false,
      useJieQiStartMonth: map['use_jie_qi_start_month'] ?? false,
      useSheHaiRule: map['use_she_hai_rule'] ?? false,
      useGuiRenArrangement: map['use_gui_ren_arrangement'] ?? true,
      useLiuShenOrder: map['use_liu_shen_order'] ?? true,
      useShunYunQiFu: map['use_shun_yun_qi_fu'] ?? true,
    );
  }

  MingLiSettings copyWith({
    bool? useKongWang,
    bool? useTrueSunTime,
    bool? useJieQiStartMonth,
    bool? useSheHaiRule,
    bool? useGuiRenArrangement,
    bool? useLiuShenOrder,
    bool? useShunYunQiFu,
  }) {
    return MingLiSettings(
      useKongWang: useKongWang ?? this.useKongWang,
      useTrueSunTime: useTrueSunTime ?? this.useTrueSunTime,
      useJieQiStartMonth: useJieQiStartMonth ?? this.useJieQiStartMonth,
      useSheHaiRule: useSheHaiRule ?? this.useSheHaiRule,
      useGuiRenArrangement: useGuiRenArrangement ?? this.useGuiRenArrangement,
      useLiuShenOrder: useLiuShenOrder ?? this.useLiuShenOrder,
      useShunYunQiFu: useShunYunQiFu ?? this.useShunYunQiFu,
    );
  }
}
