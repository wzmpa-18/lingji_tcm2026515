import 'package:flutter/foundation.dart';

enum PaymentMethod {
  wechatPay,
  alipay,
  other,
}

enum RegionType {
  domestic,
  overseas,
}

enum OrderType {
  course,
  product,
  membership,
  fortuneReading,
}

enum OrderStatus {
  pending,
  paid,
  processing,
  completed,
  refunded,
  failed,
}

enum SettlementStatus {
  pending,
  processing,
  settled,
  failed,
}

enum WithdrawalStatus {
  pending,
  processing,
  approved,
  completed,
  rejected,
}

class PaymentConfig {
  static const String platformName = '中医易学学习助手';
  static const String wechatAppId = '';
  static const String alipayAppId = '';
  static const String usdtAddress = '';
  static const String usdcAddress = '';
  static const String btcAddress = '';
  static const String ethAddress = '';

  static bool showWechatPay = true;
  static bool showAlipay = true;
  static bool showOtherPay = false;

  static bool forceDomesticOtp = false;
  static bool forceOverseasOtp = false;
}

class PaymentChannel {
  final String id;
  final String name;
  final String icon;
  final PaymentMethod method;
  final bool isEnabled;
  final bool showForDomestic;
  final bool showForOverseas;
  final int sortOrder;

  PaymentChannel({
    required this.id,
    required this.name,
    required this.icon,
    required this.method,
    required this.isEnabled,
    required this.showForDomestic,
    required this.showForOverseas,
    required this.sortOrder,
  });

  factory PaymentChannel.wechat() {
    return PaymentChannel(
      id: 'wechat',
      name: '微信支付',
      icon: '💬',
      method: PaymentMethod.wechatPay,
      isEnabled: PaymentConfig.showWechatPay,
      showForDomestic: true,
      showForOverseas: true,
      sortOrder: 1,
    );
  }

  factory PaymentChannel.alipay() {
    return PaymentChannel(
      id: 'alipay',
      name: '支付宝',
      icon: '💰',
      method: PaymentMethod.alipay,
      isEnabled: PaymentConfig.showAlipay,
      showForDomestic: true,
      showForOverseas: true,
      sortOrder: 2,
    );
  }

  factory PaymentChannel.usdt() {
    return PaymentChannel(
      id: 'usdt',
      name: 'USDT (TRC20)',
      icon: '💎',
      method: PaymentMethod.other,
      isEnabled: PaymentConfig.showOtherPay,
      showForDomestic: false,
      showForOverseas: true,
      sortOrder: 3,
    );
  }

  factory PaymentChannel.usdc() {
    return PaymentChannel(
      id: 'usdc',
      name: 'USDC (ERC20)',
      icon: '🔷',
      method: PaymentMethod.other,
      isEnabled: PaymentConfig.showOtherPay,
      showForDomestic: false,
      showForOverseas: true,
      sortOrder: 4,
    );
  }

  factory PaymentChannel.btc() {
    return PaymentChannel(
      id: 'btc',
      name: 'Bitcoin (BTC)',
      icon: '₿',
      method: PaymentMethod.other,
      isEnabled: PaymentConfig.showOtherPay,
      showForDomestic: false,
      showForOverseas: true,
      sortOrder: 5,
    );
  }

  factory PaymentChannel.eth() {
    return PaymentChannel(
      id: 'eth',
      name: 'Ethereum (ETH)',
      icon: 'Ξ',
      method: PaymentMethod.other,
      isEnabled: PaymentConfig.showOtherPay,
      showForDomestic: false,
      showForOverseas: true,
      sortOrder: 6,
    );
  }
}

class Order {
  final String id;
  final String orderNo;
  final OrderType type;
  final double amount;
  final double? originalAmount;
  final PaymentMethod method;
  final OrderStatus status;
  final String? productId;
  final String? productName;
  final String? instructorId;
  final String? affiliateId;
  final RegionType region;
  final DateTime createdAt;
  final DateTime? paidAt;
  final String? transactionId;

  Order({
    required this.id,
    required this.orderNo,
    required this.type,
    required this.amount,
    this.originalAmount,
    required this.method,
    required this.status,
    this.productId,
    this.productName,
    this.instructorId,
    this.affiliateId,
    required this.region,
    required this.createdAt,
    this.paidAt,
    this.transactionId,
  });

  Order copyWith({
    String? id,
    String? orderNo,
    OrderType? type,
    double? amount,
    double? originalAmount,
    PaymentMethod? method,
    OrderStatus? status,
    String? productId,
    String? productName,
    String? instructorId,
    String? affiliateId,
    RegionType? region,
    DateTime? createdAt,
    DateTime? paidAt,
    String? transactionId,
  }) {
    return Order(
      id: id ?? this.id,
      orderNo: orderNo ?? this.orderNo,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      originalAmount: originalAmount ?? this.originalAmount,
      method: method ?? this.method,
      status: status ?? this.status,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      instructorId: instructorId ?? this.instructorId,
      affiliateId: affiliateId ?? this.affiliateId,
      region: region ?? this.region,
      createdAt: createdAt ?? this.createdAt,
      paidAt: paidAt ?? this.paidAt,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNo': orderNo,
      'type': type.name,
      'amount': amount,
      'originalAmount': originalAmount,
      'method': method.name,
      'status': status.name,
      'productId': productId,
      'productName': productName,
      'instructorId': instructorId,
      'affiliateId': affiliateId,
      'region': region.name,
      'createdAt': createdAt.toIso8601String(),
      'paidAt': paidAt?.toIso8601String(),
      'transactionId': transactionId,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderNo: json['orderNo'],
      type: OrderType.values.firstWhere((e) => e.name == json['type']),
      amount: json['amount'],
      originalAmount: json['originalAmount'],
      method: PaymentMethod.values.firstWhere((e) => e.name == json['method']),
      status: OrderStatus.values.firstWhere((e) => e.name == json['status']),
      productId: json['productId'],
      productName: json['productName'],
      instructorId: json['instructorId'],
      affiliateId: json['affiliateId'],
      region: RegionType.values.firstWhere((e) => e.name == json['region']),
      createdAt: DateTime.parse(json['createdAt']),
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
      transactionId: json['transactionId'],
    );
  }
}

class Settlement {
  final String id;
  final String orderId;
  final String orderNo;
  final String? recipientId;
  final String recipientType;
  final double amount;
  final double fee;
  final double netAmount;
  final SettlementStatus status;
  final DateTime createdAt;
  final DateTime? settledAt;
  final String? remark;

  Settlement({
    required this.id,
    required this.orderId,
    required this.orderNo,
    this.recipientId,
    required this.recipientType,
    required this.amount,
    required this.fee,
    required this.netAmount,
    required this.status,
    required this.createdAt,
    this.settledAt,
    this.remark,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'orderNo': orderNo,
      'recipientId': recipientId,
      'recipientType': recipientType,
      'amount': amount,
      'fee': fee,
      'netAmount': netAmount,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'settledAt': settledAt?.toIso8601String(),
      'remark': remark,
    };
  }
}

class WithdrawalRequest {
  final String id;
  final String userId;
  final double amount;
  final double fee;
  final double netAmount;
  final String paymentMethod;
  final String accountInfo;
  final WithdrawalStatus status;
  final DateTime createdAt;
  final DateTime? processedAt;
  final DateTime? completedAt;
  final String? rejectionReason;

  WithdrawalRequest({
    required this.id,
    required this.userId,
    required this.amount,
    required this.fee,
    required this.netAmount,
    required this.paymentMethod,
    required this.accountInfo,
    required this.status,
    required this.createdAt,
    this.processedAt,
    this.completedAt,
    this.rejectionReason,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'fee': fee,
      'netAmount': netAmount,
      'paymentMethod': paymentMethod,
      'accountInfo': accountInfo,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'processedAt': processedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'rejectionReason': rejectionReason,
    };
  }
}

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  final List<Order> _orders = [];
  final List<Settlement> _settlements = [];
  final List<WithdrawalRequest> _withdrawals = [];

  double platformInitialCommissionRate = 0.5;
  double platformMinimumCommissionRate = 0.1;
  double affiliateLevel1Rate = 0.1;
  double affiliateLevel2Rate = 0.05;
  double withdrawalFeeRate = 0.05;

  RegionType _currentRegion = RegionType.domestic;

  void setCurrentRegion(RegionType region) {
    _currentRegion = region;
  }

  RegionType getCurrentRegion() {
    return _currentRegion;
  }

  List<PaymentChannel> getAvailableChannels() {
    final channels = <PaymentChannel>[];

    if (PaymentConfig.showWechatPay) {
      channels.add(PaymentChannel.wechat());
    }
    if (PaymentConfig.showAlipay) {
      channels.add(PaymentChannel.alipay());
    }

    if (_currentRegion == RegionType.overseas && PaymentConfig.showOtherPay) {
      channels.add(PaymentChannel.usdt());
      channels.add(PaymentChannel.usdc());
      channels.add(PaymentChannel.btc());
      channels.add(PaymentChannel.eth());
    }

    channels.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return channels;
  }

  String generateOrderNo() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = List.generate(6, (index) => '1234567890'[DateTime.now().millisecond % 10]).join();
    return 'ZY$timestamp$random';
  }

  Future<Order?> createOrder({
    required OrderType type,
    required double amount,
    double? originalAmount,
    required PaymentMethod method,
    required RegionType region,
    String? productId,
    String? productName,
    String? instructorId,
    String? affiliateId,
  }) async {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderNo: generateOrderNo(),
      type: type,
      amount: amount,
      originalAmount: originalAmount ?? amount,
      method: method,
      status: OrderStatus.pending,
      productId: productId,
      productName: productName,
      instructorId: instructorId,
      affiliateId: affiliateId,
      region: region,
      createdAt: DateTime.now(),
    );

    _orders.add(order);
    return order;
  }

  Future<bool> processPayment(String orderId) async {
    final orderIndex = _orders.indexWhere((o) => o.id == orderId);
    if (orderIndex == -1) return false;

    final order = _orders[orderIndex];
    _orders[orderIndex] = order.copyWith(
      status: OrderStatus.paid,
      paidAt: DateTime.now(),
      transactionId: 'TRX${DateTime.now().millisecondsSinceEpoch}',
    );

    await _generateSettlements(_orders[orderIndex]);

    return true;
  }

  Future<void> _generateSettlements(Order order) async {
    final settlements = <Settlement>[];
    final orderAmount = order.amount;

    if (order.instructorId != null && order.type == OrderType.course) {
      final instructorCommission = _calculateInstructorCommission(orderAmount);
      final platformCommission = orderAmount - instructorCommission;

      settlements.add(Settlement(
        id: 'ST${DateTime.now().millisecondsSinceEpoch}-1',
        orderId: order.id,
        orderNo: order.orderNo,
        recipientId: order.instructorId,
        recipientType: 'instructor',
        amount: orderAmount,
        fee: platformCommission,
        netAmount: instructorCommission,
        status: SettlementStatus.pending,
        createdAt: DateTime.now(),
      ));
    } else {
      settlements.add(Settlement(
        id: 'ST${DateTime.now().millisecondsSinceEpoch}-1',
        orderId: order.id,
        orderNo: order.orderNo,
        recipientType: 'platform',
        amount: orderAmount,
        fee: 0,
        netAmount: orderAmount,
        status: SettlementStatus.pending,
        createdAt: DateTime.now(),
      ));
    }

    if (order.affiliateId != null) {
      final level1Amount = orderAmount * affiliateLevel1Rate;
      settlements.add(Settlement(
        id: 'ST${DateTime.now().millisecondsSinceEpoch}-2',
        orderId: order.id,
        orderNo: order.orderNo,
        recipientId: order.affiliateId,
        recipientType: 'affiliate',
        amount: orderAmount,
        fee: 0,
        netAmount: level1Amount,
        status: SettlementStatus.pending,
        createdAt: DateTime.now(),
        remark: '一级分销佣金',
      ));
    }

    _settlements.addAll(settlements);
  }

  double _calculateInstructorCommission(double orderAmount) {
    final rating = 4.8;
    double rate;

    if (rating >= 4.9) {
      rate = 1 - platformMinimumCommissionRate;
    } else if (rating >= 4.8) {
      rate = 0.7;
    } else if (rating >= 4.5) {
      rate = 0.6;
    } else {
      rate = 1 - platformInitialCommissionRate;
    }

    return orderAmount * rate;
  }

  Future<WithdrawalRequest?> requestWithdrawal({
    required String userId,
    required double amount,
    required String paymentMethod,
    required String accountInfo,
  }) async {
    final fee = amount * withdrawalFeeRate;
    final netAmount = amount - fee;

    final withdrawal = WithdrawalRequest(
      id: 'WD${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      amount: amount,
      fee: fee,
      netAmount: netAmount,
      paymentMethod: paymentMethod,
      accountInfo: accountInfo,
      status: WithdrawalStatus.pending,
      createdAt: DateTime.now(),
    );

    _withdrawals.add(withdrawal);
    return withdrawal;
  }

  Future<bool> processRefund(String orderId, String reason) async {
    final orderIndex = _orders.indexWhere((o) => o.id == orderId);
    if (orderIndex == -1) return false;

    final order = _orders[orderIndex];
    _orders[orderIndex] = order.copyWith(status: OrderStatus.refunded);

    final relatedSettlements = _settlements.where((s) => s.orderId == orderId).toList();
    for (var settlement in relatedSettlements) {
      final index = _settlements.indexWhere((s) => s.id == settlement.id);
      if (index != -1) {
        _settlements[index] = Settlement(
          id: settlement.id,
          orderId: settlement.orderId,
          orderNo: settlement.orderNo,
          recipientId: settlement.recipientId,
          recipientType: settlement.recipientType,
          amount: settlement.amount,
          fee: settlement.fee,
          netAmount: settlement.netAmount,
          status: SettlementStatus.failed,
          createdAt: settlement.createdAt,
          remark: reason,
        );
      }
    }

    return true;
  }

  double getAvailableBalance(String userId) {
    final userSettlements = _settlements.where((s) =>
      s.recipientId == userId &&
      s.status == SettlementStatus.settled
    );

    double total = 0;
    for (var settlement in userSettlements) {
      total += settlement.netAmount;
    }

    final pendingWithdrawals = _withdrawals.where((w) =>
      w.userId == userId &&
      (w.status == WithdrawalStatus.pending || w.status == WithdrawalStatus.processing)
    );
    for (var w in pendingWithdrawals) {
      total -= w.amount;
    }

    return total;
  }

  List<Order> getUserOrders(String userId) {
    return _orders.toList();
  }

  List<Settlement> getUserSettlements(String userId) {
    return _settlements.where((s) => s.recipientId == userId).toList();
  }

  List<WithdrawalRequest> getUserWithdrawals(String userId) {
    return _withdrawals.where((w) => w.userId == userId).toList();
  }
}
