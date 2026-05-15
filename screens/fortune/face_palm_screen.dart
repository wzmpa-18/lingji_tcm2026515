import 'package:flutter/material.dart';

class FacePalmScreen extends StatefulWidget {
  const FacePalmScreen({super.key});

  @override
  State<FacePalmScreen> createState() => _FacePalmScreenState();
}

class _FacePalmScreenState extends State<FacePalmScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('面相手相'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '面相', icon: Icon(Icons.face)),
            Tab(text: '手相', icon: Icon(Icons.pan_tool)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          FaceReadingTab(),
          PalmReadingTab(),
        ],
      ),
    );
  }
}

class FaceReadingTab extends StatelessWidget {
  const FaceReadingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTheoryCard(),
        _buildFaceZonesCard(),
        _buildFiveElementsCard(),
      ],
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
            const Text('面相学理论', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('面相学是通过观察人的面部特征，推断其性格、运势的方法。', style: TextStyle(height: 1.6)),
            const SizedBox(height: 8),
            const Text('面相要诀：上停看少年、中停看中年、下停看晚年。', style: TextStyle(height: 1.6)),
          ],
        ),
      ),
    );
  }

  Widget _buildFaceZonesCard() {
    final zones = [
      {'name': '额部', 'desc': '少年运、智慧、祖荫', 'color': Colors.blue},
      {'name': '眉部', 'desc': '兄弟、感情、兄弟宫', 'color': Colors.green},
      {'name': '眼部', 'desc': '心灵、桃花、夫妻宫', 'color': Colors.red},
      {'name': '鼻部', 'desc': '财运、事业、中岳', 'color': Colors.orange},
      {'name': '口部', 'desc': '晚年运、食禄、下巴', 'color': Colors.purple},
      {'name': '耳部', 'desc': '童年运、寿元、听力', 'color': Colors.teal},
    ];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('面部十二宫', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
              ),
              itemCount: zones.length,
              itemBuilder: (context, index) {
                final zone = zones[index];
                return InkWell(
                  onTap: () => _showZoneDetail(context, zone['name'] as String, zone['desc'] as String),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: (zone['color'] as Color).shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: (zone['color'] as Color).withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(zone['name'] as String, style: TextStyle(fontWeight: FontWeight.bold, color: zone['color'] as Color)),
                        const SizedBox(height: 4),
                        Text(zone['desc'] as String, style: const TextStyle(fontSize: 10), textAlign: TextAlign.center),
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

  Widget _buildFiveElementsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('五行面相', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('金形人：面部方正、肤色白', style: TextStyle(height: 1.6)),
            const Text('木形人：面部修长、肤色青', style: TextStyle(height: 1.6)),
            const Text('水形人：面部圆润、肤色黑', style: TextStyle(height: 1.6)),
            const Text('火形人：面部上尖、肤色赤', style: TextStyle(height: 1.6)),
            const Text('土形人：面部厚实、肤色黄', style: TextStyle(height: 1.6)),
          ],
        ),
      ),
    );
  }

  void _showZoneDetail(BuildContext context, String name, String desc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('部位：$name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('主论：$desc'),
            const SizedBox(height: 8),
            const Text('面相学认为面部各部位与人生运势相关。'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('关闭'))],
      ),
    );
  }
}

class PalmReadingTab extends StatelessWidget {
  const PalmReadingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTheoryCard(),
        _buildPalmZonesCard(),
        _buildLineMeaningsCard(),
      ],
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
            const Text('手相学理论', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('手相学是通过观察手掌的形状、纹路，推断人的性格与命运。', style: TextStyle(height: 1.6)),
            const SizedBox(height: 8),
            const Text('左手先天、右手后天，左手论先天禀赋，右手论后天发展。', style: TextStyle(height: 1.6)),
          ],
        ),
      ),
    );
  }

  Widget _buildPalmZonesCard() {
    final zones = [
      {'name': '拇指', 'desc': '意志力、领导力', 'color': Colors.red},
      {'name': '食指', 'desc': '野心、权力欲', 'color': Colors.blue},
      {'name': '中指', 'desc': '责任心、事业心', 'color': Colors.purple},
      {'name': '无名指', 'desc': '艺术感、桃花', 'color': Colors.pink},
      {'name': '小指', 'desc': '沟通、子女运', 'color': Colors.orange},
    ];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('五指论断', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...zones.map((zone) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: (zone['color'] as Color).shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(zone['name'] as String, style: TextStyle(fontWeight: FontWeight.bold, color: zone['color'] as Color)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(zone['desc'] as String)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildLineMeaningsCard() {
    final lines = [
      {'name': '感情线', 'desc': '感情经历、桃花运', 'color': Colors.red},
      {'name': '智慧线', 'desc': '智力、思考能力', 'color': Colors.blue},
      {'name': '生命线', 'desc': '寿命、健康', 'color': Colors.green},
      {'name': '事业线', 'desc': '事业发展、事业心', 'color': Colors.orange},
      {'name': '婚姻线', 'desc': '婚姻状况、晚婚运', 'color': Colors.purple},
    ];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('掌纹主论', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...lines.map((line) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: (line['color'] as Color).shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(line['name'] as String, style: TextStyle(fontWeight: FontWeight.bold, color: line['color'] as Color)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(line['desc'] as String)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
