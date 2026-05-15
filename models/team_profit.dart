class TeamProfit {
  final String id;
  final String userId;
  final String fromUserId;
  final int level;
  final int amount;
  final int profitAmount;
  final String transactionId;
  final DateTime createdAt;

  TeamProfit({
    required this.id,
    required this.userId,
    required this.fromUserId,
    required this.level,
    required this.amount,
    required this.profitAmount,
    required this.transactionId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'from_user_id': fromUserId,
      'level': level,
      'amount': amount,
      'profit_amount': profitAmount,
      'transaction_id': transactionId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory TeamProfit.fromMap(Map<String, dynamic> map) {
    return TeamProfit(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      fromUserId: map['from_user_id'] ?? '',
      level: map['level'] ?? 1,
      amount: map['amount'] ?? 0,
      profitAmount: map['profit_amount'] ?? 0,
      transactionId: map['transaction_id'] ?? '',
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class TeamRelation {
  final String id;
  final String userId;
  final String parentId;
  final String? grandParentId;
  final String? greatGrandParentId;
  final int directCount;
  final int level2Count;
  final int level3Count;
  final DateTime createdAt;

  TeamRelation({
    required this.id,
    required this.userId,
    required this.parentId,
    this.grandParentId,
    this.greatGrandParentId,
    this.directCount = 0,
    this.level2Count = 0,
    this.level3Count = 0,
    required this.createdAt,
  });

  int get totalTeamCount => directCount + level2Count + level3Count;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'parent_id': parentId,
      'grand_parent_id': grandParentId,
      'great_grand_parent_id': greatGrandParentId,
      'direct_count': directCount,
      'level2_count': level2Count,
      'level3_count': level3Count,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory TeamRelation.fromMap(Map<String, dynamic> map) {
    return TeamRelation(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      parentId: map['parent_id'] ?? '',
      grandParentId: map['grand_parent_id'],
      greatGrandParentId: map['great_grand_parent_id'],
      directCount: map['direct_count'] ?? 0,
      level2Count: map['level2_count'] ?? 0,
      level3Count: map['level3_count'] ?? 0,
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class ProfitShareConfig {
  static const double level1Rate = 0.20;
  static const double level2Rate = 0.10;
  static const double level3Rate = 0.0;

  static const int directUsersForMidMember = 200;
  static const int directUsersForHighMember = 500;

  static int calculateProfit(int amount, int level) {
    switch (level) {
      case 1:
        return (amount * level1Rate).round();
      case 2:
        return (amount * level2Rate).round();
      case 3:
        return (amount * level3Rate).round();
      default:
        return 0;
    }
  }
}

class RollLevel {
  final int level;
  final String name;
  final int minLingji;
  final int minTeamSize;
  final double dailyBonus;
  final String icon;

  const RollLevel({
    required this.level,
    required this.name,
    required this.minLingji,
    required this.minTeamSize,
    required this.dailyBonus,
    required this.icon,
  });

  static const List<RollLevel> levels = [
    RollLevel(level: 0, name: '普通', minLingji: 0, minTeamSize: 0, dailyBonus: 0.0, icon: '🌱'),
    RollLevel(level: 1, name: '青铜卷轴', minLingji: 1000, minTeamSize: 10, dailyBonus: 0.01, icon: '🥉'),
    RollLevel(level: 2, name: '白银卷轴', minLingji: 5000, minTeamSize: 50, dailyBonus: 0.02, icon: '🥈'),
    RollLevel(level: 3, name: '黄金卷轴', minLingji: 20000, minTeamSize: 200, dailyBonus: 0.03, icon: '🥇'),
    RollLevel(level: 4, name: '铂金卷轴', minLingji: 100000, minTeamSize: 500, dailyBonus: 0.05, icon: '💎'),
    RollLevel(level: 5, name: '钻石卷轴', minLingji: 500000, minTeamSize: 2000, dailyBonus: 0.08, icon: '💠'),
    RollLevel(level: 6, name: '王者卷轴', minLingji: 2000000, minTeamSize: 5000, dailyBonus: 0.12, icon: '👑'),
  ];

  static RollLevel getLevelByLingji(int lingji, int teamSize) {
    for (int i = levels.length - 1; i >= 0; i--) {
      if (lingji >= levels[i].minLingji && teamSize >= levels[i].minTeamSize) {
        return levels[i];
      }
    }
    return levels[0];
  }

  static RollLevel? getNextLevel(RollLevel current) {
    final nextIndex = current.level + 1;
    if (nextIndex < levels.length) {
      return levels[nextIndex];
    }
    return null;
  }
}

class DailyProfit {
  final String id;
  final String userId;
  final int baseAmount;
  final double bonusRate;
  final int totalAmount;
  final String rollLevel;
  final DateTime calculatedAt;

  DailyProfit({
    required this.id,
    required this.userId,
    required this.baseAmount,
    required this.bonusRate,
    required this.totalAmount,
    required this.rollLevel,
    required this.calculatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'base_amount': baseAmount,
      'bonus_rate': bonusRate,
      'total_amount': totalAmount,
      'roll_level': rollLevel,
      'calculated_at': calculatedAt.toIso8601String(),
    };
  }

  factory DailyProfit.fromMap(Map<String, dynamic> map) {
    return DailyProfit(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      baseAmount: map['base_amount'] ?? 0,
      bonusRate: (map['bonus_rate'] ?? 0.0).toDouble(),
      totalAmount: map['total_amount'] ?? 0,
      rollLevel: map['roll_level'] ?? '',
      calculatedAt: DateTime.parse(map['calculated_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class PromotionReward {
  final String id;
  final String userId;
  final String rewardType;
  final int lingjiReward;
  final int? memberDaysReward;
  final int? memberLevelReward;
  final String? rewardReason;
  final DateTime createdAt;
  final bool isClaimed;

  PromotionReward({
    required this.id,
    required this.userId,
    required this.rewardType,
    required this.lingjiReward,
    this.memberDaysReward,
    this.memberLevelReward,
    this.rewardReason,
    required this.createdAt,
    this.isClaimed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'reward_type': rewardType,
      'lingji_reward': lingjiReward,
      'member_days_reward': memberDaysReward,
      'member_level_reward': memberLevelReward,
      'reward_reason': rewardReason,
      'created_at': createdAt.toIso8601String(),
      'is_claimed': isClaimed ? 1 : 0,
    };
  }

  factory PromotionReward.fromMap(Map<String, dynamic> map) {
    return PromotionReward(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      rewardType: map['reward_type'] ?? '',
      lingjiReward: map['lingji_reward'] ?? 0,
      memberDaysReward: map['member_days_reward'],
      memberLevelReward: map['member_level_reward'],
      rewardReason: map['reward_reason'],
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      isClaimed: map['is_claimed'] == 1,
    );
  }
}

enum RewardType {
  directUser,
  teamMilestone,
  dailySignin,
  firstPurchase,
  bugReport,
  contentCorrection,
  qualitySuggestion,
}

extension RewardTypeExtension on RewardType {
  String get displayName {
    switch (this) {
      case RewardType.directUser:
        return '直推用户奖励';
      case RewardType.teamMilestone:
        return '团队里程碑';
      case RewardType.dailySignin:
        return '每日签到';
      case RewardType.firstPurchase:
        return '首次付费';
      case RewardType.bugReport:
        return 'BUG报告';
      case RewardType.contentCorrection:
        return '内容校正';
      case RewardType.qualitySuggestion:
        return '优质建议';
    }
  }

  int get defaultLingji {
    switch (this) {
      case RewardType.directUser:
        return 10;
      case RewardType.teamMilestone:
        return 100;
      case RewardType.dailySignin:
        return 5;
      case RewardType.firstPurchase:
        return 50;
      case RewardType.bugReport:
        return 50;
      case RewardType.contentCorrection:
        return 100;
      case RewardType.qualitySuggestion:
        return 200;
    }
  }
}
