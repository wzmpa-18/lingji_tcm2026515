import 'package:flutter/material.dart';

class FeiTengBaFaScreen extends StatefulWidget {
  const FeiTengBaFaScreen({super.key});

  @override
  State<FeiTengBaFaScreen> createState() => _FeiTengBaFaScreenState();
}

class _FeiTengBaFaScreenState extends State<FeiTengBaFaScreen> {
  final TextEditingController _yearController = TextEditingController(text: '2026');
  final TextEditingController _monthController = TextEditingController(text: '5');
  final TextEditingController _dayController = TextEditingController(text: '13');
  final TextEditingController _hourController = TextEditingController(text: '10');

  Map<String, String> result = {};

  final List<String> ganList = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
  final List<String> zhiList = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

  final Map<String, Map<String, String>> feiTengBaFa = {
    '甲': {'日': '公孙', '时': '内关'},
    '乙': {'日': '公孙', '时': '列缺'},
    '丙': {'日': '内关', '时': '照海'},
    '丁': {'日': '公孙', '时': '申脉'},
    '戊': {'日': '公孙', '时': '内关'},
    '己': {'日': '公孙', '时': '列缺'},
    '庚': {'日': '外关', '时': '足临泣'},
    '辛': {'日': '公孙', '时': '后溪'},
    '壬': {'日': '外关', '时': '照海'},
    '癸': {'日': '公孙', '时': '内关'},
  };

  final Map<String, String> wuXingPosition = {
    '甲': '公孙', '乙': '公孙', '丙': '内关', '丁': '公孙', '戊': '公孙',
    '己': '公孙', '庚': '外关', '辛': '公孙', '壬': '外关', '癸': '公孙',
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
        '开穴穴位': feiTengBaFa[dayGan]?['日'] ?? '公孙',
        '开时穴位': feiTengBaFa[dayGan]?['时'] ?? '内关',
        '八卦方位': wuXingPosition[dayGan] ?? '公孙',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('飞腾八法'),
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
          backgroundColor: Colors.orange,
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
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('飞腾八法开穴结果', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange)),
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
            const Text('飞腾八法理论', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('飞腾八法是以天干配八卦，按时辰开穴的针法。', style: TextStyle(height: 1.6)),
            const SizedBox(height: 8),
            const Text('甲日公孙、乙日公孙、丙日内关、丁日公孙...', style: TextStyle(height: 1.6)),
            const SizedBox(height: 8),
            const Text('按日干开穴，按时干应穴，合而用之。', style: TextStyle(height: 1.6)),
          ],
        ),
      ),
    );
  }
}
