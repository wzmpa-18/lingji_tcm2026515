import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/watermark_service.dart';
import '../services/referral_service.dart';

class WatermarkOverlay extends StatelessWidget {
  final GlobalKey? contentKey;
  final bool showWatermark;
  final bool showQRCode;
  final bool showDisclaimer;
  final WatermarkPosition watermarkPosition;
  final Alignment qrCodePosition;
  final double watermarkPadding;

  const WatermarkOverlay({
    super.key,
    this.contentKey,
    this.showWatermark = true,
    this.showQRCode = false,
    this.showDisclaimer = true,
    this.watermarkPosition = WatermarkPosition.bottomCenter,
    this.qrCodePosition = Alignment.bottomRight,
    this.watermarkPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (contentKey != null) KeyedSubtree(key: contentKey!, child: const SizedBox.expand()),
        if (showWatermark)
          Positioned(
            left: watermarkPosition == WatermarkPosition.topLeft || watermarkPosition == WatermarkPosition.bottomLeft
                ? watermarkPadding
                : null,
            right: watermarkPosition == WatermarkPosition.topRight || watermarkPosition == WatermarkPosition.bottomRight
                ? watermarkPadding
                : null,
            top: watermarkPosition == WatermarkPosition.topLeft ||
                    watermarkPosition == WatermarkPosition.topCenter ||
                    watermarkPosition == WatermarkPosition.topRight
                ? watermarkPadding
                : null,
            bottom: watermarkPosition == WatermarkPosition.bottomLeft ||
                    watermarkPosition == WatermarkPosition.bottomCenter ||
                    watermarkPosition == WatermarkPosition.bottomRight
                ? watermarkPadding
                : null,
            child: Center(
              child: WatermarkService().buildWatermarkWidget(),
            ),
          ),
        if (showQRCode)
          Positioned(
            right: watermarkPadding,
            bottom: watermarkPadding,
            child: _buildCompactQRCode(),
          ),
        if (showDisclaimer)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildDisclaimerBar(),
          ),
      ],
    );
  }

  Widget _buildCompactQRCode() {
    final referralService = ReferralService();
    if (!referralService.showQRCode) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: QrImageView(
        data: referralService.currentConfig?.qrData ?? 'https://lingji.app',
        version: QrVersions.auto,
        size: 50,
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
    );
  }

  Widget _buildDisclaimerBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.orange.shade50.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(color: Colors.orange.shade200),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 14,
            color: Colors.orange.shade700,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '本内容仅供传统文化学习参考，不构成医疗或占卜服务',
              style: TextStyle(
                fontSize: 11,
                color: Colors.orange.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShareableContentCard extends StatelessWidget {
  final Widget child;
  final String title;
  final String? subtitle;
  final GlobalKey repaintKey;
  final bool enableShare;
  final bool enableWatermark;
  final bool enableQRCode;

  const ShareableContentCard({
    super.key,
    required this.child,
    required this.title,
    this.subtitle,
    required this.repaintKey,
    this.enableShare = true,
    this.enableWatermark = true,
    this.enableQRCode = false,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: repaintKey,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (enableWatermark)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B4513), Color(0xFFA0522D)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.auto_stories,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '中医易学学习助手',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '传统中医 · 针灸经络 · 易学文化',
                            style: TextStyle(
                              fontSize: 10,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(child: child),
            if (enableQRCode)
              Positioned(
                right: 12,
                bottom: 12,
                child: _buildInlineQRCode(),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '本内容仅供传统文化学习参考，不构成医疗或占卜服务',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  if (enableShare)
                    IconButton(
                      icon: Icon(
                        Icons.share,
                        size: 20,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () => _shareContent(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineQRCode() {
    final referralService = ReferralService();
    if (!referralService.showQRCode) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QrImageView(
            data: referralService.currentConfig?.qrData ?? 'https://lingji.app',
            version: QrVersions.auto,
            size: 50,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 4),
          Text(
            '扫码下载',
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _shareContent(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('正在生成分享图片...'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}

class AcupointShareCard extends StatelessWidget {
  final String acupointName;
  final String meridian;
  final String location;
  final String indication;
  final String technique;
  final GlobalKey repaintKey;

  const AcupointShareCard({
    super.key,
    required this.acupointName,
    required this.meridian,
    required this.location,
    required this.indication,
    required this.technique,
    required this.repaintKey,
  });

  @override
  Widget build(BuildContext context) {
    return ShareableContentCard(
      repaintKey: repaintKey,
      title: acupointName,
      subtitle: '$meridian · 穴位学习',
      enableWatermark: true,
      enableQRCode: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('定位', location),
            const SizedBox(height: 12),
            _buildInfoRow('主治', indication),
            const SizedBox(height: 12),
            _buildInfoRow('操作', technique),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF8B4513).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8B4513),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrescriptionShareCard extends StatelessWidget {
  final String prescriptionName;
  final String syndrome;
  final List<String> herbs;
  final String usage;
  final GlobalKey repaintKey;

  const PrescriptionShareCard({
    super.key,
    required this.prescriptionName,
    required this.syndrome,
    required this.herbs,
    required this.usage,
    required this.repaintKey,
  });

  @override
  Widget build(BuildContext context) {
    return ShareableContentCard(
      repaintKey: repaintKey,
      title: prescriptionName,
      subtitle: '经方配伍思路研习',
      enableWatermark: true,
      enableQRCode: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('症候', syndrome),
            const SizedBox(height: 16),
            _buildSection('配伍', herbs.join(' · ')),
            const SizedBox(height: 16),
            _buildSection('用法', usage),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B4513),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class BaziShareCard extends StatelessWidget {
  final String chartName;
  final String birthInfo;
  final String analysis;
  final GlobalKey repaintKey;

  const BaziShareCard({
    super.key,
    required this.chartName,
    required this.birthInfo,
    required this.analysis,
    required this.repaintKey,
  });

  @override
  Widget build(BuildContext context) {
    return ShareableContentCard(
      repaintKey: repaintKey,
      title: chartName,
      subtitle: '易学文化探讨 · 八字排盘学习',
      enableWatermark: true,
      enableQRCode: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('生辰', birthInfo),
            const SizedBox(height: 12),
            _buildInfoRow('解析', analysis),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B4513),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
