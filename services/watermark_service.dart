import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum WatermarkPosition {
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

enum WatermarkStyle {
  logo,
  text,
  logoWithText,
}

class WatermarkConfig {
  final String appName;
  final String? logoPath;
  final WatermarkPosition position;
  final WatermarkStyle style;
  final double opacity;
  final double fontSize;
  final Color textColor;
  final bool showOnScreenshots;
  final bool showOnShares;

  const WatermarkConfig({
    this.appName = '中医易学学习助手',
    this.logoPath,
    this.position = WatermarkPosition.bottomCenter,
    this.style = WatermarkStyle.logoWithText,
    this.opacity = 0.7,
    this.fontSize = 14,
    this.textColor = Colors.black54,
    this.showOnScreenshots = true,
    this.showOnShares = true,
  });

  WatermarkConfig copyWith({
    String? appName,
    String? logoPath,
    WatermarkPosition? position,
    WatermarkStyle? style,
    double? opacity,
    double? fontSize,
    Color? textColor,
    bool? showOnScreenshots,
    bool? showOnShares,
  }) {
    return WatermarkConfig(
      appName: appName ?? this.appName,
      logoPath: logoPath ?? this.logoPath,
      position: position ?? this.position,
      style: style ?? this.style,
      opacity: opacity ?? this.opacity,
      fontSize: fontSize ?? this.fontSize,
      textColor: textColor ?? this.textColor,
      showOnScreenshots: showOnScreenshots ?? this.showOnScreenshots,
      showOnShares: showOnShares ?? this.showOnShares,
    );
  }
}

class WatermarkService {
  static final WatermarkService _instance = WatermarkService._internal();
  factory WatermarkService() => _instance;
  WatermarkService._internal();

  WatermarkConfig _config = const WatermarkConfig();
  
  WatermarkConfig get config => _config;

  void updateConfig(WatermarkConfig config) {
    _config = config;
  }

  void updatePosition(WatermarkPosition position) {
    _config = _config.copyWith(position: position);
  }

  void updateStyle(WatermarkStyle style) {
    _config = _config.copyWith(style: style);
  }

  void updateOpacity(double opacity) {
    _config = _config.copyWith(opacity: opacity.clamp(0.3, 1.0));
  }

  void updateFontSize(double fontSize) {
    _config = _config.copyWith(fontSize: fontSize.clamp(10, 24));
  }

  void toggleShowOnScreenshots(bool show) {
    _config = _config.copyWith(showOnScreenshots: show);
  }

  void toggleShowOnShares(bool show) {
    _config = _config.copyWith(showOnShares: show);
  }

  Widget buildWatermarkWidget({double? width, double? height}) {
    return _WatermarkWidget(
      config: _config,
      containerWidth: width,
      containerHeight: height,
    );
  }

  Offset getWatermarkOffset(Size containerSize, Size watermarkSize) {
    final padding = 16.0;
    double left, top;

    switch (_config.position) {
      case WatermarkPosition.topLeft:
        left = padding;
        top = padding;
        break;
      case WatermarkPosition.topCenter:
        left = (containerSize.width - watermarkSize.width) / 2;
        top = padding;
        break;
      case WatermarkPosition.topRight:
        left = containerSize.width - watermarkSize.width - padding;
        top = padding;
        break;
      case WatermarkPosition.bottomLeft:
        left = padding;
        top = containerSize.height - watermarkSize.height - padding;
        break;
      case WatermarkPosition.bottomCenter:
        left = (containerSize.width - watermarkSize.width) / 2;
        top = containerSize.height - watermarkSize.height - padding;
        break;
      case WatermarkPosition.bottomRight:
        left = containerSize.width - watermarkSize.width - padding;
        top = containerSize.height - watermarkSize.height - padding;
        break;
    }

    return Offset(left, top);
  }

  Future<Uint8List?> captureWidgetWithWatermark(
    GlobalKey repaintBoundaryKey, {
    bool addWatermark = true,
  }) async {
    try {
      final boundary = repaintBoundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) return null;
      
      Uint8List pngBytes = byteData.buffer.asUint8List();

      if (addWatermark && _config.showOnShares) {
        pngBytes = await _addWatermarkToImage(pngBytes);
      }

      return pngBytes;
    } catch (e) {
      debugPrint('Error capturing widget: $e');
      return null;
    }
  }

  Future<Uint8List> _addWatermarkToImage(Uint8List imageBytes) async {
    final codec = await ui.instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    final originalImage = frame.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawImage(originalImage, Offset.zero, Paint());

    final watermarkPainter = _WatermarkPainter(config: _config);
    watermarkPainter.paint(canvas, originalImage.size);

    final picture = recorder.endRecording();
    final newImage = await picture.toImage(
      originalImage.width,
      originalImage.height,
    );

    final byteData = await newImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List() ?? imageBytes;
  }

  String get defaultDisclaimer => '本内容仅供传统文化学习参考，不构成医疗或占卜服务';

  String get fullDisclaimer =>
      '免责声明：本应用为「中医易学学习助手」，仅为中华传统文化（中医、针灸、易学、命理）知识学习与学术研究工具。所有内容来自公开古籍、名家学术整理、传统典籍解析，不提供医疗诊断、处方用药、针灸治疗、占卜算命服务。内容仅供学习参考，非医疗建议、非人生决策依据。身体不适请咨询专业医师，请勿自行按方用药、施针。';
}

class _WatermarkWidget extends StatelessWidget {
  final WatermarkConfig config;
  final double? containerWidth;
  final double? containerHeight;

  const _WatermarkWidget({
    required this.config,
    this.containerWidth,
    this.containerHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: config.opacity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    switch (config.style) {
      case WatermarkStyle.logo:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF8B4513),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.local_hospital,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              config.appName,
              style: TextStyle(
                fontSize: config.fontSize,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF8B4513),
              ),
            ),
          ],
        );

      case WatermarkStyle.text:
        return Text(
          config.appName,
          style: TextStyle(
            fontSize: config.fontSize,
            fontWeight: FontWeight.w500,
            color: config.textColor,
          ),
        );

      case WatermarkStyle.logoWithText:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B4513), Color(0xFFA0522D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.auto_stories,
                color: Colors.white,
                size: 12,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              config.appName,
              style: TextStyle(
                fontSize: config.fontSize,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5D4037),
              ),
            ),
          ],
        );
    }
  }
}

class _WatermarkPainter extends CustomPainter {
  final WatermarkConfig config;

  _WatermarkPainter({required this.config});

  @override
  void paint(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: config.appName,
      style: TextStyle(
        fontSize: config.fontSize * 2,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF8B4513).withValues(alpha: config.opacity * 0.8),
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    double x, y;
    final padding = 20.0;

    switch (config.position) {
      case WatermarkPosition.topLeft:
        x = padding;
        y = padding;
        break;
      case WatermarkPosition.topCenter:
        x = (size.width - textPainter.width) / 2;
        y = padding;
        break;
      case WatermarkPosition.topRight:
        x = size.width - textPainter.width - padding;
        y = padding;
        break;
      case WatermarkPosition.bottomLeft:
        x = padding;
        y = size.height - textPainter.height - padding;
        break;
      case WatermarkPosition.bottomCenter:
        x = (size.width - textPainter.width) / 2;
        y = size.height - textPainter.height - padding;
        break;
      case WatermarkPosition.bottomRight:
        x = size.width - textPainter.width - padding;
        y = size.height - textPainter.height - padding;
        break;
    }

    final shadowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawRect(
      Rect.fromLTWH(x - 10, y - 5, textPainter.width + 20, textPainter.height + 10),
      shadowPaint,
    );

    textPainter.paint(canvas, Offset(x, y));

    final disclaimerPainter = TextPainter(
      text: TextSpan(
        text: '中医易学学习助手',
        style: TextStyle(
          fontSize: config.fontSize * 1.2,
          color: const Color(0xFF8B4513).withValues(alpha: config.opacity * 0.6),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    disclaimerPainter.layout();

    double dx, dy;
    switch (config.position) {
      case WatermarkPosition.topLeft:
      case WatermarkPosition.topCenter:
      case WatermarkPosition.topRight:
        dx = padding;
        dy = y + textPainter.height + 5;
        break;
      default:
        dx = padding;
        dy = y - disclaimerPainter.height - 5;
    }

    disclaimerPainter.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(covariant _WatermarkPainter oldDelegate) {
    return config != oldDelegate.config;
  }
}
