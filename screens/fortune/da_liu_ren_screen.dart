import 'package:flutter/material.dart';

class DaLiuRenScreen extends StatefulWidget {
  const DaLiuRenScreen({super.key});

  @override
  State<DaLiuRenScreen> createState() => _DaLiuRenScreenState();
}

class _DaLiuRenScreenState extends State<DaLiuRenScreen> {
  final TextEditingController _yearController = TextEditingController(text: '2026');
  final TextEditingController _monthController = TextEditingController(text: '5');
  final TextEditingController _dayController = TextEditingController(text: '12');
  final TextEditingController _hourController = TextEditingController(text: '10');

  String? selectedDiZhi;
  bool showShensha = true;

  final Map<String, List<String>> cangGan = {
    '子': ['癸'], '丑': ['己', '辛', '癸'], '寅': ['甲', '丙', '戊'], '卯': ['乙'],
    '辰': ['戊', '乙', '癸'], '巳': ['丙', '戊', '庚'], '午': ['丁', '己'], '未': ['己', '丁', '乙'],
    '申': ['庚', '壬', '戊'], '酉': ['辛'], '戌': ['戊', '辛', '丁'], '亥': ['壬', '甲'],
  };

  final Map<String, Map<String, String>> shiErChangSheng = {
    '甲': {'长生': '亥', '沐浴': '子', '冠带': '丑', '临官': '寅', '帝旺': '卯', '衰': '辰', '病': '巳', '死': '午', '墓': '未', '绝': '申', '胎': '酉', '养': '戌'},
    '丙': {'长生': '寅', '沐浴': '卯', '冠带': '辰', '临官': '巳', '帝旺': '午', '衰': '未', '病': '申', '死': '酉', '墓': '戌', '绝': '亥', '胎': '子', '养': '丑'},
    '戊': {'长生': '寅', '沐浴': '卯', '冠带': '辰', '临官': '巳', '帝旺': '午', '衰': '未', '病': '申', '死': '酉', '墓': '戌', '绝': '亥', '胎': '子', '养': '丑'},
    '庚': {'长生': '巳', '沐浴': '午', '冠带': '未', '临官': '申', '帝旺': '酉', '衰': '戌', '病': '亥', '死': '子', '墓': '丑', '绝': '寅', '胎': '卯', '养': '辰'},
    '壬': {'长生': '申', '沐浴': '酉', '冠带': '戌', '临官': '亥', '帝旺': '子', '衰': '丑', '病': '寅', '死': '卯', '墓': '辰', '绝': '巳', '胎': '午', '养': '未'},
    '乙': {'长生': '午', '沐浴': '巳', '冠带': '辰', '临官': '卯', '帝旺': '寅', '衰': '丑', '病': '子', '死': '亥', '墓': '戌', '绝': '酉', '胎': '申', '养': '未'},
    '丁': {'长生': '酉', '沐浴': '申', '冠带': '未', '临官': '午', '帝旺': '巳', '衰': '辰', '病': '卯', '死': '寅', '墓': '丑', '绝': '子', '胎': '亥', '养': '戌'},
    '己': {'长生': '酉', '沐浴': '申', '冠带': '未', '临官': '午', '帝旺': '巳', '衰': '辰', '病': '卯', '死': '寅', '墓': '丑', '绝': '子', '胎': '亥', '养': '戌'},
    '辛': {'长生': '子', '沐浴': '亥', '冠带': '戌', '临官': '酉', '帝旺': '申', '衰': '未', '病': '午', '死': '巳', '墓': '辰', '绝': '卯', '胎': '寅', '养': '丑'},
    '癸': {'长生': '卯', '沐浴': '寅', '冠带': '丑', '临官': '子', '帝旺': '亥', '衰': '戌', '病': '酉', '死': '申', '墓': '未', '绝': '午', '胎': '巳', '养': '辰'},
  };

  final Map<String, String> tianPan = {
    '子': '辰', '丑': '巳', '寅': '午', '卯': '未', '辰': '申', '巳': '酉',
    '午': '戌', '未': '亥', '申': '子', '酉': '丑', '戌': '寅', '亥': '卯',
  };

  final Map<String, String> shen = {
    '子': '贵', '丑': '后', '寅': '阴', '卯': '玄', '辰': '常', '巳': '虎',
    '午': '空', '未': '龙', '申': '勾', '酉': '合', '戌': '蛇', '亥': '朱',
  };

  final Map<String, String> diZhiPositions = {
    '子': '北方', '丑': '东北', '寅': '东北', '卯': '东方',
    '辰': '东南', '巳': '东南', '午': '南方', '未': '西南',
    '申': '西南', '酉': '西方', '戌': '西北', '亥': '西北',
  };

  final Map<String, Map<String, String>> daLiuRenShensha = {
    '贵人': {'desc': '官禄吉神', 'category': '吉神'},
    '螣蛇': {'desc': '惊恐怪异', 'category': '凶神'},
    '朱雀': {'desc': '口舌文书', 'category': '凶神'},
    '六合': {'desc': '和合婚姻', 'category': '吉神'},
    '勾陈': {'desc': '田宅牵连', 'category': '中性'},
    '青龙': {'desc': '喜庆吉神', 'category': '吉神'},
    '天空': {'desc': '虚伪空亡', 'category': '凶神'},
    '白虎': {'desc': '凶丧血光', 'category': '凶神'},
    '太常': {'desc': '宴会酒食', 'category': '吉神'},
    '玄武': {'desc': '盗贼阴私', 'category': '凶神'},
    '太阴': {'desc': '阴私女人', 'category': '吉神'},
    '天后': {'desc': '恩泽庇护', 'category': '吉神'},
    '日德': {'desc': '日德吉神', 'category': '吉神'},
    '日合': {'desc': '日合吉神', 'category': '吉神'},
    '日禄': {'desc': '日禄吉神', 'category': '吉神'},
    '日马': {'desc': '日马吉神', 'category': '吉神'},
    '日盗': {'desc': '日盗凶神', 'category': '凶神'},
    '日鬼': {'desc': '日鬼凶神', 'category': '凶神'},
    '日墓': {'desc': '日墓凶神', 'category': '凶神'},
    '日绝': {'desc': '日绝凶神', 'category': '凶神'},
    '生气': {'desc': '生气吉神', 'category': '吉神'},
    '死气': {'desc': '死气凶神', 'category': '凶神'},
    '旺气': {'desc': '旺气吉神', 'category': '吉神'},
    '相气': {'desc': '相气吉神', 'category': '吉神'},
    '休气': {'desc': '休气凶神', 'category': '凶神'},
    '囚气': {'desc': '囚气凶神', 'category': '凶神'},
    '驿马': {'desc': '驿马吉神', 'category': '吉神'},
    '桃花': {'desc': '桃花吉神', 'category': '吉神'},
    '劫煞': {'desc': '劫煞凶神', 'category': '凶神'},
    '灾煞': {'desc': '灾煞凶神', 'category': '凶神'},
    '岁煞': {'desc': '岁煞凶神', 'category': '凶神'},
    '月煞': {'desc': '月煞凶神', 'category': '凶神'},
    '三合': {'desc': '三合吉神', 'category': '吉神'},
    '长生': {'desc': '长生吉神', 'category': '吉神'},
    '沐浴': {'desc': '沐浴凶神', 'category': '凶神'},
    '冠带': {'desc': '冠带吉神', 'category': '吉神'},
    '临官': {'desc': '临官吉神', 'category': '吉神'},
    '帝旺': {'desc': '帝旺吉神', 'category': '吉神'},
    '衰': {'desc': '衰凶神', 'category': '凶神'},
    '病': {'desc': '病凶神', 'category': '凶神'},
    '死': {'desc': '死凶神', 'category': '凶神'},
    '墓': {'desc': '墓凶神', 'category': '凶神'},
    '绝': {'desc': '绝凶神', 'category': '凶神'},
    '胎': {'desc': '胎吉神', 'category': '吉神'},
    '养': {'desc': '养吉神', 'category': '吉神'},
    '天喜': {'desc': '天喜吉神', 'category': '吉神'},
    '天恩': {'desc': '天恩吉神', 'category': '吉神'},
    '天官': {'desc': '天官吉神', 'category': '吉神'},
    '天福': {'desc': '天福吉神', 'category': '吉神'},
    '天贼': {'desc': '天贼凶神', 'category': '凶神'},
    '天狱': {'desc': '天狱凶神', 'category': '凶神'},
    '天刑': {'desc': '天刑凶神', 'category': '凶神'},
    '岁德': {'desc': '岁德吉神', 'category': '吉神'},
    '岁合': {'desc': '岁合吉神', 'category': '吉神'},
    '岁禄': {'desc': '岁禄吉神', 'category': '吉神'},
    '月德': {'desc': '月德吉神', 'category': '吉神'},
    '月合': {'desc': '月合吉神', 'category': '吉神'},
    '月禄': {'desc': '月禄吉神', 'category': '吉神'},
    '干德': {'desc': '干德吉神', 'category': '吉神'},
    '支德': {'desc': '支德吉神', 'category': '吉神'},
    '害': {'desc': '相害凶神', 'category': '凶神'},
    '刑': {'desc': '相刑凶神', 'category': '凶神'},
    '冲': {'desc': '相冲凶神', 'category': '凶神'},
    '破': {'desc': '相破凶神', 'category': '凶神'},
    '空': {'desc': '空亡凶神', 'category': '凶神'},
    '禄': {'desc': '临官吉神', 'category': '吉神'},
    '马': {'desc': '驿马吉神', 'category': '吉神'},
    '印': {'desc': '印绶吉神', 'category': '吉神'},
    '学堂': {'desc': '学堂吉神', 'category': '吉神'},
    '词馆': {'desc': '词馆吉神', 'category': '吉神'},
    '金堂': {'desc': '金堂吉神', 'category': '吉神'},
    '玉堂': {'desc': '玉堂吉神', 'category': '吉神'},
    '血支': {'desc': '血支凶神', 'category': '凶神'},
    '血忌': {'desc': '血忌凶神', 'category': '凶神'},
    '天马': {'desc': '天马吉神', 'category': '吉神'},
    '丧门': {'desc': '丧门凶神', 'category': '凶神'},
    '吊客': {'desc': '吊客凶神', 'category': '凶神'},
    '白虎煞': {'desc': '白虎凶煞', 'category': '凶神'},
    '官符': {'desc': '官符凶神', 'category': '凶神'},
    '龙德': {'desc': '龙德吉神', 'category': '吉神'},
    '福德': {'desc': '福德吉神', 'category': '吉神'},
    '丧车': {'desc': '丧车凶神', 'category': '凶神'},
    '五鬼': {'desc': '五鬼凶神', 'category': '凶神'},
    '阴错': {'desc': '阴错凶神', 'category': '凶神'},
    '阳错': {'desc': '阳错凶神', 'category': '凶神'},
    '红艳': {'desc': '红艳煞', 'category': '凶神'},
    '寡宿': {'desc': '寡宿凶神', 'category': '凶神'},
    '孤辰': {'desc': '孤辰凶神', 'category': '凶神'},
    '三刑': {'desc': '三刑凶神', 'category': '凶神'},
    '自刑': {'desc': '自刑凶神', 'category': '凶神'},
    '六仪': {'desc': '六仪吉神', 'category': '吉神'},
    '将星': {'desc': '将星吉神', 'category': '吉神'},
    '华盖': {'desc': '华盖吉神', 'category': '吉神'},
    '文昌': {'desc': '文昌吉神', 'category': '吉神'},
  };

  void _showDiZhiDetail(String diZhi) {
    setState(() {
      selectedDiZhi = diZhi;
    });
  }

  String _getShiErChangShengForRiGan(String diZhi) {
    const riGan = '丙';
    if (shiErChangSheng.containsKey(riGan)) {
      for (var entry in shiErChangSheng[riGan]!.entries) {
        if (entry.value == diZhi) {
          return entry.key;
        }
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('大六壬 · 袖中金'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildBaziInput(),
          _buildHeader(),
          _buildShiErChangShengTable(),
          _buildTianDiPan(),
          _buildSiKe(),
          _buildShenshaSection(),
          if (selectedDiZhi != null) _buildDiZhiDetailCard(),
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

  Widget _buildHeader() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            Text('大六壬 · 袖中金', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('适用年份：1600-2200', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildShiErChangShengTable() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('十二长生表（日元：丙）', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('状态')),
                  DataColumn(label: Text('地支')),
                ],
                rows: [
                  for (var entry in shiErChangSheng['丙']!.entries)
                    DataRow(cells: [
                      DataCell(Text(entry.key)),
                      DataCell(Text(entry.value)),
                    ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTianDiPan() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('天地盘 · 点击查看藏干', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final diZhiList = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];
                final diZhi = diZhiList[index];
                final tian = tianPan[diZhi]!;
                final shenName = shen[diZhi]!;
                final sheng = _getShiErChangShengForRiGan(diZhi);

                return InkWell(
                  onTap: () => _showDiZhiDetail(diZhi),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: selectedDiZhi == diZhi ? Colors.orange : Colors.blue),
                      borderRadius: BorderRadius.circular(8),
                      color: selectedDiZhi == diZhi ? Colors.orange.shade50 : null,
                    ),
                    child: Column(
                      children: [
                        Text(shenName, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(tian, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                        const SizedBox(height: 4),
                        Text(diZhi, style: const TextStyle(fontSize: 14, color: Colors.blue)),
                        if (sheng.isNotEmpty) Text(sheng, style: const TextStyle(fontSize: 10, color: Colors.orange)),
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

  Widget _buildSiKe() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('四课', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Table(
              border: TableBorder.all(),
              children: [
                TableRow(
                  children: [
                    for (int i = 1; i <= 4; i++)
                      TableCell(child: Center(child: Text('第$i课'))),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(child: Center(child: Column(children: [Text('合', style: const TextStyle(fontSize: 10)), Text('申'), Text('丙')]))),
                    TableCell(child: Center(child: Column(children: [Text('贵', style: const TextStyle(fontSize: 10)), Text('亥'), Text('申')]))),
                    TableCell(child: Center(child: Column(children: [Text('阴', style: const TextStyle(fontSize: 10)), Text('丑'), Text('戌')]))),
                    TableCell(child: Center(child: Column(children: [Text('虎', style: const TextStyle(fontSize: 10)), Text('辰'), Text('丑')]))),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShenshaSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('神煞大全（共${daLiuRenShensha.length}种）', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Switch(value: showShensha, onChanged: (v) => setState(() => showShensha = v)),
              ],
            ),
            if (showShensha) ...[
              const SizedBox(height: 12),
              _buildShenshaCategory('吉神', Colors.green),
              _buildShenshaCategory('凶神', Colors.red),
              _buildShenshaCategory('中性', Colors.orange),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildShenshaCategory(String category, Color color) {
    final items = daLiuRenShensha.entries.where((e) => e.value['category'] == category).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((e) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.shade50,
                border: Border.all(color: color),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  Text(e.key, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 12)),
                  Text(e.value['desc']!, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildDiZhiDetailCard() {
    return Card(
      elevation: 4,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('地支详情：$selectedDiZhi', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() => selectedDiZhi = null)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [const Text('方位'), Text(diZhiPositions[selectedDiZhi!]!, style: const TextStyle(fontWeight: FontWeight.bold))]),
                Column(children: [const Text('天盘'), Text(tianPan[selectedDiZhi!]!, style: const TextStyle(fontWeight: FontWeight.bold))]),
                Column(children: [const Text('神'), Text(shen[selectedDiZhi!]!, style: const TextStyle(fontWeight: FontWeight.bold))]),
                Column(children: [const Text('十二长生'), Text(_getShiErChangShengForRiGan(selectedDiZhi!), style: const TextStyle(fontWeight: FontWeight.bold))]),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('藏干：', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: (cangGan[selectedDiZhi!] ?? []).map((gan) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                      child: Text(gan, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
