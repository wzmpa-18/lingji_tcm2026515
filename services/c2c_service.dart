import '../models/team_profit.dart';

class C2CFeeService {
  static const double feeRate = 0.02;
  static const int minFee = 10;
  static const int maxFee = 100;

  static int calculateFee(int amount) {
    final fee = (amount * feeRate).round();
    if (fee < minFee) return minFee;
    if (fee > maxFee) return maxFee;
    return fee;
  }

  static int calculateFeeWithDiscount(int amount, int memberLevel) {
    final fee = calculateFee(amount);
    final discount = _getFeeDiscount(memberLevel);
    return (fee * discount).round();
  }

  static double _getFeeDiscount(int memberLevel) {
    switch (memberLevel) {
      case 0:
        return 1.0;
      case 1:
        return 0.8;
      case 2:
        return 0.5;
      case 3:
        return 0.0;
      default:
        return 1.0;
    }
  }

  static C2CFeeBreakdown calculateFeeBreakdown(int amount, int memberLevel) {
    final grossFee = calculateFee(amount);
    final netFee = calculateFeeWithDiscount(amount, memberLevel);

    final level1Profit = ProfitShareConfig.calculateProfit(grossFee, 1);
    final level2Profit = ProfitShareConfig.calculateProfit(grossFee, 2);
    final level3Profit = ProfitShareConfig.calculateProfit(grossFee, 3);
    final platformRevenue = grossFee - level1Profit - level2Profit - level3Profit;

    return C2CFeeBreakdown(
      amount: amount,
      grossFee: grossFee,
      netFee: netFee,
      level1Profit: level1Profit,
      level2Profit: level2Profit,
      level3Profit: level3Profit,
      platformRevenue: platformRevenue,
      discountApplied: _getFeeDiscount(memberLevel),
    );
  }

  static String getFeeDescription() {
    return '手续费规则：按交易额2%收取，单笔最低10积分，最高100积分';
  }
}

class C2CFeeBreakdown {
  final int amount;
  final int grossFee;
  final int netFee;
  final int level1Profit;
  final int level2Profit;
  final int level3Profit;
  final int platformRevenue;
  final double discountApplied;

  C2CFeeBreakdown({
    required this.amount,
    required this.grossFee,
    required this.netFee,
    required this.level1Profit,
    required this.level2Profit,
    required this.level3Profit,
    required this.platformRevenue,
    required this.discountApplied,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'gross_fee': grossFee,
      'net_fee': netFee,
      'level1_profit': level1Profit,
      'level2_profit': level2Profit,
      'level3_profit': level3Profit,
      'platform_revenue': platformRevenue,
      'discount_applied': discountApplied,
    };
  }

  String toDisplayString() {
    return '''
交易金额: $amount 积分
手续费率: 2%
标准手续费: $grossFee 积分
${discountApplied < 1.0 ? '会员折扣: ${(discountApplied * 100).toInt()}折\n实收手续费: $netFee 积分' : ''}

分润明细:
- 直推分润(20%): $level1Profit 积分
- 二级分润(10%): $level2Profit 积分
- 平台收益: $platformRevenue 积分
''';
  }
}

class PromotionService {
  static int getDirectCountForMidMember() {
    return ProfitShareConfig.directUsersForMidMember;
  }

  static int getDirectCountForHighMember() {
    return ProfitShareConfig.directUsersForHighMember;
  }

  static int? checkMemberUpgrade(int currentLevel, int directVerifiedUsers) {
    if (currentLevel >= 2) return null;

    if (directVerifiedUsers >= ProfitShareConfig.directUsersForHighMember && currentLevel < 2) {
      return 2;
    }
    if (directVerifiedUsers >= ProfitShareConfig.directUsersForMidMember && currentLevel < 1) {
      return 1;
    }
    return null;
  }

  static String getUpgradeHint(int currentLevel, int directVerifiedUsers) {
    if (currentLevel >= 2) {
      return '已是高级会员';
    }

    final target = currentLevel == 0
        ? ProfitShareConfig.directUsersForMidMember
        : ProfitShareConfig.directUsersForHighMember;

    final remaining = target - directVerifiedUsers;
    if (remaining <= 0) {
      return '恭喜！已达到升级条件';
    }
    return '再推荐 $remaining 个实名用户即可升级${currentLevel == 0 ? "中级" : "高级"}会员';
  }

  static Map<String, int> calculateLevelRewards() {
    return {
      '直推200实名': 0,
      '送中级会员一年': 0,
      '直推500实名': 0,
      '送高级会员一年': 0,
    };
  }
}

class LingjiBalanceService {
  static const int lingjiToYuan = 10;

  static int yuanToLingji(double yuan) {
    return (yuan * lingjiToYuan).round();
  }

  static double lingjiToYuanDisplay(int lingji) {
    return lingji / lingjiToYuan;
  }

  static String formatLingji(int lingji) {
    if (lingji >= 10000) {
      return '${(lingji / 10000).toStringAsFixed(2)}万';
    }
    return lingji.toString();
  }

  static bool canAfford(int balance, int cost) {
    return balance >= cost;
  }

  static int calculateDailyIncome(int balance, double bonusRate) {
    return (balance * bonusRate).round();
  }
}
