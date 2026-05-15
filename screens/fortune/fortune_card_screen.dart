import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../services/content_compliance.dart';
import '../../services/ad_service.dart';
import '../../providers/user_provider.dart';
import 'package:provider/provider.dart';

class FortuneScreen extends StatefulWidget {
  const FortuneScreen({super.key});

  @override
  State<FortuneScreen> createState() => _FortuneScreenState();
}

class _FortuneScreenState extends State<FortuneScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;
    final adService = AdService();
    final showAd = !adService.shouldHideAds(user?.memberLevel);

    return Scaffold(
      appBar: AppBar(
        title: const Text('易学文化探讨'),
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
                  _buildSectionTitle('命理文化'),
                  const SizedBox(height: 12),
                  _buildFortuneGrid(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('数字能量'),
                  const SizedBox(height: 12),
                  _buildNumberEnergyCards(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('相学文化'),
                  const SizedBox(height: 12),
                  _buildPhysiognomyCards(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('测字起名'),
                  const SizedBox(height: 12),
                  _buildNamingCards(),
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

  Widget _buildFortuneGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildToolCard(
          '问真八字',
          '刘文元正统体系',
          Icons.calendar_today,
          Colors.blue,
          () => context.go('/fortune/bazi'),
        ),
        _buildToolCard(
          '刘文元合盘',
          '双人关系分析',
          Icons.people,
          Colors.purple,
          () => context.go('/fortune/hopan'),
        ),
        _buildToolCard(
          '大六壬',
          '袖中金神煞全',
          Icons.auto_awesome,
          Colors.brown,
          () => context.go('/fortune/da-liu-ren'),
        ),
        _buildToolCard(
          '六爻纳甲',
          '藏干神煞100+',
          Icons.hexagon,
          Colors.green,
          () => context.go('/fortune/liu-yao'),
        ),
        _buildToolCard(
          '奇门遁甲',
          '飞盘转盘可调',
          Icons.map,
          Colors.orange,
          () => context.go('/fortune/qi-men'),
        ),
        _buildToolCard(
          '梅花易数',
          '心易起卦法',
          Icons.auto_graph,
          Colors.teal,
          () => context.go('/fortune/maitai'),
        ),
        _buildToolCard(
          '紫微斗数',
          '文墨天机风格',
          Icons.stars,
          Colors.indigo,
          () => context.go('/fortune/ziwei'),
        ),
        _buildToolCard(
          '数字能量',
          '号码磁场分析',
          Icons.numbers,
          Colors.deepPurple,
          () => context.go('/fortune/digital-energy'),
        ),
      ],
    );
  }

  Widget _buildNumberEnergyCards() {
    return Column(
      children: [
        _buildFeaturedCard(
          '手机号分析',
          '拍照识别号码',
          '匹配八字吉凶',
          Icons.phone_android,
          Colors.teal,
          () => context.go('/fortune/phone'),
        ),
        const SizedBox(height: 12),
        _buildFeaturedCard(
          '车牌分析',
          '拍照识别车牌',
          '匹配八字吉凶',
          Icons.directions_car,
          Colors.indigo,
          () => context.go('/fortune/plate'),
        ),
      ],
    );
  }

  Widget _buildPhysiognomyCards() {
    return Row(
      children: [
        Expanded(
          child: _buildToolCard(
            '面相手相',
            '拍照AI解析',
            Icons.face,
            Colors.pink,
            () => context.go('/fortune/face-palm'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildToolCard(
            '骨相学',
            '传统相法',
            Icons.front_hand,
            Colors.red,
            () => context.go('/fortune/bone-face'),
          ),
        ),
      ],
    );
  }

  Widget _buildNamingCards() {
    return Column(
      children: [
        _buildFeaturedCard(
          '测字问事',
          '奇门梅花算法',
          '事情吉凶趋势',
          Icons.short_text,
          Colors.deepOrange,
          () => context.go('/fortune/cezi'),
        ),
        const SizedBox(height: 12),
        _buildFeaturedCard(
          '起名改名',
          '搭配八字格局',
          '姓名数理分析',
          Icons.text_fields,
          Colors.brown,
          () => context.go('/fortune/naming'),
        ),
      ],
    );
  }

  Widget _buildToolCard(
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
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
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

  Widget _buildFeaturedCard(
    String title,
    String subtitle1,
    String subtitle2,
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
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle1,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle2,
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
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '80元',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
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
        title: const Text('易學文化探討'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('本模塊提供以下功能，僅供傳統文化學習、歷史哲學探討使用：'),
              const SizedBox(height: 8),
              const Text('• 八字排盤學習（劉文元正統體系）'),
              const Text('• 雙人合盤關係分析'),
              const Text('• 數字能量文化研討'),
              const Text('• 麻衣手相面相AI解析'),
              const Text('• 奇門梅花測字起名'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '所有解讀僅提供古籍出處參考，不作命理預測、吉凶判斷、改運指導。',
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('我已知曉'),
          ),
        ],
      ),
    );
  }
}
