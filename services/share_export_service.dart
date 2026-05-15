import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'watermark_service.dart';

enum SharePlatform {
  wechat,
  moments,
  weibo,
  qq,
  copyLink,
  saveImage,
}

class ShareConfig {
  final String title;
  final String description;
  final String? imagePath;
  final Uint8List? imageBytes;
  final String shareUrl;
  final bool includeWatermark;
  final bool includeQRCode;
  final bool includeDisclaimer;

  const ShareConfig({
    required this.title,
    required this.description,
    this.imagePath,
    this.imageBytes,
    this.shareUrl = '',
    this.includeWatermark = true,
    this.includeQRCode = false,
    this.includeDisclaimer = true,
  });
}

class ShareExportService {
  static final ShareExportService _instance = ShareExportService._internal();
  factory ShareExportService() => _instance;
  ShareExportService._internal();

  final WatermarkService _watermarkService = WatermarkService();

  Future<Uint8List?> generateShareImage({
    required GlobalKey repaintKey,
    required String title,
    String? subtitle,
    String? qrCodeData,
    bool addWatermark = true,
    bool addQRCode = false,
    bool addDisclaimer = true,
  }) async {
    try {
      final imageBytes = await _captureWidget(repaintKey);
      if (imageBytes == null) return null;

      if (!addWatermark && !addQRCode && !addDisclaimer) {
        return imageBytes;
      }

      final combinedBytes = await _addOverlays(
        imageBytes,
        title: title,
        subtitle: subtitle,
        qrCodeData: qrCodeData,
        addWatermark: addWatermark,
        addQRCode: addQRCode,
        addDisclaimer: addDisclaimer,
      );

      return combinedBytes;
    } catch (e) {
      debugPrint('Error generating share image: $e');
      return null;
    }
  }

  Future<Uint8List?> _captureWidget(GlobalKey key) async {
    try {
      final boundary = key.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing widget: $e');
      return null;
    }
  }

  Future<Uint8List> _addOverlays(
    Uint8List originalBytes, {
    required String title,
    String? subtitle,
    String? qrCodeData,
    required bool addWatermark,
    required bool addQRCode,
    required bool addDisclaimer,
  }) async {
    final codec = await ui.instantiateImageCodec(originalBytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawImage(image, Offset.zero, Paint());

    final imageSize = Size(image.width.toDouble(), image.height.toDouble());

    if (addQRCode && qrCodeData != null) {
      _drawQRCode(canvas, qrCodeData, imageSize);
    }

    if (addDisclaimer) {
      _drawDisclaimer(canvas, imageSize);
    }

    if (addWatermark) {
      _drawWatermark(canvas, imageSize);
    }

    final picture = recorder.endRecording();
    final newImage = await picture.toImage(image.width, image.height);
    final byteData = await newImage.toByteData(format: ui.ImageByteFormat.png);

    return byteData?.buffer.asUint8List() ?? originalBytes;
  }

  void _drawQRCode(Canvas canvas, String data, Size imageSize) {
    final qrSize = imageSize.width * 0.18;
    final qrPadding = 16.0;

    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        imageSize.width - qrSize - qrPadding,
        imageSize.height - qrSize - qrPadding,
        qrSize + 16,
        qrSize + 40,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(bgRect, bgPaint);

    final qrPainter = QrPainter(
      data: data,
      version: QrVersions.auto,
      color: const Color(0xFF8B4513),
      emptyColor: Colors.white,
      embeddedImageStyle: null,
      embeddedImage: null,
    );

    qrPainter.paint(
      canvas,
      Size(
        qrSize,
        qrSize,
      ),
    );

    final textSpan = TextSpan(
      text: '扫码下载APP',
      style: TextStyle(
        fontSize: qrSize * 0.12,
        color: const Color(0xFF8B4513),
        fontWeight: FontWeight.w500,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(
        imageSize.width - qrSize - qrPadding + (qrSize - textPainter.width) / 2,
        imageSize.height - qrPadding - 8,
      ),
    );
  }

  void _drawDisclaimer(Canvas canvas, Size imageSize) {
    final disclaimer =
        '本内容仅供传统文化学习参考，不构成医疗或占卜服务';

    final textSpan = TextSpan(
      text: disclaimer,
      style: TextStyle(
        fontSize: imageSize.width * 0.025,
        color: Colors.grey.shade600,
        fontWeight: FontWeight.w400,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final maxWidth = imageSize.width * 0.9;
    textPainter.layout(maxWidth: maxWidth);

    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    final bgRect = Rect.fromLTWH(
      (imageSize.width - maxWidth) / 2 - 8,
      imageSize.height - textPainter.height - 50,
      maxWidth + 16,
      textPainter.height + 12,
    );
    canvas.drawRect(bgRect, bgPaint);

    textPainter.paint(
      canvas,
      Offset(
        (imageSize.width - textPainter.width) / 2,
        imageSize.height - textPainter.height - 44,
      ),
    );
  }

  void _drawWatermark(Canvas canvas, Size imageSize) {
    final watermarkText = '中医易学学习助手';

    final textSpan = TextSpan(
      text: watermarkText,
      style: TextStyle(
        fontSize: imageSize.width * 0.035,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF8B4513).withValues(alpha: 0.7),
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final padding = 20.0;
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        (imageSize.width - textPainter.width) / 2 - 12,
        padding - 4,
        textPainter.width + 24,
        textPainter.height + 8,
      ),
      const Radius.circular(16),
    );
    canvas.drawRRect(bgRect, bgPaint);

    textPainter.paint(
      canvas,
      Offset(
        (imageSize.width - textPainter.width) / 2,
        padding,
      ),
    );
  }

  Widget buildShareCard({
    required String title,
    String? subtitle,
    String? qrCodeData,
    bool showQRCode = false,
    bool showWatermark = true,
    double? width,
    double? height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (subtitle != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: const Color(0xFF8B4513).withValues(alpha: 0.1),
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
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Container(
                    color: Colors.grey.shade100,
                    child: Center(
                      child: Text(
                        '内容预览区',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '本内容仅供学习参考',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                      if (showQRCode && qrCodeData != null)
                        Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: QrImageView(
                            data: qrCodeData,
                            version: QrVersions.auto,
                            color: const Color(0xFF8B4513),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (showWatermark)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.auto_stories,
                        size: 14,
                        color: Color(0xFF8B4513),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '中医易学学习助手',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5D4037),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<SharePlatform> get availablePlatforms => [
        SharePlatform.wechat,
        SharePlatform.moments,
        SharePlatform.qq,
        SharePlatform.copyLink,
        SharePlatform.saveImage,
      ];

  IconData getPlatformIcon(SharePlatform platform) {
    switch (platform) {
      case SharePlatform.wechat:
        return Icons.chat_bubble;
      case SharePlatform.moments:
        return Icons.public;
      case SharePlatform.weibo:
        return Icons.alternate_email;
      case SharePlatform.qq:
        return Icons.forum;
      case SharePlatform.copyLink:
        return Icons.link;
      case SharePlatform.saveImage:
        return Icons.save_alt;
    }
  }

  String getPlatformName(SharePlatform platform) {
    switch (platform) {
      case SharePlatform.wechat:
        return '微信';
      case SharePlatform.moments:
        return '朋友圈';
      case SharePlatform.weibo:
        return '微博';
      case SharePlatform.qq:
        return 'QQ';
      case SharePlatform.copyLink:
        return '复制链接';
      case SharePlatform.saveImage:
        return '保存图片';
    }
  }
}
