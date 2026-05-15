class UserRegistration {
  final String id;
  final String phone;
  final String? email;
  final String passwordHash;
  final IdentityType identityType;
  final String realName;
  final String? idCardNumber;
  final String? cryptoWallet;
  final String? cryptoNetwork;
  final DateTime registeredAt;
  final bool isVerified;
  final DateTime? verifiedAt;

  UserRegistration({
    required this.id,
    required this.phone,
    this.email,
    required this.passwordHash,
    required this.identityType,
    required this.realName,
    this.idCardNumber,
    this.cryptoWallet,
    this.cryptoNetwork,
    required this.registeredAt,
    this.isVerified = false,
    this.verifiedAt,
  });

  bool get isDomestic => identityType == IdentityType.domestic;
  bool get hasCryptoPayment => cryptoWallet != null && cryptoWallet!.isNotEmpty;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'email': email,
      'password_hash': passwordHash,
      'identity_type': identityType.name,
      'real_name': realName,
      'id_card_number': idCardNumber,
      'crypto_wallet': cryptoWallet,
      'crypto_network': cryptoNetwork,
      'registered_at': registeredAt.toIso8601String(),
      'is_verified': isVerified ? 1 : 0,
      'verified_at': verifiedAt?.toIso8601String(),
    };
  }

  factory UserRegistration.fromMap(Map<String, dynamic> map) {
    return UserRegistration(
      id: map['id'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'],
      passwordHash: map['password_hash'] ?? '',
      identityType: IdentityType.values.firstWhere(
        (e) => e.name == map['identity_type'],
        orElse: () => IdentityType.domestic,
      ),
      realName: map['real_name'] ?? '',
      idCardNumber: map['id_card_number'],
      cryptoWallet: map['crypto_wallet'],
      cryptoNetwork: map['crypto_network'],
      registeredAt: DateTime.parse(map['registered_at'] ?? DateTime.now().toIso8601String()),
      isVerified: map['is_verified'] == 1,
      verifiedAt: map['verified_at'] != null ? DateTime.parse(map['verified_at']) : null,
    );
  }
}

enum IdentityType {
  domestic,
  overseas,
}

extension IdentityTypeExtension on IdentityType {
  String get displayName {
    switch (this) {
      case IdentityType.domestic:
        return '境内用户';
      case IdentityType.overseas:
        return '境外用户';
    }
  }

  String get description {
    switch (this) {
      case IdentityType.domestic:
        return '使用微信、支付宝支付';
      case IdentityType.overseas:
        return '支持加密货币支付';
    }
  }
}

class PaymentMethod {
  final String id;
  final String userId;
  final PaymentType type;
  final String account;
  final String? qrCodeUrl;
  final String? bankName;
  final String? branchName;
  final bool isDefault;
  final DateTime createdAt;

  PaymentMethod({
    required this.id,
    required this.userId,
    required this.type,
    required this.account,
    this.qrCodeUrl,
    this.bankName,
    this.branchName,
    this.isDefault = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.name,
      'account': account,
      'qr_code_url': qrCodeUrl,
      'bank_name': bankName,
      'branch_name': branchName,
      'is_default': isDefault ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      type: PaymentType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => PaymentType.wechat,
      ),
      account: map['account'] ?? '',
      qrCodeUrl: map['qr_code_url'],
      bankName: map['bank_name'],
      branchName: map['branch_name'],
      isDefault: map['is_default'] == 1,
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

enum PaymentType {
  wechat,
  alipay,
  bankCard,
  crypto,
}

extension PaymentTypeExtension on PaymentType {
  String get displayName {
    switch (this) {
      case PaymentType.wechat:
        return '微信支付';
      case PaymentType.alipay:
        return '支付宝';
      case PaymentType.bankCard:
        return '银行卡';
      case PaymentType.crypto:
        return '加密货币';
    }
  }

  String get icon {
    switch (this) {
      case PaymentType.wechat:
        return '💚';
      case PaymentType.alipay:
        return '🔵';
      case PaymentType.bankCard:
        return '💳';
      case PaymentType.crypto:
        return '₿';
    }
  }

  static PaymentType? fromString(String value) {
    switch (value.toLowerCase()) {
      case 'wechat':
      case '微信':
        return PaymentType.wechat;
      case 'alipay':
      case '支付宝':
        return PaymentType.alipay;
      case 'bankcard':
      case '银行卡':
        return PaymentType.bankCard;
      case 'crypto':
      case '加密货币':
      case 'usdt':
      case 'trc20':
        return PaymentType.crypto;
      default:
        return null;
    }
  }
}

class OTCC2COrder {
  final String id;
  final String sellerId;
  final String sellerName;
  final String buyerId;
  final String buyerName;
  final int amount;
  final int pricePerUnit;
  final int totalPrice;
  final PaymentType paymentType;
  final OrderStatus status;
  final String? escrowProof;
  final String? paymentProof;
  final DateTime createdAt;
  final DateTime? paidAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancelReason;

  OTCC2COrder({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.buyerId,
    required this.buyerName,
    required this.amount,
    required this.pricePerUnit,
    required this.totalPrice,
    required this.paymentType,
    this.status = OrderStatus.pending,
    this.escrowProof,
    this.paymentProof,
    required this.createdAt,
    this.paidAt,
    this.completedAt,
    this.cancelledAt,
    this.cancelReason,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'seller_id': sellerId,
      'seller_name': sellerName,
      'buyer_id': buyerId,
      'buyer_name': buyerName,
      'amount': amount,
      'price_per_unit': pricePerUnit,
      'total_price': totalPrice,
      'payment_type': paymentType.name,
      'status': status.name,
      'escrow_proof': escrowProof,
      'payment_proof': paymentProof,
      'created_at': createdAt.toIso8601String(),
      'paid_at': paidAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
      'cancel_reason': cancelReason,
    };
  }

  factory OTCC2COrder.fromMap(Map<String, dynamic> map) {
    return OTCC2COrder(
      id: map['id'] ?? '',
      sellerId: map['seller_id'] ?? '',
      sellerName: map['seller_name'] ?? '',
      buyerId: map['buyer_id'] ?? '',
      buyerName: map['buyer_name'] ?? '',
      amount: map['amount'] ?? 0,
      pricePerUnit: map['price_per_unit'] ?? 0,
      totalPrice: map['total_price'] ?? 0,
      paymentType: PaymentType.values.firstWhere(
        (e) => e.name == map['payment_type'],
        orElse: () => PaymentType.wechat,
      ),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      escrowProof: map['escrow_proof'],
      paymentProof: map['payment_proof'],
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      paidAt: map['paid_at'] != null ? DateTime.parse(map['paid_at']) : null,
      completedAt: map['completed_at'] != null ? DateTime.parse(map['completed_at']) : null,
      cancelledAt: map['cancelled_at'] != null ? DateTime.parse(map['cancelled_at']) : null,
      cancelReason: map['cancel_reason'],
    );
  }
}

enum OrderStatus {
  pending,
  escrowHeld,
  paid,
  completed,
  cancelled,
  disputed,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return '待托管';
      case OrderStatus.escrowHeld:
        return '已托管';
      case OrderStatus.paid:
        return '已付款';
      case OrderStatus.completed:
        return '已完成';
      case OrderStatus.cancelled:
        return '已取消';
      case OrderStatus.disputed:
        return '争议中';
    }
  }

  String get description {
    switch (this) {
      case OrderStatus.pending:
        return '等待卖家托管灵积';
      case OrderStatus.escrowHeld:
        return '灵积已托管，等待买家付款';
      case OrderStatus.paid:
        return '买家已付款，等待卖家确认';
      case OrderStatus.completed:
        return '交易完成';
      case OrderStatus.cancelled:
        return '交易取消';
      case OrderStatus.disputed:
        return '有争议，等待处理';
    }
  }
}
