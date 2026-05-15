import 'package:flutter/material.dart';

class AffiliateConfig {
  static const double platformFee = 0.10;
  static const double level1Commission = 0.15;
  static const double level2Commission = 0.05;
  static const double maxCommission = 0.20;

  static double get level1Rate => level1Commission;
  static double get level2Rate => level2Commission;
  static double get platformRate => platformFee;
}

enum CommissionType {
  memberRecharge,
  talentService,
  blogPay,
  storeOrder,
  other,
}

extension CommissionTypeExtension on CommissionType {
  String get displayName {
    switch (this) {
      case CommissionType.memberRecharge:
        return '会员充值';
      case CommissionType.talentService:
        return '达人服务';
      case CommissionType.blogPay:
        return '博客付费';
      case CommissionType.storeOrder:
        return '商城订单';
      case CommissionType.other:
        return '其他订单';
    }
  }

  IconData get icon {
    switch (this) {
      case CommissionType.memberRecharge:
        return Icons.workspace_premium;
      case CommissionType.talentService:
        return Icons.person;
      case CommissionType.blogPay:
        return Icons.article;
      case CommissionType.storeOrder:
        return Icons.shopping_bag;
      case CommissionType.other:
        return Icons.receipt;
    }
  }

  String get description {
    switch (this) {
      case CommissionType.memberRecharge:
        return '会员购买付费服务';
      case CommissionType.talentService:
        return '达人提供的咨询服务';
      case CommissionType.blogPay:
        return '博客内容付费解锁';
      case CommissionType.storeOrder:
        return '商城商品购买';
      case CommissionType.other:
        return '其他消费订单';
    }
  }
}

class CommissionOrder {
  final String id;
  final String orderId;
  final CommissionType type;
  final double amount;
  final double platformFee;
  final double level1Commission;
  final double level2Commission;
  final String userId;
  final String? level1UserId;
  final String? level2UserId;
  final String? talentId;
  final DateTime createdAt;
  final CommissionStatus status;

  CommissionOrder({
    required this.id,
    required this.orderId,
    required this.type,
    required this.amount,
    required this.platformFee,
    required this.level1Commission,
    required this.level2Commission,
    required this.userId,
    this.level1UserId,
    this.level2UserId,
    this.talentId,
    required this.createdAt,
    required this.status,
  });

  double get totalCommission => level1Commission + level2Commission;
  double get talentEarning => amount * (1 - AffiliateConfig.platformFee);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'type': type.name,
      'amount': amount,
      'platform_fee': platformFee,
      'level1_commission': level1Commission,
      'level2_commission': level2Commission,
      'user_id': userId,
      'level1_user_id': level1UserId,
      'level2_user_id': level2UserId,
      'talent_id': talentId,
      'created_at': createdAt.toIso8601String(),
      'status': status.name,
    };
  }

  factory CommissionOrder.fromMap(Map<String, dynamic> map) {
    return CommissionOrder(
      id: map['id'],
      orderId: map['order_id'],
      type: CommissionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => CommissionType.other,
      ),
      amount: (map['amount'] as num).toDouble(),
      platformFee: (map['platform_fee'] as num).toDouble(),
      level1Commission: (map['level1_commission'] as num).toDouble(),
      level2Commission: (map['level2_commission'] as num).toDouble(),
      userId: map['user_id'],
      level1UserId: map['level1_user_id'],
      level2UserId: map['level2_user_id'],
      talentId: map['talent_id'],
      createdAt: DateTime.parse(map['created_at']),
      status: CommissionStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => CommissionStatus.pending,
      ),
    );
  }
}

enum CommissionStatus {
  pending,
  settled,
  cancelled,
  expired,
}

extension CommissionStatusExtension on CommissionStatus {
  String get displayName {
    switch (this) {
      case CommissionStatus.pending:
        return '待结算';
      case CommissionStatus.settled:
        return '已结算';
      case CommissionStatus.cancelled:
        return '已取消';
      case CommissionStatus.expired:
        return '已失效';
    }
  }
}

class AffiliateUser {
  final String id;
  final String userId;
  final String? parentId;
  final String? grandparentId;
  final DateTime boundAt;
  final DateTime? lastOrderAt;
  final int totalOrders;
  final double totalEarnings;
  final int level1Count;
  final int level2Count;

  AffiliateUser({
    required this.id,
    required this.userId,
    this.parentId,
    this.grandparentId,
    required this.boundAt,
    this.lastOrderAt,
    this.totalOrders = 0,
    this.totalEarnings = 0.0,
    this.level1Count = 0,
    this.level2Count = 0,
  });

  bool get hasParent => parentId != null;
  bool get hasGrandparent => grandparentId != null;
  bool get isTopLevel => parentId == null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'parent_id': parentId,
      'grandparent_id': grandparentId,
      'bound_at': boundAt.toIso8601String(),
      'last_order_at': lastOrderAt?.toIso8601String(),
      'total_orders': totalOrders,
      'total_earnings': totalEarnings,
      'level1_count': level1Count,
      'level2_count': level2Count,
    };
  }

  factory AffiliateUser.fromMap(Map<String, dynamic> map) {
    return AffiliateUser(
      id: map['id'],
      userId: map['user_id'],
      parentId: map['parent_id'],
      grandparentId: map['grandparent_id'],
      boundAt: DateTime.parse(map['bound_at']),
      lastOrderAt: map['last_order_at'] != null
          ? DateTime.parse(map['last_order_at'])
          : null,
      totalOrders: map['total_orders'] ?? 0,
      totalEarnings: (map['total_earnings'] as num?)?.toDouble() ?? 0.0,
      level1Count: map['level1_count'] ?? 0,
      level2Count: map['level2_count'] ?? 0,
    );
  }
}

class CommissionSettlement {
  final String id;
  final String userId;
  final double amount;
  final double level1Amount;
  final double level2Amount;
  final CommissionType type;
  final String orderId;
  final DateTime settledAt;
  final SettlementStatus status;
  final String? notes;

  CommissionSettlement({
    required this.id,
    required this.userId,
    required this.amount,
    required this.level1Amount,
    required this.level2Amount,
    required this.type,
    required this.orderId,
    required this.settledAt,
    required this.status,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'level1_amount': level1Amount,
      'level2_amount': level2Amount,
      'type': type.name,
      'order_id': orderId,
      'settled_at': settledAt.toIso8601String(),
      'status': status.name,
      'notes': notes,
    };
  }

  factory CommissionSettlement.fromMap(Map<String, dynamic> map) {
    return CommissionSettlement(
      id: map['id'],
      userId: map['user_id'],
      amount: (map['amount'] as num).toDouble(),
      level1Amount: (map['level1_amount'] as num).toDouble(),
      level2Amount: (map['level2_amount'] as num).toDouble(),
      type: CommissionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => CommissionType.other,
      ),
      orderId: map['order_id'],
      settledAt: DateTime.parse(map['settled_at']),
      status: SettlementStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => SettlementStatus.pending,
      ),
      notes: map['notes'],
    );
  }
}

enum SettlementStatus {
  pending,
  processing,
  completed,
  failed,
}

extension SettlementStatusExtension on SettlementStatus {
  String get displayName {
    switch (this) {
      case SettlementStatus.pending:
        return '待处理';
      case SettlementStatus.processing:
        return '处理中';
      case SettlementStatus.completed:
        return '已完成';
      case SettlementStatus.failed:
        return '失败';
    }
  }
}

class AffiliatePromotionLink {
  final String id;
  final String userId;
  final String code;
  final String link;
  final String? posterUrl;
  final int clickCount;
  final int bindCount;
  final int orderCount;
  final double totalEarnings;
  final DateTime createdAt;
  final bool isActive;

  AffiliatePromotionLink({
    required this.id,
    required this.userId,
    required this.code,
    required this.link,
    this.posterUrl,
    this.clickCount = 0,
    this.bindCount = 0,
    this.orderCount = 0,
    this.totalEarnings = 0.0,
    required this.createdAt,
    this.isActive = true,
  });

  String get qrCodeUrl => 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=$link';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'code': code,
      'link': link,
      'poster_url': posterUrl,
      'click_count': clickCount,
      'bind_count': bindCount,
      'order_count': orderCount,
      'total_earnings': totalEarnings,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive ? 1 : 0,
    };
  }

  factory AffiliatePromotionLink.fromMap(Map<String, dynamic> map) {
    return AffiliatePromotionLink(
      id: map['id'],
      userId: map['user_id'],
      code: map['code'],
      link: map['link'],
      posterUrl: map['poster_url'],
      clickCount: map['click_count'] ?? 0,
      bindCount: map['bind_count'] ?? 0,
      orderCount: map['order_count'] ?? 0,
      totalEarnings: (map['total_earnings'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(map['created_at']),
      isActive: map['is_active'] == 1,
    );
  }
}

class AffiliateStats {
  final String userId;
  final int totalInvites;
  final int level1Invites;
  final int level2Invites;
  final int totalOrders;
  final double totalEarnings;
  final double thisMonthEarnings;
  final double pendingSettlement;
  final DateTime? lastSettlementAt;

  AffiliateStats({
    required this.userId,
    this.totalInvites = 0,
    this.level1Invites = 0,
    this.level2Invites = 0,
    this.totalOrders = 0,
    this.totalEarnings = 0.0,
    this.thisMonthEarnings = 0.0,
    this.pendingSettlement = 0.0,
    this.lastSettlementAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'total_invites': totalInvites,
      'level1_invites': level1Invites,
      'level2_invites': level2Invites,
      'total_orders': totalOrders,
      'total_earnings': totalEarnings,
      'this_month_earnings': thisMonthEarnings,
      'pending_settlement': pendingSettlement,
      'last_settlement_at': lastSettlementAt?.toIso8601String(),
    };
  }

  factory AffiliateStats.fromMap(Map<String, dynamic> map) {
    return AffiliateStats(
      userId: map['user_id'],
      totalInvites: map['total_invites'] ?? 0,
      level1Invites: map['level1_invites'] ?? 0,
      level2Invites: map['level2_invites'] ?? 0,
      totalOrders: map['total_orders'] ?? 0,
      totalEarnings: (map['total_earnings'] as num?)?.toDouble() ?? 0.0,
      thisMonthEarnings: (map['this_month_earnings'] as num?)?.toDouble() ?? 0.0,
      pendingSettlement: (map['pending_settlement'] as num?)?.toDouble() ?? 0.0,
      lastSettlementAt: map['last_settlement_at'] != null
          ? DateTime.parse(map['last_settlement_at'])
          : null,
    );
  }
}

class AffiliateLevelBonus {
  final int levelValue;
  final double level1Rate;
  final double level2Rate;

  const AffiliateLevelBonus({
    required this.levelValue,
    required this.level1Rate,
    required this.level2Rate,
  });

  static const List<AffiliateLevelBonus> defaultBonus = [
    AffiliateLevelBonus(
      levelValue: 0,
      level1Rate: 0.10,
      level2Rate: 0.02,
    ),
    AffiliateLevelBonus(
      levelValue: 1,
      level1Rate: 0.12,
      level2Rate: 0.03,
    ),
    AffiliateLevelBonus(
      levelValue: 2,
      level1Rate: 0.15,
      level2Rate: 0.05,
    ),
    AffiliateLevelBonus(
      levelValue: 3,
      level1Rate: 0.18,
      level2Rate: 0.08,
    ),
    AffiliateLevelBonus(
      levelValue: 4,
      level1Rate: 0.20,
      level2Rate: 0.10,
    ),
    AffiliateLevelBonus(
      levelValue: 5,
      level1Rate: 0.20,
      level2Rate: 0.10,
    ),
  ];

  static AffiliateLevelBonus getBonusForLevel(int memberLevel) {
    return defaultBonus.firstWhere(
      (b) => b.levelValue == memberLevel,
      orElse: () => defaultBonus.first,
    );
  }
}
