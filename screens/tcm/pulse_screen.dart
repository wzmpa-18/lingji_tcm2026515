import 'package:flutter/material.dart';
import '../../config/theme.dart';

class PulseScreen extends StatefulWidget {
  const PulseScreen({super.key});

  @override
  State<PulseScreen> createState() => _PulseScreenState();
}

class _PulseScreenState extends State<PulseScreen> {
  String? _selectedPulse;
  String _analysis = '';
  final Map<String, bool> _symptoms = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('脉象分析'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(
                    Icons.favorite,
                    size: 80,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '脉象演示',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '浮沉迟数滑涩虚实',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '请选择您感受到的脉象特征',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildPulseSection('脉位', ['浮脉', '沉脉', '伏脉']),
          _buildPulseSection('脉数', ['迟脉', '数脉', '疾脉']),
          _buildPulseSection('脉形', ['滑脉', '涩脉', '洪脉', '细脉', '弦脉', '紧脉', '濡脉', '弱脉']),
          _buildPulseSection('其他', ['芤脉', '革脉', '牢脉', '散脉', '短脉', '长脉', '动脉', '促脉', '结脉', '代脉', '微脉', '缓脉', '虚脉', '实脉']),
          const SizedBox(height: 24),
          const Text(
            '伴随症状（可多选）',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              '头痛', '眩晕', '失眠', '心悸', '胸闷', '气短',
              '乏力', '畏寒', '发热', '汗出', '口干', '咽痛',
              '咳嗽', '腹痛', '腹胀', '便秘', '腹泻', '恶心',
            ].map((symptom) {
              return FilterChip(
                label: Text(symptom),
                selected: _symptoms[symptom] == true,
                onSelected: (selected) {
                  setState(() => _symptoms[symptom] = selected);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _analyzePulse,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('分析脉象', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 24),
          if (_analysis.isNotEmpty)
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
                        '脉象分析结果',
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
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPulseSection(String title, List<String> pulses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.secondaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: pulses.map((pulse) {
            return ChoiceChip(
              label: Text(pulse),
              selected: _selectedPulse == pulse,
              onSelected: (_) {
                setState(() {
                  _selectedPulse = pulse;
                });
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _analyzePulse() {
    if (_selectedPulse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择至少一种脉象')),
      );
      return;
    }

    StringBuffer analysis = StringBuffer();
    analysis.writeln('主脉：$_selectedPulse');

    final symptomList = _symptoms.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    if (symptomList.isNotEmpty) {
      analysis.writeln('伴症：${symptomList.join('、')}');
    }

    analysis.writeln();

    switch (_selectedPulse) {
      case '浮脉':
        analysis.writeln('浮脉主表证，常见于外感病初期。');
        analysis.writeln('脉象特点：轻取即得，重按稍减。');
        analysis.writeln('辨证：浮紧为表寒，浮数为表热，浮缓为表虚。');
        analysis.writeln('治法：解表散邪。');
        break;
      case '沉脉':
        analysis.writeln('沉脉主里证，常见于脏腑病变。');
        analysis.writeln('脉象特点：轻取不应，重按始得。');
        analysis.writeln('辨证：沉紧为里寒，沉数为里热，沉弱为里虚。');
        analysis.writeln('治法：调理脏腑。');
        break;
      case '迟脉':
        analysis.writeln('迟脉主寒证，常见于阳虚内寒。');
        analysis.writeln('脉象特点：一息三至，来去极慢。');
        analysis.writeln('辨证：迟而有力为冷积，迟而无力为虚寒。');
        analysis.writeln('治法：温阳散寒。');
        break;
      case '数脉':
        analysis.writeln('数脉主热证，常见于发热或阴虚内热。');
        analysis.writeln('脉象特点：一息六至，来去急促。');
        analysis.writeln('辨证：数而有力为实热，数而无力为虚热。');
        analysis.writeln('治法：清热泻火或滋阴降火。');
        break;
      case '滑脉':
        analysis.writeln('滑脉主痰饮、食滞、实热。');
        analysis.writeln('脉象特点：往来流利，应指圆滑，如珠走盘。');
        analysis.writeln('辨证：滑而数为热盛，滑而迟为痰饮，滑而紧为实邪。');
        analysis.writeln('治法：化痰祛饮或消食导滞。');
        break;
      case '涩脉':
        analysis.writeln('涩脉主气滞血瘀、精亏血少。');
        analysis.writeln('脉象特点：往来艰涩，如轻刀刮竹。');
        analysis.writeln('辨证：涩而有力为气滞血瘀，涩而无力为精亏血少。');
        analysis.writeln('治法：活血化瘀或补益精血。');
        break;
      case '弦脉':
        analysis.writeln('弦脉主肝胆病、痛证、痰饮。');
        analysis.writeln('脉象特点：端直以长，如按琴弦。');
        analysis.writeln('辨证：弦数为肝火，弦紧为痛证，弦滑为痰饮。');
        analysis.writeln('治法：疏肝解郁或化痰祛饮。');
        break;
      case '细脉':
        analysis.writeln('细脉主气血两虚、阴虚。');
        analysis.writeln('脉象特点：细如一线，应指明显。');
        analysis.writeln('辨证：细而数为阴虚火旺，细而迟为气血两虚。');
        analysis.writeln('治法：补益气血或滋阴降火。');
        break;
      case '洪脉':
        analysis.writeln('洪脉主气分热盛、阳亢。');
        analysis.writeln('脉象特点：脉来洪大，满于指下，来盛去衰。');
        analysis.writeln('辨证：洪大为热盛伤阴，洪而数为阳亢。');
        analysis.writeln('治法：清热泻火或滋阴潜阳。');
        break;
      default:
        analysis.writeln('该脉象需结合其他症状综合分析。');
        analysis.writeln('建议：请咨询专业中医师进行详细诊断。');
    }

    setState(() {
      _analysis = analysis.toString();
    });
  }
}
