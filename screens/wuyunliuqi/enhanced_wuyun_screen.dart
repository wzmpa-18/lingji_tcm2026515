import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/wuyun_model.dart';
import '../../services/wuyun_service.dart';
import '../../providers/user_provider.dart';
import '../../config/theme.dart';

class EnhancedWuYunScreen extends StatefulWidget {
  const EnhancedWuYunScreen({super.key});

  @override
  State<EnhancedWuYunScreen> createState() => _EnhancedWuYunScreenState();
}

class _EnhancedWuYunScreenState extends State<EnhancedWuYunScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final WuYunService _wuYunService = WuYunService();
  int _selectedYear = DateTime.now().year;
  WuYunLiuQi? _wuYunData;
  List<JieQi>? _jieQiList;
  WuYunSchool _selectedSchool = WuYunSchool.standard;
  WuYunConfig? _config;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _calculateWuYun();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _calculateWuYun() {
    final memberLevel = context.read<UserProvider>().currentUser?.memberLevel ?? 0;
    _config = _wuYunService.getConfigForMemberLevel(memberLevel);
    _wuYunData = _wuYunService.calculateWuYunLiuQi(_selectedYear, school: _selectedSchool);
    _jieQiList = _wuYunService.getYearJieQi(_selectedYear);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('五运六气'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: '岁运总览'),
            Tab(text: '主运客运'),
            Tab(text: '主气客气'),
            Tab(text: '司天在泉'),
            Tab(text: '二十四节气'),
            Tab(text: '养生调理'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildYearSelector(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSuiYunTab(),
                _buildZhuYunTab(),
                _buildZhuQiTab(),
                _buildSiTianTab(),
                _buildJieQiTab(),
                _buildHealthTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: AppTheme.surfaceColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => setState(() {
              _selectedYear--;
              _calculateWuYun();
            }),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$_selectedYear年',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => setState(() {
              _selectedYear++;
              _calculateWuYun();
            }),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => setState(() {
              _selectedYear = DateTime.now().year;
              _calculateWuYun();
            }),
            child: const Text('今年'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuiYunTab() {
    if (_wuYunData == null) return const Center(child: CircularProgressIndicator());

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildMainCard(),
        const SizedBox(height: 16),
        _buildWuYunStateCard(),
        const SizedBox(height: 16),
        _buildLiuQiStateCard(),
        const SizedBox(height: 16),
        if (_config?.includeDetailedAnalysis == true) ...[
          _buildTaiSuiCard(),
          const SizedBox(height: 16),
          _buildSuiXingCard(),
        ],
      ],
    );
  }

  Widget _buildMainCard() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMainItem('天干', _wuYunData!.tianGan),
              _buildMainItem('地支', _wuYunData!.diZhi),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMainItem('岁运', _wuYunData!.suYun),
              _buildMainItem('太岁', _wuYunData!.taiSui),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _wuYunData!.douJian,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMainItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildWuYunStateCard() {
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
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.trending_up, color: Colors.green),
                ),
                const SizedBox(width: 12),
                const Text('五运状态', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(_wuYunData!.wuYunState, style: const TextStyle(fontSize: 15, height: 1.6)),
            const Divider(),
            Text(_wuYunData!.organEmphasis, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildLiuQiStateCard() {
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
                  decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.wb_sunny, color: Colors.orange),
                ),
                const SizedBox(width: 12),
                const Text('六气状态', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(_wuYunData!.liuQiState, style: const TextStyle(fontSize: 15, height: 1.6)),
            const Divider(),
            Text('司天在泉：${_wuYunData!.siTian}/${_wuYunData!.zaiQuan}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildTaiSuiCard() {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.stars, color: Colors.amber),
                ),
                const SizedBox(width: 12),
                const Text('太岁方位', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10)),
                  child: const Text('高级会员', style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('太岁神：${_wuYunData!.taiSui}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('岁星纪年：${_wuYunData!.suiXing}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildSuiXingCard() {
    final taiSuiYear = _wuYunService.getTaiSuiYear(_selectedYear);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.calendar_today, color: AppTheme.accentColor),
                SizedBox(width: 8),
                Text('岁神宜忌', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        const Icon(Icons.block, color: Colors.red),
                        const SizedBox(height: 4),
                        const Text('宜', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(taiSuiYear.suitable, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(height: 4),
                        const Text('忌', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(taiSuiYear.avoid, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZhuYunTab() {
    if (_wuYunData == null) return const Center(child: CircularProgressIndicator());

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionTitle('主运（五运）', Icons.timeline),
        const SizedBox(height: 8),
        ..._wuYunData!.zhuYun.asMap().entries.map((e) => _buildYunItem(e.key + 1, e.value, Colors.blue)),
        const SizedBox(height: 24),
        _buildSectionTitle('客运', Icons.swap_horiz),
        const SizedBox(height: 8),
        ..._wuYunData!.keYun.asMap().entries.map((e) => _buildYunItem(e.key + 1, e.value, Colors.purple)),
        const SizedBox(height: 16),
        _buildYunExplanation(),
      ],
    );
  }

  Widget _buildYunItem(int index, String yun, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(child: Text('$index', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(yun, style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildYunExplanation() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.blue),
                SizedBox(width: 8),
                Text('运解读', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '主运：年年不变，从木运开始依次为木、火、土、金、水。\n客运：年年不同，随岁运变化而轮转。\n主客运结合，可判断该年各个时节的气候特点与发病倾向。',
              style: const TextStyle(fontSize: 13, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZhuQiTab() {
    if (_wuYunData == null) return const Center(child: CircularProgressIndicator());

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionTitle('主气（六步主时之气）', Icons.air),
        const SizedBox(height: 8),
        ..._wuYunData!.zhuQi.asMap().entries.map((e) => _buildQiItem(e.key + 1, e.value, Colors.teal)),
        const SizedBox(height: 24),
        _buildSectionTitle('客气（加临之气）', Icons.cloud),
        const SizedBox(height: 8),
        ..._wuYunData!.keQi.asMap().entries.map((e) => _buildQiItem(e.key + 1, e.value, Colors.deepOrange)),
        const SizedBox(height: 16),
        _buildLeftRightJianQi(),
      ],
    );
  }

  Widget _buildQiItem(int index, String qi, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(child: Text('$index', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(qi, style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildLeftRightJianQi() {
    return Card(
      color: Colors.cyan.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.swap_horiz, color: Colors.cyan),
                SizedBox(width: 8),
                Text('左右间气', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: _wuYunData!.zuoYouJianQi.map((qi) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.cyan.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(qi, style: const TextStyle(fontSize: 13), textAlign: TextAlign.center),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSiTianTab() {
    if (_wuYunData == null) return const Center(child: CircularProgressIndicator());

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildMainCard(),
        const SizedBox(height: 16),
        _buildSiTianCard(),
        const SizedBox(height: 16),
        _buildZaiQuanCard(),
        const SizedBox(height: 16),
        _buildZuoYouCard(),
        const SizedBox(height: 16),
        _buildShengYinCard(),
      ],
    );
  }

  Widget _buildSiTianCard() {
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
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.public, color: Colors.red),
                ),
                const SizedBox(width: 12),
                const Text('司天', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Text(_wuYunData!.siTian, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red)),
                  const SizedBox(height: 8),
                  Text(_getSiTianDesc(_wuYunData!.siTian), style: const TextStyle(fontSize: 14, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZaiQuanCard() {
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
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.landscape, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                const Text('在泉', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Text(_wuYunData!.zaiQuan, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),
                  const SizedBox(height: 8),
                  Text(_getZaiQuanDesc(_wuYunData!.zaiQuan), style: const TextStyle(fontSize: 14, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZuoYouCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('司天在泉与疾病关系', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(_getDiseaseRelation(_wuYunData!.siTian, _wuYunData!.zaiQuan), style: const TextStyle(fontSize: 14, height: 1.6)),
          ],
        ),
      ),
    );
  }

  Widget _buildShengYinCard() {
    return Card(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.auto_stories, color: Colors.purple),
                SizedBox(width: 8),
                Text('经典溯源', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            _buildSchoolSelector(),
            const SizedBox(height: 12),
            Text(
              _getSchoolContent(_selectedSchool),
              style: const TextStyle(fontSize: 13, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchoolSelector() {
    return Wrap(
      spacing: 8,
      children: WuYunSchool.values.map((school) {
        final isSelected = _selectedSchool == school;
        return ChoiceChip(
          label: Text(_getSchoolName(school)),
          selected: isSelected,
          onSelected: (_) => setState(() => _selectedSchool = school),
        );
      }).toList(),
    );
  }

  Widget _buildJieQiTab() {
    if (_jieQiList == null) return const Center(child: CircularProgressIndicator());

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionTitle('二十四节气养生', Icons.calendar_month),
        const SizedBox(height: 8),
        ..._jieQiList!.map((jieqi) => _buildJieQiCard(jieqi)),
      ],
    );
  }

  Widget _buildJieQiCard(JieQi jieqi) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getJieQiColor(jieqi.name).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(jieqi.name, style: TextStyle(fontWeight: FontWeight.bold, color: _getJieQiColor(jieqi.name))),
                  Text('${jieqi.date.month}/${jieqi.date.day}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(jieqi.solarTerm, style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text('气运：${jieqi.wuYun}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(jieqi.healthAdvice, style: const TextStyle(fontSize: 12, color: AppTheme.secondaryColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthTab() {
    if (_wuYunData == null) return const Center(child: CircularProgressIndicator());

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDiseaseRiskCard(),
        const SizedBox(height: 16),
        _buildDietAdviceCard(),
        const SizedBox(height: 16),
        _buildLifeAdviceCard(),
        const SizedBox(height: 16),
        _buildRecipeCard(),
        if (_config?.includeLongTermPlanning == true) ...[
          const SizedBox(height: 16),
          _buildLongTermPlanningCard(),
        ],
      ],
    );
  }

  Widget _buildDiseaseRiskCard() {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 8),
                Text('时令疾病风险', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(_wuYunData!.diseaseRisk, style: const TextStyle(fontSize: 14, height: 1.6)),
          ],
        ),
      ),
    );
  }

  Widget _buildDietAdviceCard() {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.restaurant, color: Colors.green),
                SizedBox(width: 8),
                Text('饮食宜忌', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(_wuYunData!.dietAdvice, style: const TextStyle(fontSize: 14, height: 1.6)),
          ],
        ),
      ),
    );
  }

  Widget _buildLifeAdviceCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.self_improvement, color: Colors.blue),
                SizedBox(width: 8),
                Text('作息养生建议', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(_wuYunData!.lifeAdvice, style: const TextStyle(fontSize: 14, height: 1.6)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.local_cafe, color: AppTheme.accentColor),
                SizedBox(width: 8),
                Text('调理经方推荐', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(_getRecipeRecommendation(_wuYunData!.suYun), style: const TextStyle(fontSize: 14, height: 1.6)),
          ],
        ),
      ),
    );
  }

  Widget _buildLongTermPlanningCard() {
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
                  decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(10)),
                  child: const Text('至尊会员', style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
                const SizedBox(width: 8),
                const Text('长期养生规划', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(_getLongTermPlanning(_wuYunData!.suYun), style: const TextStyle(fontSize: 13, height: 1.6)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Color _getJieQiColor(String name) {
    if (['立春', '雨水', '惊蛰', '春分', '清明', '谷雨'].contains(name)) return Colors.green;
    if (['立夏', '小满', '芒种', '夏至', '小暑', '大暑'].contains(name)) return Colors.red;
    if (['立秋', '处暑', '白露', '秋分', '寒露', '霜降'].contains(name)) return Colors.orange;
    return Colors.blue;
  }

  String _getSiTianDesc(String siTian) {
    final descMap = {
      '厥阴风木': '上半年风气旺盛，易患肝病、风病，当注意疏肝理气，避开风邪',
      '少阴君火': '上半年火气偏盛，易患心病、火病，当注意清心降火，避免暴晒',
      '太阴湿土': '上半年湿气偏重，易患脾病、湿病，当注意健脾祛湿',
      '少阳相火': '上半年相火司天，易患胆病、热病，当和解少阳',
    };
    return descMap[siTian] ?? '';
  }

  String _getZaiQuanDesc(String zaiQuan) {
    final descMap = {
      '少阳相火': '下半年相火在泉，气候闷热，易患火热证',
      '阳明燥金': '下半年燥金在泉，气候干燥，易患肺燥证',
      '太阳寒水': '下半年寒水在泉，气候寒冷，易患肾寒证',
      '厥阴风木': '下半年风木在泉，气候多变，易患风病',
      '少阴君火': '下半年君火在泉，气候温热，易患热病',
      '太阴湿土': '下半年湿土在泉，气候潮湿，易患湿病',
    };
    return descMap[zaiQuan] ?? '';
  }

  String _getDiseaseRelation(String siTian, String zaiQuan) {
    return '司天主上半年之气，在泉主下半年之气。$_selectedYear年$_siTian司天，$_zaiQuan在泉，\n上下半年气候特点不同，养生调理需因时制宜。';
  }

  String _getSchoolName(WuYunSchool school) {
    switch (school) {
      case WuYunSchool.standard:
        return '标准派';
      case WuYunSchool.huangDiNeiJing:
        return '黄帝内经';
      case WuYunSchool.suWen:
        return '素问';
      case WuYunSchool.nanJing:
        return '难经';
    }
  }

  String _getSchoolContent(WuYunSchool school) {
    switch (school) {
      case WuYunSchool.standard:
        return '采用现代标准五运六气计算方法，综合各家之长。';
      case WuYunSchool.huangDiNeiJing:
        return '《黄帝内经》七篇大论为五运六气理论之宗源，详述天符、岁会、太乙天符等运气格局。';
      case WuYunSchool.suWen:
        return '《素问》六微旨大论、气交变大论等篇章，系统阐述五运六气与疾病发生发展的关系。';
      case WuYunSchool.nanJing:
        return '《难经》以五行阴阳为基础，阐述脏腑经络与五运六气的对应关系。';
    }
  }

  String _getRecipeRecommendation(String suYun) {
    final recipes = {
      '木': '疏肝茶：柴胡6g、白芍9g、当归6g、陈皮6g，沸水泡服',
      '火': '清心饮：莲子心3g、麦冬9g、五味子6g，煎汤代茶',
      '土': '健脾粥：山药30g、薏米30g、茯苓15g，煮粥食用',
      '金': '润肺膏：雪梨1个、川贝6g、蜂蜜适量，熬膏服用',
      '水': '温肾酒：肉桂3g、枸杞15g、杜仲12g，黄酒浸泡',
    };
    return recipes[suYun] ?? '根据个人体质选择合适方剂';
  }

  String _getLongTermPlanning(String suYun) {
    return '''根据$_suYun年特点，建议制定长期养生规划：

春季（1-3月）：顺应木气生发，宜早起舒展，调畅情志
夏季（4-6月）：顺应火气长养，宜午休养心，清热防暑
长夏（7-8月）：顺应土气运化，宜健脾益气，化湿和中
秋季（9-11月）：顺应金气收敛，宜润燥养肺，少辛多酸
冬季（12月-2月）：顺应水气封藏，宜早睡晚起，温肾藏精

建议每年根据当年岁运调整养生重点，三年为一个调理周期。''';
  }
}
