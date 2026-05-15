import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

class OCRResult {
  final String rawText;
  final String? extractedNumber;
  final double confidence;
  final OCRResultType type;

  const OCRResult({
    required this.rawText,
    this.extractedNumber,
    required this.confidence,
    required this.type,
  });
}

enum OCRResultType {
  phoneNumber,
  carPlate,
  character,
  face,
  palm,
}

class OcrService {
  static final OcrService _instance = OcrService._internal();
  factory OcrService() => _instance;
  OcrService._internal();

  Future<OCRResult> recognizePhoneNumber(File imageFile) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final mockNumbers = [
      '13812345678',
      '13998765432',
      '13656789012',
    ];
    final random = Random();
    final number = mockNumbers[random.nextInt(mockNumbers.length)];
    
    return OCRResult(
      rawText: number,
      extractedNumber: number,
      confidence: 0.95,
      type: OCRResultType.phoneNumber,
    );
  }

  Future<OCRResult> recognizeCarPlate(File imageFile) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final mockPlates = [
      'ABC123',
      'XYZ789',
      'HK4567',
    ];
    final random = Random();
    final plate = mockPlates[random.nextInt(mockPlates.length)];
    
    return OCRResult(
      rawText: plate,
      extractedNumber: plate,
      confidence: 0.92,
      type: OCRResultType.carPlate,
    );
  }

  Future<OCRResult> recognizeCharacter(File imageFile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return OCRResult(
      rawText: '測',
      extractedNumber: '測',
      confidence: 0.88,
      type: OCRResultType.character,
    );
  }
}

class FaceRecognitionService {
  static final FaceRecognitionService _instance = FaceRecognitionService._internal();
  factory FaceRecognitionService() => _instance;
  FaceRecognitionService._internal();

  static const List<String> faceShapes = [
    '圓形',
    '方形',
    '長形',
    '瓜子形',
    '橢圓形',
  ];

  static const List<String> foreheadTypes = [
    '飽滿',
    '光滑',
    '有紋',
    '狹窄',
  ];

  static const List<String> eyebrowTypes = [
    '柳葉眉',
    '劍眉',
    '粗眉',
    '細眉',
    '一字眉',
  ];

  static const List<String> eyeTypes = [
    '有神',
    '清澈',
    '深邃',
    '渙散',
  ];

  static const List<String> noseTypes = [
    '端正',
    '挺直',
    '豐滿',
    '塌陷',
  ];

  static const List<String> mouthTypes = [
    '紅潤',
    '飽滿',
    '蒼白',
    '過大',
    '過小',
  ];

  static const List<String> chinTypes = [
    '飽滿',
    '方正',
    '尖削',
    '雙下巴',
  ];

  static const List<String> earTypes = [
    '分明',
    '厚實',
    '單薄',
    '貼面',
  ];

  Future<Map<String, String>> analyzeFace(File imageFile) async {
    await Future.delayed(const Duration(seconds: 2));
    
    final random = Random();
    
    return {
      'faceShape': faceShapes[random.nextInt(faceShapes.length)],
      'forehead': foreheadTypes[random.nextInt(foreheadTypes.length)],
      'eyebrow': eyebrowTypes[random.nextInt(eyebrowTypes.length)],
      'eye': eyeTypes[random.nextInt(eyeTypes.length)],
      'nose': noseTypes[random.nextInt(noseTypes.length)],
      'mouth': mouthTypes[random.nextInt(mouthTypes.length)],
      'chin': chinTypes[random.nextInt(chinTypes.length)],
      'ear': earTypes[random.nextInt(earTypes.length)],
    };
  }
}

class PalmRecognitionService {
  static final PalmRecognitionService _instance = PalmRecognitionService._internal();
  factory PalmRecognitionService() => _instance;
  PalmRecognitionService._internal();

  static const List<String> palmShapes = [
    '方形',
    '圓形',
    '長形',
    '三角形',
    '混合形',
  ];

  static const List<String> lifeLineTypes = [
    '深長',
    '清晰',
    '斷裂',
    '淺淡',
  ];

  static const List<String> heartLineTypes = [
    '彎曲',
    '直線',
    '環形',
    '鎖鏈形',
  ];

  static const List<String> headLineTypes = [
    '清晰',
    '深長',
    '分叉',
    '斷裂',
  ];

  static const List<String> marriageLineTypes = [
    '一條',
    '多條',
    '無',
    '模糊',
  ];

  Future<Map<String, String>> analyzePalm(File imageFile) async {
    await Future.delayed(const Duration(seconds: 2));
    
    final random = Random();
    
    return {
      'palmShape': palmShapes[random.nextInt(palmShapes.length)],
      'lifeLine': lifeLineTypes[random.nextInt(lifeLineTypes.length)],
      'heartLine': heartLineTypes[random.nextInt(heartLineTypes.length)],
      'headLine': headLineTypes[random.nextInt(headLineTypes.length)],
      'marriageLine': marriageLineTypes[random.nextInt(marriageLineTypes.length)],
    };
  }
}

class CameraHelper {
  static Future<File?> captureImage(BuildContext context) async {
    return null;
  }

  static Future<List<File>> captureMultipleImages(BuildContext context, int count) async {
    return [];
  }
}

class OCRCaptureWidget extends StatelessWidget {
  final String title;
  final String hint;
  final OCRResultType resultType;
  final Function(String) onResult;

  const OCRCaptureWidget({
    super.key,
    required this.title,
    required this.hint,
    required this.resultType,
    required this.onResult,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(
            Icons.camera_alt,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hint,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () async {
                  await _captureAndRecognize(context);
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('拍照識別'),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () => _showManualInput(context),
                icon: const Icon(Icons.keyboard),
                label: const Text('手動輸入'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _captureAndRecognize(BuildContext context) async {
    final ocrService = OcrService();
    
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('正在識別...')),
      );
      
      OCRResult? result;
      
      if (resultType == OCRResultType.phoneNumber) {
        result = await ocrService.recognizePhoneNumber(File(''));
      } else if (resultType == OCRResultType.carPlate) {
        result = await ocrService.recognizeCarPlate(File(''));
      }
      
      if (result != null && result.extractedNumber != null) {
        onResult(result.extractedNumber!);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('識別成功：${result.extractedNumber}')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('識別失敗：$e')),
        );
      }
    }
  }

  void _showManualInput(BuildContext context) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
          ),
          keyboardType: resultType == OCRResultType.phoneNumber
              ? TextInputType.phone
              : TextInputType.text,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onResult(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('確認'),
          ),
        ],
      ),
    );
  }
}
