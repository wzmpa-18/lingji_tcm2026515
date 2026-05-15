import 'package:flutter/material.dart';

class MaitaiScreen extends StatefulWidget {
  const MaitaiScreen({super.key});

  @override
  State<MaitaiScreen> createState() => _MaitaiScreenState();
}

class _MaitaiScreenState extends State<MaitaiScreen> {
  final TextEditingController _yearController = TextEditingController(text: '2026');
  final TextEditingController _monthController = TextEditingController(text: '5');
  final TextEditingController _dayController = TextEditingController(text: '13');
  final TextEditingController _hourController = TextEditingController(text: '10');

  Map<String, String> result = {};
  String? selectedHexagram;
  String? selectedGua;

  final List<String> ganList = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
  final List<String> zhiList = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

  final Map<String, Map<String, String>> hexagrams = {
    '乾': {'上': '乾', '下': '乾', '卦辞': '元亨利贞', '象': '天行健，君子以自强不息'},
    '坤': {'上': '坤', '下': '坤', '卦辞': '元亨利牝马之贞', '象': '地势坤，君子以厚德载物'},
    '屯': {'上': '坎', '下': '震', '卦辞': '元亨利贞，勿用有攸往', '象': '云雷屯，君子以经纶'},
    '蒙': {'上': '艮', '下': '坎', '卦辞': '亨，匪我求童蒙，童蒙求我', '象': '山下出泉，蒙'},
    '需': {'上': '坎', '下': '乾', '卦辞': '有孚，光亨贞吉', '象': '云上于天，需'},
    '讼': {'上': '乾', '下': '坎', '卦辞': '有孚，窒惕，中吉终凶', '象': '天与水违行，讼'},
    '师': {'上': '坤', '下': '坎', '卦辞': '贞，丈人吉，无咎', '象': '地中有水，师'},
    '比': {'上': '坎', '下': '坤', '卦辞': '吉，原筮元永贞', '象': '地上有水，比'},
    '小畜': {'上': '巽', '下': '乾', '卦辞': '亨，密云不雨', '象': '风行天上，小畜'},
    '履': {'上': '乾', '下': '兑', '卦辞': '亨，履虎尾，不咥人', '象': '上天下泽，履'},
  };

  final Map<String, List<String>> yaoMeaning = {
    '初爻': '事物的萌芽阶段',
    '二爻': '事物的初步发展',
    '三爻': '事物的发展阶段',
    '四爻': '事物接近成功',
    '五爻': '事物成功阶段',
    '上爻': '事物的终极状态',
  };

  void _calculate() {
    final year = int.tryParse(_yearController.text) ?? 2026;
    final month = int.tryParse(_monthController.text) ?? 5;
    final day = int.tryParse(_dayController.text) ?? 13;
    final hour = int.tryParse(_hourController.text) ?? 10;

    final dayGanIndex = (year - 1984) % 10;
    final dayZhiIndex = (year - 1984) % 12;

    final dayGan = ganList[dayGanIndex >= 0 ? dayGanIndex : dayGanIndex + 10];
    final dayZhi = zhiList[dayZhiIndex >= 0 ? dayZhiIndex : dayZhiIndex + 12];

    final timeZhiIndex = (hour / 2).floor() % 12;
    final timeZhi = zhiList[timeZhiIndex];

    final timeGanIndex = (dayGanIndex + dayZhiIndex) % 10;
    final timeGan = ganList[timeGanIndex >= 0 ? timeGanIndex : timeGanIndex + 10];

    final hexagramNames = hexagrams.keys.toList();
    final upperIndex = dayZhiIndex % 8;
    final lowerIndex = timeZhiIndex % 8;

    final upperGua = ['乾', '兑', '离', '震', '巽', '坎', '艮', '坤'][upperIndex];
    final lowerGua = ['乾', '兑', '离', '震', '巽', '坎', '艮', '坤'][lowerIndex];

    final guaKey = '$lowerGua$upperGua';
    final hexagram = hexagrams[guaKey] ?? hexagrams['乾']!;

    setState(() {
      result = {
        '年柱': '$dayGan$dayZhi',
        '月柱': '待定',
        '日柱': '$dayGan$dayZhi',
        '时柱': '$timeGan$timeZhi',
        '上卦': upperGua,
        '下卦': lowerGua,
        '卦辞': hexagram['卦辞'] ?? '',
        '象辞': hexagram['象'] ?? '',
      };
      selectedHexagram = guaKey;
      selectedGua = guaKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('梅花易数'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInputCard(),
          _buildCalculateButton(),
          if (result.isNotEmpty) _buildResultCard(),
          _buildTheoryCard(),
          _buildHexagramList(),
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
            const Text('输入生辰', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('起卦', style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 2,
      color: Colors.teal.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('梅花卦象：$selectedHexagram', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
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
            const Text('梅花易数理论', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('梅花易数以先天八卦为本，取年月日时之数起卦。', style: TextStyle(height: 1.6)),
            const SizedBox(height: 8),
            const Text('乾一、兑二、离三、震四、巽五、坎六、艮七、坤八', style: TextStyle(height: 1.6)),
            const SizedBox(height: 8),
            const Text('以数起卦，以卦象分析事物发展趋势。', style: TextStyle(height: 1.6)),
          ],
        ),
      ),
    );
  }

  Widget _buildHexagramList() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('六十四卦表', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
              ),
              itemCount: hexagrams.length,
              itemBuilder: (context, index) {
                final name = hexagrams.keys.toList()[index];
                return InkWell(
                  onTap: () => _showHexagramDetail(name),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: selectedGua == name ? Colors.teal.shade100 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold))),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showHexagramDetail(String name) {
    final hex = hexagrams[name];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('卦象：$name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('上卦：${hex?['上']}'),
            Text('下卦：${hex?['下']}'),
            Text('卦辞：${hex?['卦辞']}'),
            Text('象辞：${hex?['象']}'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('关闭'))],
      ),
    );
  }
}
