import 'package:flutter/material.dart';

class DigitalEnergyScreen extends StatefulWidget {
  const DigitalEnergyScreen({super.key});

  @override
  State<DigitalEnergyScreen> createState() => _DigitalEnergyScreenState();
}

class _DigitalEnergyScreenState extends State<DigitalEnergyScreen> {
  final TextEditingController _phoneController = TextEditingController();
  Map<String, dynamic> result = {};

  final Map<String, Map<String, String>> numbers = {
    '1': {'name': '天医', 'desc': '贵人、财富、智慧', 'xing': '吉', 'color': '蓝色'},
    '2': {'name': '祸害', 'desc': '是非、口舌、疾病', 'xing': '凶', 'color': '黑色'},
    '3': {'name': '延年', 'desc': '事业、健康、权力', 'xing': '吉', 'color': '绿色'},
    '4': {'name': '绝命', 'desc': '破财、离散、凶险', 'xing': '凶', 'color': '红色'},
    '5': {'name': '五鬼', 'desc': '变动、阴险、小人', 'xing': '凶', 'color': '紫色'},
    '6': {'name': '六煞', 'desc': '桃花、暧昧、桃花劫', 'xing': '凶', 'color': '粉色'},
    '7': {'name': '生气', 'desc': '贵子、活泼、向上', 'xing': '吉', 'color': '青色'},
    '8': {'name': '伏位', 'desc': '保守、等待、延续', 'xing': '平', 'color': '黄色'},
    '9': {'name': '绝阴', 'desc': '疾病、阴气、消耗', 'xing': '凶', 'color': '灰色'},
    '0': {'name': '归藏', 'desc': '包容、归一、回归', 'xing': '平', 'color': '白色'},
  };

  final Map<String, String> heJu = {
    '13/31': '天医+延年：财富事业双丰收',
    '68/86': '延年+天医：权力财富兼备',
    '21/12': '祸害+天医：财来财去',
    '49/94': '绝命+延年：事业心强',
    '37/73': '生气+天医：贵人相助',
    '26/62': '六煞+天医：桃花带财',
    '48/84': '延年+绝命：事业心重',
    '57/75': '五鬼+生气：变动中发展',
  };

  void _analyze() {
    final phone = _phoneController.text;
    if (phone.isEmpty || phone.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入至少4位数字')));
      return;
    }

    final digits = phone.split('').take(8).toList();
    final analysis = <String>[];
    final juHe = <String>[];

    for (int i = 0; i < digits.length; i++) {
      final d = digits[i];
      if (numbers.containsKey(d)) {
        analysis.add('第${i + 1}位(${d}): ${numbers[d]!['name']}');
      }
    }

    for (final key in heJu.keys) {
      if (phone.contains(key.substring(0, 2))) {
        juHe.add(heJu[key]!);
      }
    }

    final score = analysis.where((a) => numbers[a.split('(')[1].substring(0, 1)]?['xing'] == '吉').length;

    setState(() {
      result = {
        '号码': phone,
        '位数分析': analysis.join('\n'),
        '组合论断': juHe.isEmpty ? '无特殊组合' : juHe.join('\n'),
        '吉位': '$score/${analysis.length}',
        '综合评价': score >= 5 ? '大吉' : score >= 3 ? '中吉' : score >= 1 ? '一般' : '需谨慎',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('数字能量'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInputCard(),
          _buildAnalyzeButton(),
          if (result.isNotEmpty) _buildResultCard(),
          _buildTheoryCard(),
          _buildNumbersCard(),
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
            const Text('输入号码分析', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: '手机号/车牌号/QQ号',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            const Text('数字能量通过分析数字组合，论断其对事业、财富、感情的影响。', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton(
        onPressed: _analyze,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('分析号码', style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 2,
      color: Colors.deepPurple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('分析结果：${result['综合评价']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            const SizedBox(height: 12),
            Text('号码：${result['号码']}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('吉位：${result['吉位']}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('位数分析：', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${result['位数分析']}'),
            const SizedBox(height: 8),
            const Text('组合论断：', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${result['组合论断']}'),
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
            const Text('数字能量理论', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('数字能量学源自河图洛书，以数字1-9对应不同能量场。', style: TextStyle(height: 1.6)),
            const SizedBox(height: 8),
            const Text('天医（1）：财富、贵人、智慧', style: TextStyle(height: 1.6)),
            const Text('延年（3）：事业、健康、权力', style: TextStyle(height: 1.6)),
            const Text('生气（7）：贵子、活泼、向上', style: TextStyle(height: 1.6)),
            const SizedBox(height: 8),
            const Text('绝命（4）：破财、离散、凶险', style: TextStyle(height: 1.6)),
            const Text('祸害（2）：是非、口舌、疾病', style: TextStyle(height: 1.6)),
            const Text('六煞（6）：桃花、暧昧', style: TextStyle(height: 1.6)),
            const Text('五鬼（5）：变动、阴险、小人', style: TextStyle(height: 1.6)),
          ],
        ),
      ),
    );
  }

  Widget _buildNumbersCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('数字能量对照表', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...numbers.entries.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: Text(e.key, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepPurple)),
                  ),
                  SizedBox(
                    width: 60,
                    child: Text(e.value['name']!, style: TextStyle(fontWeight: FontWeight.bold, color: e.value['xing'] == '吉' ? Colors.green : e.value['xing'] == '凶' ? Colors.red : Colors.grey)),
                  ),
                  Expanded(child: Text(e.value['desc']!, style: const TextStyle(fontSize: 12))),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
