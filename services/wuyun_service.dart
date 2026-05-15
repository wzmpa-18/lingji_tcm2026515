import '../models/wuyun_model.dart';

class WuYunService {
  static const List<String> tianGan = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
  static const List<String> diZhi = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];
  static const List<String> wuYun = ['木', '火', '土', '金', '水'];
  static const List<String> liuQi = ['风木', '君火', '相火', '湿土', '燥金', '寒水'];
  static const List<String> siTianZaiQuan = [
    '厥阴风木/少阳相火',
    '少阴君火/阳明燥金',
    '太阴湿土/太阳寒水',
    '少阳相火/厥阴风木',
    '阳明燥金/少阴君火',
    '太阳寒水/太阴湿土',
  ];
  static const Map<String, int> jieQiIndex = {
    '小寒': 0, '大寒': 1, '立春': 2, '雨水': 3, '惊蛰': 4, '春分': 5,
    '清明': 6, '谷雨': 7, '立夏': 8, '小满': 9, '芒种': 10, '夏至': 11,
    '小暑': 12, '大暑': 13, '立秋': 14, '处暑': 15, '白露': 16, '秋分': 17,
    '寒露': 18, '霜降': 19, '立冬': 20, '小雪': 21, '大雪': 22, '冬至': 23,
  };
  static const List<String> jieQi24 = [
    '小寒', '大寒', '立春', '雨水', '惊蛰', '春分',
    '清明', '谷雨', '立夏', '小满', '芒种', '夏至',
    '小暑', '大暑', '立秋', '处暑', '白露', '秋分',
    '寒露', '霜降', '立冬', '小雪', '大雪', '冬至',
  ];
  static const Map<String, List<String>> zhuYunMap = {
    '木': ['初运木', '二运火', '三运土', '四运金', '终运水'],
    '火': ['初运火', '二运土', '三运金', '四运水', '终运木'],
    '土': ['初运土', '二运金', '三运水', '四运木', '终运火'],
    '金': ['初运金', '二运水', '三运木', '四运火', '终运土'],
    '水': ['初运水', '二运木', '三运火', '四运土', '终运金'],
  };
  static const Map<String, List<String>> keYunMap = {
    '厥阴风木': ['初客气厥阴风木', '二客气少阴君火', '三客气太阴湿土', '四客气少阳相火', '五客气阳明燥金', '终客气太阳寒水'],
    '少阴君火': ['初客气少阴君火', '二客气太阴湿土', '三客气少阳相火', '四客气阳明燥金', '五客气太阳寒水', '终客气厥阴风木'],
    '太阴湿土': ['初客气太阴湿土', '二客气少阳相火', '三客气阳明燥金', '四客气太阳寒水', '五客气厥阴风木', '终客气少阴君火'],
    '少阳相火': ['初客气少阳相火', '二客气阳明燥金', '三客气太阳寒水', '四客气厥阴风木', '五客气少阴君火', '终客气太阴湿土'],
    '阳明燥金': ['初客气阳明燥金', '二客气太阳寒水', '三客气厥阴风木', '四客气少阴君火', '五客气太阴湿土', '终客气少阳相火'],
    '太阳寒水': ['初客气太阳寒水', '二客气厥阴风木', '三客气少阴君火', '四客气太阴湿土', '五客气少阳相火', '终客气阳明燥金'],
  };
  static const Map<String, String> zhuQiMap = {
    '初气': '厥阴风木', '二气': '少阴君火', '三气': '少阳相火',
    '四气': '太阴湿土', '五气': '阳明燥金', '终气': '太阳寒水',
  };
  static const Map<String, List<String>> organMap = {
    '木': ['肝', '胆', '目', '筋'],
    '火': ['心', '小肠', '舌', '脉'],
    '土': ['脾', '胃', '口', '肉'],
    '金': ['肺', '大肠', '鼻', '皮毛'],
    '水': ['肾', '膀胱', '耳', '骨'],
  };
  static const Map<String, List<String>> diseaseMap = {
    '木': ['肝气郁结', '胁痛', '眩晕', '目赤肿痛', '情绪抑郁'],
    '火': ['心火亢盛', '口舌生疮', '失眠多梦', '心悸怔忡', '小便赤涩'],
    '土': ['脾胃湿困', '脘腹胀满', '食欲不振', '大便溏泄', '肢体困重'],
    '金': ['肺燥咳嗽', '咽干口燥', '皮肤干燥', '便秘干咳', '鼻塞流涕'],
    '水': ['肾阳不足', '畏寒肢冷', '腰膝酸软', '夜尿频多', '水肿胀满'],
  };
  static const Map<String, List<String>> dietMap = {
    '木': ['酸味食物（乌梅、山楂）', '青色蔬菜', '疏肝理气食物', '避免辛辣刺激'],
    '火': ['苦味食物（苦瓜、莲子）', '红色食物', '清心降火', '避免熬夜'],
    '土': ['甘味食物（山药、薏米）', '黄色食物', '健脾祛湿', '避免生冷油腻'],
    '金': ['辛味食物（梨、蜂蜜）', '白色食物', '润燥养肺', '保持室内湿度'],
    '水': ['咸味食物（黑豆、核桃）', '黑色食物', '温肾散寒', '避免受寒'],
  };

  int _getYearIndex(int year) {
    return (year - 1984) % 10;
  }

  int _getSiTianIndex(int year) {
    return (year - 1984) % 6;
  }

  String _getTianGan(int year) {
    return tianGan[_getYearIndex(year)];
  }

  String _getDiZhi(int year) {
    return diZhi[(year - 1984) % 12];
  }

  String _getSuYun(int year) {
    final index = _getYearIndex(year);
    return wuYun[index ~/ 2];
  }

  List<String> _getZhuYun(int year) {
    final suYun = _getSuYun(year);
    return zhuYunMap[suYun] ?? zhuYunMap['木']!;
  }

  List<String> _getKeYun(int year) {
    final siTianIndex = _getSiTianIndex(year);
    final siTian = liuQi[siTianIndex];
    return keYunMap[siTian] ?? keYunMap['厥阴风木']!;
  }

  List<String> _getZhuQi() {
    return ['初气厥阴风木', '二气少阴君火', '三气少阳相火', '四气太阴湿土', '五气阳明燥金', '终气太阳寒水'];
  }

  List<String> _getKeQi(int year) {
    return _getKeYun(year);
  }

  String _getSiTian(int year) {
    final index = _getSiTianIndex(year);
    return siTianZaiQuan[index].split('/')[0];
  }

  String _getZaiQuan(int year) {
    final index = _getSiTianIndex(year);
    return siTianZaiQuan[index].split('/')[1];
  }

  List<String> _getZuoYouJianQi(int year) {
    final siTianIndex = _getSiTianIndex(year);
    final leftIndex = (siTianIndex + 4) % 6;
    final rightIndex = (siTianIndex + 2) % 6;
    return ['左间气${liuQi[leftIndex]}', '右间气${liuQi[rightIndex]}'];
  }

  String _getWuYunState(int year) {
    final suYun = _getSuYun(year);
    switch (suYun) {
      case '木':
        return '木气旺盛，万物生发，肝气易动，宜疏肝理气';
      case '火':
        return '火气偏盛，气候炎热，心火易亢，宜清心降火';
      case '土':
        return '土气湿重，气候潮湿，脾气易困，宜健脾祛湿';
      case '金':
        return '金气干燥，气候干燥，肺气易燥，宜润燥养阴';
      case '水':
        return '水气寒冷，气候寒冷，肾气易衰，宜温肾散寒';
      default:
        return '';
    }
  }

  String _getLiuQiState(int year) {
    final siTianIndex = _getSiTianIndex(year);
    final siTian = liuQi[siTianIndex];
    switch (siTian) {
      case '风木':
        return '风木当令，气候多变，风邪易袭，防风护肝';
      case '君火':
        return '君火主令，气候炎热，火邪易生，清心泻火';
      case '相火':
        return '相火司天，气候闷热，湿热易蕴，和解少阳';
      case '湿土':
        return '湿土主事，气候潮湿，湿邪易困，健脾祛湿';
      case '燥金':
        return '燥金当令，气候干燥，燥邪易伤，润燥养肺';
      case '寒水':
        return '寒水在泉，气候寒冷，寒邪易袭，温阳散寒';
      default:
        return '';
    }
  }

  String _getOrganEmphasis(int year) {
    final suYun = _getSuYun(year);
    final organs = organMap[suYun] ?? organMap['木']!;
    return '重点养护：${organs.join('、')}';
  }

  String _getDiseaseRisk(int year) {
    final suYun = _getSuYun(year);
    final diseases = diseaseMap[suYun] ?? diseaseMap['木']!;
    return diseases.join('、');
  }

  String _getDietAdvice(int year) {
    final suYun = _getSuYun(year);
    final advice = dietMap[suYun] ?? dietMap['木']!;
    return advice.join('\n');
  }

  String _getLifeAdvice(int year) {
    final suYun = _getSuYun(year);
    switch (suYun) {
      case '木':
        return '宜早起散步舒展筋骨，多做拉伸运动，保持心情舒畅，避免抑郁生气，春季养肝最佳';
      case '火':
        return '宜午休养心，避免烈日暴晒，多饮绿豆汤、菊花茶等清热饮品，保持充足睡眠';
      case '土':
        return '宜健脾益气，适度运动促进脾胃运化，避免久坐潮湿之地，饮食有节';
      case '金':
        return '宜润肺养阴，早晚适度运动，多食白色食物，注意室内湿度，谨防秋燥';
      case '水':
        return '宜早睡晚起固护阳气，注意腰膝保暖，多食温热食物，冬季封藏肾精';
      default:
        return '';
    }
  }

  String _getDouJian(int month) {
    final douJianMap = {
      1: ['丑', '立建在丑'],
      2: ['寅', '立建在寅'],
      3: ['卯', '立建在卯'],
      4: ['辰', '立建在辰'],
      5: ['巳', '立建在巳'],
      6: ['午', '立建在午'],
      7: ['未', '立建在未'],
      8: ['申', '立建在申'],
      9: ['酉', '立建在酉'],
      10: ['戌', '立建在戌'],
      11: ['亥', '立建在亥'],
      12: ['子', '立建在子'],
    };
    return douJianMap[month]?.join(': ') ?? '';
  }

  String _getTaiSui(int year) {
    final taiSuiMap = {
      2024: '甲辰',
      2025: '乙巳',
      2026: '丙午',
      2027: '丁未',
      2028: '戊申',
      2029: '己酉',
      2030: '庚戌',
      2031: '辛亥',
      2032: '壬子',
      2033: '癸丑',
      2034: '甲寅',
      2035: '乙卯',
      2036: '丙辰',
      2037: '丁巳',
      2038: '戊午',
      2039: '己未',
      2040: '庚申',
      2041: '辛酉',
      2042: '壬戌',
      2043: '癸亥',
      2044: '甲子',
    };
    return taiSuiMap[year] ?? '';
  }

  String _getSuiXing(int year) {
    final suiXingMap = {
      2024: '青龙',
      2025: '白虎',
      2026: '朱雀',
      2027: '玄武',
      2028: '青龙',
      2029: '白虎',
      2030: '朱雀',
      2031: '玄武',
      2032: '青龙',
      2033: '白虎',
      2034: '朱雀',
      2035: '玄武',
      2036: '青龙',
      2037: '白虎',
      2038: '朱雀',
      2039: '玄武',
      2040: '青龙',
      2041: '白虎',
      2042: '朱雀',
      2043: '玄武',
      2044: '青龙',
    };
    return suiXingMap[year] ?? '';
  }

  String _getJieQiForMonth(int month, int year) {
    final monthJieQi = {
      1: '小寒',
      2: '大寒',
      3: '立春',
      4: '雨水',
      5: '惊蛰',
      6: '春分',
      7: '清明',
      8: '谷雨',
      9: '立夏',
      10: '小满',
      11: '芒种',
      12: '夏至',
    };
    return monthJieQi[month] ?? '';
  }

  WuYunLiuQi calculateWuYunLiuQi(int year, {WuYunSchool school = WuYunSchool.standard}) {
    return WuYunLiuQi(
      year: year,
      tianGan: _getTianGan(year),
      diZhi: _getDiZhi(year),
      suYun: _getSuYun(year),
      zhuYun: _getZhuYun(year),
      keYun: _getKeYun(year),
      zhuQi: _getZhuQi(),
      keQi: _getKeQi(year),
      siTian: _getSiTian(year),
      zaiQuan: _getZaiQuan(year),
      zuoYouJianQi: _getZuoYouJianQi(year),
      wuYunState: _getWuYunState(year),
      liuQiState: _getLiuQiState(year),
      organEmphasis: _getOrganEmphasis(year),
      diseaseRisk: _getDiseaseRisk(year),
      dietAdvice: _getDietAdvice(year),
      lifeAdvice: _getLifeAdvice(year),
      jieQi: '二十四节气',
      douJian: '斗建正月从丑起',
      taiSui: _getTaiSui(year),
      suiXing: _getSuiXing(year),
      calculatedAt: DateTime.now(),
    );
  }

  List<JieQi> getYearJieQi(int year) {
    final jieQiData = [
      JieQi(name: '小寒', date: DateTime(year, 1, 5), solarTerm: '寒气至极', wuYun: '太阳寒水', healthAdvice: '温阳散寒，补肾固本'),
      JieQi(name: '大寒', date: DateTime(year, 1, 20), solarTerm: '大寒严凝', wuYun: '太阳寒水', healthAdvice: '防寒保暖，温补肾阳'),
      JieQi(name: '立春', date: DateTime(year, 2, 4), solarTerm: '春季开始', wuYun: '厥阴风木', healthAdvice: '养肝疏肝，少酸多甘'),
      JieQi(name: '雨水', date: DateTime(year, 2, 19), solarTerm: '降雨开始', wuYun: '厥阴风木', healthAdvice: '健脾祛湿，避风防寒'),
      JieQi(name: '惊蛰', date: DateTime(year, 3, 5), solarTerm: '春雷惊醒', wuYun: '厥阴风木', healthAdvice: '疏肝理气，预防春温'),
      JieQi(name: '春分', date: DateTime(year, 3, 20), solarTerm: '昼夜平分', wuYun: '少阴君火', healthAdvice: '平衡阴阳，养护肝气'),
      JieQi(name: '清明', date: DateTime(year, 4, 5), solarTerm: '天清气明', wuYun: '少阴君火', healthAdvice: '疏肝清热，养心安神'),
      JieQi(name: '谷雨', date: DateTime(year, 4, 20), solarTerm: '雨生百谷', wuYun: '少阴君火', healthAdvice: '健脾祛湿，柔肝明目'),
      JieQi(name: '立夏', date: DateTime(year, 5, 5), solarTerm: '夏季开始', wuYun: '少阳相火', healthAdvice: '养心安神，清热消暑'),
      JieQi(name: '小满', date: DateTime(year, 5, 21), solarTerm: '小麦饱满', wuYun: '少阳相火', healthAdvice: '健脾祛湿，清热利湿'),
      JieQi(name: '芒种', date: DateTime(year, 6, 5), solarTerm: '有芒作物', wuYun: '少阳相火', healthAdvice: '益气健脾，预防暑湿'),
      JieQi(name: '夏至', date: DateTime(year, 6, 21), solarTerm: '阳气至极', wuYun: '太阴湿土', healthAdvice: '养心护阳，健脾祛湿'),
      JieQi(name: '小暑', date: DateTime(year, 7, 7), solarTerm: '暑气初盛', wuYun: '太阴湿土', healthAdvice: '清热解暑，健脾化湿'),
      JieQi(name: '大暑', date: DateTime(year, 7, 22), solarTerm: '暑气极盛', wuYun: '太阴湿土', healthAdvice: '防暑降温，益气养阴'),
      JieQi(name: '立秋', date: DateTime(year, 8, 7), solarTerm: '秋季开始', wuYun: '阳明燥金', healthAdvice: '润燥养肺，少辛多酸'),
      JieQi(name: '处暑', date: DateTime(year, 8, 23), solarTerm: '暑气消退', wuYun: '阳明燥金', healthAdvice: '养阴润燥，清热生津'),
      JieQi(name: '白露', date: DateTime(year, 9, 7), solarTerm: '露凝而白', wuYun: '阳明燥金', healthAdvice: '润肺益气，防燥养阴'),
      JieQi(name: '秋分', date: DateTime(year, 9, 23), solarTerm: '昼夜平分', wuYun: '少阴君火', healthAdvice: '平衡肺金，养护脾胃'),
      JieQi(name: '寒露', date: DateTime(year, 10, 8), solarTerm: '露气寒冷', wuYun: '少阴君火', healthAdvice: '润燥养阴，补益肺气'),
      JieQi(name: '霜降', date: DateTime(year, 10, 23), solarTerm: '开始降霜', wuYun: '太阳寒水', healthAdvice: '养肺护胃，防寒保暖'),
      JieQi(name: '立冬', date: DateTime(year, 11, 7), solarTerm: '冬季开始', wuYun: '太阳寒水', healthAdvice: '温肾藏精，早睡晚起'),
      JieQi(name: '小雪', date: DateTime(year, 11, 22), solarTerm: '开始降雪', wuYun: '太阳寒水', healthAdvice: '温阳散寒，补益肾气'),
      JieQi(name: '大雪', date: DateTime(year, 12, 7), solarTerm: '雪量增大', wuYun: '太阳寒水', healthAdvice: '防寒保暖，养肾固精'),
      JieQi(name: '冬至', date: DateTime(year, 12, 21), solarTerm: '阴极阳生', wuYun: '厥阴风木', healthAdvice: '阴阳交替，补肾助阳'),
    ];
    return jieQiData;
  }

  TaiSuiYear getTaiSuiYear(int year) {
    return TaiSuiYear(
      year: year,
      location: _getTaiSui(year),
      avoid: _getTaiSuiAvoid(year),
      suitable: _getTaiSuiSuitable(year),
    );
  }

  String _getTaiSuiAvoid(int year) {
    final taiSui = _getTaiSui(year);
    final avoidMap = {
      '甲子': '修造动土', '乙丑': '嫁娶嫁娶', '丙寅': '开业开工', '丁卯': '搬家入宅',
      '戊辰': '竖柱上梁', '己巳': '开市交易', '庚午': '安床安葬', '辛未': '出行移徙',
      '壬申': '订盟纳采', '癸酉': '祈福求嗣', '甲戌': '嫁娶纳采', '乙亥': '开市立券',
      '丙子': '出行移徙', '丁丑': '动土破土', '戊寅': '安床安葬', '己卯': '栽种针灸',
      '庚辰': '修造动土', '辛巳': '嫁娶纳采', '壬午': '开市交易', '癸未': '出行移徙',
      '甲申': '安床安葬', '乙酉': '动土破土', '丙戌': '嫁娶纳采', '丁亥': '开业开工',
      '戊子': '出行移徙', '己丑': '订盟纳采', '庚寅': '修造动土', '辛卯': '嫁娶纳采',
      '壬辰': '开市交易', '癸巳': '出行移徙', '甲午': '安床安葬', '乙未': '动土破土',
      '丙申': '嫁娶纳采', '丁酉': '开业开工', '戊戌': '出行移徙', '己亥': '订盟纳采',
      '庚子': '修造动土', '辛丑': '嫁娶纳采', '壬寅': '开市交易', '癸卯': '出行移徙',
      '甲辰': '安床安葬', '乙巳': '动土破土', '丙午': '嫁娶纳采', '丁未': '开业开工',
      '戊申': '出行移徙', '己酉': '订盟纳采', '庚戌': '修造动土', '辛亥': '嫁娶纳采',
      '壬子': '开市交易', '癸丑': '出行移徙', '甲寅': '安床安葬', '乙卯': '动土破土',
      '丙辰': '嫁娶纳采', '丁巳': '开业开工', '戊午': '出行移徙', '己未': '订盟纳采',
      '庚申': '修造动土', '辛酉': '嫁娶纳采', '壬戌': '开市交易', '癸亥': '出行移徙',
    };
    return avoidMap[taiSui] ?? '常规修造';
  }

  String _getTaiSuiSuitable(int year) {
    final taiSui = _getTaiSui(year);
    final suitableMap = {
      '甲子': '祭祀祈福、订盟纳采', '乙丑': '嫁娶祭祀、开业开市', '丙寅': '嫁娶纳采、出行移徙',
      '丁卯': '祭祀祈福、安床安葬', '戊辰': '嫁娶纳采、订盟立券', '己巳': '出行移徙、祭祀祈福',
      '庚午': '祭祀祈福、嫁娶纳采', '辛未': '开业开市、订盟立券', '壬申': '出行移徙、嫁娶纳采',
      '癸酉': '祭祀祈福、安床安葬', '甲戌': '订盟纳采、开业开市', '乙亥': '出行移徙、嫁娶纳采',
      '丙子': '嫁娶纳采、祭祀祈福', '丁丑': '开业开市、订盟立券', '戊寅': '祭祀祈福、安床安葬',
      '己卯': '出行移徙、嫁娶纳采', '庚辰': '祭祀祈福、订盟立券', '辛巳': '开业开市、嫁娶纳采',
      '壬午': '出行移徙、祭祀祈福', '癸未': '嫁娶纳采、订盟立券', '甲申': '开业开市、安床安葬',
      '乙酉': '祭祀祈福、出行移徙', '丙戌': '订盟纳采、嫁娶纳采', '丁亥': '开业开市、祭祀祈福',
      '戊子': '嫁娶纳采、订盟立券', '己丑': '出行移徙、安床安葬', '庚寅': '祭祀祈福、嫁娶纳采',
      '辛卯': '开业开市、订盟立券', '壬辰': '出行移徙、祭祀祈福', '癸巳': '嫁娶纳采、订盟立券',
      '甲午': '开业开市、安床安葬', '乙未': '祭祀祈福、出行移徙', '丙申': '订盟纳采、嫁娶纳采',
      '丁酉': '开业开市、祭祀祈福', '戊戌': '出行移徙、安床安葬', '己亥': '嫁娶纳采、订盟立券',
      '庚子': '祭祀祈福、出行移徙', '辛丑': '开业开市、订盟立券', '壬寅': '嫁娶纳采、祭祀祈福',
      '癸卯': '出行移徙、安床安葬', '甲辰': '订盟纳采、嫁娶纳采', '乙巳': '开业开市、祭祀祈福',
      '丙午': '出行移徙、订盟立券', '丁未': '嫁娶纳采、安床安葬', '戊申': '祭祀祈福、出行移徙',
      '己酉': '开业开市、订盟立券', '庚戌': '嫁娶纳采、祭祀祈福', '辛亥': '出行移徙、安床安葬',
      '壬子': '订盟纳采、嫁娶纳采', '癸丑': '开业开市、祭祀祈福', '甲寅': '出行移徙、订盟立券',
      '乙卯': '嫁娶纳采、安床安葬', '丙辰': '祭祀祈福、出行移徙', '丁巳': '开业开市、订盟立券',
      '戊午': '嫁娶纳采、祭祀祈福', '己未': '出行移徙、安床安葬', '庚申': '订盟纳采、嫁娶纳采',
      '辛酉': '开业开市、祭祀祈福', '壬戌': '出行移徙、订盟立券', '癸亥': '嫁娶纳采、安床安葬',
    };
    return suitableMap[taiSui] ?? '常规事宜';
  }

  WuYunConfig getConfigForMemberLevel(int memberLevel) {
    switch (memberLevel) {
      case 0:
        return WuYunConfig();
      case 1:
        return WuYunConfig(
          school: WuYunSchool.standard,
          includeDetailedAnalysis: true,
        );
      case 2:
        return WuYunConfig(
          school: WuYunSchool.standard,
          includeDetailedAnalysis: true,
          includeLifePrediction: true,
        );
      case 3:
        return WuYunConfig(
          school: WuYunSchool.standard,
          includeDetailedAnalysis: true,
          includeLifePrediction: true,
          includeLongTermPlanning: true,
        );
      default:
        return WuYunConfig();
    }
  }
}
