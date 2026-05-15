import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/mingli_model.dart';
import '../../models/wuyun_model.dart';
import '../../services/mingli_service.dart';
import '../../providers/user_provider.dart';
import '../../config/theme.dart';

class MingLiScreen extends StatefulWidget {
  const MingLiScreen({super.key});

  @override
  State<MingLiScreen> createState() => _MingLiScreenState();
}

class _MingLiScreenState extends State<MingLiScreen> {
  final MingLiService _mingLiService = MingLiService();
  MingLiType? _selectedType;
  MingLiSettings _settings = MingLiSettings();
  bool _showSettings = false;

  int _birthYear = 1990;
  int _birthMonth = 1;
  int _birthDay = 1;
  int _birthHour = 12;
  int _birthMinute = 0;

  BaZi? _baZiResult;
  QiMenDunJia? _qiMenResult;
  ZiWeiDouShu? _ziWeiResult;
  DaLiuRen? _daLiuRenResult;
  LiuYaoNaJia? _liuYaoResult;
  MeiHuaYiShu? _meiHuaResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('命理全科'),
        actions: [
          IconButton(
            icon: Icon(_showSettings ? Icons.close : Icons.settings),
            onPressed: () => setState(() => _showSettings = !_showSettings),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showSettings) _buildSettingsPanel(),
          Expanded(
            child: _selectedType == null
                ? _buildTypeSelection()
                : _buildResultView(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.surfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('排盘设置', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSettingChip('空亡日时', _settings.useKongWang, (v) => setState(() => _settings = _settings.copyWith(useKongWang: v))),
              _buildSettingChip('真太阳时', _settings.useTrueSunTime, (v) => setState(() => _settings = _settings.copyWith(useTrueSunTime: v))),
              _buildSettingChip('节气起月', _settings.useJieQiStartMonth, (v) => setState(() => _settings = _settings.copyWith(useJieQiStartMonth: v))),
              _buildSettingChip('涉害规则', _settings.useSheHaiRule, (v) => setState(() => _settings = _settings.copyWith(useSheHaiRule: v))),
              _buildSettingChip('贵人排布', _settings.useGuiRenArrangement, (v) => setState(() => _settings = _settings.copyWith(useGuiRenArrangement: v))),
              _buildSettingChip('六神顺序', _settings.useLiuShenOrder, (v) => setState(() => _settings = _settings.copyWith(useLiuShenOrder: v))),
              _buildSettingChip('起运顺逆', _settings.useShunYunQiFu, (v) => setState(() => _settings = _settings.copyWith(useShunYunQiFu: v))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingChip(String label, bool value, Function(bool) onChanged) {
    return FilterChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: value,
      onSelected: onChanged,
    );
  }

  Widget _buildTypeSelection() {
    final memberLevel = context.read<UserProvider>().currentUser?.memberLevel ?? 0;
    final hasFullPackage = _mingLiService.hasFullPackage(memberLevel);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTypeCard(
          '八字四柱',
          '命理基础，四柱推命',
          Icons.account_tree,
          Colors.blue,
          MingLiType.baZi,
          0,
          memberLevel,
        ),
        _buildTypeCard(
          '奇门遁甲',
          '排兵布阵，趋吉避凶',
          Icons.grid_on,
          Colors.purple,
          MingLiType.qiMenDunJia,
          0,
          memberLevel,
        ),
        _buildTypeCard(
          '紫微斗数',
          '星曜论命，十二宫位',
          Icons.stars,
          Colors.deepOrange,
          MingLiType.ziWeiDouShu,
          0,
          memberLevel,
        ),
        _buildTypeCard(
          '大六壬',
          '袖中金标准，天地人三才',
          Icons.calculate,
          Colors.teal,
          MingLiType.daLiuRen,
          0,
          memberLevel,
        ),
        _buildTypeCard(
          '六爻纳甲',
          '铜钱卦象，万物类象',
          Icons.scatter_plot,
          Colors.indigo,
          MingLiType.liuYaoNaJia,
          0,
          memberLevel,
        ),
        _buildTypeCard(
          '梅花易数',
          '心易占卜，灵活变通',
          Icons.flutter_dash,
          Colors.green,
          MingLiType.meiHuaYiShu,
          0,
          memberLevel,
        ),
        _buildTypeCard(
          '五运六气',
          '气运养生，节气调理',
          Icons.wb_sunny,
          Colors.amber,
          MingLiType.wuYunLiuQi,
          0,
          memberLevel,
        ),
        if (!hasFullPackage)
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.withOpacity(0.2), Colors.orange.withOpacity(0.2)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(Icons.lock, color: Colors.amber),
                const SizedBox(height: 8),
                const Text('命理全科套餐', style: TextStyle(fontWeight: FontWeight.bold)),
                const Text('解锁全部典籍批注、名家高阶解读', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  child: const Text('300元解锁全科'),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTypeCard(String title, String subtitle, IconData icon, Color color, MingLiType type, int requiredLevel, int memberLevel) {
    final canAccess = memberLevel >= requiredLevel;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: canAccess ? () => _selectType(type) : () => _showUpgradeDialog(),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        if (!canAccess) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(8)),
                            child: const Text('高级', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ),
                        ],
                      ],
                    ),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              Icon(canAccess ? Icons.chevron_right : Icons.lock, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultView() {
    return Column(
      children: [
        _buildBirthInput(),
        Expanded(child: _buildDetailView()),
      ],
    );
  }

  Widget _buildBirthInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.surfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('出生信息', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildDatePicker('年', _birthYear, 1950, 2030, (v) => setState(() => _birthYear = v))),
              const SizedBox(width: 8),
              Expanded(child: _buildDatePicker('月', _birthMonth, 1, 12, (v) => setState(() => _birthMonth = v))),
              const SizedBox(width: 8),
              Expanded(child: _buildDatePicker('日', _birthDay, 1, 31, (v) => setState(() => _birthDay = v))),
              const SizedBox(width: 8),
              Expanded(child: _buildDatePicker('时', _birthHour, 0, 23, (v) => setState(() => _birthHour = v))),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _calculate,
              icon: const Icon(Icons.calculate),
              label: const Text('开始排盘'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(String label, int value, int min, int max, Function(int) onChanged) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        DropdownButton<int>(
          value: value.clamp(min, max),
          isExpanded: true,
          items: List.generate(max - min + 1, (i) => min + i)
              .map((v) => DropdownMenuItem(value: v, child: Text(v.toString().padLeft(2, '0'))))
              .toList(),
          onChanged: (v) => if (v != null) onChanged(v),
        ),
      ],
    );
  }

  Widget _buildDetailView() {
    switch (_selectedType) {
      case MingLiType.baZi:
        return _buildBaZiView();
      case MingLiType.qiMenDunJia:
        return _buildQiMenView();
      case MingLiType.ziWeiDouShu:
        return _buildZiWeiView();
      case MingLiType.daLiuRen:
        return _buildDaLiuRenView();
      case MingLiType.liuYaoNaJia:
        return _buildLiuYaoView();
      case MingLiType.meiHuaYiShu:
        return _buildMeiHuaView();
      case MingLiType.wuYunLiuQi:
        return _buildWuYunView();
      default:
        return const Center(child: Text('请选择命理类型'));
    }
  }

  Widget _buildBaZiView() {
    if (_baZiResult == null) return const Center(child: Text('请输入出生信息开始排盘'));
    final memberLevel = context.read<UserProvider>().currentUser?.memberLevel ?? 0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBaZiCard(),
        const SizedBox(height: 16),
        _buildBaZiDetailCard('纳音五行', _baZiResult!.naYin.join('、'), Colors.purple),
        const SizedBox(height: 12),
        _buildBaZiDetailCard('十神', _baZiResult!.shiShen.join('、'), Colors.blue),
        const SizedBox(height: 12),
        _buildBaZiDetailCard('藏干', _baZiResult!.cangGan.join('、'), Colors.teal),
        const SizedBox(height: 12),
        _buildBaZiDetailCard('五行平衡', _baZiResult!.wuXing, Colors.green),
        const SizedBox(height: 12),
        _buildBaZiDetailCard('神煞', _baZiResult!.shenSha.join('、'), Colors.orange),
        if (memberLevel >= 1) ...[
          const SizedBox(height: 16),
          _buildBasicInterpretation(),
        ],
        if (memberLevel >= 2) ...[
          const SizedBox(height: 16),
          _buildAdvancedInterpretation(),
        ],
      ],
    );
  }

  Widget _buildBaZiCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppTheme.primaryColor, AppTheme.secondaryColor]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('四柱八字', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildBaZiColumn('年柱', _baZiResult!.year),
          _buildBaZiColumn('月柱', _baZiResult!.month),
          _buildBaZiColumn('日柱', _baZiResult!.day),
          _buildBaZiColumn('时柱', _baZiResult!.hour),
        ],
      ),
    );
  }

  Widget _buildBaZiColumn(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 60, child: Text(label, style: const TextStyle(color: Colors.white70))),
          Container(
            width: 80,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
          ),
        ],
      ),
    );
  }

  Widget _buildBaZiDetailCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 40,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(value, style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInterpretation() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.article, color: Colors.blue),
                SizedBox(width: 8),
                Text('通俗解析（中级会员）', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '日主为${_baZiResult!.riYuan[0]}，${_baZiResult!.wuXing}。\n年柱${_baZiResult!.naYin[0]}，祖上有一定的家业基础。\n月柱${_baZiResult!.naYin[1]}，代表青少年时期的发展。\n日柱${_baZiResult!.naYin[2]}，为命主本身的核心特质。\n时柱${_baZiResult!.naYin[3]}，反映晚年运势与子女缘分。',
              style: const TextStyle(fontSize: 13, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedInterpretation() {
    return Card(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(8)),
                  child: const Text('高级会员', style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.school, color: Colors.purple),
                const SizedBox(width: 8),
                const Text('深度课理教学', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '【命局分析】\n此八字日主甲木，生于春季，得令而旺。木主生发，命主具有较强的创造力和行动力...',
              style: TextStyle(fontSize: 12, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQiMenView() {
    if (_qiMenResult == null) return const Center(child: Text('请输入时间开始排盘'));
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildQiMenCard(),
        const SizedBox(height: 16),
        _buildGridDisplay('天盘', _qiMenResult!.tianPan, Colors.blue),
        const SizedBox(height: 12),
        _buildGridDisplay('地盘', _qiMenResult!.diPan, Colors.green),
        const SizedBox(height: 12),
        _buildQiMenDetail(),
      ],
    );
  }

  Widget _buildQiMenCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.purple, Colors.deepPurple]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('奇门遁甲', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQiMenItem('宫', _qiMenResult!.gong),
              _buildQiMenItem('门', _qiMenResult!.men),
              _buildQiMenItem('神', _qiMenResult!.shen),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQiMenItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildGridDisplay(String title, List<String> items, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: items.map((item) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                child: Text(item),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQiMenDetail() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('盘象解读', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(_qiMenResult!.panXing, style: const TextStyle(fontSize: 14, height: 1.6)),
          ],
        ),
      ),
    );
  }

  Widget _buildZiWeiView() {
    if (_ziWeiResult == null) return const Center(child: Text('请输入时间开始排盘'));
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildZiWeiCard(),
        const SizedBox(height: 16),
        _buildStarGroup('主星', _ziWeiResult!.mainStars, Colors.red),
        const SizedBox(height: 12),
        _buildStarGroup('辅星', _ziWeiResult!.assistantStars, Colors.blue),
        const SizedBox(height: 12),
        _buildStarGroup('文星', _ziWeiResult!.literaryStars, Colors.purple),
        const SizedBox(height: 12),
        _buildStarGroup('武星', _ziWeiResult!.martialStars, Colors.orange),
      ],
    );
  }

  Widget _buildZiWeiCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.deepOrange, Colors.orange]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('紫微斗数', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQiMenItem('命宫', _ziWeiResult!.mingGong),
              _buildQiMenItem('身宫', _ziWeiResult!.shenGong),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStarGroup(String title, List<String> stars, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: stars.map((star) => Chip(
                label: Text(star, style: const TextStyle(fontSize: 12)),
                backgroundColor: color.withOpacity(0.1),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaLiuRenView() {
    if (_daLiuRenResult == null) return const Center(child: Text('请输入时间开始排盘'));
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDaLiuRenCard(),
        const SizedBox(height: 16),
        _buildStarGroup('六神', _daLiuRenResult!.liuShen, Colors.teal),
        const SizedBox(height: 12),
        _buildDaLiuRenDetail(),
      ],
    );
  }

  Widget _buildDaLiuRenCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.teal, Colors.cyan]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('大六壬（袖中金标准）', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQiMenItem('日神', _daLiuRenResult!.diShen),
              _buildQiMenItem('阳贵', _daLiuRenResult!.riShen),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDaLiuRenDetail() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('神煞吉凶', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildDaLiuRenRow('驿马', _daLiuRenResult!.yiMa),
            _buildDaLiuRenRow('禄马', _daLiuRenResult!.luMa),
            _buildDaLiuRenRow('天马', _daLiuRenResult!.tiANhu),
            _buildDaLiuRenRow('吉门', _daLiuRenResult!.jiMen),
          ],
        ),
      ),
    );
  }

  Widget _buildDaLiuRenRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildLiuYaoView() {
    if (_liuYaoResult == null) return const Center(child: Text('请输入时间开始排盘'));
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildLiuYaoCard(),
        const SizedBox(height: 16),
        _buildLiuYaoDetail(),
      ],
    );
  }

  Widget _buildLiuYaoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.indigo, Colors.blue]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('六爻纳甲', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(_liuYaoResult!.guaName, style: const TextStyle(color: Colors.white, fontSize: 24)),
          const SizedBox(height: 8),
          Text('动爻：${_liuYaoResult!.dongYaoy}', style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildLiuYaoDetail() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('卦象详解', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('本卦：${_liuYaoResult!.muGua}', style: const TextStyle(fontSize: 14)),
            Text('变卦：${_liuYaoResult!.bianYao.join("、")}', style: const TextStyle(fontSize: 14)),
            Text('互卦：${_liuYaoResult!.neiGua}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            Text('应爻：${_liuYaoResult!.yingShen}，用神：${_liuYaoResult!.yongShen}', style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildMeiHuaView() {
    if (_meiHuaResult == null) return const Center(child: Text('请输入时间开始排盘'));
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildMeiHuaCard(),
        const SizedBox(height: 16),
        _buildMeiHuaDetail(),
      ],
    );
  }

  Widget _buildMeiHuaCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.green, Colors.teal]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('梅花易数', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQiMenItem('上卦', _meiHuaResult!.shangGua),
              _buildQiMenItem('下卦', _meiHuaResult!.xiaGua),
              _buildQiMenItem('体卦', _meiHuaResult!.zongGua),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeiHuaDetail() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('心易解读', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('旺相：${_meiHuaResult!.wangWang}', style: const TextStyle(fontSize: 14)),
            Text('生克：${_meiHuaResult!.shengKe}', style: const TextStyle(fontSize: 14)),
            Text('动爻：${_meiHuaResult!.dongChen}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Text('仪神：${_meiHuaResult!.yiShen}，经纬：${_meiHuaResult!.jingWei}', style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildWuYunView() {
    return const Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.wb_sunny, size: 64, color: Colors.amber),
        SizedBox(height: 16),
        Text('请到五运六气板块查看'),
        Text('完整的岁运、主运客运、主气客气分析'),
      ],
    ));
  }

  void _selectType(MingLiType type) {
    setState(() => _selectedType = type);
  }

  void _calculate() {
    switch (_selectedType) {
      case MingLiType.baZi:
        _baZiResult = _mingLiService.calculateBaZi(_birthYear, _birthMonth, _birthDay, _birthHour, _settings);
        break;
      case MingLiType.qiMenDunJia:
        _qiMenResult = _mingLiService.calculateQiMen(_birthYear, _birthMonth, _birthDay, _birthHour, _settings);
        break;
      case MingLiType.ziWeiDouShu:
        _ziWeiResult = _mingLiService.calculateZiWei(_birthYear, _birthMonth, _birthDay, _birthHour);
        break;
      case MingLiType.daLiuRen:
        _daLiuRenResult = _mingLiService.calculateDaLiuRen(_birthYear, _birthMonth, _birthDay, _birthHour);
        break;
      case MingLiType.liuYaoNaJia:
        _liuYaoResult = _mingLiService.calculateLiuYao(_birthYear, _birthMonth, _birthDay, _birthHour);
        break;
      case MingLiType.meiHuaYiShu:
        _meiHuaResult = _mingLiService.calculateMeiHua(_birthYear, _birthMonth, _birthDay, _birthHour);
        break;
      default:
        break;
    }
    setState(() {});
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('权限不足'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('此功能需要更高会员等级解锁'),
            SizedBox(height: 8),
            Text('免费会员：基础排盘+简单断语'),
            Text('中级会员：完整排盘+通俗解析'),
            Text('高级会员：全开流派切换+深度教学'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(onPressed: () { Navigator.pop(context); }, child: const Text('立即升级')),
        ],
      ),
    );
  }
}
