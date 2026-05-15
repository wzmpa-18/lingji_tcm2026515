import 'package:flutter/material.dart';

class AdminConfigService with ChangeNotifier {
  static final AdminConfigService _instance = AdminConfigService._internal();
  factory AdminConfigService() => _instance;
  AdminConfigService._internal();

  PlatformConfig _platformConfig = PlatformConfig.defaultConfig();
  AffiliateConfig _affiliateConfig = AffiliateConfig.defaultConfig();
  PaymentConfig _paymentConfig = PaymentConfig.defaultConfig();
  TalentConfig _talentConfig = TalentConfig.defaultConfig();

  PlatformConfig get platformConfig => _platformConfig;
  AffiliateConfig get affiliateConfig => _affiliateConfig;
  PaymentConfig get paymentConfig => _paymentConfig;
  TalentConfig get talentConfig => _talentConfig;

  void updateAffiliateConfig(AffiliateConfig config) {
    _affiliateConfig = config;
    notifyListeners();
  }

  void updatePaymentConfig(PaymentConfig config) {
    _paymentConfig = config;
    notifyListeners();
  }

  void updateTalentConfig(TalentConfig config) {
    _talentConfig = config;
    notifyListeners();
  }

  Map<String, dynamic> exportAllConfig() {
    return {
      'platform': _platformConfig.toMap(),
      'affiliate': _affiliateConfig.toMap(),
      'payment': _paymentConfig.toMap(),
      'talent': _talentConfig.toMap(),
      'exported_at': DateTime.now().toIso8601String(),
    };
  }
}

class PlatformConfig {
  final String entityName;
  final String region;
  final String serverRegion;
  final String dataStorage;
  final String backendRegion;
  final bool脱离内地监管;

  PlatformConfig({
    required this.entityName,
    required this.region,
    required this.serverRegion,
    required this.dataStorage,
    required this.backendRegion,
    required this.脱离内地监管,
  });

  static PlatformConfig defaultConfig() {
    return PlatformConfig(
      entityName: '靈積國際文化有限公司',
      region: '香港',
      serverRegion: '香港',
      dataStorage: '香港雲端伺服器',
      backendRegion: '香港',
      脱离内地监管: true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'entity_name': entityName,
      'region': region,
      'server_region': serverRegion,
      'data_storage': dataStorage,
      'backend_region': backendRegion,
      '脱离内地监管': 脱离内地监管,
    };
  }
}

class AffiliateConfig {
  final double level1Rate;
  final double level2Rate;
  final int maxLevels;
  final bool requirePurchaseToPromote;
  final bool requireFeeToPromote;
  final double maxCommissionRate;
  final bool enableAffiliate;
  final String legalDisclaimer;

  AffiliateConfig({
    required this.level1Rate,
    required this.level2Rate,
    required this.maxLevels,
    required this.requirePurchaseToPromote,
    required this.requireFeeToPromote,
    required this.maxCommissionRate,
    required this.enableAffiliate,
    required this.legalDisclaimer,
  });

  static AffiliateConfig defaultConfig() {
    return AffiliateConfig(
      level1Rate: 0.15,
      level2Rate: 0.05,
      maxLevels: 2,
      requirePurchaseToPromote: false,
      requireFeeToPromote: false,
      maxCommissionRate: 0.20,
      enableAffiliate: true,
      legalDisclaimer: '本推廣體系嚴格遵循香港法例，採用合規二級分銷模式，無層壓式營銷',
    );
  }

  double get totalCommissionRate => level1Rate + level2Rate;

  Map<String, dynamic> toMap() {
    return {
      'level1_rate': level1Rate,
      'level1_rate_percent': '${(level1Rate * 100).toInt()}%',
      'level2_rate': level2Rate,
      'level2_rate_percent': '${(level2Rate * 100).toInt()}%',
      'max_levels': maxLevels,
      'require_purchase_to_promote': requirePurchaseToPromote,
      'require_fee_to_promote': requireFeeToPromote,
      'max_commission_rate': maxCommissionRate,
      'enable_affiliate': enableAffiliate,
      'legal_disclaimer': legalDisclaimer,
      'total_commission_rate': totalCommissionRate,
      'total_commission_percent': '${(totalCommissionRate * 100).toInt()}%',
    };
  }
}

class PaymentConfig {
  final double platformFeeRate;
  final bool enableWechatPay;
  final bool enableAlipay;
  final bool enableCreditCard;
  final bool enableBankTransfer;
  final bool enableCryptoPayment;
  final bool enableUSDT;
  final bool enableUSDC;
  final bool enableBTC;
  final bool enableETH;
  final Set<int> cryptoMemberLevels;
  final String currency;
  final String merchantRegion;
  final String settlementRegion;
  final bool fundRetentionInHK;
  final bool cryptoSeparateSettlement;

  PaymentConfig({
    required this.platformFeeRate,
    required this.enableWechatPay,
    required this.enableAlipay,
    required this.enableCreditCard,
    required this.enableBankTransfer,
    required this.enableCryptoPayment,
    required this.enableUSDT,
    required this.enableUSDC,
    required this.enableBTC,
    required this.enableETH,
    required this.cryptoMemberLevels,
    required this.currency,
    required this.merchantRegion,
    required this.settlementRegion,
    required this.fundRetentionInHK,
    required this.cryptoSeparateSettlement,
  });

  static PaymentConfig defaultConfig() {
    return PaymentConfig(
      platformFeeRate: 0.10,
      enableWechatPay: true,
      enableAlipay: true,
      enableCreditCard: false,
      enableBankTransfer: true,
      enableCryptoPayment: true,
      enableUSDT: true,
      enableUSDC: true,
      enableBTC: true,
      enableETH: true,
      cryptoMemberLevels: {},
      currency: 'HKD',
      merchantRegion: '香港',
      settlementRegion: '香港',
      fundRetentionInHK: true,
      cryptoSeparateSettlement: true,
    );
  }

  List<String> get enabledPaymentMethods {
    final methods = <String>[];
    if (enableWechatPay) methods.add('微信支付');
    if (enableAlipay) methods.add('支付寶');
    if (enableCreditCard) methods.add('信用卡');
    if (enableBankTransfer) methods.add('銀行轉帳');
    if (enableCryptoPayment) {
      if (enableUSDT) methods.add('USDT');
      if (enableUSDC) methods.add('USDC');
      if (enableBTC) methods.add('BTC');
      if (enableETH) methods.add('ETH');
    }
    return methods;
  }

  List<String> get enabledCryptoMethods {
    final methods = <String>[];
    if (enableUSDT) methods.add('USDT');
    if (enableUSDC) methods.add('USDC');
    if (enableBTC) methods.add('BTC');
    if (enableETH) methods.add('ETH');
    return methods;
  }

  Map<String, dynamic> toMap() {
    return {
      'platform_fee_rate': platformFeeRate,
      'platform_fee_percent': '${(platformFeeRate * 100).toInt()}%',
      'enabled_payment_methods': enabledPaymentMethods,
      'fiat_methods': {
        'wechat_pay': enableWechatPay,
        'alipay': enableAlipay,
        'credit_card': enableCreditCard,
        'bank_transfer': enableBankTransfer,
      },
      'crypto_methods': {
        'enabled': enableCryptoPayment,
        'usdt': enableUSDT,
        'usdc': enableUSDC,
        'btc': enableBTC,
        'eth': enableETH,
        'member_levels': cryptoMemberLevels.toList(),
      },
      'currency': currency,
      'merchant_region': merchantRegion,
      'settlement_region': settlementRegion,
      'fund_retention_in_hk': fundRetentionInHK,
      'crypto_separate_settlement': cryptoSeparateSettlement,
    };
  }
}

class TalentConfig {
  final double platformFeeRate;
  final bool allowCustomPricing;
  final bool requireVerification;
  final int minStarLevel;
  final bool enableShowcase;
  final bool enablePromotion;

  TalentConfig({
    required this.platformFeeRate,
    required this.allowCustomPricing,
    required this.requireVerification,
    required this.minStarLevel,
    required this.enableShowcase,
    required this.enablePromotion,
  });

  static TalentConfig defaultConfig() {
    return TalentConfig(
      platformFeeRate: 0.10,
      allowCustomPricing: true,
      requireVerification: true,
      minStarLevel: 1,
      enableShowcase: true,
      enablePromotion: true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'platform_fee_rate': platformFeeRate,
      'platform_fee_percent': '${(platformFeeRate * 100).toInt()}%',
      'allow_custom_pricing': allowCustomPricing,
      'require_verification': requireVerification,
      'min_star_level': minStarLevel,
      'enable_showcase': enableShowcase,
      'enable_promotion': enablePromotion,
    };
  }
}

class AdminConfigScreen extends StatefulWidget {
  const AdminConfigScreen({super.key});

  @override
  State<AdminConfigScreen> createState() => _AdminConfigScreenState();
}

class _AdminConfigScreenState extends State<AdminConfigScreen> {
  final AdminConfigService _configService = AdminConfigService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('後台配置'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            '平台配置',
            Icons.business,
            Colors.blue,
            _buildPlatformConfig(),
          ),
          const SizedBox(height: 16),
          _buildSection(
            '推廣分佣配置',
            Icons.campaign,
            Colors.orange,
            _buildAffiliateConfig(),
          ),
          const SizedBox(height: 16),
          _buildSection(
            '支付配置',
            Icons.payment,
            Colors.green,
            _buildPaymentConfig(),
          ),
          const SizedBox(height: 16),
          _buildSection(
            '達人配置',
            Icons.person,
            Colors.purple,
            _buildTalentConfig(),
          ),
          const SizedBox(height: 16),
          _buildExportButton(),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Color color, Widget content) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: content,
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformConfig() {
    final config = _configService.platformConfig;
    return Column(
      children: [
        _buildInfoRow('實體名稱', config.entityName),
        _buildInfoRow('運營地區', config.region),
        _buildInfoRow('伺服器', config.serverRegion),
        _buildInfoRow('數據存儲', config.dataStorage),
        _buildInfoRow('後台管理', config.backendRegion),
        _buildInfoRow('脫離內地監管', config.脫离内地监管 ? '是' : '否'),
      ],
    );
  }

  Widget _buildAffiliateConfig() {
    final config = _configService.affiliateConfig;
    return Column(
      children: [
        _buildConfigRow(
          '一級分佣比例',
          '${(config.level1Rate * 100).toInt()}%',
          Icons.person_add,
          Slider(
            value: config.level1Rate,
            min: 0.05,
            max: 0.25,
            divisions: 20,
            label: '${(config.level1Rate * 100).toInt()}%',
            onChanged: (value) {
              _configService.updateAffiliateConfig(
                AffiliateConfig(
                  level1Rate: value,
                  level2Rate: config.level2Rate,
                  maxLevels: config.maxLevels,
                  requirePurchaseToPromote: config.requirePurchaseToPromote,
                  requireFeeToPromote: config.requireFeeToPromote,
                  maxCommissionRate: config.maxCommissionRate,
                  enableAffiliate: config.enableAffiliate,
                  legalDisclaimer: config.legalDisclaimer,
                ),
              );
              setState(() {});
            },
          ),
        ),
        _buildConfigRow(
          '二級分佣比例',
          '${(config.level2Rate * 100).toInt()}%',
          Icons.people,
          Slider(
            value: config.level2Rate,
            min: 0.01,
            max: 0.10,
            divisions: 9,
            label: '${(config.level2Rate * 100).toInt()}%',
            onChanged: (value) {
              _configService.updateAffiliateConfig(
                AffiliateConfig(
                  level1Rate: config.level1Rate,
                  level2Rate: value,
                  maxLevels: config.maxLevels,
                  requirePurchaseToPromote: config.requirePurchaseToPromote,
                  requireFeeToPromote: config.requireFeeToPromote,
                  maxCommissionRate: config.maxCommissionRate,
                  enableAffiliate: config.enableAffiliate,
                  legalDisclaimer: config.legalDisclaimer,
                ),
              );
              setState(() {});
            },
          ),
        ),
        _buildInfoRow('最高分佣級別', '${config.maxLevels}級'),
        _buildInfoRow('總分佣比例', '${(config.totalCommissionRate * 100).toInt()}%'),
        _buildInfoRow('免費參與推廣', config.requireFeeToPromote ? '否' : '是'),
        _buildInfoRow('推廣開關', config.enableAffiliate ? '開啟' : '關閉'),
      ],
    );
  }

  Widget _buildPaymentConfig() {
    final config = _configService.paymentConfig;
    return Column(
      children: [
        _buildConfigRow(
          '平台服務費比例',
          '${(config.platformFeeRate * 100).toInt()}%',
          Icons.percent,
          Slider(
            value: config.platformFeeRate,
            min: 0.05,
            max: 0.20,
            divisions: 15,
            label: '${(config.platformFeeRate * 100).toInt()}%',
            onChanged: (value) {
              _configService.updatePaymentConfig(
                PaymentConfig(
                  platformFeeRate: value,
                  enableWechatPay: config.enableWechatPay,
                  enableAlipay: config.enableAlipay,
                  enableCreditCard: config.enableCreditCard,
                  enableBankTransfer: config.enableBankTransfer,
                  currency: config.currency,
                  merchantRegion: config.merchantRegion,
                  settlementRegion: config.settlementRegion,
                  fundRetentionInHK: config.fundRetentionInHK,
                ),
              );
              setState(() {});
            },
          ),
        ),
        _buildInfoRow('結算貨幣', config.currency),
        _buildInfoRow('商戶地區', config.merchantRegion),
        _buildInfoRow('結算地區', config.settlementRegion),
        _buildInfoRow('資金留存香港', config.fundRetentionInHK ? '是' : '否'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            if (config.enableWechatPay) _buildChip('微信支付', Colors.green),
            if (config.enableAlipay) _buildChip('支付寶', Colors.blue),
            if (config.enableCreditCard) _buildChip('信用卡', Colors.purple),
            if (config.enableBankTransfer) _buildChip('銀行轉帳', Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _buildTalentConfig() {
    final config = _configService.talentConfig;
    return Column(
      children: [
        _buildConfigRow(
          '達人服務費比例',
          '${(config.platformFeeRate * 100).toInt()}%',
          Icons.monetization_on,
          Slider(
            value: config.platformFeeRate,
            min: 0.05,
            max: 0.20,
            divisions: 15,
            label: '${(config.platformFeeRate * 100).toInt()}%',
            onChanged: (value) {
              _configService.updateTalentConfig(
                TalentConfig(
                  platformFeeRate: value,
                  allowCustomPricing: config.allowCustomPricing,
                  requireVerification: config.requireVerification,
                  minStarLevel: config.minStarLevel,
                  enableShowcase: config.enableShowcase,
                  enablePromotion: config.enablePromotion,
                ),
              );
              setState(() {});
            },
          ),
        ),
        _buildInfoRow('允許自定義定價', config.allowCustomPricing ? '是' : '否'),
        _buildInfoRow('需要驗證', config.requireVerification ? '是' : '否'),
        _buildInfoRow('最低星級', '${config.minStarLevel}星'),
        _buildInfoRow('開通櫥窗', config.enableShowcase ? '是' : '否'),
        _buildInfoRow('允許推廣', config.enablePromotion ? '是' : '否'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildConfigRow(String label, String value, IconData icon, Widget control) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: Colors.grey.shade600)),
            const Spacer(),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
        control,
      ],
    );
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color),
    );
  }

  Widget _buildExportButton() {
    return ElevatedButton.icon(
      onPressed: () {
        final config = _configService.exportAllConfig();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('配置已導出: ${config.keys.length}項'),
            action: SnackBarAction(
              label: '查看',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('導出配置'),
                    content: SingleChildScrollView(
                      child: Text(
                        config.toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('關閉'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
      icon: const Icon(Icons.save),
      label: const Text('導出當前配置'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
