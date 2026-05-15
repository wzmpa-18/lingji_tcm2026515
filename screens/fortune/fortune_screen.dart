import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/user.dart';
import '../../models/fortune/bazi_chart.dart';
import '../../models/fortune/ziwei_chart.dart';
import '../../models/fortune/other_charts.dart';
import '../../models/fortune/shensha_library.dart';
import '../../models/fortune/nihaixia_four_piece_set.dart';
import '../../services/fortune/fortune_school_config.dart';
import '../../services/watermark_service.dart';
import '../../services/referral_service.dart';
import '../../services/content_compliance.dart';
import '../../providers/user_provider.dart';

class FortuneScreen extends StatefulWidget {
  const FortuneScreen({super.key});

  @override
  State<FortuneScreen> createState() => _FortuneScreenState();
}

class _FortuneScreenState extends State<FortuneScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FortuneSchoolConfig _config = FortuneSchoolConfig();
  final WatermarkService _watermarkService = WatermarkService();
  final ReferralService _referralService = ReferralService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    _referralService.generateReferralCode('user_${DateTime.now().millisecondsSinceEpoch}');
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
        title: const Text('易学文化探讨'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showComplianceInfo(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: '八字', icon: Icon(Icons.auto_awesome)),
            Tab(text: '紫微斗數', icon: Icon(Icons.stars)),
            Tab(text: '奇門遁甲', icon: Icon(Icons.hexagon)),
            Tab(text: '大六壬', icon: Icon(Icons.grid_3x3)),
            Tab(text: '鐵板神數', icon: Icon(Icons.calculate)),
            Tab(text: '梅花易數', icon: Icon(Icons.local_florist)),
            Tab(text: '倪師四件套', icon: Icon(Icons.school)),
            Tab(text: '設置', icon: Icon(Icons.settings)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _BaziTab(config: _config, watermarkService: _watermarkService, referralService: _referralService),
                _ZiweiTab(config: _config),
                _QimenTab(config: _config),
                _DaliurenTab(config: _config),
                _TiebanTab(config: _config),
                _MeihuaTab(config: _config),
                const _NiHaixiaTab(),
                _SettingsTab(config: _config),
              ],
            ),
          ),
          ComplianceHelper.buildDisclaimerBanner(),
        ],
      ),
    );
  }

  void _showComplianceInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.auto_stories, color: Color(0xFF8B4513)),
            SizedBox(width: 8),
            Text('易学文化探讨'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📖 学习目的',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ComplianceTexts.fortuneSectionIntro,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red, size: 18),
                        SizedBox(width: 8),
                        Text(
                          '⚠️ 重要声明',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ContentCompliance.pageDisclaimer,
                      style: const TextStyle(fontSize: 13, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('我已知悉'),
          ),
        ],
      ),
    );
  }
}

class _BaziTab extends StatelessWidget {
  final FortuneSchoolConfig config;
  final WatermarkService watermarkService;
  final ReferralService referralService;

  const _BaziTab({
    required this.config,
    required this.watermarkService,
    required this.referralService,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildModuleHeader(
            '四柱八字',
            '依据传统八字理论，提供排盘学习',
            Icons.auto_awesome,
          ),
          const SizedBox(height: 12),
          _buildIntroCard(
            '本板块提供八字排盘、十神解析、格局分析，以文化研究、历史哲学、传统术数知识普及为目的。',
          ),
          const SizedBox(height: 16),
          _buildSchoolSelector(context, 'bazi', config.baziSettings),
          const SizedBox(height: 16),
          _buildBaziInputCard(context),
          const SizedBox(height: 24),
          _buildRuleTutorials(context, '八字'),
        ],
      ),
    );
  }

  Widget _buildIntroCard(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.blue.shade700, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBaziInputCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '输入出生资讯',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDateTime(context),
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('选择出生时间'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('男'),
                    selected: true,
                    onSelected: (selected) {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('女'),
                    selected: false,
                    onSelected: (selected) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _calculateBazi(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('排盘学习', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 12, minute: 0),
      );
    }
  }

  void _calculateBazi(BuildContext context) {
    final baziService = BaziCalculationService();
    final chart = baziService.calculateBazi(
      birthTime: DateTime(1990, 1, 1, 12, 0),
      gender: '男',
      ganzhiRule: config.baziSettings['ganzhi_rule'] ?? 'standard',
      kongwangRule: config.baziSettings['kongwang_rule'] ?? 'table',
    );
    _showBaziResult(context, chart);
  }

  void _showBaziResult(BuildContext context, BaziChart chart) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => _BaziResultView(
          chart: chart,
          scrollController: scrollController,
        ),
      ),
    );
  }

  Widget _buildRuleTutorials(BuildContext context, String category) {
    final user = context.read<UserProvider>().currentUser;
    final rules = FortuneRuleTutorial.getRulesByCategory(category);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.menu_book, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  '排盘规则教程',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '高级会员专属',
                    style: TextStyle(fontSize: 10, color: Colors.orange),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...rules.map((rule) {
              final canAccess = FortuneAccessControl.canAccessRuleTutorial(user);
              return ListTile(
                leading: Icon(
                  canAccess ? Icons.lock_open : Icons.lock,
                  color: canAccess ? Colors.green : Colors.grey,
                ),
                title: Text(rule.title),
                subtitle: Text('来源: ${rule.source}'),
                trailing: canAccess
                    ? const Icon(Icons.chevron_right)
                    : const Icon(Icons.vpn_lock, color: Colors.grey),
                onTap: canAccess
                    ? () => _showRuleDetail(context, rule)
                    : () => _showAccessDenied(context),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showRuleDetail(BuildContext context, FortuneRuleTutorial rule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(rule.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('来源: ${rule.source}', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              if (rule.memorySong.isNotEmpty) ...[
                const Text('记忆歌诀:', style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(rule.memorySong),
                ),
                const SizedBox(height: 16),
              ],
              const Text('原理解析:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(rule.principle),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showAccessDenied(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('请升级至高级会员解锁此功能'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

class _BaziResultView extends StatelessWidget {
  final BaziChart chart;
  final ScrollController scrollController;

  const _BaziResultView({
    required this.chart,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildGanzhiGrid(),
                const SizedBox(height: 16),
                _buildShengshaSection(context),
                const SizedBox(height: 16),
                _buildInterpretationSection(context),
                const SizedBox(height: 16),
                _buildDisclaimerCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              ContentCompliance.pageDisclaimer,
              style: TextStyle(fontSize: 12, color: Colors.orange.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      color: AppTheme.primaryColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              '四柱八字',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '出生：${chart.birthTime.year}-${chart.birthTime.month}-${chart.birthTime.day} ${chart.birthTime.hour}:00',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGanzhiGrid() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildRow('年柱', chart.nianGanzhi, '年'),
            const Divider(),
            _buildRow('月柱', chart.yueGanzhi, '月'),
            const Divider(),
            _buildRow('日柱', chart.riGanzhi, '日'),
            const Divider(),
            _buildRow('时柱', chart.shiGanzhi, '时'),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String ganzhi, String position) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Center(
              child: Text(
                ganzhi,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              '${chart.nianSheng}${chart.yueSheng}旺',
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShengshaSection(BuildContext context) {
    final shenshas = BaziShenshaLibrary.tianyuShens.keys.take(10).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Text(
                  '神煞学习',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: shenshas.map((name) {
                final desc = BaziShenshaLibrary.getShenshaDescription(name);
                final source = BaziShenshaLibrary.getSource(name);
                return InkWell(
                  onTap: () => _showShenshaDetail(context, name, desc, source),
                  child: Chip(
                    label: Text(name),
                    backgroundColor: Colors.blue.shade50,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showShenshaDetail(BuildContext context, String name, String desc, String source) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('来源: $source', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 12),
            Text(desc.isNotEmpty ? desc : '暂无详细说明'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  Widget _buildInterpretationSection(BuildContext context) {
    final user = context.read<UserProvider>().currentUser;
    final canAccess = FortuneAccessControl.canAccessAdvancedInterpretation(user);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.psychology, color: Colors.purple, size: 20),
                SizedBox(width: 8),
                Text(
                  '组合解析',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInterpretationTile(
              '日主${chart.riElement}性',
              FortuneInterpretationLibrary.getCharacteristic(chart.shishen),
              canAccess,
            ),
            const Divider(),
            _buildInterpretationTile(
              '格局判定',
              '待分析',
              canAccess,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterpretationTile(String title, String content, bool canAccess) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: canAccess
                ? Text(content)
                : Row(
                    children: [
                      const Icon(Icons.lock, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '初一会元解锁',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _ModuleHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _ModuleHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildModuleHeader(String title, String subtitle, IconData icon) {
  return _ModuleHeader(
    title: title,
    subtitle: subtitle,
    icon: icon,
    color: AppTheme.primaryColor,
  );
}

class _ZiweiTab extends StatelessWidget {
  final FortuneSchoolConfig config;

  const _ZiweiTab({required this.config});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildModuleHeader(
            '紫微斗數',
            '传统星命学文化研习',
            Icons.stars,
          ),
          const SizedBox(height: 12),
          _buildIntroCard(
            '本板块提供紫微斗数学习，以传统文化研究为目的。',
          ),
          const SizedBox(height: 16),
          _buildSchoolSelector(context, 'ziwei', config.ziweiSettings),
          const SizedBox(height: 16),
          _buildInputCard(context),
          const SizedBox(height: 24),
          _buildRuleTutorials(context, '紫微斗數'),
        ],
      ),
    );
  }

  Widget _buildIntroCard(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.purple.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.purple.shade700, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '输入出生资讯',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('排盘学习', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleTutorials(BuildContext context, String category) {
    final user = context.read<UserProvider>().currentUser;
    final rules = FortuneRuleTutorial.getRulesByCategory(category);
    final canAccess = FortuneAccessControl.canAccessRuleTutorial(user);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.menu_book, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  '安星规则教程',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (rules.isEmpty)
              const Text('暂无教程内容')
            else
              ...rules.map((rule) => ListTile(
                    leading: Icon(canAccess ? Icons.lock_open : Icons.lock,
                        color: canAccess ? Colors.green : Colors.grey),
                    title: Text(rule.title),
                    subtitle: Text('来源: ${rule.source}'),
                  )),
          ],
        ),
      ),
    );
  }
}

class _QimenTab extends StatelessWidget {
  final FortuneSchoolConfig config;

  const _QimenTab({required this.config});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildModuleHeader(
            '奇門遁甲',
            '传统时空数理文化研习',
            Icons.hexagon,
          ),
          const SizedBox(height: 12),
          _buildIntroCard('本板块提供奇门遁甲学习，以传统文化研究为目的。'),
          const SizedBox(height: 16),
          _buildSchoolSelector(context, 'qimen', config.qimenSettings),
          const SizedBox(height: 16),
          _buildInputCard(context),
        ],
      ),
    );
  }

  Widget _buildIntroCard(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.teal.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.teal.shade700, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '选择学习类型',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(label: const Text('时间局'), selected: true, onSelected: (_) {}),
                ChoiceChip(label: const Text('方位局'), selected: false, onSelected: (_) {}),
                ChoiceChip(label: const Text('姓名局'), selected: false, onSelected: (_) {}),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('排盘学习', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DaliurenTab extends StatelessWidget {
  final FortuneSchoolConfig config;

  const _DaliurenTab({required this.config});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildModuleHeader(
            '大六壬',
            '传统三式之一文化研习',
            Icons.grid_3x3,
          ),
          const SizedBox(height: 16),
          _buildInputCard(context),
        ],
      ),
    );
  }

  Widget _buildInputCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '输入学习时间',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('起课学习', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TiebanTab extends StatelessWidget {
  final FortuneSchoolConfig config;

  const _TiebanTab({required this.config});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildModuleHeader(
            '鐵板神數',
            '传统命理文化研习',
            Icons.calculate,
          ),
          const SizedBox(height: 16),
          _buildInputCard(context),
        ],
      ),
    );
  }

  Widget _buildInputCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '输入出生资讯',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('计算学习', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeihuaTab extends StatelessWidget {
  final FortuneSchoolConfig config;

  const _MeihuaTab({required this.config});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildModuleHeader(
            '梅花易數',
            '传统象数文化研习',
            Icons.local_florist,
          ),
          const SizedBox(height: 12),
          _buildIntroCard('本板块提供梅花易数学习，以传统文化研究为目的。'),
          const SizedBox(height: 16),
          _buildSchoolSelector(context, 'meihua', config.meihuaSettings),
          const SizedBox(height: 16),
          _buildInputCard(context),
        ],
      ),
    );
  }

  Widget _buildIntroCard(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.green.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.green.shade700, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '输入学习问题',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: '请描述您想学习的问题...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('起卦学习', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NiHaixiaTab extends StatelessWidget {
  const _NiHaixiaTab();

  @override
  Widget build(BuildContext context) {
    final lessons = NiHaixiaFourPieceSet.sampleLessons;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade100, Colors.orange.shade50],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.school, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '倪海厦四件套',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            '全套永久免费开放',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat('课程', '${lessons.length}'),
                      _buildStat('天纪', '2'),
                      _buildStat('人纪', '2'),
                      _buildStat('案例', '2'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...lessons.map((lesson) => _buildLessonCard(context, lesson)),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildLessonCard(BuildContext context, NiHaixiaLesson lesson) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showLessonDetail(context, lesson),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.play_circle_outline, color: Colors.orange),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      lesson.description,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            lesson.category,
                            style: const TextStyle(fontSize: 10, color: Colors.orange),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '免费',
                            style: TextStyle(fontSize: 10, color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  void _showLessonDetail(BuildContext context, NiHaixiaLesson lesson) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      lesson.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(lesson.category, style: const TextStyle(color: Colors.orange)),
                        const SizedBox(width: 16),
                        Text(lesson.difficulty, style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(lesson.content),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Text(
                        ContentCompliance.pageDisclaimer,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTab extends StatelessWidget {
  final FortuneSchoolConfig config;

  const _SettingsTab({required this.config});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.tune, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        '流派设置',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '各门类排盘参数设置',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.auto_awesome),
                    title: const Text('八字流派'),
                    subtitle: Text(config.baziSettings['ganzhi_rule'] ?? '标准'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showBaziSettings(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.stars),
                    title: const Text('紫微斗數流派'),
                    subtitle: Text(config.ziweiSettings['sizheng_rule'] ?? '文墨天机'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showZiweiSettings(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.hexagon),
                    title: const Text('奇門遁甲流派'),
                    subtitle: Text(config.qimenSettings['method'] ?? '阳盘'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showQimenSettings(context),
                  ),
                  const Divider(),
                  ElevatedButton(
                    onPressed: () => config.resetToDefault(),
                    child: const Text('恢复默认设置'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBaziSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '八字流派设置',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            ...FortuneSchoolOptions.baziOptions.entries.map((entry) {
              return ListTile(
                title: Text(entry.value.name),
                subtitle: Text(entry.value.options.first.description),
                onTap: () {
                  config.setBaziSetting(entry.key, entry.value.options.first.value);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showZiweiSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '紫微斗數流派设置',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            ...FortuneSchoolOptions.ziweiOptions.entries.map((entry) {
              return ListTile(
                title: Text(entry.value.name),
                subtitle: Text(entry.value.options.first.description),
                onTap: () {
                  config.setZiweiSetting(entry.key, entry.value.options.first.value);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showQimenSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '奇門遁甲流派设置',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            ...FortuneSchoolOptions.qimenOptions.entries.map((entry) {
              return ListTile(
                title: Text(entry.value.name),
                subtitle: Text(entry.value.options.first.description),
                onTap: () {
                  config.setQimenSetting(entry.key, entry.value.options.first.value);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

Widget _buildSchoolSelector(BuildContext context, String category, Map<String, String> settings) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tune, size: 18, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                '流派设置',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.check, size: 16),
                label: const Text('问真标准'),
                onPressed: () {},
              ),
              ActionChip(
                label: const Text('古法派'),
                onPressed: () {},
              ),
              ActionChip(
                label: const Text('自定义'),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
