import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../services/content_compliance.dart';
import '../../services/ad_service.dart';
import '../../providers/user_provider.dart';
import 'package:provider/provider.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;
    final adService = AdService();
    final showAd = !adService.shouldHideAds(user?.memberLevel);

    return Scaffold(
      appBar: AppBar(
        title: const Text('医易工具包'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showComplianceInfo(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNiHaixiaSection(context),
                  const SizedBox(height: 24),
                  _buildSectionTitle('专业罗盘'),
                  const SizedBox(height: 12),
                  _buildCompassTools(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('量尺工具'),
                  const SizedBox(height: 12),
                  _buildMeasureTools(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('智能风水分析'),
                  const SizedBox(height: 12),
                  _buildFengshuiTools(),
                  const SizedBox(height: 24),
                  _buildComplianceBanner(),
                ],
              ),
            ),
          ),
          if (showAd) AdBannerWidget(memberLevel: user?.memberLevel),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNiHaixiaSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '倪海厦四件套',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '永久免费',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '天纪 · 人纪 · 地纪 · 案例',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '完整收录倪海厦老师全部学术资料，包含天纪（易经、紫微斗数）、人纪（针灸、黄帝内经、神农本草经）、地纪及临床案例。',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('正在跳转倪海厦四件套...')),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('立即学习'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompassTools() {
    final tools = [
      _ToolItem(
        title: '玄空飞星盘',
        subtitle: '玄空派风水核心工具',
        icon: Icons.explore,
        color: Colors.blue,
        onTap: () {},
      ),
      _ToolItem(
        title: '八宅明镜盘',
        subtitle: '八宅派风水核心工具',
        icon: Icons.home,
        color: Colors.green,
        onTap: () {},
      ),
      _ToolItem(
        title: '三合罗盘',
        subtitle: '三合派风水核心工具',
        icon: Icons.layers,
        color: Colors.purple,
        onTap: () {},
      ),
      _ToolItem(
        title: '三元罗盘',
        subtitle: '三元派风水核心工具',
        icon: Icons.all_inclusive,
        color: Colors.orange,
        onTap: () {},
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: tools.map((tool) => _buildToolCard(tool)).toList(),
    );
  }

  Widget _buildMeasureTools() {
    final tools = [
      _ToolItem(
        title: '标准鲁班尺',
        subtitle: '门公尺/丁兰尺',
        icon: Icons.straighten,
        color: Colors.brown,
        onTap: () {},
      ),
      _ToolItem(
        title: '智能立极',
        subtitle: '户型立极定位',
        icon: Icons.gps_fixed,
        color: Colors.teal,
        onTap: () {},
      ),
    ];

    return Row(
      children: tools.map((tool) => Expanded(
        child: Padding(
          padding: EdgeInsets.only(
            left: tool == tools.first ? 0 : 6,
            right: tool == tools.last ? 0 : 6,
          ),
          child: _buildToolCard(tool),
        ),
      )).toList(),
    );
  }

  Widget _buildFengshuiTools() {
    final tools = [
      _ToolItem(
        title: '智能户型分析',
        subtitle: '上传图纸AI分析',
        icon: Icons.architecture,
        color: Colors.indigo,
        onTap: () {},
      ),
      _ToolItem(
        title: '装修建议',
        subtitle: '风水调理方案',
        icon: Icons.build,
        color: Colors.pink,
        onTap: () {},
      ),
    ];

    return Row(
      children: tools.map((tool) => Expanded(
        child: Padding(
          padding: EdgeInsets.only(
            left: tool == tools.first ? 0 : 6,
            right: tool == tools.last ? 0 : 6,
          ),
          child: _buildToolCard(tool),
        ),
      )).toList(),
    );
  }

  Widget _buildToolCard(_ToolItem tool) {
    return GestureDetector(
      onTap: tool.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: tool.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: tool.color.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(tool.icon, size: 32, color: tool.color),
            const SizedBox(height: 8),
            Text(
              tool.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: tool.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              tool.subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplianceBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        ContentCompliance.pageDisclaimer,
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey,
        ),
      ),
    );
  }

  void _showComplianceInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('医易工具包说明'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('本模块提供以下专业工具，仅供传统文化学习、研究使用：'),
              const SizedBox(height: 8),
              const Text('• 倪海厦四件套（天纪/人纪/地纪/案例）'),
              const Text('• 多门派电子罗盘'),
              const Text('• 鲁班尺量尺工具'),
              const Text('• 智能户型风水分析'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '所有工具仅供学习参考，风水分析结果不构成任何决策依据。',
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('我已知晓'),
          ),
        ],
      ),
    );
  }
}

class _ToolItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _ToolItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
