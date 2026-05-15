import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/fortune_provider.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';

class WuYunScreen extends StatefulWidget {
  const WuYunScreen({super.key});

  @override
  State<WuYunScreen> createState() => _WuYunScreenState();
}

class _WuYunScreenState extends State<WuYunScreen> {
  int _selectedYear = DateTime.now().year;
  Map<String, dynamic>? _result;

  @override
  void initState() {
    super.initState();
    _loadWuYun();
  }

  Future<void> _loadWuYun() async {
    final result = await context.read<FortuneProvider>().getWuYunLiuQi(_selectedYear);
    setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('五运六气'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildYearSelector(),
          const SizedBox(height: 24),
          if (_result != null) ...[
            _buildMainInfo(),
            const SizedBox(height: 16),
            _buildYunDetail(),
            const SizedBox(height: 16),
            _buildQiDetail(),
            const SizedBox(height: 16),
            _buildWeatherInfo(),
            const SizedBox(height: 16),
            _buildDiseaseInfo(),
            const SizedBox(height: 16),
            _buildPreventionInfo(),
            const SizedBox(height: 24),
            _buildSuggestionCard(),
          ],
        ],
      ),
    );
  }

  Widget _buildYearSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '选择年份',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() => _selectedYear--);
                    _loadWuYun();
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '$_selectedYear年',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => _selectedYear++);
                    _loadWuYun();
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: ChoiceChip(
                label: const Text('今年'),
                selected: _selectedYear == DateTime.now().year,
                onSelected: (_) {
                  setState(() => _selectedYear = DateTime.now().year);
                  _loadWuYun();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            '$_selectedYear年 五运六气',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem('天干', _result!['tiangans']),
              _buildInfoItem('地支', _result!['dizhis']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildYunDetail() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.trending_up, color: Colors.green),
                ),
                const SizedBox(width: 12),
                const Text(
                  '主运',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    _result!['yun'] ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _getYunDescription(_result!['yun'] ?? ''),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQiDetail() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.wb_sunny, color: Colors.orange),
                ),
                const SizedBox(width: 12),
                const Text(
                  '司天在泉',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    _result!['qi'] ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _getQiDescription(_result!['qi'] ?? ''),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.cloud, color: AppTheme.secondaryColor),
                SizedBox(width: 8),
                Text(
                  '气候特点',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _result!['weather'] ?? '',
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.healing, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  '易感疾病',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _result!['disease'] ?? '',
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreventionInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.favorite, color: Colors.pink),
                SizedBox(width: 8),
                Text(
                  '预防保健',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _result!['prevention'] ?? '',
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withOpacity(0.2),
            Colors.orange.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.amber),
              SizedBox(width: 8),
              Text(
                '养生建议',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _getSuggestion(_result!['qi'] ?? ''),
            style: const TextStyle(fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }

  String _getYunDescription(String yun) {
    switch (yun) {
      case '木运':
        return '木气旺盛，易患肝胆疾病，应注意疏肝理气';
      case '火运':
        return '火气偏盛，易患心脑血管疾病，应注意清心泻火';
      case '土运':
        return '土气湿重，易患脾胃疾病，应注意健脾祛湿';
      case '金运':
        return '金气干燥，易患肺系疾病，应注意润肺养阴';
      case '水运':
        return '水气寒冷，易患肾系疾病，应注意温肾散寒';
      default:
        return '';
    }
  }

  String _getQiDescription(String qi) {
    switch (qi) {
      case '厥阴风木':
        return '司天为厥阴风木，在泉为少阳相火，风火相煽';
      case '少阴君火':
        return '司天为少阴君火，在泉为阳明燥金，火金相克';
      case '少阳相火':
        return '司天为少阳相火，在泉为厥阴风木，相火风木';
      case '太阴湿土':
        return '司天为太阴湿土，在泉为太阳寒水，湿寒交加';
      case '阳明燥金':
        return '司天为阳明燥金，在泉为少阴君火，燥热并存';
      case '太阳寒水':
        return '司天为太阳寒水，在泉为太阴湿土，寒湿为患';
      default:
        return '';
    }
  }

  String _getSuggestion(String qi) {
    switch (qi) {
      case '厥阴风木':
        return '宜养肝息风，多食酸味食物，如乌梅、山楂等；避免风寒，适当运动，保持心情舒畅。';
      case '少阴君火':
        return '宜清心降火，多食苦味食物，如苦瓜、莲子等；避免熬夜，保持充足睡眠。';
      case '少阳相火':
        return '宜和解少阳，多食清淡食物，如菊花茶、绿豆汤等；避免辛辣刺激性食物。';
      case '太阴湿土':
        return '宜健脾祛湿，多食甘味食物，如山药、薏米等；避免生冷油腻，适当运动排湿。';
      case '阳明燥金':
        return '宜润燥养肺，多食辛味食物，如梨、蜂蜜等；保持室内湿度，多饮水。';
      case '太阳寒水':
        return '宜温肾散寒，多食咸味食物，如黑豆、核桃等；避免受寒，适当保暖。';
      default:
        return '根据当年五运六气特点，调理身体。';
    }
  }
}
