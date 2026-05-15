import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReferralConfig {
  final String userId;
  final String referralCode;
  final String? customQrData;
  final double qrCodeSize;
  final Color qrCodeColor;
  final Color backgroundColor;
  final bool showDownloadHint;
  final String downloadHint;

  const ReferralConfig({
    required this.userId,
    required this.referralCode,
    this.customQrData,
    this.qrCodeSize = 120,
    this.qrCodeColor = const Color(0xFF8B4513),
    this.backgroundColor = Colors.white,
    this.showDownloadHint = true,
    this.downloadHint = '扫码下载中医易学学习助手',
  });

  String get qrData => customQrData ?? 'lingji://referral/$referralCode';

  String get shareText => '我在使用「中医易学学习助手」学习中医传统文化，扫码一起学习：$qrData';
}

class ReferralService {
  static final ReferralService _instance = ReferralService._internal();
  factory ReferralService() => _instance;
  ReferralService._internal();

  bool _showQRCode = true;
  ReferralConfig? _currentConfig;

  bool get showQRCode => _showQRCode;
  ReferralConfig? get currentConfig => _currentConfig;

  void toggleShowQRCode(bool show) {
    _showQRCode = show;
  }

  void setReferralConfig(ReferralConfig config) {
    _currentConfig = config;
  }

  void generateReferralCode(String userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final code = base64Encode('$userId$timestamp'.codeUnits);
    final referralCode = code.substring(0, 8).toUpperCase();

    _currentConfig = ReferralConfig(
      userId: userId,
      referralCode: referralCode,
    );
  }

  String getReferralUrl() {
    if (_currentConfig == null) return '';
    return 'https://lingji.app/download?ref=${_currentConfig!.referralCode}';
  }

  Widget buildReferralQRWidget({
    double size = 100,
    bool showHint = true,
    bool showBorder = true,
  }) {
    if (_currentConfig == null) {
      return Container(
        width: size,
        height: size,
        color: Colors.grey.shade200,
        child: const Icon(Icons.qr_code, color: Colors.grey),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: showBorder
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                ),
              ],
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QrImageView(
            data: _currentConfig!.qrData,
            version: QrVersions.auto,
            size: size,
            backgroundColor: Colors.white,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Color(0xFF8B4513),
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Color(0xFF8B4513),
            ),
          ),
          if (showHint) ...[
            const SizedBox(height: 8),
            Text(
              _currentConfig!.downloadHint,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget buildCompactQRWidget({
    double size = 60,
    Alignment position = Alignment.bottomRight,
  }) {
    if (!_showQRCode || _currentConfig == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      right: 8,
      bottom: 8,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: QrImageView(
          data: _currentConfig!.qrData,
          version: QrVersions.auto,
          size: size,
          backgroundColor: Colors.white,
          eyeStyle: const QrEyeStyle(
            eyeShape: QrEyeShape.square,
            color: Color(0xFF8B4513),
          ),
          dataModuleStyle: const QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.square,
            color: Color(0xFF8B4513),
          ),
        ),
      ),
    );
  }

  Widget buildShareableCard({
    required String title,
    String? subtitle,
    String? content,
    double width = 300,
    double height = 400,
  }) {
    if (_currentConfig == null) {
      return SizedBox(width: width, height: height);
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF8F0), Colors.white],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B4513).withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF8B4513),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.auto_stories,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '中医易学学习助手',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '传统中医 · 针灸经络 · 易学文化',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D4037),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 16),
                if (content != null)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        content,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 8,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                QrImageView(
                  data: _currentConfig!.qrData,
                  version: QrVersions.auto,
                  size: 80,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Color(0xFF8B4513),
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Color(0xFF8B4513),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '扫码下载APP',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8B4513),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '邀请码：${_currentConfig!.referralCode}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '一起学习传统文化',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 14,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '本内容仅供传统文化学习参考',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void applyReferralCode(String code) {
    debugPrint('Applying referral code: $code');
  }

  bool validateReferralCode(String code) {
    if (code.length < 6 || code.length > 12) return false;
    return RegExp(r'^[A-Z0-9]+$').hasMatch(code);
  }

  String getReferralStats() {
    return '''
邀请人数：0
绑定成功：0
累计奖励：0 学分
''';
  }
}

class ReferralSettingsScreen extends StatefulWidget {
  const ReferralSettingsScreen({super.key});

  @override
  State<ReferralSettingsScreen> createState() => _ReferralSettingsScreenState();
}

class _ReferralSettingsScreenState extends State<ReferralSettingsScreen> {
  final ReferralService _referralService = ReferralService();
  bool _showQRCode = true;

  @override
  void initState() {
    super.initState();
    _referralService.generateReferralCode('user_${DateTime.now().millisecondsSinceEpoch}');
    _showQRCode = _referralService.showQRCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('推广设置'),
        backgroundColor: const Color(0xFF8B4513),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingCard(
            title: '分享二维码',
            subtitle: '在其他页面显示您的推广二维码',
            trailing: Switch(
              value: _showQRCode,
              activeColor: const Color(0xFF8B4513),
              onChanged: (value) {
                setState(() => _showQRCode = value);
                _referralService.toggleShowQRCode(value);
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingCard(
            title: '我的邀请码',
            subtitle: _referralService.currentConfig?.referralCode ?? '暂无',
            trailing: IconButton(
              icon: const Icon(Icons.copy, color: Color(0xFF8B4513)),
              onPressed: () {
                if (_referralService.currentConfig != null) {
                  _copyToClipboard(_referralService.currentConfig!.referralCode);
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildQrCodePreview(),
          const SizedBox(height: 16),
          _buildShareButton(),
          const SizedBox(height: 24),
          _buildDisclaimer(),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5D4037),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildQrCodePreview() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '二维码预览',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 16),
          _referralService.buildReferralQRWidget(
            size: 150,
            showHint: true,
          ),
          const SizedBox(height: 12),
          Text(
            '扫描二维码下载APP',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton() {
    return ElevatedButton.icon(
      onPressed: () {
        _shareReferralLink();
      },
      icon: const Icon(Icons.share),
      label: const Text('分享推广链接'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8B4513),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                '推广说明',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• 分享您的邀请码或二维码给好友\n'
            '• 好友扫码下载注册后自动绑定\n'
            '• 好友完成学习任务您可获得学分奖励\n'
            '• 具体奖励规则请查看平台公告',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    // In production, use Clipboard.setData
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已复制: $text')),
    );
  }

  void _shareReferralLink() {
    if (_referralService.currentConfig == null) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_referralService.currentConfig!.shareText),
        action: SnackBarAction(
          label: '复制',
          onPressed: () => _copyToClipboard(_referralService.currentConfig!.shareText),
        ),
      ),
    );
  }
}

String base64Encode(List<int> bytes) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  String result = '';
  int i = 0;
  while (i < bytes.length) {
    int a = bytes[i++];
    int b = i < bytes.length ? bytes[i++] : 0;
    int c = i < bytes.length ? bytes[i++] : 0;
    result += chars[(a >> 2) & 0x3F];
    result += chars[((a << 4) | (b >> 4)) & 0x3F];
    result += i > bytes.length + 1 ? '=' : chars[((b << 2) | (c >> 6)) & 0x3F];
    result += i > bytes.length ? '=' : chars[c & 0x3F];
  }
  return result;
}
