import 'package:flutter/foundation.dart';

enum PaymentMethod {
  wechatPay,
  alipay,
  usdt,
  usdc,
  btc,
  eth,
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
  static const String platformName = '灵积学堂';
  static const String wechatAppId = '';
  static const String alipayAppId = '';
  static const String usdtAddress = '';
  static const String usdcAddress = '';
  static const String btcAddress = '';
  static const String ethAddress = '';
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

  Settlement copyWith({
    String? id,
    String? orderId,
    String? orderNo,
    String? recipientId,
    String? recipientType,
    double? amount,
    double? fee,
    double? netAmount,
    SettlementStatus? status,
    DateTime? createdAt,
    DateTime? settledAt,
    String? remark,
  }) {
    return Settlement(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      orderNo: orderNo ?? this.orderNo,
      recipientId: recipientId ?? this.recipientId,
      recipientType: recipientType ?? this.recipientType,
      amount: amount ?? this.amount,
      fee: fee ?? this.fee,
      netAmount: netAmount ?? this.netAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      settledAt: settledAt ?? this.settledAt,
      remark: remark ?? this.remark,
    );
  }

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

  factory Settlement.fromJson(Map<String, dynamic> json) {
    return Settlement(
      id: json['id'],
      orderId: json['orderId'],
      orderNo: json['orderNo'],
      recipientId: json['recipientId'],
      recipientType: json['recipientType'],
      amount: json['amount'],
      fee: json['fee'],
      netAmount: json['netAmount'],
      status: SettlementStatus.values.firstWhere((e) => e.name == json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      settledAt: json['settledAt'] != null ? DateTime.parse(json['settledAt']) : null,
      remark: json['remark'],
    );
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

  WithdrawalRequest copyWith({
    String? id,
    String? userId,
    double? amount,
    double? fee,
    double? netAmount,
    String? paymentMethod,
    String? accountInfo,
    WithdrawalStatus? status,
    DateTime? createdAt,
    DateTime? processedAt,
    DateTime? completedAt,
    String? rejectionReason,
  }) {
    return WithdrawalRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      fee: fee ?? this.fee,
      netAmount: netAmount ?? this.netAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      accountInfo: accountInfo ?? this.accountInfo,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      processedAt: processedAt ?? this.processedAt,
      completedAt: completedAt ?? this.completedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

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

  factory WithdrawalRequest.fromJson(Map<String, dynamic> json) {
    return WithdrawalRequest(
      id: json['id'],
      userId: json['userId'],
      amount: json['amount'],
      fee: json['fee'],
      netAmount: json['netAmount'],
      paymentMethod: json['paymentMethod'],
      accountInfo: json['accountInfo'],
      status: WithdrawalStatus.values.firstWhere((e) => e.name == json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      processedAt: json['processedAt'] != null ? DateTime.parse(json['processedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      rejectionReason: json['rejectionReason'],
    );
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

  String generateOrderNo() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = List.generate(6, (index) => '1234567890'[DateTime.now().millisecond % 10]).join();
    return 'LJ$timestamp$random';
  }

  Future<Order?> createOrder({
    required OrderType type,
    required double amount,
    double? originalAmount,
    required PaymentMethod method,
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
        _settlements[index] = settlement.copyWith(status: SettlementStatus.failed, remark: reason);
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
