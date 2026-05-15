import 'dart:async';

enum PaymentMethod {
  wechatPay,
  alipay,
  creditCard,
  bankTransfer,
  usdt,
  usdc,
  btc,
  eth,
}

enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  refunded,
}

enum PaymentType {
  fiat,
  crypto,
}

class CryptoCurrency {
  final String symbol;
  final String name;
  final String nameCn;
  final String icon;
  final double usdRate;

  const CryptoCurrency({
    required this.symbol,
    required this.name,
    required this.nameCn,
    required this.icon,
    required this.usdRate,
  });

  static const usdt = CryptoCurrency(
    symbol: 'USDT',
    name: 'Tether',
    nameCn: '泰达币',
    icon: '₮',
    usdRate: 1.0,
  );

  static const usdc = CryptoCurrency(
    symbol: 'USDC',
    name: 'USD Coin',
    nameCn: '美元币',
    icon: '💵',
    usdRate: 1.0,
  );

  static const btc = CryptoCurrency(
    symbol: 'BTC',
    name: 'Bitcoin',
    nameCn: '比特币',
    icon: '₿',
    usdRate: 60000.0,
  );

  static const eth = CryptoCurrency(
    symbol: 'ETH',
    name: 'Ethereum',
    nameCn: '以太坊',
    icon: 'Ξ',
    usdRate: 3000.0,
  );

  static List<CryptoCurrency> get supportedCurrencies => [usdt, usdc, btc, eth];

  static CryptoCurrency? fromSymbol(String symbol) {
    switch (symbol.toUpperCase()) {
      case 'USDT':
        return usdt;
      case 'USDC':
        return usdc;
      case 'BTC':
        return btc;
      case 'ETH':
        return eth;
      default:
        return null;
    }
  }
}

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  static const String merchantId = 'HK_ENTERPRISE_MERCHANT';
  static const String currency = 'HKD';
  static const String region = '香港';

  static const Map<PaymentMethod, String> paymentMethodNames = {
    PaymentMethod.wechatPay: '微信支付',
    PaymentMethod.alipay: '支付寶',
    PaymentMethod.creditCard: '信用卡',
    PaymentMethod.bankTransfer: '銀行轉帳',
    PaymentMethod.usdt: 'USDT',
    PaymentMethod.usdc: 'USDC',
    PaymentMethod.btc: 'BTC',
    PaymentMethod.eth: 'ETH',
  };

  static const Map<PaymentMethod, String> paymentMethodIcons = {
    PaymentMethod.wechatPay: 'wechat',
    PaymentMethod.alipay: 'alipay',
    PaymentMethod.creditCard: 'credit_card',
    PaymentMethod.bankTransfer: 'account_balance',
    PaymentMethod.usdt: '₮',
    PaymentMethod.usdc: '💵',
    PaymentMethod.btc: '₿',
    PaymentMethod.eth: 'Ξ',
  };

  static const double platformFeeRate = 0.10;
  static const double affiliateMaxRate = 0.20;

  bool _fiatPaymentEnabled = true;
  bool _cryptoPaymentEnabled = true;
  Set<PaymentMethod> _enabledFiatMethods = {PaymentMethod.wechatPay, PaymentMethod.alipay};
  Set<PaymentMethod> _enabledCryptoMethods = {PaymentMethod.usdt};
  Set<int> _cryptoMemberLevels = {};

  bool get fiatPaymentEnabled => _fiatPaymentEnabled;
  bool get cryptoPaymentEnabled => _cryptoPaymentEnabled;
  Set<PaymentMethod> get enabledFiatMethods => _enabledFiatMethods;
  Set<PaymentMethod> get enabledCryptoMethods => _enabledCryptoMethods;

  void setFiatPaymentEnabled(bool enabled) {
    _fiatPaymentEnabled = enabled;
  }

  void setCryptoPaymentEnabled(bool enabled) {
    _cryptoPaymentEnabled = enabled;
  }

  void setEnabledFiatMethods(Set<PaymentMethod> methods) {
    _enabledFiatMethods = methods;
  }

  void setEnabledCryptoMethods(Set<PaymentMethod> methods) {
    _enabledCryptoMethods = methods;
  }

  void setCryptoMemberLevels(Set<int> levels) {
    _cryptoMemberLevels = levels;
  }

  bool isCryptoEnabledForMember(int memberLevel) {
    if (_cryptoMemberLevels.isEmpty) return _cryptoPaymentEnabled;
    return _cryptoMemberLevels.contains(memberLevel);
  }

  List<PaymentMethod> getAvailableMethods({int memberLevel = 0}) {
    final methods = <PaymentMethod>[];

    if (_fiatPaymentEnabled) {
      methods.addAll(_enabledFiatMethods);
    }

    if (_cryptoPaymentEnabled && isCryptoEnabledForMember(memberLevel)) {
      methods.addAll(_enabledCryptoMethods);
    }

    return methods;
  }

  PaymentType getPaymentType(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.wechatPay:
      case PaymentMethod.alipay:
      case PaymentMethod.creditCard:
      case PaymentMethod.bankTransfer:
        return PaymentType.fiat;
      case PaymentMethod.usdt:
      case PaymentMethod.usdc:
      case PaymentMethod.btc:
      case PaymentMethod.eth:
        return PaymentType.crypto;
    }
  }

  Future<PaymentResult> createPayment({
    required String orderId,
    required double amount,
    required PaymentMethod method,
    required String description,
    String? userId,
    String? talentId,
    int memberLevel = 0,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final paymentType = getPaymentType(method);

    if (paymentType == PaymentType.fiat && !_fiatPaymentEnabled) {
      return PaymentResult(
        success: false,
        message: '法幣支付已關閉',
      );
    }

    if (paymentType == PaymentType.crypto && !isCryptoEnabledForMember(memberLevel)) {
      return PaymentResult(
        success: false,
        message: '加密貨幣支付未對此會員級別開放',
      );
    }

    final platformFee = amount * platformFeeRate;
    final actualAmount = amount - platformFee;

    final payment = PaymentRecord(
      id: 'PAY_${DateTime.now().millisecondsSinceEpoch}',
      orderId: orderId,
      amount: amount,
      actualAmount: actualAmount,
      platformFee: platformFee,
      currency: paymentType == PaymentType.crypto ? 'USDT' : currency,
      method: method,
      status: PaymentStatus.completed,
      description: description,
      userId: userId,
      talentId: talentId,
      createdAt: DateTime.now(),
      completedAt: DateTime.now(),
      merchantId: merchantId,
      settlementRegion: region,
      paymentType: paymentType,
    );

    return PaymentResult(
      success: true,
      message: '支付成功',
      paymentId: payment.id,
      paymentRecord: payment,
    );
  }

  double convertToCrypto(double amount, PaymentMethod cryptoMethod) {
    final crypto = CryptoCurrency.fromSymbol(cryptoMethod.name.toUpperCase());
    if (crypto == null) return 0;
    return amount / crypto.usdRate;
  }

  Future<PaymentResult> processRefund({
    required String paymentId,
    required double amount,
    String? reason,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return PaymentResult(
      success: true,
      message: '退款成功',
      paymentId: paymentId,
    );
  }

  Future<SettlementRecord> createSettlement({
    required String userId,
    required double amount,
    required String settlementType,
    String? orderId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return SettlementRecord(
      id: 'STL_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      amount: amount,
      type: settlementType,
      orderId: orderId,
      status: 'completed',
      createdAt: DateTime.now(),
      completedAt: DateTime.now(),
      settlementRegion: region,
      notes: '資金結算留存香港賬戶',
    );
  }

  Map<String, dynamic> getPaymentConfig() {
    return {
      'merchant_id': merchantId,
      'currency': currency,
      'region': region,
      'platform_fee_rate': platformFeeRate,
      'affiliate_max_rate': affiliateMaxRate,
      'fiat_payment_enabled': _fiatPaymentEnabled,
      'crypto_payment_enabled': _cryptoPaymentEnabled,
      'enabled_fiat_methods': _enabledFiatMethods.map((m) => m.name).toList(),
      'enabled_crypto_methods': _enabledCryptoMethods.map((m) => m.name).toList(),
      'supported_cryptos': CryptoCurrency.supportedCurrencies.map((c) => {
        'symbol': c.symbol,
        'name': c.name,
        'name_cn': c.nameCn,
        'usd_rate': c.usdRate,
      }).toList(),
      'settlement_info': '資金結算留存香港賬戶，不回流內地個人賬戶',
      'crypto_settlement_info': '加密貨幣走香港合規跨境通道結算，獨立記賬、訂單留痕',
      'payment_notice': '支持微信支付、支付寶、USDT、USDC、BTC、ETH',
    };
  }
}

class PaymentRecord {
  final String id;
  final String orderId;
  final double amount;
  final double actualAmount;
  final double platformFee;
  final String currency;
  final PaymentMethod method;
  final PaymentStatus status;
  final String description;
  final String? userId;
  final String? talentId;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String merchantId;
  final String settlementRegion;
  final PaymentType? paymentType;

  PaymentRecord({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.actualAmount,
    required this.platformFee,
    required this.currency,
    required this.method,
    required this.status,
    required this.description,
    this.userId,
    this.talentId,
    required this.createdAt,
    this.completedAt,
    required this.merchantId,
    required this.settlementRegion,
    this.paymentType,
  });
}

class SettlementRecord {
  final String id;
  final String userId;
  final double amount;
  final String type;
  final String? orderId;
  final String status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String settlementRegion;
  final String? notes;

  SettlementRecord({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    this.orderId,
    required this.status,
    required this.createdAt,
    this.completedAt,
    required this.settlementRegion,
    this.notes,
  });
}

class PaymentResult {
  final bool success;
  final String message;
  final String? paymentId;
  final PaymentRecord? paymentRecord;

  PaymentResult({
    required this.success,
    required this.message,
    this.paymentId,
    this.paymentRecord,
  });
}

class HKPaymentConfig {
  static const bool isHKMerchant = true;
  static const String merchantRegion = '香港';
  static const String settlementRegion = '香港';

  static const String paymentInfo = '''
  【海外商戶支付說明】
  • 本平台通過香港正規企業資質申請海外商戶通道
  • 支持微信支付、支付寶、USDT、USDC、BTC、ETH
  • 法幣資金結算留存香港賬戶
  • 加密貨幣走香港合規跨境通道結算
  ''';

  static const String settlementInfo = '''
  【資金結算說明】
  • 法幣交易：結算至香港企業賬戶
  • 加密貨幣：獨立記賬、訂單留痕，與法幣收支體系隔離分開統計
  • 平台按固定比例收取服務費
  • 達人收益即時結算
  ''';

  static const String cryptoDisclaimer = '''
  【加密貨幣支付說明】
  • 支持USDT、USDC、BTC、ETH等主流加密貨幣
  • 走香港合規跨境通道結算
  • 獨立記賬、訂單留痕
  • 與法幣收支體系隔離分開統計
  • 後台可開關加密支付入口
  • 可單獨設置是否對某類會員開放使用
  ''';
}
