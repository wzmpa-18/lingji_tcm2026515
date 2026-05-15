import 'package:flutter/material.dart';

class LiuYaoScreen extends StatefulWidget {
  const LiuYaoScreen({super.key});

  @override
  State<LiuYaoScreen> createState() => _LiuYaoScreenState();
}

class _LiuYaoScreenState extends State<LiuYaoScreen> {
  final TextEditingController _yearController = TextEditingController(text: '2026');
  final TextEditingController _monthController = TextEditingController(text: '5');
  final TextEditingController _dayController = TextEditingController(text: '12');
  final TextEditingController _hourController = TextEditingController(text: '10');

  String? selectedYao;
  bool showShensha = true;

  final List<String> ganList = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
  final List<String> zhiList = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

  final Map<String, List<String>> cangGan = {
    '子': ['癸'], '丑': ['己', '辛', '癸'], '寅': ['甲', '丙', '戊'], '卯': ['乙'],
    '辰': ['戊', '乙', '癸'], '巳': ['丙', '戊', '庚'], '午': ['丁', '己'], '未': ['己', '丁', '乙'],
    '申': ['庚', '壬', '戊'], '酉': ['辛'], '戌': ['戊', '辛', '丁'], '亥': ['壬', '甲'],
  };

  final List<String> yaoNames = ['初爻', '二爻', '三爻', '四爻', '五爻', '上爻'];
  final List<String> yaoGua = ['⚋', '⚊', '⚋', '⚊', '⚋', '⚊'];

  final Map<String, Map<String, String>> liuyaoShensha = {
    '初爻': {'liuqin': '子孙', 'shensha': '日建,月建,长生'},
    '二爻': {'liuqin': '妻财', 'shensha': '日合,月合'},
    '三爻': {'liuqin': '官鬼', 'shensha': '日冲,月冲'},
    '四爻': {'liuqin': '官鬼', 'shensha': '日墓,月墓'},
    '五爻': {'liuqin': '父母', 'shensha': '日绝,月绝'},
    '上爻': {'liuqin': '父母', 'shensha': '日破,月破'},
  };

  final Map<String, Map<String, String>> allShensha = {
    '青龙': {'desc': '喜庆、吉利', 'category': '吉神'},
    '白虎': {'desc': '凶丧、血光', 'category': '凶神'},
    '朱雀': {'desc': '口舌、文书', 'category': '凶神'},
    '玄武': {'desc': '盗贼、阴私', 'category': '凶神'},
    '勾陈': {'desc': '田宅、牵连', 'category': '中性'},
    '螣蛇': {'desc': '虚惊、怪异', 'category': '凶神'},
    '六合': {'desc': '和合、婚姻', 'category': '吉神'},
    '官鬼': {'desc': '官职、鬼祟', 'category': '中性'},
    '父母': {'desc': '父母、文书', 'category': '中性'},
    '兄弟': {'desc': '兄弟、竞争', 'category': '中性'},
    '子孙': {'desc': '子孙、福德', 'category': '吉神'},
    '妻财': {'desc': '妻财、物资', 'category': '中性'},
    '驿马': {'desc': '出行、变动', 'category': '吉神'},
    '桃花': {'desc': '感情、姻缘', 'category': '吉神'},
    '贵人': {'desc': '贵人、扶持', 'category': '吉神'},
    '三合': {'desc': '三合、会局', 'category': '吉神'},
    '进神': {'desc': '进取、向前', 'category': '吉神'},
    '退神': {'desc': '后退、保守', 'category': '凶神'},
    '伏神': {'desc': '伏藏、待发', 'category': '中性'},
    '动爻': {'desc': '发动、变化', 'category': '中性'},
    '变爻': {'desc': '变化、转变', 'category': '中性'},
    '日建': {'desc': '当日之建', 'category': '吉神'},
    '月建': {'desc': '当月之建', 'category': '吉神'},
    '日破': {'desc': '当日之破', 'category': '凶神'},
    '月破': {'desc': '当月之破', 'category': '凶神'},
    '日害': {'desc': '日支相害', 'category': '凶神'},
    '月害': {'desc': '月支相害', 'category': '凶神'},
    '日刑': {'desc': '日支相刑', 'category': '凶神'},
    '月刑': {'desc': '月支相刑', 'category': '凶神'},
    '日冲': {'desc': '日支相冲', 'category': '凶神'},
    '月冲': {'desc': '月支相冲', 'category': '凶神'},
    '三刑': {'desc': '三刑之煞', 'category': '凶神'},
    '自刑': {'desc': '自相刑伤', 'category': '凶神'},
    '天喜': {'desc': '天喜吉神', 'category': '吉神'},
    '天恩': {'desc': '天恩吉神', 'category': '吉神'},
    '天马': {'desc': '天马吉神', 'category': '吉神'},
    '丧门': {'desc': '丧事之煞', 'category': '凶神'},
    '吊客': {'desc': '吊客凶煞', 'category': '凶神'},
    '白虎煞': {'desc': '白虎凶煞', 'category': '凶神'},
    '丧车': {'desc': '丧车凶煞', 'category': '凶神'},
    '天贼': {'desc': '天贼凶煞', 'category': '凶神'},
    '五鬼': {'desc': '五鬼凶煞', 'category': '凶神'},
    '阴错': {'desc': '阴错凶煞', 'category': '凶神'},
    '阳错': {'desc': '阳错凶煞', 'category': '凶神'},
    '红艳': {'desc': '红艳煞', 'category': '凶神'},
    '天医': {'desc': '天医吉神', 'category': '吉神'},
    '地医': {'desc': '地医吉神', 'category': '吉神'},
    '解神': {'desc': '解神吉神', 'category': '吉神'},
    '圣心': {'desc': '圣心吉神', 'category': '吉神'},
    '天赦': {'desc': '天赦吉神', 'category': '吉神'},
    '生气': {'desc': '生气吉神', 'category': '吉神'},
    '死气': {'desc': '死气凶神', 'category': '凶神'},
    '囚狱': {'desc': '囚狱凶神', 'category': '凶神'},
    '天狱': {'desc': '天狱凶神', 'category': '凶神'},
    '地贼': {'desc': '地贼凶神', 'category': '凶神'},
    '天火': {'desc': '天火凶神', 'category': '凶神'},
    '朱雀煞': {'desc': '朱雀凶煞', 'category': '凶神'},
    '勾陈煞': {'desc': '勾陈凶煞', 'category': '凶神'},
    '螣蛇煞': {'desc': '螣蛇凶煞', 'category': '凶神'},
    '六合煞': {'desc': '六合凶煞', 'category': '凶神'},
    '岁破': {'desc': '岁破凶煞', 'category': '凶神'},
    '月破煞': {'desc': '月破凶煞', 'category': '凶神'},
    '大耗': {'desc': '大耗凶煞', 'category': '凶神'},
    '小耗': {'desc': '小耗凶煞', 'category': '凶神'},
    '的煞': {'desc': '的煞凶神', 'category': '凶神'},
    '天空': {'desc': '天空凶神', 'category': '凶神'},
    '官符': {'desc': '官符凶神', 'category': '凶神'},
    '龙德': {'desc': '龙德吉神', 'category': '吉神'},
    '福德': {'desc': '福德吉神', 'category': '吉神'},
    '寡宿': {'desc': '寡宿凶神', 'category': '凶神'},
    '孤辰': {'desc': '孤辰凶神', 'category': '凶神'},
    '六仪': {'desc': '六仪吉神', 'category': '吉神'},
    '将星': {'desc': '将星吉神', 'category': '吉神'},
    '华盖': {'desc': '华盖吉神', 'category': '吉神'},
    '文昌': {'desc': '文昌吉神', 'category': '吉神'},
    '学堂': {'desc': '学堂吉神', 'category': '吉神'},
    '词馆': {'desc': '词馆吉神', 'category': '吉神'},
    '金堂': {'desc': '金堂吉神', 'category': '吉神'},
    '玉堂': {'desc': '玉堂吉神', 'category': '吉神'},
    '血支': {'desc': '血支凶神', 'category': '凶神'},
    '血忌': {'desc': '血忌凶神', 'category': '凶神'},
    '劫煞': {'desc': '劫煞凶神', 'category': '凶神'},
    '灾煞': {'desc': '灾煞凶神', 'category': '凶神'},
    '岁煞': {'desc': '岁煞凶神', 'category': '凶神'},
    '月煞': {'desc': '月煞凶神', 'category': '凶神'},
    '干德': {'desc': '干德吉神', 'category': '吉神'},
    '支德': {'desc': '支德吉神', 'category': '吉神'},
    '日德': {'desc': '日德吉神', 'category': '吉神'},
    '日合': {'desc': '日合吉神', 'category': '吉神'},
    '日禄': {'desc': '日禄吉神', 'category': '吉神'},
    '日马': {'desc': '日马吉神', 'category': '吉神'},
    '日盗': {'desc': '日盗凶神', 'category': '凶神'},
    '日鬼': {'desc': '日鬼凶神', 'category': '凶神'},
    '日墓': {'desc': '日墓凶神', 'category': '凶神'},
    '日绝': {'desc': '日绝凶神', 'category': '凶神'},
    '岁德': {'desc': '岁德吉神', 'category': '吉神'},
    '岁合': {'desc': '岁合吉神', 'category': '吉神'},
    '岁禄': {'desc': '岁禄吉神', 'category': '吉神'},
    '月德': {'desc': '月德吉神', 'category': '吉神'},
    '月合': {'desc': '月合吉神', 'category': '吉神'},
    '月禄': {'desc': '月禄吉神', 'category': '吉神'},
  };

  void _showYaoDetail(int index) {
    setState(() {
      selectedYao = yaoNames[index];
    });
  }

  String _getCangGanForYao(int index) {
    final zhi = zhiList[index];
    return cangGan[zhi]?.join('、') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('六爻纳甲'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildBaziInput(),
          _buildGuaGua(),
          _buildLiuYaoDisplay(),
          _buildShenshaList(),
          if (selectedYao != null) _buildYaoDetailCard(),
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

  Widget _buildGuaGua() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('卦象', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('水雷屯', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                Column(
                  children: [
                    Text(yaoGua[0], style: const TextStyle(fontSize: 24)),
                    Text(yaoGua[1], style: const TextStyle(fontSize: 24)),
                    Text(yaoGua[2], style: const TextStyle(fontSize: 24)),
                    Text(yaoGua[3], style: const TextStyle(fontSize: 24)),
                    Text(yaoGua[4], style: const TextStyle(fontSize: 24)),
                    Text(yaoGua[5], style: const TextStyle(fontSize: 24)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiuYaoDisplay() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('六爻 · 点击查看藏干', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...List.generate(6, (index) {
              final yao = yaoNames[index];
              final zhi = zhiList[index];
              final gan = ganList[index];
              final liuqin = liuyaoShensha[yao]?['liuqin'] ?? '';

              return InkWell(
                onTap: () => _showYaoDetail(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: selectedYao == yao ? Colors.blue.shade50 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: selectedYao == yao ? Colors.blue : Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(yao, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Text(yaoGua[index], style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(gan, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                              Text(zhi, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Text('藏干: ${_getCangGanForYao(index)}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(liuqin, style: TextStyle(color: Colors.orange[800], fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildShenshaList() {
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
                Text('神煞大全（共${allShensha.length}种）', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
    final items = allShensha.entries.where((e) => e.value['category'] == category).toList();
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

  Widget _buildYaoDetailCard() {
    final index = yaoNames.indexOf(selectedYao!);
    final zhi = zhiList[index];
    final liuqin = liuyaoShensha[selectedYao]?['liuqin'] ?? '';

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
                Text(
                  '$selectedYao 详细信息',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => selectedYao = null),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [const Text('纳干'), Text(ganList[index], style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18))]),
                Column(children: [const Text('纳支'), Text(zhi, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18))]),
                Column(children: [const Text('六亲'), Text(liuqin, style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 18))]),
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
                  children: (cangGan[zhi] ?? []).map((gan) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
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
