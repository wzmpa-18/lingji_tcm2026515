import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../config/theme.dart';
import '../../services/eink_theme_service.dart';
import '../../services/content_compliance.dart';
import '../../services/ad_service.dart';

class HomeScreen extends StatefulWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem(icon: Icons.local_hospital_outlined, activeIcon: Icons.local_hospital, label: '中医'),
    _NavItem(icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome, label: '易学'),
    _NavItem(icon: Icons.school_outlined, activeIcon: Icons.school, label: '学堂'),
    _NavItem(icon: Icons.store_outlined, activeIcon: Icons.store, label: '商城'),
  ];

  @override
  Widget build(BuildContext context) {
    final adService = AdService();
    final user = context.watch<UserProvider>().currentUser;
    final showAd = !adService.shouldHideAds(user?.memberLevel);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showAd)
            Container(
              height: 50,
              color: Colors.grey.shade100,
              child: AdService().buildBannerAd(),
            ),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() => _currentIndex = index);
              switch (index) {
                case 0:
                  context.go('/tcm');
                  break;
                case 1:
                  context.go('/fortune');
                  break;
                case 2:
                  context.go('/school');
                  break;
                case 3:
                  context.go('/store');
                  break;
              }
            },
            items: _navItems.map((item) => BottomNavigationBarItem(
              icon: Icon(item.icon),
              activeIcon: Icon(item.activeIcon),
              label: item.label,
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _EInkQuickToggle extends StatefulWidget {
  @override
  State<_EInkQuickToggle> createState() => _EInkQuickToggleState();
}

class _EInkQuickToggleState extends State<_EInkQuickToggle> {
  final EInkThemeService _einkService = EInkThemeService();

  @override
  void initState() {
    super.initState();
    _einkService.init();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _einkService.getModeIcon(),
        color: _einkService.isEInkMode ? Colors.brown : null,
      ),
      tooltip: '護眼模式：${_einkService.getModeDisplayName()}',
      onPressed: () => _showQuickToggle(context),
    );
  }

  void _showQuickToggle(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.menu_book, color: Colors.brown),
                SizedBox(width: 8),
                Text('護眼模式', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('普通模式'),
              subtitle: const Text('標準顯示效果'),
              trailing: _einkService.currentMode == AppThemeMode.normal
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
              onTap: () {
                _einkService.setNormalMode();
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('墨水屏·護眼'),
              subtitle: const Text('暖色調背景，降低藍光'),
              trailing: _einkService.currentMode == AppThemeMode.einkLight
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
              onTap: () {
                _einkService.setEInkLight();
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.brightness_2),
              title: const Text('墨水屏·深色'),
              subtitle: const Text('深色背景，省電護眼'),
              trailing: _einkService.currentMode == AppThemeMode.einkDark
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
              onTap: () {
                _einkService.setEInkDark();
                Navigator.pop(context);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('中医易学学习助手'),
        elevation: 0,
        actions: [
          _EInkQuickToggle(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
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
                  _buildAppIntroCard(context),
                  const SizedBox(height: 20),
                  _buildNiHaixiaSection(context),
                  const SizedBox(height: 20),
                  _buildMainGrid(context),
                  const SizedBox(height: 20),
                  _buildSchoolSection(context),
                  const SizedBox(height: 20),
                  _buildCooperationSection(context),
                  const SizedBox(height: 20),
                  _buildFeedbackSection(context),
                  const SizedBox(height: 20),
                  _buildPatchSection(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          ComplianceHelper.buildDisclaimerBanner(),
        ],
      ),
    );
  }

  Widget _buildAppIntroCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B4513), Color(0xFFA0522D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B4513).withValues(alpha: 0.3),
            blurRadius: 10,
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
                  Icons.auto_stories,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '中医易学学习助手',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '传统中医 · 针灸经络 · 易学文化 · 古籍研习',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '传承中华传统国学文化，供传统文化爱好者学习、研究、交流使用。不涉及医疗诊疗、不提供占卜服务。',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNiHaixiaSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
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
              const Text(
                '永久免费',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '天纪 | 人纪 | 地纪 | 案例\n完整收录倪海厦老师全部学术资料',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/fortune'),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('立即学习'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '核心功能',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
          children: [
            _buildGridCard(
              context,
              '经方',
              '医部',
              Icons.medical_services_outlined,
              const Color(0xFF8B4513),
              () => context.go('/tcm'),
            ),
            _buildGridCard(
              context,
              '针灸',
              '经络',
              Icons.spa_outlined,
              const Color(0xFF2E7D32),
              () => context.go('/acupuncture'),
            ),
            _buildGridCard(
              context,
              '命理',
              '八字',
              Icons.auto_awesome,
              const Color(0xFF1565C0),
              () => context.go('/fortune'),
            ),
            _buildGridCard(
              context,
              '紫微',
              '斗数',
              Icons.stars,
              const Color(0xFF7B1FA2),
              () => context.go('/fortune'),
            ),
            _buildGridCard(
              context,
              '奇门',
              '遁甲',
              Icons.hexagon_outlined,
              const Color(0xFF00838F),
              () => context.go('/fortune'),
            ),
            _buildGridCard(
              context,
              '风水',
              '罗盘',
              Icons.explore,
              const Color(0xFFEF6C00),
              () => context.go('/tools'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
          children: [
            _buildGridCard(
              context,
              '儿科',
              '推拿',
              Icons.child_care,
              const Color(0xFFE91E63),
              () => context.go('/tcm/pediatric'),
            ),
            _buildGridCard(
              context,
              '五运',
              '六气',
              Icons.wb_sunny_outlined,
              const Color(0xFFFFA000),
              () => context.go('/wuyun'),
            ),
            _buildGridCard(
              context,
              '古籍',
              '典藏',
              Icons.menu_book,
              const Color(0xFF5D4037),
              () => context.go('/books'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGridCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
            ),
            Text(
              subtitle,
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

  Widget _buildSchoolSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '学堂',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.8,
          children: [
            _buildSchoolCard(
              '讲师课堂',
              '入驻开课',
              Icons.school_outlined,
              Colors.blue,
              () => context.go('/school/instructor'),
            ),
            _buildSchoolCard(
              '典籍商城',
              '古籍善本',
              Icons.store_outlined,
              Colors.green,
              () => context.go('/store'),
            ),
            _buildSchoolCard(
              '学习积分',
              '任务变现',
              Icons.stars_outlined,
              Colors.amber,
              () => context.go('/school/points'),
            ),
            _buildSchoolCard(
              '推广中心',
              '分享赚钱',
              Icons.share_outlined,
              Colors.purple,
              () => context.go('/promotion'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSchoolCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
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

  Widget _buildCooperationSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.handshake_outlined, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                '合作申请',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.email_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              const Text(
                '官方邮箱：',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              Text(
                'contact@lingji.app',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '诚邀中医名家、命理大师、讲师入驻合作，共建传统文化学习平台。',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/feedback'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.feedback_outlined, color: Colors.green.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '用户留言反馈',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.green.shade700,
                    ),
                  ),
                  Text(
                    '问题建议，一键反馈',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildPatchSection(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPatchDialog(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.system_update_alt, color: Colors.amber.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '新版公测补丁',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.amber.shade700,
                    ),
                  ),
                  Text(
                    'v2.1.0 Beta - 点击查看更新内容',
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
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'NEW',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPatchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.system_update_alt, color: Colors.amber),
            SizedBox(width: 8),
            Text('更新日志'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildVersionItem('v2.1.0 Beta', '2026-05-11', [
                '新增水印+推广二维码系统',
                '新增内容合规文本系统',
                '优化底部导航布局',
                '修复已知问题',
              ]),
              const Divider(),
              _buildVersionItem('v2.0.0', '2026-05-01', [
                '全新界面改版',
                '新增数字能量测算',
                '新增麻衣手相面相',
                '新增测字起名系统',
              ]),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已是最新版本')),
              );
            },
            child: const Text('检查更新'),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionItem(String version, String date, List<String> features) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                version,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade800,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              date,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...features.map((f) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontSize: 12)),
              Expanded(
                child: Text(
                  f,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
