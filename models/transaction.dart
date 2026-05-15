class LingjiTransaction {
  final String id;
  final String sellerId;
  final String? buyerId;
  final int amount;
  final double price;
  final double totalAmount;
  final String? paymentScreenshot;
  final String status;
  final DateTime createdAt;
  final DateTime? completedAt;

  LingjiTransaction({
    required this.id,
    required this.sellerId,
    this.buyerId,
    required this.amount,
    required this.price,
    required this.totalAmount,
    this.paymentScreenshot,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'seller_id': sellerId,
      'buyer_id': buyerId,
      'amount': amount,
      'price': price,
      'total_amount': totalAmount,
      'payment_screenshot': paymentScreenshot,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  factory LingjiTransaction.fromMap(Map<String, dynamic> map) {
    return LingjiTransaction(
      id: map['id'] ?? '',
      sellerId: map['seller_id'] ?? '',
      buyerId: map['buyer_id'],
      amount: map['amount'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
      totalAmount: (map['total_amount'] ?? 0).toDouble(),
      paymentScreenshot: map['payment_screenshot'],
      status: map['status'] ?? 'pending',
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      completedAt: map['completed_at'] != null ? DateTime.parse(map['completed_at']) : null,
    );
  }

  LingjiTransaction copyWith({
    String? id,
    String? sellerId,
    String? buyerId,
    int? amount,
    double? price,
    double? totalAmount,
    String? paymentScreenshot,
    String? status,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return LingjiTransaction(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      buyerId: buyerId ?? this.buyerId,
      amount: amount ?? this.amount,
      price: price ?? this.price,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentScreenshot: paymentScreenshot ?? this.paymentScreenshot,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class PaymentMethod {
  final String type;
  final String qrCode;
  final String? accountName;

  PaymentMethod({
    required this.type,
    required this.qrCode,
    this.accountName,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'qr_code': qrCode,
      'account_name': accountName,
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      type: map['type'] ?? '',
      qrCode: map['qr_code'] ?? '',
      accountName: map['account_name'],
    );
  }
}
