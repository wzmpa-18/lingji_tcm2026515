import 'package:flutter/material.dart';

class LingGuiBaFaScreen extends StatefulWidget {
  const LingGuiBaFaScreen({super.key});

  @override
  State<LingGuiBaFaScreen> createState() => _LingGuiBaFaScreenState();
}

class _LingGuiBaFaScreenState extends State<LingGuiBaFaScreen> {
  final TextEditingController _yearController = TextEditingController(text: '2026');
  final TextEditingController _monthController = TextEditingController(text: '5');
  final TextEditingController _dayController = TextEditingController(text: '13');
  final TextEditingController _hourController = TextEditingController(text: '10');

  Map<String, String> result = {};

  final List<String> ganList = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
  final List<String> zhiList = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

  final Map<String, Map<String, String>> lingGuiBaFa = {
    '甲': {'穴位': '公孙', '内关': '列缺', '后溪': '申脉', '照海': '临泣', '外关': '足临泣'},
    '乙': {'穴位': '公孙', '内关': '列缺', '后溪': '申脉', '照海': '临泣', '外关': '足临泣'},
    '丙': {'穴位': '内关', '公孙': '列缺', '照海': '申脉', '后溪': '临泣', '外关': '足临泣'},
    '丁': {'穴位': '公孙', '外关': '列缺', '后溪': '申脉', '照海': '临泣', '内关': '足临泣'},
    '戊': {'穴位': '公孙', '内关': '列缺', '后溪': '申脉', '照海': '临泣', '外关': '足临泣'},
    '己': {'穴位': '公孙', '内关': '列缺', '照海': '申脉', '后溪': '临泣', '外关': '足临泣'},
    '庚': {'穴位': '外关', '公孙': '列缺', '后溪': '申脉', '照海': '临泣', '内关': '足临泣'},
    '辛': {'穴位': '公孙', '内关': '列缺', '照海': '申脉', '后溪': '临泣', '外关': '足临泣'},
    '壬': {'穴位': '外关', '公孙': '列缺', '后溪': '申脉', '照海': '临泣', '内关': '足临泣'},
    '癸': {'穴位': '公孙', '内关': '列缺', '后溪': '申脉', '照海': '临泣', '外关': '足临泣'},
  };

  final Map<String, String> baGuaPosition = {
    '坎一': '申脉', '坤二': '照海', '震三': '外关', '巽四': '足临泣',
    '乾六': '公孙', '兑七': '内关', '艮八': '后溪', '离九': '列缺',
  };

  void _calculate() {
    final year = int.tryParse(_yearController.text) ?? 2026;
    final month = int.tryParse(_monthController.text) ?? 5;
    final day = int.tryParse(_dayController.text) ?? 13;
    final hour = int.tryParse(_hourController.text) ?? 10;

    final dayOfWeek = DateTime(year, month, day).weekday;
    final dayName = ['一', '二', '三', '四', '五', '六', '日'][dayOfWeek - 1];

    final dayGanIndex = (year - 1984) % 10;
    final dayZhiIndex = (year - 1984) % 12;

    final dayGan = ganList[dayGanIndex >= 0 ? dayGanIndex : dayGanIndex + 10];
    final dayZhi = zhiList[dayZhiIndex >= 0 ? dayZhiIndex : dayZhiIndex + 12];

    final timeGanIndex = (dayGanIndex * 2 + hour ~/ 2) % 10;
    final timeGan = ganList[timeGanIndex >= 0 ? timeGanIndex : timeGanIndex + 10];

    setState(() {
      result = {
        '日期': '$year年$month月$day日',
        '星期': dayName,
        '日干': dayGan,
        '日支': dayZhi,
        '时干': timeGan,
        '开穴穴位': lingGuiBaFa[dayGan]?['穴位'] ?? '公孙',
        '应开穴位': '公孙、内关、列缺、后溪、申脉、照海、临泣、足临泣',
        '八卦方位': baGuaPosition[dayGan] ?? '公孙',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('灵龟八法'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInputCard(),
          _buildCalculateButton(),
          if (result.isNotEmpty) _buildResultCard(),
          _buildTheoryCard(),
        ],
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('输入日期时间', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: _yearController, decoration: const InputDecoration(labelText: '年', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: _monthController, decoration: const InputDecoration(labelText: '月', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: _dayController, decoration: const InputDecoration(labelText: '日', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: _hourController, decoration: const InputDecoration(labelText: '时', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton(
        onPressed: _calculate,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('计算开穴', style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 2,
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('灵龟八法开穴结果', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 12),
            ...result.entries.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(width: 80, child: Text('${e.key}：', style: const TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(child: Text(e.value, style: const TextStyle(fontSize: 16))),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTheoryCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('灵龟八法理论', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('灵龟八法是以奇经八脉与十二正经八个特定穴位相配，按日时干支开穴治病。', style: TextStyle(height: 1.6)),
            const SizedBox(height: 8),
            const Text('八大穴：公孙、内关、列缺、后溪、申脉、照海、临泣（足临泣）、外关', style: TextStyle(height: 1.6)),
            const SizedBox(height: 8),
            const Text('日干配穴：甲日公孙、乙日公孙、丙日内关、丁日公孙...', style: TextStyle(height: 1.6)),
          ],
        ),
      ),
    );
  }
}
