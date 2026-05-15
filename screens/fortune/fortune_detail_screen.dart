import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/fortune_provider.dart';
import '../../providers/user_provider.dart';
import '../../config/theme.dart';

class FortuneDetailScreen extends StatefulWidget {
  const FortuneDetailScreen({super.key});

  @override
  State<FortuneDetailScreen> createState() => _FortuneDetailScreenState();
}

class _FortuneDetailScreenState extends State<FortuneDetailScreen> {
  final _nameController = TextEditingController();
  DateTime _birthDate = DateTime(1990, 1, 1);
  TimeOfDay _birthTime = const TimeOfDay(hour: 12, minute: 0);
  String _gender = '男';
  bool _isCalculating = false;
  Map<String, dynamic>? _result;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<FortuneProvider>(
          builder: (context, provider, _) {
            return Text(provider.selectedChartType);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInputCard(),
          const SizedBox(height: 24),
          if (_result != null) _buildResultCard(),
        ],
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '基本信息',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '姓名',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('出生日期'),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(_birthDate)),
              onTap: _pickDate,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.access_time),
              title: const Text('出生时间'),
              subtitle: Text('${_birthTime.hour.toString().padLeft(2, '0')}:${_birthTime.minute.toString().padLeft(2, '0')}'),
              onTap: _pickTime,
            ),
            const SizedBox(height: 16),
            const Text('性别', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('男'),
                  selected: _gender == '男',
                  onSelected: (_) => setState(() => _gender = '男'),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('女'),
                  selected: _gender == '女',
                  onSelected: (_) => setState(() => _gender = '女'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isCalculating ? null : _calculate,
                child: _isCalculating
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('开始排盘', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.auto_awesome, color: AppTheme.accentColor),
                SizedBox(width: 8),
                Text(
                  '排盘结果',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildBaZiDisplay(),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '五行分析',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildWuxingAnalysis(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveChart,
                icon: const Icon(Icons.save),
                label: const Text('保存记录'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBaZiDisplay() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.secondaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildColumn('年柱', _result!['year_gan'] ?? '', _result!['year_zhi'] ?? ''),
          _buildColumn('月柱', _result!['month_gan'] ?? '', _result!['month_zhi'] ?? ''),
          _buildColumn('日柱', _result!['day_gan'] ?? '', _result!['day_zhi'] ?? ''),
          _buildColumn('时柱', _result!['hour_gan'] ?? '', _result!['hour_zhi'] ?? ''),
        ],
      ),
    );
  }

  Widget _buildColumn(String label, String gan, String zhi) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 8),
        Container(
          width: 60,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                gan,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              Text(
                zhi,
                style: const TextStyle(
                  fontSize: 20,
                  color: AppTheme.secondaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWuxingAnalysis() {
    final wuxing = <String, int>{'木': 0, '火': 0, '土': 0, '金': 0, '水': 0};
    final allGans = [
      _result!['year_gan'] ?? '',
      _result!['month_gan'] ?? '',
      _result!['day_gan'] ?? '',
      _result!['hour_gan'] ?? '',
    ];
    final allZhis = [
      _result!['year_zhi'] ?? '',
      _result!['month_zhi'] ?? '',
      _result!['day_zhi'] ?? '',
      _result!['hour_zhi'] ?? '',
    ];

    for (var g in allGans) {
      if (g == '甲' || g == '乙') wuxing['木'] = (wuxing['木'] ?? 0) + 1;
      if (g == '丙' || g == '丁') wuxing['火'] = (wuxing['火'] ?? 0) + 1;
      if (g == '戊' || g == '己') wuxing['土'] = (wuxing['土'] ?? 0) + 1;
      if (g == '庚' || g == '辛') wuxing['金'] = (wuxing['金'] ?? 0) + 1;
      if (g == '壬' || g == '癸') wuxing['水'] = (wuxing['水'] ?? 0) + 1;
    }

    final zhiWuxing = {
      '子': '水', '丑': '土', '寅': '木', '卯': '木', '辰': '土', '巳': '火',
      '午': '火', '未': '土', '申': '金', '酉': '金', '戌': '土', '亥': '水',
    };

    for (var z in allZhis) {
      final wx = zhiWuxing[z];
      if (wx != null) wuxing[wx] = (wuxing[wx] ?? 0) + 1;
    }

    final colors = {'木': Colors.green, '火': Colors.red, '土': Colors.brown, '金': Colors.amber, '水': Colors.blue};

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: wuxing.entries.map((e) {
        return Column(
          children: [
            Text(
              e.key,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors[e.key],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${e.value}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        );
      }).toList(),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _birthDate = date);
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _birthTime,
    );
    if (time != null) {
      setState(() => _birthTime = time);
    }
  }

  Future<void> _calculate() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入姓名')),
      );
      return;
    }

    setState(() => _isCalculating = true);

    final birthDateTime = DateTime(
      _birthDate.year,
      _birthDate.month,
      _birthDate.day,
      _birthTime.hour,
      _birthTime.minute,
    );

    final provider = context.read<FortuneProvider>();
    final result = await provider.calculateChart(
      userId: context.read<UserProvider>().currentUser!.id,
      name: _nameController.text,
      birthTime: birthDateTime,
      gender: _gender,
    );

    setState(() {
      _isCalculating = false;
      _result = provider.currentChart;
    });

    if (mounted && result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('排盘完成'), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _saveChart() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('记录已保存'), backgroundColor: Colors.green),
    );
  }
}
