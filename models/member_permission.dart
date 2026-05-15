class MemberPermission {
  final int memberLevel;

  MemberPermission(this.memberLevel);

  bool get canViewBasicWuYun => true;
  bool get canViewDetailedWuYun => memberLevel >= 1;
  bool get canViewLifePrediction => memberLevel >= 2;
  bool get canViewLongTermPlanning => memberLevel >= 3;

  bool get canViewBasicBazi => true;
  bool get canViewCompleteBazi => memberLevel >= 1;
  bool get canViewDeepTeaching => memberLevel >= 2;

  bool get canUseAllSchools => memberLevel >= 2;
  bool get canViewAllCommentaries => memberLevel >= 3;

  bool get canUseCloudBackup => memberLevel >= 1;
  bool get canUseMultiDeviceSync => memberLevel >= 2;
  bool get canUseUnlimitedCloud => memberLevel >= 3;

  bool get hasLocalStorage => true;

  bool get canViewMingLiPackage => memberLevel >= 3;
  bool get hasFullMingLiPackage => memberLevel >= 3;

  int get maxProfileBioLength {
    switch (memberLevel) {
      case 0:
        return 50;
      case 1:
        return 500;
      case 2:
        return 2000;
      case 3:
        return 10000;
      default:
        return 50;
    }
  }

  String get memberName {
    switch (memberLevel) {
      case 0:
        return '免费会员';
      case 1:
        return '中级会员';
      case 2:
        return '高级会员';
      case 3:
        return '至尊会员';
      default:
        return '免费会员';
    }
  }

  List<String> get unlockedFeatures {
    final features = <String>[];
    if (canViewBasicWuYun) features.add('五运六气基础');
    if (canViewDetailedWuYun) features.add('详细气运分析');
    if (canViewLifePrediction) features.add('个人命盘联动');
    if (canViewLongTermPlanning) features.add('长期养生规划');

    if (canViewBasicBazi) features.add('基础八字排盘');
    if (canViewCompleteBazi) features.add('完整八字解析');
    if (canViewDeepTeaching) features.add('深度课理教学');

    if (canUseAllSchools) features.add('全流派切换');
    if (canViewAllCommentaries) features.add('典籍批注');

    if (canUseCloudBackup) features.add('云备份');
    if (canUseMultiDeviceSync) features.add('多设备同步');
    if (canUseUnlimitedCloud) features.add('无限云存');

    return features;
  }

  static const List<Map<String, dynamic>> memberPackages = [
    {
      'level': 0,
      'name': '免费会员',
      'price': 0,
      'features': [
        '五运六气基础气运查看',
        '基础养生建议',
        '八字简单排盘',
        '本地SQLite永久存储',
        '个人主页简介(50字)',
        '加好友/私聊/群聊',
        '每日签到领积分',
        '付费提问/C2C交易',
      ],
    },
    {
      'level': 1,
      'name': '中级会员',
      'price': 350,
      'features': [
        '免费会员全部功能',
        '详细气运分析',
        '完整八字解析',
        '个人命盘联动',
        '基础云备份',
        '个人主页简介(500字)',
        '3D穴位基础内容',
        '脉象基础教学',
        '积分收益加成30%',
        '交易手续费8折',
        '自建社群特权',
      ],
    },
    {
      'level': 2,
      'name': '高级会员',
      'price': 700,
      'features': [
        '中级会员全部功能',
        '全流派规则切换',
        '深度课理教学',
        '五运六气长期规划',
        '无限云存+多设备同步',
        '个人主页简介(2000字)',
        '一键复制转发功能',
        '全名家辨证权限',
        '倪海厦全套教学',
        '命理全流派切换',
        '积分收益加成60%',
        '交易手续费5折',
      ],
    },
    {
      'level': 3,
      'name': '至尊会员',
      'price': 1000,
      'features': [
        '高级会员全部功能',
        '命理全科典籍批注',
        '名家高阶解读',
        '300元命理全包套餐',
        '个人主页简介(10000字)',
        '全功能永久全开',
        '交易免手续费',
        '积分收益翻倍',
        '无限云存储永久同步',
        '优先客服支持',
      ],
    },
  ];

  static const Map<String, int> mingLiPackage = {
    'name': '命理全科套餐',
    'price': 300,
    'includes': [
      '八字四柱完整排盘',
      '奇门遁甲完整盘',
      '紫微斗数十二宫',
      '大六壬袖中金标准',
      '六爻纳甲卦象',
      '梅花易数心易',
      '全部典籍批注',
      '名家高阶解读',
    ],
  };
}
