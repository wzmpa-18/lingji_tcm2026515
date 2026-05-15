abstract class ShenshaRule {
  final String name;
  final String description;
  final String source;
  final String category;

  const ShenshaRule({
    required this.name,
    required this.description,
    required this.source,
    required this.category,
  });

  bool isMatch(Map<String, dynamic> chartData);
}

class BaziShenshaLibrary {
  static const String category = '八字';

  static const Map<String, String> tianyuShens = {
    '天乙貴人': '甲戊兼牛羊，乙己鼠猴鄉，丙丁豬雞位，壬癸兔蛇藏，庚辛逢虎馬，此是貴人方。',
    '太極貴人': '甲乙生人子午中，丙丁雞兔定亨通，戊己兩干連四季，庚辛寅卯旺秋冬，壬癸巳申胎七綻，五行此地更滔滔。',
    '文昌貴人': '甲乙蛇口乙馬頭，丙戊狗尋牛地休，丁己猴兒與虎謀，庚豬癸鳳辛聽雞，壬午癸未卯中求。',
    '魁星貴人': '甲乙未逢午，丙丁申見亥，戊己丑寅子，庚辛酉戌不相離，壬寅卯上存，癸巳午中最是非。',
    '國印貴人': '甲逢甲子乙逢丑，丙逢寅卯丁逢申，戊辰未戌君須記，己亥庚子細推尋，辛酉壬戌癸巳上，此是國印貴人真。',
    '祿神': '甲祿在寅，乙祿在卯，丙戊祿在巳，丁己祿在午，庚祿在申，辛祿在酉，壬祿在亥，癸祿在子。',
    '羊刃': '甲刃在卯，乙刃在寅，丙刃在午，丁刃在巳，戊刃在午，己刃在巳，庚刃在酉，辛刃在申，壬刃在子，癸刃在亥。',
    '驛馬': '申子辰馬在寅，寅午戌馬在申，亥卯未馬在巳，巳酉丑馬在亥。',
    '桃花': '申子辰見酉，寅午戌見卯，亥卯未見子，巳酉丑見午。',
    '將星': '子午卯酉將在中，辰戌丑未是魁星，申酉亥亦是將星，四正臨宮主大吉。',
    '華蓋': '寅午戌見戌，申子辰見辰，亥卯未見未，巳酉丑見丑。',
    '空亡': '甲子旬中無戌亥，甲戌旬中無申酉，甲申旬中無午未，甲午旬中無辰巳，甲辰旬中無寅卯，甲寅旬中無子丑。',
    '亡神': '寅午戌見巳，申子辰見亥，亥卯未見寅，巳酉丑見申。',
    '劫煞': '寅午戌見亥，申子辰見巳，亥卯未見申，巳酉丑見寅。',
    '災煞': '寅午戌見子，申子辰見午，亥卯未見酉，巳酉丑見卯。',
    '歲煞': '寅午戌見丑，申子辰見未，亥卯未見戌，巳酉丑見辰。',
    '月煞': '寅午戌見卯，申子辰見酉，亥卯未見午，巳酉丑見子。',
    '咸池': '申子辰見酉，寅午戌見卯，亥卯未見子，巳酉丑見午。',
    '孤辰': '亥子丑見寅，寅卯辰見巳，巳午未見申，申酉戌見亥。',
    '寡宿': '亥子丑見戌，寅卯辰見丑，巳午未見辰，申酉戌見未。',
    '紅鸞': '子見卯兮丑見寅，寅見丑兮丑見寅，卯見子兮卯見亥，辰見戌兮辰見亥，巳見酉兮巳見申，午見未兮午見申，未見午兮未見巳，申見辰兮申見卯，酉見卯兮酉見丑，戌見丑兮戌見子。',
    '天喜': '春亥子，夏寅卯，秋辰巳，冬申酉。',
    '天德': '正丁二申中，三壬四辛同，五亥六甲上，七癸八寅同，九丙十居乙，子巳丑庚中。',
    '月德': '正五九月丙，二六十月甲，三七十一壬，四八十二庚。',
    '三奇': '天上三奇甲戊庚，地下三奇乙丙丁，人中三奇壬癸辛。',
    '六儀': '甲子、甲戌、甲申、甲午、甲辰、甲寅。',
    '金輿': '甲祿在寅乙祿卯，丙戊祿在巳丁己午，庚祿在申辛祿酉，壬祿在亥癸祿子。',
    '天廚': '甲丙忌見蛇，乙丁忌見馬，戊己忌見羊，庚辛忌見猴，壬癸忌見雞。',
    '學堂': '木命人見亥，己丙命見寅，火命人見申，辛壬命見亥，金命人見巳，土命人見寅。',
    '詞館': '木命人見寅，火命人見巳，金命人見申，水土命人見亥。',
    '正印': '甲生亥子乙戊午，丙生寅卯丁己申，庚生巳午辛生未，壬生申酉癸生辰。',
    '偏印': '甲生申乙生酉丙生亥丁生子戊生寅己生卯庚生巳辛生午壬生未癸生辰。',
    '傷官': '甲見丁乙見丙丙見戊丁見己戊見辛己見庚庚見癸辛見壬壬見乙癸見甲。',
    '食神': '甲見丙乙見丁丙見戊丁見己戊見庚己見辛庚見壬辛見癸壬見甲癸見乙。',
    '正財': '甲見乙乙見甲丙見丁丁見丙戊見己己見戊庚見辛辛見庚壬見癸癸見壬。',
    '偏財': '甲見戊乙見己丙見庚丁見辛戊見壬己見癸庚見甲辛見乙壬見丙癸見丁。',
    '正官': '甲見辛乙見庚丙見癸丁見壬戊見甲己見乙庚見丙辛見丁壬見戊癸見己。',
    '七殺': '甲見癸乙見壬丙見甲丁見乙戊見丙己見丁庚見戊辛見己壬見庚癸見辛。',
    '比肩': '甲見甲乙見乙丙見丙丁見丁戊見戊己見己庚見庚辛見辛壬見壬癸見癸。',
    '劫財': '甲見乙乙見甲丙見丁丁見丙戊見己己見戊庚見辛辛見庚壬見癸癸見壬。',
  };

  static const Map<String, Map<String, String>> shenshaSources = {
    '天乙貴人': {'source': '《三命通會》', 'category': '貴人類'},
    '文昌貴人': {'source': '《淵海子平》', 'category': '貴人類'},
    '祿神': {'source': '《五行精記》', 'category': '祿馬類'},
    '羊刃': {'source': '《三車一覽》', 'category': '凶煞類'},
    '驛馬': {'source': '《蘭臺妙選》', 'category': '遷動類'},
    '桃花': {'source': '《淵海子平》', 'category': '情感類'},
    '華蓋': {'source': '《神峰通考》', 'category': '藝術類'},
    '空亡': {'source': '《胎微經》', 'category': '虛無類'},
    '亡神': {'source': '《五行精記》', 'category': '凶煞類'},
    '劫煞': {'source': '《鬼谷遺文》', 'category': '凶煞類'},
  };

  static String getShenshaDescription(String shenshaName) {
    return tianyuShens[shenshaName] ?? '';
  }

  static String getSource(String shenshaName) {
    return shenshaSources[shenshaName]?['source'] ?? '古籍不詳';
  }

  static String getCategory(String shenshaName) {
    return shenshaSources[shenshaName]?['category'] ?? '其他';
  }

  static List<String> getShenshaByCategory(String category) {
    return shenshaSources.entries
        .where((e) => e.value['category'] == category)
        .map((e) => e.key)
        .toList();
  }
}

class ZiweiShenshaLibrary {
  static const String category = '紫微斗數';

  static const Map<String, String> ziweiShens = {
    '天乙貴人': '紫微斗數中重要的貴人星，逢之主貴人相助。',
    '天府': '南斗主星，逢之主財庫豐厚。',
    '天相': '南斗主星，逢之主文書顯達。',
    '天機': '南斗主星，逢之主聰明機變。',
    '天同': '南斗主星，逢之主福祿雙全。',
    '天梁': '南斗主星，逢之主清貴長壽。',
    '天府': '南斗主星，逢之主富貴盈門。',
    '七殺': '南斗將星，逢之主威權顯赫。',
    '破軍': '北斗將星，逢之主開創變動。',
    '貪狼': '北斗桃花星，逢之主欲望機巧。',
    '巨門': '北斗暗星，逢之主是非口舌。',
    '廉貞': '北斗囚星，逢之主感情糾葛。',
    '武曲': '北斗財星，逢之主財運亨通。',
    '太陽': '日主星，逢之主事業顯達。',
    '太陰': '月主星，逢之主感情豐富。',
    '祿存': '財帛主星，逢之主財祿豐厚。',
    '天馬': '遷動主星，逢主奔波遠行。',
    '紅鸞': '姻緣星，逢之主感情姻緣。',
    '天喜': '喜慶星，逢之主好事連連。',
    '咸池': '桃花星，逢之主感情豐富。',
    '天姚': '桃花星，逢之主風流浪漫。',
    '解神': '化解星，逢之可化解凶煞。',
    '月德': '吉慶星，逢之主逢凶化吉。',
    '天空': '虛空星，逢之主理想主義。',
    '地空': '虛空星，逢之主空想不實。',
    '截空': '煞星，逢之主阻礙困頓。',
    '旬空': '煞星，逢之主機會流失。',
    '火星': '燥熱煞，逢之主脾氣火爆。',
    '鈴星': '燥熱煞，逢之主暗藏是非。',
    '擎羊': '刑剋煞，逢之主血光意外。',
    '陀羅': '刑剋煞，逢之主拖延糾纏。',
  };

  static const Map<String, Map<String, String>> shenshaSources = {
    '天府': {'source': '《紫微斗數全書》', 'category': '主星類'},
    '天相': {'source': '《紫微斗數全書》', 'category': '主星類'},
    '天機': {'source': '《紫微斗數全書》', 'category': '主星類'},
    '天同': {'source': '《紫微斗數全書》', 'category': '主星類'},
    '天梁': {'source': '《紫微斗數全書》', 'category': '主星類'},
    '七殺': {'source': '《紫微斗數全書》', 'category': '將星類'},
    '破軍': {'source': '《紫微斗數全書》', 'category': '將星類'},
    '貪狼': {'source': '《紫微斗數全書》', 'category': '桃花類'},
    '祿存': {'source': '《紫微斗數全書》', 'category': '財星類'},
    '天馬': {'source': '《紫微斗數全書》', 'category': '動星類'},
  };

  static String getShenshaDescription(String shenshaName) {
    return ziweiShens[shenshaName] ?? '';
  }

  static String getSource(String shenshaName) {
    return shenshaSources[shenshaName]?['source'] ?? '《紫微斗數》';
  }
}

class QimenShenshaLibrary {
  static const String category = '奇門遁甲';

  static const Map<String, String> qimenShens = {
    '天蓬': '大凶之星，逢之主盜賊傷災。',
    '天芮': '疾病之星，逢之主疾病纏身。',
    '天沖': '衝動之星，逢之主行動迅速。',
    '天輔': '文曲之星，逢之主文才出眾。',
    '天禽': '中宮之星，逢之主位居正中。',
    '天心': 'medical之星，逢之主醫藥有效。',
    '天柱': '惊恐之星，逢之主驚恐是非。',
    '天任': ' 生旺之星，逢之主承受艱辛。',
    '天英': '火光之星，逢之主血光火光。',
    '天任': '生旺之星，逢之主勤勞踏實。',
    '九地': '柔順之星，逢主固守穩重。',
    '九天': '剛強之星，逢主行動力強。',
    '九地': '坤卦之象，逢主柔中帶剛。',
    '九天': '乾卦之象，逢主剛健有力。',
    '白虎': '凶煞之神，逢主血光官非。',
    '青龍': '吉慶之神，逢主富貴榮華。',
    '朱雀': '文采之神，逢主文書口舌。',
    '玄武': '盜賊之神，逢主盜賊暗害。',
    '螣蛇': '驚恐之神，逢主驚恐不安。',
    '勾陳': '牽絆之神，逢主糾纏糾葛。',
    '六合': '和合之神，逢主婚姻合夥。',
    '三奇': '最吉之象，逢主萬事亨通。',
    '八門': '人事之門，各有吉凶。',
    '八神': '天行之神，各有本領。',
    '九宮': '方位之數，變化無窮。',
  };

  static const Map<String, Map<String, String>> shenshaSources = {
    '天蓬': {'source': '《奇門遁甲》', 'category': '九星類'},
    '天芮': {'source': '《奇門遁甲》', 'category': '九星類'},
    '天沖': {'source': '《奇門遁甲》', 'category': '九星類'},
    '天輔': {'source': '《奇門遁甲》', 'category': '九星類'},
    '八門': {'source': '《奇門遁甲》', 'category': '八門類'},
    '八神': {'source': '《奇門遁甲》', 'category': '八神類'},
    '三奇': {'source': '《煙波釣叟歌》', 'category': '三奇類'},
  };

  static const Map<String, String> kongwangRule = {
    '冬至': '坎卦',
    '小寒': '坤卦',
    '大寒': '震卦',
    '立春': '震卦',
    '雨水': '巽卦',
    '驚蟄': '巽卦',
    '春分': '坤卦',
    '清明': '坎卦',
    '穀雨': '離卦',
    '立夏': '乾卦',
    '小滿': '兌卦',
    '芒種': '乾卦',
    '夏至': '離卦',
    '小暑': '坤卦',
    '大暑': '兌卦',
    '立秋': '坤卦',
    '處暑': '兌卦',
    '白露': '乾卦',
    '秋分': '坎卦',
    '寒露': '艮卦',
    '霜降': '坤卦',
    '立冬': '乾卦',
    '小雪': '坎卦',
    '大雪': '坤卦',
  };

  static String getShenshaDescription(String shenshaName) {
    return qimenShens[shenshaName] ?? '';
  }

  static String getKongwangByJieqi(String jieqi) {
    return kongwangRule[jieqi] ?? '';
  }
}

class DaliurenShenshaLibrary {
  static const String category = '大六壬';

  static const Map<String, String> daliurenShens = {
    '大安': '青龍吉神，逢之主平安吉祥。',
    '留連': '勾陳凶神，逢之主糾纏拖延。',
    '速喜': '朱雀吉神，逢之主好事迅速。',
    '赤口': '白虎凶神，逢主口舌官非。',
    '小吉': '六合吉神，逢主小利小得。',
    '空亡': '虛空凶神，逢主機會落空。',
    '青龍': '吉神之首，逢主財運官運。',
    '白虎': '凶神之首，逢主血光傷災。',
    '朱雀': '文采之神，逢主文書口舌。',
    '玄武': '盜賊之神，逢主盜賊暗害。',
    '勾陳': '牽絆之神，逢主糾纏糾葛。',
    '六合': '和合之神，逢主婚姻合夥。',
    '貴人': '一切吉慶的根本。',
    '螣蛇': '驚恐之神，逢主驚恐不安。',
    '天空': '虛空之神，逢主空想不實。',
  };

  static const Map<String, Map<String, String>> shenshaSources = {
    '大安': {'source': '《大六壬金鶴鳴》', 'category': '六壬類'},
    '留連': {'source': '《大六壬金鶴鳴》', 'category': '六壬類'},
    '速喜': {'source': '《大六壬金鶴鳴》', 'category': '六壬類'},
    '赤口': {'source': '《大六壬金鶴鳴》', 'category': '六壬類'},
    '小吉': {'source': '《大六壬金鶴鳴》', 'category': '六壬類'},
    '空亡': {'source': '《大六壬大全》', 'category': '六壬類'},
    '貴人': {'source': '《大六壬大全》', 'category': '貴人類'},
    '青龍': {'source': '《大六壬大全》', 'category': '四神之類'},
  };

  static String getShenshaDescription(String shenshaName) {
    return daliurenShens[shenshaName] ?? '';
  }
}

class TiebanShenshaLibrary {
  static const String category = '鐵板神數';

  static const Map<String, String> tiebanShens = {
    '太極': '萬物之始，陰陽之本。',
    '兩儀': '陰陽分判，天地初開。',
    '四象': '太少陰陽，四時之變。',
    '八卦': '天地水火，山澤風雷。',
    '六十四卦': '陰陽重疊，八卦相蕩。',
  };

  static String getShenshaDescription(String shenshaName) {
    return tiebanShens[shenshaName] ?? '';
  }
}

class MeihuaShenshaLibrary {
  static const String category = '梅花易數';

  static const Map<String, String> meihuaShens = {
    '體用': '以體為主，用為變化。',
    '旺相': '得時當令，生機旺盛。',
    '休囚': '失時失令，生機衰退。',
    '動變': '一動一靜，陰陽對待。',
    '生剋': '相生相剋，五行流轉。',
    '沖合': '相沖相合，感應之道。',
  };

  static String getShenshaDescription(String shenshaName) {
    return meihuaShens[shenshaName] ?? '';
  }
}

class ShenshaFactory {
  static String getLibrary(String category) {
    switch (category) {
      case '八字':
      case '四柱':
        return 'BaziShenshaLibrary';
      case '紫微斗數':
      case '紫微':
        return 'ZiweiShenshaLibrary';
      case '奇門遁甲':
      case '奇門':
        return 'QimenShenshaLibrary';
      case '大六壬':
      case '六壬':
        return 'DaliurenShenshaLibrary';
      case '鐵板神數':
      case '鐵板':
        return 'TiebanShenshaLibrary';
      case '梅花易數':
      case '梅花':
        return 'MeihuaShenshaLibrary';
      default:
        return 'BaziShenshaLibrary';
    }
  }

  static Map<String, String> getAllShensha(String category) {
    switch (category) {
      case '八字':
      case '四柱':
        return BaziShenshaLibrary.tianyuShens;
      case '紫微斗數':
      case '紫微':
        return ZiweiShenshaLibrary.ziweiShens;
      case '奇門遁甲':
      case '奇門':
        return QimenShenshaLibrary.qimenShens;
      case '大六壬':
      case '六壬':
        return DaliurenShenshaLibrary.daliurenShens;
      case '鐵板神數':
      case '鐵板':
        return TiebanShenshaLibrary.tiebanShens;
      case '梅花易數':
      case '梅花':
        return MeihuaShenshaLibrary.meihuaShens;
      default:
        return {};
    }
  }
}
