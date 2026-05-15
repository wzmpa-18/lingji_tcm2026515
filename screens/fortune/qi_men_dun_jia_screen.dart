import 'package:flutter/material.dart';

class QiMenDunJiaScreen extends StatefulWidget {
  const QiMenDunJiaScreen({super.key});

  @override
  State<QiMenDunJiaScreen> createState() => _QiMenDunJiaScreenState();
}

class _QiMenDunJiaScreenState extends State<QiMenDunJiaScreen> {
  final TextEditingController _yearController = TextEditingController(text: '2026');
  final TextEditingController _monthController = TextEditingController(text: '5');
  final TextEditingController _dayController = TextEditingController(text: '12');
  final TextEditingController _hourController = TextEditingController(text: '10');

  bool isFeiPan = true;
  String? selectedGua;

  final Map<String, List<String>> cangGan = {
    '子': ['癸'], '丑': ['己', '辛', '癸'], '寅': ['甲', '丙', '戊'], '卯': ['乙'],
    '辰': ['戊', '乙', '癸'], '巳': ['丙', '戊', '庚'], '午': ['丁', '己'], '未': ['己', '丁', '乙'],
    '申': ['庚', '壬', '戊'], '酉': ['辛'], '戌': ['戊', '辛', '丁'], '亥': ['壬', '甲'],
  };

  final List<String> baGua = ['坎', '艮', '震', '巽', '离', '坤', '兑', '乾'];
  final List<String> tianPan = ['蓬', '任', '冲', '辅', '英', '芮', '柱', '心'];
  final List<String> diPan = ['休', '生', '伤', '杜', '景', '死', '惊', '开'];
  final List<String> baShen = ['玄武', '白虎', '螣蛇', '太阴', '六合', '勾陈', '朱雀', '青龙'];
  final List<String> gongNames = ['一宫', '二宫', '三宫', '四宫', '五宫', '六宫', '七宫', '八宫'];

  final Map<String, Map<String, String>> shensha = {
    '值符': {'desc': '百神之主', 'category': '吉神'},
    '螣蛇': {'desc': '惊恐虚惊', 'category': '凶神'},
    '太阴': {'desc': '阴私庇护', 'category': '吉神'},
    '六合': {'desc': '和合婚姻', 'category': '吉神'},
    '白虎': {'desc': '凶丧血光', 'category': '凶神'},
    '玄武': {'desc': '盗贼阴私', 'category': '凶神'},
    '九地': {'desc': '柔顺固守', 'category': '吉神'},
    '九天': {'desc': '刚健变动', 'category': '吉神'},
    '生门': {'desc': '生机财源', 'category': '吉门'},
    '伤门': {'desc': '伤害灾祸', 'category': '凶门'},
    '杜门': {'desc': '阻塞隐蔽', 'category': '中性'},
    '景门': {'desc': '文书信息', 'category': '中性'},
    '死门': {'desc': '死亡凶事', 'category': '凶门'},
    '惊门': {'desc': '惊恐口舌', 'category': '凶门'},
    '开门': {'desc': '开放事业', 'category': '吉门'},
    '休门': {'desc': '休养贵人', 'category': '吉门'},
    '天蓬': {'desc': '破财盗匪', 'category': '凶星'},
    '天任': {'desc': '担当守信', 'category': '吉星'},
    '天冲': {'desc': '冲动果断', 'category': '中性'},
    '天辅': {'desc': '辅弼文教', 'category': '吉星'},
    '天英': {'desc': '明星火光', 'category': '中性'},
    '天芮': {'desc': '疾病问题', 'category': '凶星'},
    '天柱': {'desc': '折损惊恐', 'category': '凶星'},
    '天心': {'desc': '心机周密', 'category': '吉星'},
  };

  void _showGuaDetail(int index) {
    setState(() {
      selectedGua = baGua[index];
    });
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${baGua[index]}宫详情', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [const Text('天盘'), Text(tianPan[index], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red))]),
                Column(children: [const Text('地盘'), Text(diPan[index], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))]),
                Column(children: [const Text('八神'), Text(baShen[index], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple))]),
              ],
            ),
            const SizedBox(height: 16),
            const Text('藏干：', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildCangGanDisplay(index),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCangGanDisplay(int index) {
    final zhiList = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申'];
    final diZhi = zhiList[index];
    final cangGanList = cangGan[diZhi] ?? [];

    return Wrap(
      spacing: 8,
      children: cangGanList.map((gan) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(gan, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('奇门遁甲'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildBaziInput(),
          _buildPanTypeToggle(),
          _buildPanInfo(),
          _buildPanDisplay(),
          _buildBaShenSection(),
          _buildMenPaSection(),
        ],
      ),
    );
  }

  Widget _buildBaziInput() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('八字输入', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGanZhiDisplay('年干支', '丙', '午'),
                _buildGanZhiDisplay('月干支', '癸', '巳'),
                _buildGanZhiDisplay('日干支', '丙', '戌'),
                _buildGanZhiDisplay('时干支', '甲', '午'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGanZhiDisplay(String label, String gan, String zhi) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        Row(
          children: [
            Text(gan, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            Text(zhi, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildPanTypeToggle() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => isFeiPan = true),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isFeiPan ? Colors.blue : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '飞盘',
                      style: TextStyle(color: isFeiPan ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => isFeiPan = false),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: !isFeiPan ? Colors.blue : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '转盘',
                      style: TextStyle(color: !isFeiPan ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanInfo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '奇门遁甲 · ${isFeiPan ? '飞盘' : '转盘'}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoItem('值符', '天英'),
                _buildInfoItem('值使', '景门'),
                _buildInfoItem('值坤', '芮'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildPanDisplay() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('九宫格 · 点击查看藏干', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                final gua = baGua[index];
                final tian = tianPan[index];
                final di = diPan[index];
                final shen = baShen[index];

                return InkWell(
                  onTap: () => _showGuaDetail(index),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: selectedGua == gua ? Colors.orange : Colors.blue),
                      borderRadius: BorderRadius.circular(8),
                      color: selectedGua == gua ? Colors.orange.shade50 : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(gongNames[index], style: TextStyle(color: Colors.grey[600], fontSize: 10)),
                        Text(gua, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(tian, style: TextStyle(color: Colors.red[800], fontSize: 12)),
                        Text(di, style: TextStyle(color: Colors.green[800], fontSize: 12)),
                        Text(shen, style: TextStyle(color: Colors.purple[800], fontSize: 10)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBaShenSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('八神', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: shensha.entries.where((e) => e.key.length == 2 && ['值符', '螣蛇', '太阴', '六合', '白虎', '玄武', '九地', '九天'].contains(e.key)).map((e) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: e.value['category'] == '吉神' ? Colors.green.shade50 : Colors.red.shade50,
                    border: Border.all(color: e.value['category'] == '吉神' ? Colors.green : Colors.red),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      Text(e.key, style: TextStyle(fontWeight: FontWeight.bold, color: e.value['category'] == '吉神' ? Colors.green : Colors.red)),
                      Text(e.value['desc']!, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenPaSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('八门', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildMenCategory('吉门', Colors.green, ['生门', '休门', '开门']),
            _buildMenCategory('中性门', Colors.orange, ['景门', '杜门']),
            _buildMenCategory('凶门', Colors.red, ['伤门', '死门', '惊门']),
          ],
        ),
      ),
    );
  }

  Widget _buildMenCategory(String title, Color color, List<String> menList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: menList.map((men) {
            final info = shensha[men] ?? {};
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.shade50,
                border: Border.all(color: color),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  Text(men, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                  Text(info['desc'] ?? '', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
