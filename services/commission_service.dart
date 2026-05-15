import 'dart:math';
import '../models/affiliate_commission.dart';

class CommissionService {
  static final CommissionService _instance = CommissionService._internal();
  factory CommissionService() => _instance;
  CommissionService._internal();

  static const double platformFeeRate = 0.10;
  static const double level1BaseRate = 0.15;
  static const double level2BaseRate = 0.05;

  static const String legalDisclaimer = '''
  【香港合規聲明】
  本推廣體系嚴格遵循香港《禁止層壓式推廣條例》：
  • 零門檻免費註冊即可參與推廣
  • 無需購買會員、無需繳費
  • 僅按真實成交訂單計算佣金
  • 無拉人頭獎勵、無層級人頭計酬
  • 直推一級分成、間推二級分成
  • 三級及以上不再額外分潤
  ''';

  static const String commissionRules = '''
  【分佣說明】
  • 一級佣金：直推會員下單成交後，自動結算
  • 二級佣金：間推會員下單成交後，自動結算
  • 所有推廣收益自動到賬，結算透明可查
  • 會員充值、達人服務成交、博客付費等全部適用
  ''';

  final Map<String, AffiliateUser> _affiliateUsers = {};
  final Map<String, CommissionOrder> _orders = {};
  final Map<String, CommissionSettlement> _settlements = {};

  void bindAffiliateRelation({
    required String userId,
    String? parentId,
    String? grandparentId,
  }) {
    final affiliateUser = AffiliateUser(
      id: _generateId(),
      userId: userId,
      parentId: parentId,
      grandparentId: grandparentId,
      boundAt: DateTime.now(),
    );
    _affiliateUsers[userId] = affiliateUser;

    if (parentId != null && _affiliateUsers.containsKey(parentId)) {
      final parent = _affiliateUsers[parentId]!;
      _affiliateUsers[parentId] = AffiliateUser(
        id: parent.id,
        userId: parent.userId,
        parentId: parent.parentId,
        grandparentId: parent.grandparentId,
        boundAt: parent.boundAt,
        lastOrderAt: parent.lastOrderAt,
        totalOrders: parent.totalOrders,
        totalEarnings: parent.totalEarnings,
        level1Count: parent.level1Count + 1,
        level2Count: parent.level2Count,
      );
    }

    if (grandparentId != null && _affiliateUsers.containsKey(grandparentId)) {
      final grandparent = _affiliateUsers[grandparentId]!;
      _affiliateUsers[grandparentId] = AffiliateUser(
        id: grandparent.id,
        userId: grandparent.userId,
        parentId: grandparent.parentId,
        grandparentId: grandparent.grandparentId,
        boundAt: grandparent.boundAt,
        lastOrderAt: grandparent.lastOrderAt,
        totalOrders: grandparent.totalOrders,
        totalEarnings: grandparent.totalEarnings,
        level1Count: grandparent.level1Count,
        level2Count: grandparent.level2Count + 1,
      );
    }
  }

  CommissionOrder createCommissionOrder({
    required String orderId,
    required CommissionType type,
    required double amount,
    required String userId,
    String? talentId,
    int? userMemberLevel,
  }) {
    final bonus = AffiliateLevelBonus.getBonusForLevel(userMemberLevel ?? 0);
    final level1Rate = bonus.level1Rate;
    final level2Rate = bonus.level2Rate;

    final affiliateUser = _affiliateUsers[userId];
    final platformFee = amount * platformFeeRate;
    final level1Amount = affiliateUser?.hasParent == true
        ? amount * level1Rate
        : 0.0;
    final level2Amount = affiliateUser?.hasGrandparent == true
        ? amount * level2Rate
        : 0.0;

    final order = CommissionOrder(
      id: _generateId(),
      orderId: orderId,
      type: type,
      amount: amount,
      platformFee: platformFee,
      level1Commission: level1Amount,
      level2Commission: level2Amount,
      userId: userId,
      level1UserId: affiliateUser?.parentId,
      level2UserId: affiliateUser?.grandparentId,
      talentId: talentId,
      createdAt: DateTime.now(),
      status: CommissionStatus.pending,
    );

    _orders[order.id] = order;
    return order;
  }

  List<CommissionSettlement> settleOrder(String orderId) {
    final order = _orders[orderId];
    if (order == null) return [];

    final settlements = <CommissionSettlement>[];

    if (order.level1UserId != null && order.level1Commission > 0) {
      final settlement = CommissionSettlement(
        id: _generateId(),
        userId: order.level1UserId!,
        amount: order.level1Commission,
        level1Amount: order.level1Commission,
        level2Amount: 0,
        type: order.type,
        orderId: orderId,
        settledAt: DateTime.now(),
        status: SettlementStatus.completed,
        notes: '一級推廣佣金',
      );
      _settlements[settlement.id] = settlement;
      settlements.add(settlement);

      _updateAffiliateEarnings(order.level1UserId!, order.level1Commission);
    }

    if (order.level2UserId != null && order.level2Commission > 0) {
      final settlement = CommissionSettlement(
        id: _generateId(),
        userId: order.level2UserId!,
        amount: order.level2Commission,
        level1Amount: 0,
        level2Amount: order.level2Commission,
        type: order.type,
        orderId: orderId,
        settledAt: DateTime.now(),
        status: SettlementStatus.completed,
        notes: '二級推廣佣金',
      );
      _settlements[settlement.id] = settlement;
      settlements.add(settlement);

      _updateAffiliateEarnings(order.level2UserId!, order.level2Commission);
    }

    _orders[orderId] = CommissionOrder(
      id: order.id,
      orderId: order.orderId,
      type: order.type,
      amount: order.amount,
      platformFee: order.platformFee,
      level1Commission: order.level1Commission,
      level2Commission: order.level2Commission,
      userId: order.userId,
      level1UserId: order.level1UserId,
      level2UserId: order.level2UserId,
      talentId: order.talentId,
      createdAt: order.createdAt,
      status: CommissionStatus.settled,
    );

    return settlements;
  }

  void _updateAffiliateEarnings(String userId, double amount) {
    final user = _affiliateUsers[userId];
    if (user == null) return;

    _affiliateUsers[userId] = AffiliateUser(
      id: user.id,
      userId: user.userId,
      parentId: user.parentId,
      grandparentId: user.grandparentId,
      boundAt: user.boundAt,
      lastOrderAt: DateTime.now(),
      totalOrders: user.totalOrders + 1,
      totalEarnings: user.totalEarnings + amount,
      level1Count: user.level1Count,
      level2Count: user.level2Count,
    );
  }

  AffiliateStats getAffiliateStats(String userId) {
    final user = _affiliateUsers[userId];
    final userSettlements = _settlements.values
        .where((s) => s.userId == userId)
        .toList();

    final thisMonth = DateTime.now().month;
    final thisMonthSettlements = userSettlements
        .where((s) => s.settledAt.month == thisMonth)
        .toList();

    final pendingSettlements = userSettlements
        .where((s) => s.status == SettlementStatus.pending)
        .toList();

    return AffiliateStats(
      userId: userId,
      totalInvites: (user?.level1Count ?? 0) + (user?.level2Count ?? 0),
      level1Invites: user?.level1Count ?? 0,
      level2Invites: user?.level2Count ?? 0,
      totalOrders: user?.totalOrders ?? 0,
      totalEarnings: user?.totalEarnings ?? 0.0,
      thisMonthEarnings: thisMonthSettlements.fold(
        0.0,
        (sum, s) => sum + s.amount,
      ),
      pendingSettlement: pendingSettlements.fold(
        0.0,
        (sum, s) => sum + s.amount,
      ),
      lastSettlementAt: userSettlements.isNotEmpty
          ? userSettlements.last.settledAt
          : null,
    );
  }

  AffiliatePromotionLink createPromotionLink(String userId) {
    final code = 'LJ${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(9999).toString().padLeft(4, '0')}';
    return AffiliatePromotionLink(
      id: _generateId(),
      userId: userId,
      code: code,
      link: 'https://lingji.com/invite/$code',
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> getCommissionSummary() {
    double totalPlatformFee = 0;
    double totalLevel1Commission = 0;
    double totalLevel2Commission = 0;

    for (final order in _orders.values) {
      totalPlatformFee += order.platformFee;
      totalLevel1Commission += order.level1Commission;
      totalLevel2Commission += order.level2Commission;
    }

    return {
      'total_orders': _orders.length,
      'total_platform_fee': totalPlatformFee,
      'total_level1_commission': totalLevel1Commission,
      'total_level2_commission': totalLevel2Commission,
      'total_commission': totalLevel1Commission + totalLevel2Commission,
      'settlement_count': _settlements.length,
      'legal_disclaimer': legalDisclaimer,
      'commission_rules': commissionRules,
    };
  }

  bool isValidAffiliateRelation({
    required String userId,
    required String? parentId,
    required String? grandparentId,
  }) {
    if (parentId == null) return true;
    if (parentId == userId) return false;
    if (grandparentId != null && grandparentId == userId) return false;
    if (grandparentId != null && grandparentId == parentId) return false;
    return true;
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(9999).toString().padLeft(4, '0');
  }
}

class TalentCommissionService {
  static final TalentCommissionService _instance = TalentCommissionService._internal();
  factory TalentCommissionService() => _instance;
  TalentCommissionService._internal();

  static const double platformFeeRate = 0.10;

  static const String talentDisclaimer = '''
  【達人服務說明】
  • 達人可在櫥窗自主設置服務收費標準
  • 每筆服務訂單平台統一固定抽成10%
  • 剩餘收益歸達人所有
  • 結算透明可查
  ''';

  final Map<String, TalentServicePricing> _customPricings = {};

  void setCustomPricing(String talentId, TalentServicePricing pricing) {
    _customPricings[talentId] = pricing.copyWith(
      isCustomPricing: true,
      lastUpdated: DateTime.now(),
    );
  }

  TalentServicePricing getPricing(String talentId) {
    return _customPricings[talentId] ??
        TalentServicePricing(
          isCustomPricing: false,
          lastUpdated: DateTime.now(),
        );
  }

  double calculateTalentEarning({
    required String talentId,
    required CommissionType serviceType,
    required double orderAmount,
  }) {
    return orderAmount * (1 - platformFeeRate);
  }

  Map<String, double> calculateCommissionBreakdown({
    required double orderAmount,
    required int userMemberLevel,
  }) {
    final bonus = AffiliateLevelBonus.getBonusForLevel(userMemberLevel);
    final platformFee = orderAmount * platformFeeRate;
    final level1Commission = orderAmount * bonus.level1Rate;
    final level2Commission = orderAmount * bonus.level2Rate;
    final talentEarning = orderAmount * (1 - platformFeeRate);

    return {
      'order_amount': orderAmount,
      'platform_fee': platformFee,
      'platform_fee_rate': platformFeeRate,
      'level1_commission': level1Commission,
      'level1_rate': bonus.level1Rate,
      'level2_commission': level2Commission,
      'level2_rate': bonus.level2Rate,
      'total_affiliate_commission': level1Commission + level2Commission,
      'talent_earning': talentEarning,
      'talent_rate': 1 - platformFeeRate,
    };
  }
}
