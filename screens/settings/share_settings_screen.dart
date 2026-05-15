import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/watermark_service.dart';
import '../services/referral_service.dart';
import '../services/content_compliance.dart';

class ShareSettingsScreen extends StatefulWidget {
  const ShareSettingsScreen({super.key});

  @override
  State<ShareSettingsScreen> createState() => _ShareSettingsScreenState();
}

class _ShareSettingsScreenState extends State<ShareSettingsScreen> {
  final WatermarkService _watermarkService = WatermarkService();
  final ReferralService _referralService = ReferralService();
  
  bool _showQRCode = true;
  bool _showWatermark = true;
  bool _showDisclaimer = true;
  WatermarkPosition _watermarkPosition = WatermarkPosition.bottomCenter;

  @override
  void initState() {
    super.initState();
    _referralService.generateReferralCode('user_${DateTime.now().millisecondsSinceEpoch}');
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _showQRCode = _referralService.showQRCode;
      _showWatermark = _watermarkService.config.showOnShares;
      _showDisclaimer = _watermarkService.config.showOnShares;
      _watermarkPosition = _watermarkService.config.position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('分享设置'),
        backgroundColor: const Color(0xFF8B4513),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('水印设置'),
          const SizedBox(height: 12),
          _buildWatermarkSettings(),
          const SizedBox(height: 24),
          _buildSectionTitle('推广二维码'),
          const SizedBox(height: 12),
          _buildQRCodeSettings(),
          const SizedBox(height: 24),
          _buildSectionTitle('二维码预览'),
          const SizedBox(height: 12),
          _buildQRCodePreview(),
          const SizedBox(height: 24),
          _buildSectionTitle('免责声明'),
          const SizedBox(height: 12),
          _buildDisclaimerPreview(),
          const SizedBox(height: 32),
          _buildShareButton(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF5D4037),
      ),
    );
  }

  Widget _buildWatermarkSettings() {
    return Container(
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
          SwitchListTile(
            title: const Text('显示水印'),
            subtitle: const Text('截图和分享时显示APP名称水印'),
            value: _showWatermark,
            activeColor: const Color(0xFF8B4513),
            onChanged: (value) {
              setState(() => _showWatermark = value);
              _watermarkService.toggleShowOnShares(value);
            },
          ),
          if (_showWatermark) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '水印位置',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPositionSelector(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  const Text(
                    '透明度',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: _watermarkService.config.opacity,
                      min: 0.3,
                      max: 1.0,
                      divisions: 7,
                      activeColor: const Color(0xFF8B4513),
                      label: '${(_watermarkService.config.opacity * 100).round()}%',
                      onChanged: (value) {
                        setState(() {});
                        _watermarkService.updateOpacity(value);
                      },
                    ),
                  ),
                  Text(
                    '${(_watermarkService.config.opacity * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPositionSelector() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.5,
      children: WatermarkPosition.values.map((position) {
        final isSelected = _watermarkPosition == position;
        return GestureDetector(
          onTap: () {
            setState(() => _watermarkPosition = position);
            _watermarkService.updatePosition(position);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected 
                  ? const Color(0xFF8B4513).withValues(alpha: 0.1)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? const Color(0xFF8B4513) : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.crop_square,
                    size: 24,
                    color: isSelected ? const Color(0xFF8B4513) : Colors.grey,
                  ),
                ),
                Positioned(
                  left: 4,
                  top: 4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getPositionDotColor(position, true),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getPositionDotColor(position, false),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getPositionDotColor(WatermarkPosition pos, bool isTop) {
    switch (pos) {
      case WatermarkPosition.topLeft:
        return isTop ? Colors.red : Colors.transparent;
      case WatermarkPosition.topCenter:
        return isTop ? Colors.red : Colors.transparent;
      case WatermarkPosition.topRight:
        return isTop ? Colors.red : Colors.transparent;
      case WatermarkPosition.bottomLeft:
        return !isTop ? Colors.red : Colors.transparent;
      case WatermarkPosition.bottomCenter:
        return !isTop ? Colors.red : Colors.transparent;
      case WatermarkPosition.bottomRight:
        return !isTop ? Colors.red : Colors.transparent;
    }
  }

  Widget _buildQRCodeSettings() {
    return Container(
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
          SwitchListTile(
            title: const Text('显示推广二维码'),
            subtitle: const Text('在其他页面显示您的专属推广二维码'),
            value: _showQRCode,
            activeColor: const Color(0xFF8B4513),
            onChanged: (value) {
              setState(() => _showQRCode = value);
              _referralService.toggleShowQRCode(value);
            },
          ),
          if (_showQRCode) ...[
            const Divider(height: 1),
            ListTile(
              title: const Text('我的邀请码'),
              subtitle: Text(
                _referralService.currentConfig?.referralCode ?? '暂无',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B4513),
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.copy, color: Color(0xFF8B4513)),
                onPressed: () => _copyReferralCode(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '好友扫码下载注册后自动归属为您的推广用户',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQRCodePreview() {
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
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 16),
          _referralService.buildReferralQRWidget(size: 150),
          const SizedBox(height: 12),
          Text(
            '扫描二维码下载「中医易学学习助手」',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.grey.shade600, size: 18),
              const SizedBox(width: 8),
              const Text(
                '页面底部免责提示',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF5D4037),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            ContentCompliance.pageDisclaimer,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: _showDisclaimer,
                activeColor: const Color(0xFF8B4513),
                onChanged: (value) {
                  setState(() => _showDisclaimer = value ?? true);
                },
              ),
              const Expanded(
                child: Text(
                  '显示免责声明',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton() {
    return ElevatedButton.icon(
      onPressed: _shareContent,
      icon: const Icon(Icons.share),
      label: const Text('生成分享图片'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8B4513),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _copyReferralCode() {
    if (_referralService.currentConfig?.referralCode != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已复制: ${_referralService.currentConfig!.referralCode}'),
          action: SnackBarAction(
            label: '好的',
            onPressed: () {},
          ),
        ),
      );
    }
  }

  void _shareContent() {
    final card = _referralService.buildShareableCard(
      title: '中医易学学习助手',
      subtitle: '分享内容预览',
      content: '这是分享内容的示例预览区域...',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '分享预览',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: card,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.save_alt),
                      label: const Text('保存图片'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF8B4513),
                        side: const BorderSide(color: Color(0xFF8B4513)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _doShare();
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('分享'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B4513),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _doShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('正在分享...'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
