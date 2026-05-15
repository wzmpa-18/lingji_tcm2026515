import '../models/mingli_model.dart';

class MingLiService {
  static const List<String> tianGan = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
  static const List<String> diZhi = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];
  static const List<String> wuXing = ['木', '火', '土', '金', '水'];
  static const List<String> naYin = ['海中金', '炉中火', '大林木', '路旁土', '剑锋金', '山头火', '涧下水', '城头土', '白蜡金', '杨柳木', '井泉水', '屋上土', '霹雳火', '松柏木', '长流水', '砂石金', '山下火', '平地木', '壁上土', '金箔金', '灯头火', '天河水', '大驿土', '钗钏金', '桑柘木', '大溪水', '砂中土', '天上火', '石榴木', '大海水'];
  static const List<String> shenSha = ['青龙', '朱雀', '勾陈', '螣蛇', '白虎', '玄武'];
  static const List<String> liuShen = ['青龙', '朱雀', '勾陈', '螣蛇', '白虎', '玄武'];
  static const List<String> baGua = ['乾', '兑', '离', '震', '巽', '坎', '艮', '坤'];
  static const List<String> menBa = ['休', '生', '伤', '杜', '景', '死', '惊', '开'];
  static const List<String> ziWeiStars = ['紫微', '天机', '太阳', '武曲', '天同', '廉贞'];
  static const List<String> ziWeiTransform = ['紫微星', '天机星', '太阳星', '武曲星', '天同星', '廉贞星', '天府星', '太阴星', '贪狼星', '巨门星', '天相星', '天梁星', '七杀星', '破军星'];

  Map<String, String> _getNaYin(String gan, String zhi) {
    final naYinMap = {
      '甲子': '海中金', '乙丑': '海中金', '丙寅': '炉中火', '丁卯': '炉中火',
      '戊辰': '大林木', '己巳': '大林木', '庚午': '路旁土', '辛未': '路旁土',
      '壬申': '剑锋金', '癸酉': '剑锋金', '甲戌': '山头火', '乙亥': '山头火',
      '丙子': '涧下水', '丁丑': '涧下水', '戊寅': '城头土', '己卯': '城头土',
      '庚辰': '白蜡金', '辛巳': '白蜡金', '壬午': '杨柳木', '癸未': '杨柳木',
      '甲申': '井泉水', '乙酉': '井泉水', '丙戌': '屋上土', '丁亥': '屋上土',
      '戊子': '霹雳火', '己丑': '霹雳火', '庚寅': '松柏木', '辛卯': '松柏木',
      '壬辰': '长流水', '癸巳': '长流水', '甲午': '砂石金', '乙未': '砂石金',
      '丙申': '山下火', '丁酉': '山下火', '戊戌': '平地木', '己亥': '平地木',
      '庚子': '壁上土', '辛丑': '壁上土', '壬寅': '金箔金', '癸卯': '金箔金',
      '甲辰': '灯头火', '乙巳': '灯头火', '丙午': '天河水', '丁未': '天河水',
      '戊申': '大驿土', '己酉': '大驿土', '庚戌': '钗钏金', '辛亥': '钗钏金',
      '壬子': '桑柘木', '癸丑': '桑柘木', '甲寅': '大溪水', '乙卯': '大溪水',
      '丙辰': '砂中土', '丁巳': '砂中土', '戊午': '天上火', '己未': '天上火',
      '庚申': '石榴木', '辛酉': '石榴木', '壬戌': '大海水', '癸亥': '大海水',
    };
    return {'gan': gan, 'zhi': zhi, 'naYin': naYinMap['$gan$zhi'] ?? ''};
  }

  String _getShiShen(String riGan, String otherGan) {
    final shengKe = {'甲': {'甲': '比', '乙': '劫', '丙': '食', '丁': '伤', '戊': '财', '己': '才', '庚': '官', '辛': '杀', '壬': '枭', '癸': '印'},
                    '乙': {'甲': '劫', '乙': '比', '丙': '伤', '丁': '食', '戊': '才', '己': '财', '庚': '杀', '辛': '官', '壬': '印', '癸': '枭'},
                    '丙': {'甲': '枭', '乙': '印', '丙': '比', '丁': '劫', '戊': '伤', '己': '食', '庚': '财', '辛': '才', '壬': '官', '癸': '杀'},
                    '丁': {'甲': '印', '乙': '枭', '丙': '劫', '丁': '比', '戊': '食', '己': '伤', '庚': '才', '辛': '财', '壬': '杀', '癸': '官'},
                    '戊': {'甲': '杀', '乙': '官', '丙': '枭', '丁': '印', '戊': '比', '己': '劫', '庚': '伤', '辛': '食', '壬': '财', '癸': '才'},
                    '己': {'甲': '官', '乙': '杀', '丙': '印', '丁': '枭', '戊': '劫', '己': '比', '庚': '食', '辛': '伤', '壬': '才', '癸': '财'},
                    '庚': {'甲': '财', '乙': '才', '丙': '杀', '丁': '官', '戊': '枭', '己': '印', '庚': '比', '辛': '劫', '壬': '伤', '癸': '食'},
                    '辛': {'甲': '才', '乙': '财', '丙': '官', '丁': '杀', '戊': '印', '己': '枭', '庚': '劫', '辛': '比', '壬': '食', '癸': '伤'},
                    '壬': {'甲': '食', '乙': '伤', '丙': '财', '丁': '才', '戊': '官', '己': '杀', '庚': '印', '辛': '枭', '壬': '比', '癸': '劫'},
                    '癸': {'甲': '伤', '乙': '食', '丙': '才', '丁': '财', '戊': '杀', '己': '官', '庚': '枭', '辛': '印', '壬': '劫', '癸': '比'}};
    return shengKe[riGan]?[otherGan] ?? '';
  }

  String _getCangGan(String diZhi) {
    final cangGanMap = {
      '子': ['癸'],
      '丑': ['己', '癸', '辛'],
      '寅': ['甲', '丙', '戊'],
      '卯': ['乙'],
      '辰': ['戊', '乙', '癸'],
      '巳': ['丙', '戊', '庚'],
      '午': ['丁', '己'],
      '未': ['己', '丁', '乙'],
      '申': ['庚', '壬', '戊'],
      '酉': ['辛'],
      '戌': ['戊', '辛', '丁'],
      '亥': ['壬', '甲'],
    };
    return cangGanMap[diZhi]?.join(',') ?? '';
  }

  BaZi calculateBaZi(int year, int month, int day, int hour, MingLiSettings settings) {
    final yearGan = tianGan[(year - 1984) % 10];
    final yearZhi = diZhi[(year - 1984) % 12];
    final monthGan = tianGan[(month + (yearGan == '甲' || yearGan == '己' ? 0 : yearGan == '乙' || yearGan == '庚' ? 6 : 2)) % 10];
    final monthZhi = diZhi[(month - 1) % 12];
    final dayGan = tianGan[(day - 1) % 10];
    final dayZhi = diZhi[(day - 1) % 12];
    final hourGan = tianGan[(hour ~/ 2 + (dayGan == '甲' || dayGan == '己' ? 0 : dayGan == '乙' || dayGan == '庚' ? 6 : dayGan == '丙' || dayGan == '辛' ? 4 : 2)) % 10];
    final hourZhi = diZhi[hour ~/ 2 % 12];

    final naYinYear = _getNaYin(yearGan, yearZhi)['naYin'] ?? '';
    final naYinMonth = _getNaYin(monthGan, monthZhi)['naYin'] ?? '';
    final naYinDay = _getNaYin(dayGan, dayZhi)['naYin'] ?? '';
    final naYinHour = _getNaYin(hourGan, hourZhi)['naYin'] ?? '';

    final shiShenYear = _getShiShen(dayGan, yearGan);
    final shiShenMonth = _getShiShen(dayGan, monthGan);
    final shiShenDay = '日主';
    final shiShenHour = _getShiShen(dayGan, hourGan);

    final cangGanYear = _getCangGan(yearZhi);
    final cangGanMonth = _getCangGan(monthZhi);
    final cangGanDay = _getCangGan(dayZhi);
    final cangGanHour = _getCangGan(hourZhi);

    final wuXing = _getWuXingBalance(yearGan, monthGan, dayGan, hourGan);

    return BaZi(
      year: '$yearGan$yearZhi',
      month: '$monthGan$monthZhi',
      day: '$dayGan$dayZhi',
      hour: '$hourGan$hourZhi',
      ganZhiYear: ['$yearGan$yearZhi', naYinYear],
      ganZhiMonth: ['$monthGan$monthZhi', naYinMonth],
      ganZhiDay: ['$dayGan$dayZhi', naYinDay],
      ganZhiHour: ['$hourGan$hourZhi', naYinHour],
      naYin: [naYinYear, naYinMonth, naYinDay, naYinHour],
      shenSha: _getShenSha(dayZhi),
      cangGan: [cangGanYear, cangGanMonth, cangGanDay, cangGanHour],
      riYuan: _getRiYuan(dayGan),
      wuXing: wuXing,
      mingGong: _getMingGong(monthZhi),
      ziWei: _getZiWei(monthZhi),
      shiShen: [shiShenYear, shiShenMonth, shiShenDay, shiShenHour],
      jiaCai: _getJiaCai(dayGan),
      guanYuan: _getGuanYuan(dayGan, monthGan),
      biJian: _getBiJian(dayGan),
      nianShang: _getNianShang(dayGan, yearZhi),
      jiE: _getJiE(dayGan, hourZhi),
      boShi: _getBoShi(dayGan),
      calculatedAt: DateTime.now(),
    );
  }

  List<String> _getShenSha(String diZhi) {
    final shenShaMap = {
      '子': ['青龙', '贵人', '羊刃', '灾煞', '天煞', '将星'],
      '丑': ['朱雀', '天乙', '华盖', '驿马', '天煞', '攀鞍'],
      '寅': ['勾陈', '天乙', '桃花', '天煞', '劫煞', '将星'],
      '卯': ['螣蛇', '贵人', '灾煞', '血煞', '天煞', '攀鞍'],
      '辰': ['白虎', '天乙', '华盖', '驿马', '劫煞', '将星'],
      '巳': ['玄武', '天乙', '桃花', '天煞', '灾煞', '攀鞍'],
      '午': ['青龙', '天乙', '羊刃', '血煞', '天煞', '将星'],
      '未': ['朱雀', '天乙', '华盖', '驿马', '灾煞', '攀鞍'],
      '申': ['勾陈', '天乙', '桃花', '天煞', '劫煞', '将星'],
      '酉': ['螣蛇', '贵人', '灾煞', '血煞', '天煞', '攀鞍'],
      '戌': ['白虎', '天乙', '华盖', '驿马', '劫煞', '将星'],
      '亥': ['玄武', '天乙', '桃花', '天煞', '灾煞', '攀鞍'],
    };
    return shenShaMap[diZhi] ?? [];
  }

  List<String> _getRiYuan(String dayGan) {
    return [dayGan, '日干'];
  }

  String _getWuXingBalance(String yearGan, String monthGan, String dayGan, String hourGan) {
    int mu = 0, huo = 0, tu = 0, jin = 0, shui = 0;
    final ganWuXing = {'甲': '木', '乙': '木', '丙': '火', '丁': '火', '戊': '土', '己': '土', '庚': '金', '辛': '金', '壬': '水', '癸': '水'};
    mu += ganWuXing[yearGan] == '木' ? 1 : 0;
    huo += ganWuXing[yearGan] == '火' ? 1 : 0;
    tu += ganWuXing[yearGan] == '土' ? 1 : 0;
    jin += ganWuXing[yearGan] == '金' ? 1 : 0;
    shui += ganWuXing[yearGan] == '水' ? 1 : 0;
    mu += ganWuXing[monthGan] == '木' ? 1 : 0;
    huo += ganWuXing[monthGan] == '火' ? 1 : 0;
    tu += ganWuXing[monthGan] == '土' ? 1 : 0;
    jin += ganWuXing[monthGan] == '金' ? 1 : 0;
    shui += ganWuXing[monthGan] == '水' ? 1 : 0;
    mu += ganWuXing[dayGan] == '木' ? 1 : 0;
    huo += ganWuXing[dayGan] == '火' ? 1 : 0;
    tu += ganWuXing[dayGan] == '土' ? 1 : 0;
    jin += ganWuXing[dayGan] == '金' ? 1 : 0;
    shui += ganWuXing[dayGan] == '水' ? 1 : 0;
    mu += ganWuXing[hourGan] == '木' ? 1 : 0;
    huo += ganWuXing[hourGan] == '火' ? 1 : 0;
    tu += ganWuXing[hourGan] == '土' ? 1 : 0;
    jin += ganWuXing[hourGan] == '金' ? 1 : 0;
    shui += ganWuXing[hourGan] == '水' ? 1 : 0;
    return '木$mu 火$huo 土$tu 金$jin 水$shui';
  }

  String _getMingGong(String monthZhi) {
    final mingGongMap = {'寅': '命宫', '卯': '命宫', '辰': '命宫', '巳': '命宫', '午': '命宫', '未': '命宫', '申': '命宫', '酉': '命宫', '戌': '命宫', '亥': '命宫', '子': '命宫', '丑': '命宫'};
    return mingGongMap[monthZhi] ?? '命宫';
  }

  String _getZiWei(String monthZhi) {
    return '紫微';
  }

  String _getJiaCai(String dayGan) {
    final jiaCaiMap = {'甲': '甲木', '乙': '乙木', '丙': '丙火', '丁': '丁火', '戊': '戊土', '己': '己土', '庚': '庚金', '辛': '辛金', '壬': '壬水', '癸': '癸水'};
    return [jiaCaiMap[dayGan] ?? '', '日干比和'];
  }

  List<String> _getGuanYuan(String dayGan, String monthGan) {
    return ['官元', '官星'];
  }

  List<String> _getBiJian(String dayGan) {
    return ['比肩', '同类'];
  }

  List<String> _getNianShang(String dayGan, String yearZhi) {
    return ['年上', '祖上'];
  }

  List<String> _getJiE(String dayGan, String hourZhi) {
    return ['劫煞', '时柱'];
  }

  List<String> _getBoShi(String dayGan) {
    return ['博士', '学历'];
  }

  QiMenDunJia calculateQiMen(int year, int month, int day, int hour, MingLiSettings settings) {
    final tianPan = ['值符', '螣蛇', '太阴', '勾陈', '朱雀', '九地', '九天', '白虎'];
    final diPan = ['临', '兵', '斗', '者', '皆', '阵', '列', '前'];

    return QiMenDunJia(
      year: tianGan[(year - 1984) % 10] + diZhi[(year - 1984) % 12],
      month: tianGan[month % 10] + diZhi[month % 12],
      day: tianGan[day % 10] + diZhi[day % 12],
      hour: tianGan[hour ~/ 2 % 10] + diZhi[hour ~/ 2 % 12],
      gong: '休门',
      men: '生门',
      shen: '值符',
      baGua: baGua,
      tianPan: tianPan,
      diPan: diPan,
      zhenWu: '休',
      xiuChen: '开',
      sanChuan: ['上盘', '中盘', '下盘'],
      yiGua: '乾',
      panXing: '奇门遁甲盘',
      calculatedAt: DateTime.now(),
    );
  }

  ZiWeiDouShu calculateZiWei(int year, int month, int day, int hour) {
    return ZiWeiDouShu(
      year: year.toString(),
      month: month.toString(),
      day: day.toString(),
      hour: hour.toString(),
      mingGong: '命宫',
      shenGong: '身宫',
      mainStars: ['紫微星', '天机星', '太阳星'],
      assistantStars: ['文昌星', '文曲星', '左辅星', '右弼星'],
      literaryStars: ['文昌', '文曲'],
      martialStars: ['武曲', '七杀', '破军'],
      transformStars: ['化禄', '化权', '化科', '化忌'],
      luCunStars: ['禄存'],
      tianGong: '天府星',
      diGong: '天相星',
      jiYang: ['太阳', '巨门'],
      kongWang: '空亡',
      xianChi: '咸池',
      longChi: '龙池',
      poYang: '破阳',
      yangRen: '阳刃',
      calculatedAt: DateTime.now(),
    );
  }

  DaLiuRen calculateDaLiuRen(int year, int month, int day, int hour) {
    return DaLiuRen(
      year: year.toString(),
      month: month.toString(),
      day: day.toString(),
      hour: hour.toString(),
      diShen: '日神',
      riShen: '阳贵',
      shenSha: ['大安', '留连', '速喜', '赤口', '小吉', '空亡'],
      liuShen: ['青龙', '朱雀', '勾陈', '螣蛇', '白虎', '玄武'],
      riYuan: ['日干', '日支'],
      wangWang: '旺相',
      faWei: '发微',
      chaoKe: '超神',
      siCha: '四查',
      faRen: '法人',
      youBi: '游勃',
      guanCai: '官财',
      shangGuan: '上官',
      faGuan: '法官',
      benBo: '本波',
      yiMa: '驿马',
      luMa: '禄马',
      tiANhu: '天虎',
      diHu: '地虎',
      yueMa: '月马',
      jiMen: '吉门',
      calculatedAt: DateTime.now(),
    );
  }

  LiuYaoNaJia calculateLiuYao(int year, int month, int day, int hour) {
    return LiuYaoNaJia(
      year: year.toString(),
      month: month.toString(),
      day: day.toString(),
      hour: hour.toString(),
      guaName: '乾为天',
      yaoGua: ['初九', '九二', '九三', '九四', '九五', '上九'],
      dongYaoy: '五爻动',
      fuYao: ['六二', '六四'],
      bianYao: ['初爻', '五爻'],
      neiGua: '乾',
      waiGua: '乾',
      cuoGua: '夬',
      zongGua: '乾',
      biGua: '否',
      shiGua: '大有',
      yingShen: '应爻',
      yongShen: '用神',
      changSheng: '长生',
      muGua: '本卦',
      guanTou: '官鬼',
      yiJing: '易经',
      calculatedAt: DateTime.now(),
    );
  }

  MeiHuaYiShu calculateMeiHua(int year, int month, int day, int hour) {
    return MeiHuaYiShu(
      year: year.toString(),
      month: month.toString(),
      day: day.toString(),
      hour: hour.toString(),
      shangGua: '上卦',
      xiaGua: '下卦',
      zongGua: '体卦',
      mouGua: '互卦',
      tiANpan: '天盘',
      diPan: '地盘',
      wangWang: '旺相',
      shengKe: '生克',
      dongChen: '动爻',
      yiShen: '仪神',
      jingWei: '经纬',
      xuKong: '旬空',
      calculatedAt: DateTime.now(),
    );
  }

  String getKongWang(DateTime date) {
    final tianGanIndex = (date.year - 1984) % 10;
    final diZhiIndex = (date.year - 1984) % 12;
    final kongWang1 = tianGan[tianGanIndex];
    final kongWang2 = diZhi[diZhiIndex];
    return '$kongWang1$kongWang2';
  }

  int getMemberAccessLevel(int memberLevel, MingLiType type) {
    switch (memberLevel) {
      case 0:
        return 0;
      case 1:
        return 1;
      case 2:
        return 2;
      case 3:
        return 3;
      default:
        return 0;
    }
  }

  bool hasFullPackage(int memberLevel) {
    return memberLevel >= 3;
  }
}
