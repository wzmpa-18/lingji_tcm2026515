import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/user_provider.dart';
import '../../providers/tcm_provider.dart';
import '../../services/herb_service.dart';
import '../../services/database_service.dart';
import '../../models/herb.dart';
import '../../models/consultation.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';

class AIAnalysisScreen extends StatefulWidget {
  final String formulaName;
  final Prescription formula;

  const AIAnalysisScreen({
    super.key,
    required this.formulaName,
    required this.formula,
  });

  @override
  State<AIAnalysisScreen> createState() => _AIAnalysisScreenState();
}

class _AIAnalysisScreenState extends State<AIAnalysisScreen> {
  final HerbService _herbService = HerbService();
  FormulaAnalysis? _analysis;
  bool _isGenerating = true;

  @override
  void initState() {
    super.initState();
    _generateAnalysis();
  }

  Future<void> _generateAnalysis() async {
    final user = context.read<UserProvider>().currentUser;
    final memberLevel = user?.memberLevel ?? 0;

    await Future.delayed(const Duration(seconds: 2));

    final symptoms = <String>[];
    final tongue = '淡红舌, 薄白苔';
    final pulse = '浮缓';

    setState(() {
      _analysis = _herbService.generateFormulaAnalysis(
        formula: widget.formula,
        symptoms: symptoms,
        tongue: tongue,
        pulse: pulse,
        memberLevel: memberLevel,
      );
      _isGenerating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI教学解析 - ${widget.formula.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('复制功能')),
              );
            },
          ),
        ],
      ),
      body: _isGenerating
          ? _buildLoadingState()
          : _analysis != null
              ? _buildAnalysisContent()
              : _buildErrorState(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 24),
          const Text(
            '正在生成倪海厦标准教学解析...',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            '请稍候，系统正在分析方剂配伍',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 32),
          _buildProgressSteps(),
        ],
      ),
    );
  }

  Widget _buildProgressSteps() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildProgressItem(Icons.check_circle, '六经辨证定位', true),
          _buildProgressItem(Icons.check_circle, '寒热虚实辨证', true),
          _buildProgressItem(Icons.check_circle, '选方核心理由', true),
          _buildProgressItem(Icons.check_circle, '单味药详解', true),
          _buildProgressItem(Icons.radio_button_checked, '配伍逻辑生成中...', false),
        ],
      ),
    );
  }

  Widget _buildProgressItem(IconData icon, String text, bool completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: completed ? Colors.green : AppTheme.primaryColor,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: completed ? Colors.black87 : AppTheme.primaryColor,
              fontWeight: completed ? FontWeight.normal : FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text('生成失败，请重试'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() => _isGenerating = true);
              _generateAnalysis();
            },
            child: const Text('重新生成'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisContent() {
    final user = context.read<UserProvider>().currentUser;
    final isHighLevel = (user?.memberLevel ?? 0) >= 2;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeaderCard(),
        const SizedBox(height: 16),
        _buildSection(
          '第一部分：六经辨证定位',
          Icons.location_on,
          _analysis!.sixChannel,
        ),
        const SizedBox(height: 16),
        _buildExpandableSection(
          '第二部分：病机分析',
          Icons.analytics,
          _analysis!.bingJi,
        ),
        const SizedBox(height: 16),
        _buildExpandableSection(
          '第三部分：寒热虚实辨证',
          Icons.thermostat,
          _analysis!.hanReXuShi,
        ),
        const SizedBox(height: 16),
        _buildExpandableSection(
          '第四部分：选方核心理由',
          Icons.check_circle,
          _analysis!.selectReason,
        ),
        const SizedBox(height: 16),
        _buildExpandableSection(
          '第五部分：为何不用其他方剂',
          Icons.cancel,
          _analysis!.notOtherReasons,
        ),
        const SizedBox(height: 16),
        _buildHerbDetails(),
        const SizedBox(height: 16),
        _buildExpandableSection(
          '第六部分：整方配伍逻辑',
          Icons.account_tree,
          _analysis!.peiWuLogic,
        ),
        const SizedBox(height: 16),
        _buildExpandableSection(
          '第七部分：气机升降平衡原理',
          Icons.swap_vert,
          _analysis!.qiJiBalance,
        ),
        if (isHighLevel) ...[
          const SizedBox(height: 16),
          _buildHighLevelSection(
            '第八部分：分阶段调理效果',
            Icons.timeline,
            _analysis!.stageEffect,
          ),
          const SizedBox(height: 16),
          _buildHighLevelSection(
            '第九部分：随证加减自学指导',
            Icons.add_circle,
            _analysis!.jiaJianGuidance,
          ),
        ] else ...[
          const SizedBox(height: 16),
          _buildLockedSection(
            '第八部分：分阶段调理效果',
            '高级会员专享',
          ),
          const SizedBox(height: 16),
          _buildLockedSection(
            '第九部分：随证加减自学指导',
            '高级会员专享',
          ),
        ],
        const SizedBox(height: 16),
        _buildDailyGuidance(),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildHeaderCard() {
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
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    '倪',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '倪海厦经方教学解析',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      widget.formula.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '出处：${widget.formula.origin}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, String content) {
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
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: const TextStyle(fontSize: 15, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection(String title, IconData icon, String content) {
    return Card(
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              content,
              style: const TextStyle(fontSize: 14, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighLevelSection(String title, IconData icon, String content) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.amber.withOpacity(0.1),
              Colors.orange.withOpacity(0.1),
            ],
          ),
        ),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.amber.shade700, size: 20),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '高级会员',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                content,
                style: const TextStyle(fontSize: 14, height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedSection(String title, String hint) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.lock, color: Colors.grey, size: 20),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          subtitle: Text(
            hint,
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/my/member');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
            ),
            child: const Text('开通'),
          ),
        ),
      ),
    );
  }

  Widget _buildHerbDetails() {
    return Card(
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.spa, color: AppTheme.secondaryColor, size: 20),
        ),
        title: const Text(
          '第五部分：单味药详解',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '${_analysis!.herbAnalyses.length}味药材',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        children: _analysis!.herbAnalyses.map((herb) {
          return _buildHerbDetailItem(herb);
        }).toList(),
      ),
    );
  }

  Widget _buildHerbDetailItem(HerbAnalysis herb) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    herb.herbName.substring(0, 1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      herb.herbName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${herb.nature}性，${herb.taste}味，归${herb.meridian}经',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  herb.dosage,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '功效：${herb.effect}',
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '在方中专属作用：',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                Text(
                  herb.specialRole,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyGuidance() {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.green.withOpacity(0.1),
              Colors.teal.withOpacity(0.1),
            ],
          ),
        ),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.restaurant_menu, color: Colors.green, size: 20),
          ),
          title: const Text(
            '日常调理指导',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGuidanceItem(
                    '最佳服药时辰',
                    Icons.access_time,
                    _analysis!.bestTime,
                  ),
                  const Divider(),
                  _buildGuidanceItem(
                    '日常忌口',
                    Icons.no_food,
                    _analysis!.dietTaboo,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidanceItem(String title, IconData icon, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
      ],
    );
  }
}
