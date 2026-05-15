import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';

class TongueScreen extends StatefulWidget {
  const TongueScreen({super.key});

  @override
  State<TongueScreen> createState() => _TongueScreenState();
}

class _TongueScreenState extends State<TongueScreen> {
  String? _selectedTongueColor;
  String? _selectedTongueCoating;
  String? _selectedTongueShape;
  String _analysis = '';

  final List<String> _tongueShapes = [
    '老舌', '嫩舌', '胖大舌', '瘦薄舌', '齿痕舌',
    '裂纹舌', '芒刺舌', '瘀斑舌', '正常舌',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('舌象分析'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.pink.shade200, width: 2),
                    ),
                    child: Icon(
                      Icons.touch_app,
                      size: 48,
                      color: Colors.pink.shade300,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('拍摄舌象'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '舌色',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppConstants.tongueColors.map((color) {
              return ChoiceChip(
                label: Text(color),
                selected: _selectedTongueColor == color,
                onSelected: (_) {
                  setState(() {
                    _selectedTongueColor = color;
                    _analyzeTongue();
                  });
                },
                selectedColor: _getTongueColor(color),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            '苔色',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppConstants.tongueCoatings.map((coating) {
              return ChoiceChip(
                label: Text(coating),
                selected: _selectedTongueCoating == coating,
                onSelected: (_) {
                  setState(() {
                    _selectedTongueCoating = coating;
                    _analyzeTongue();
                  });
                },
                selectedColor: _getCoatingColor(coating),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            '舌形',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tongueShapes.map((shape) {
              return ChoiceChip(
                label: Text(shape),
                selected: _selectedTongueShape == shape,
                onSelected: (_) {
                  setState(() {
                    _selectedTongueShape = shape;
                    _analyzeTongue();
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          if (_analysis.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.analytics, color: AppTheme.primaryColor),
                      SizedBox(width: 8),
                      Text(
                        '舌象分析结果',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _analysis,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Color _getTongueColor(String color) {
    switch (color) {
      case '淡红舌':
        return Colors.pink.shade100;
      case '淡白舌':
        return Colors.grey.shade200;
      case '红舌':
        return Colors.red.shade200;
      case '绛舌':
        return Colors.red.shade400;
      case '紫舌':
        return Colors.purple.shade200;
      case '青舌':
        return Colors.blue.shade200;
      case '淡紫舌':
        return Colors.purple.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getCoatingColor(String coating) {
    if (coating.contains('白')) return Colors.white;
    if (coating.contains('黄')) return Colors.yellow.shade200;
    if (coating.contains('灰') || coating.contains('黑')) return Colors.grey.shade400;
    return Colors.grey.shade200;
  }

  void _pickImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('请拍摄清晰的舌象照片')),
    );
  }

  void _analyzeTongue() {
    if (_selectedTongueColor == null) return;

    StringBuffer analysis = StringBuffer();

    analysis.writeln('舌色：$_selectedTongueColor');
    if (_selectedTongueCoating != null) {
      analysis.writeln('苔色：$_selectedTongueCoating');
    }
    if (_selectedTongueShape != null) {
      analysis.writeln('舌形：$_selectedTongueShape');
    }

    analysis.writeln();

    if (_selectedTongueColor == '淡红舌' && _selectedTongueCoating == '薄白苔') {
      analysis.writeln('此为正常舌象，舌质淡红、润泽，苔薄白均匀，表明气血平和，胃气充足。');
    } else if (_selectedTongueColor == '淡白舌') {
      analysis.writeln('舌色淡白多属气血两虚或阳虚，常见于贫血、营养不良、甲状腺功能减退等。');
      analysis.writeln('建议：补气养血，温补脾肾。');
    } else if (_selectedTongueColor == '红舌') {
      analysis.writeln('舌红主热证，热在气分则舌红少津，热入营血则舌红绛。');
      analysis.writeln('建议：清热泻火，凉血养阴。');
    } else if (_selectedTongueColor == '绛舌') {
      analysis.writeln('舌色绛红多属热入营血，阴虚火旺，或热病危重阶段。');
      analysis.writeln('建议：清营凉血，滋阴降火。');
    } else if (_selectedTongueColor == '紫舌' || _selectedTongueColor == '淡紫舌') {
      analysis.writeln('舌色青紫多属血瘀证，寒凝血瘀或热毒血瘀。');
      analysis.writeln('建议：活血化瘀，行气止痛。');
    } else if (_selectedTongueColor == '青舌') {
      analysis.writeln('舌色青绿多属寒凝血瘀，或为惊风先兆。');
      analysis.writeln('建议：温阳散寒，活血化瘀。');
    }

    if (_selectedTongueCoating != null) {
      if (_selectedTongueCoating!.contains('黄')) {
        analysis.writeln('苔黄主热证，黄苔越深，热邪越重。');
      } else if (_selectedTongueCoating!.contains('腻')) {
        analysis.writeln('苔腻多属湿浊内蕴，痰饮内停。');
      }
    }

    setState(() {
      _analysis = analysis.toString();
    });
  }
}
