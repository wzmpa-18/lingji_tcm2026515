import 'package:flutter/material.dart';

class ZiWuLiuZhuScreen extends StatefulWidget {
  const ZiWuLiuZhuScreen({super.key});

  @override
  State<ZiWuLiuZhuScreen> createState() => _ZiWuLiuZhuScreenState();
}

class _ZiWuLiuZhuScreenState extends State<ZiWuLiuZhuScreen> {
  final TextEditingController _yearController = TextEditingController(text: '2026');
  final TextEditingController _monthController = TextEditingController(text: '5');
  final TextEditingController _dayController = TextEditingController(text: '13');
  final TextEditingController _hourController = TextEditingController(text: '10');

  Map<String, String> result = {};

  final List<String> ganList = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
  final List<String> zhiList = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

  final List<String> zhuYinChannels = [
    '胆', '肝', '小肠', '心', '胃', '脾', '大肠', '肺', '膀胱', '肾', '三焦', '心包'
  ];

  final List<String> luZhuChannels = [
    '肺', '大肠', '胃', '脾', '心', '小肠', '膀胱', '肾', '心包', '三焦', '胆', '肝'
  ];

  final Map<String, List<String>> yuanYingShu = {
    '胆': ['窍阴', '侠溪', '临泣', '丘墟', '阳辅', '阳陵泉'],
    '肝': ['大敦', '行间', '太冲', '中封', '曲泉', '期门'],
    '小肠': ['少泽', '前谷', '后溪', '腕骨', '阳谷', '小海'],
    '心': ['少冲', '少府', '神门', '灵道', '少海', '极泉'],
    '胃': ['厉兑', '内庭', '陷谷', '冲阳', '解溪', '足三里'],
    '脾': ['隐白', '大都', '太白', '商丘', '阴陵泉', '章门'],
    '大肠': ['商阳', '二间', '三间', '合谷', '阳溪', '曲池'],
    '肺': ['少商', '鱼际', '太渊', '经渠', '尺泽', '中府'],
    '膀胱': ['至阴', '通谷', '束骨', '京骨', '昆仑', '委中'],
    '肾': ['涌泉', '然谷', '太溪', '大钟', '复溜', '阴谷'],
    '三焦': ['关冲', '液门', '中渚', '阳池', '支沟', '天井'],
    '心包': ['中冲', '劳宫', '大陵', '间使', '曲泽', '天池'],
  };

  final Map<String, String> yingZhuPoint = {
    '甲': '合谷', '乙': '太冲', '丙': '小海', '丁': '神门', '戊': '厉兑', '己': '隐白',
    '庚': '商阳', '辛': '少商', '壬': '至阴', '癸': '涌泉',
  };

  final Map<String, String> shuYinPoint = {
    '甲': '小肠', '乙': '肝', '丙': '心', '丁': '心包', '戊': '胃', '己': '脾',
    '庚': '大肠', '辛': '肺', '壬': '膀胱', '癸': '肾',
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

    final timeZhiIndex = (hour ~/ 2) % 12;
    final timeZhi = zhiList[timeZhiIndex];

    final zhuYin = zhuYinChannels[dayGanIndex];
    final luZhu = luZhuChannels[timeZhiIndex];

    final yuanYingShuPoints = yuanYingShu[shuYinPoint[dayGan]] ?? [];

    setState(() {
      result = {
        '日期': '$year年$month月$day日',
        '星期': dayName,
        '日干': dayGan,
        '日支': dayZhi,
        '时支': timeZhi,
        '纳甲日穴': shuYinPoint[dayGan] ?? zhuYin,
        '纳子时辰': shuYinPoint[ganList[(dayGanIndex * 2) % 10]] ?? luZhu,
        '应开穴位': yingZhuPoint[dayGan] ?? yuanYingShuPoints.first,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('子午流注'),
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
          backgroundColor: Colors.purple,
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
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('子午流注开穴结果', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple)),
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
            const Text('子午流注理论', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('子午流注是中医针灸按时开穴的一种方法，以十二正经配合十二地支，按时辰开穴。', style: TextStyle(height: 1.6)),
            const SizedBox(height: 8),
            const Text('纳甲法：按日干开穴，阳经开井穴，阴经开井荥穴', style: TextStyle(height: 1.6)),
            const SizedBox(height: 8),
            const Text('纳子法：按时辰配穴，虚则补其母，实则泻其子', style: TextStyle(height: 1.6)),
            const SizedBox(height: 8),
            const Text('子午流注遵循气血按时循行规律，配合天干地支开穴。', style: TextStyle(height: 1.6)),
          ],
        ),
      ),
    );
  }
}
