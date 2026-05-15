import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/team_profit.dart';
import '../../models/registration_payment.dart';
import '../../providers/user_provider.dart';
import '../../services/c2c_service.dart';
import '../../config/theme.dart';

class PromotionCenterScreen extends StatefulWidget {
  const PromotionCenterScreen({super.key});

  @override
  State<PromotionCenterScreen> createState() => _PromotionCenterScreenState();
}

class _PromotionCenterScreenState extends State<PromotionCenterScreen> {
  int _directCount = 0;
  int _teamTotalCount = 0;
  int _currentLingji = 0;
  RollLevel _currentRollLevel = RollLevel.levels[0];

  @override
  void initState() {
    super.initState();
    _loadPromotionData();
  }

  void _loadPromotionData() {
    final user = context.read<UserProvider>().currentUser;
    _directCount = 0;
    _teamTotalCount = 0;
    _currentLingji = user?.lingjiBalance ?? 0;
    _currentRollLevel = RollLevel.getLevelByLingji(_currentLingji, _teamTotalCount);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('推广中心'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPromotionCodeCard(),
          const SizedBox(height: 16),
          _buildTeamStatsCard(),
          const SizedBox(height: 16),
          _buildProfitShareCard(),
          const SizedBox(height: 16),
          _buildRollLevelCard(),
          const SizedBox(height: 16),
          _buildUpgradeRewardsCard(),
          const SizedBox(height: 16),
          _buildPromotionRulesCard(),
        ],
      ),
    );
  }

  Widget _buildPromotionCodeCard() {
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
          const Text(
            '🎁 免费学习，积分变现，被动躺赚',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '扫码加入我们',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '一起学习中医文化，轻松赚积分',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text(
                        '二维码',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'LJWX123456',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('保存图片'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('一键分享'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.groups, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text('团队统计', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatItem('直推人数', _directCount.toString(), Colors.blue)),
                Expanded(child: _buildStatItem('团队总人数', _teamTotalCount.toString(), Colors.purple)),
                Expanded(child: _buildStatItem('累计收益', '${_currentLingji}积分', Colors.green)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildProfitShareCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.payments, color: Colors.amber),
                SizedBox(width: 8),
                Text('三级分润', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(8)),
              child: const Text('用户付费后，直推/二级/三级永久流水返利', style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildProfitLevel(1, '20%', Colors.red, '直推')),
                Expanded(child: _buildProfitLevel(2, '10%', Colors.orange, '二级')),
                Expanded(child: _buildProfitLevel(3, '0%', Colors.grey, '三级')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfitLevel(int level, String rate, Color color, String name) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(name, style: TextStyle(fontSize: 12, color: color)),
          const SizedBox(height: 4),
          Text(rate, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text('分润', style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRollLevelCard() {
    final nextLevel = RollLevel.getNextLevel(_currentRollLevel);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.purple),
                const SizedBox(width: 8),
                const Text('卷轴等级', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.purple.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Text('${_currentRollLevel.icon} ${_currentRollLevel.name}', style: const TextStyle(color: Colors.purple, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: nextLevel != null ? _currentLingji / nextLevel.minLingji : 1.0,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
            const SizedBox(height: 8),
            if (nextLevel != null)
              Text('距离 ${nextLevel.icon} ${nextLevel.name} 还需 ${LingjiBalanceService.formatLingji(nextLevel.minLingji - _currentLingji)} 积分', style: TextStyle(fontSize: 12, color: Colors.grey.shade600))
            else
              const Text('已达到最高等级！', style: TextStyle(fontSize: 12, color: Colors.purple)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildRollItem('当前加成', '${(_currentRollLevel.dailyBonus * 100).toInt()}%', Colors.green),
                _buildRollItem('团队门槛', '${_currentRollLevel.minTeamSize}人', Colors.blue),
                _buildRollItem('积分门槛', LingjiBalanceService.formatLingji(_currentRollLevel.minLingji), Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRollItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildUpgradeRewardsCard() {
    final user = context.read<UserProvider>().currentUser;
    final directCount = _directCount;
    final midTarget = PromotionService.getDirectCountForMidMember();
    final highTarget = PromotionService.getDirectCountForHighMember();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.card_giftcard, color: Colors.red),
                SizedBox(width: 8),
                Text('推广福利', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            _buildRewardItem(
              icon: '🥈',
              title: '中级会员',
              condition: '直推 $midTarget 实名用户',
              current: '$directCount/$midTarget',
              progress: directCount / midTarget,
              reward: '送全年中级会员',
              achieved: user?.memberLevel != null && user!.memberLevel >= 1,
            ),
            const SizedBox(height: 12),
            _buildRewardItem(
              icon: '🥇',
              title: '高级会员',
              condition: '直推 $highTarget 实名用户',
              current: '$directCount/$highTarget',
              progress: directCount / highTarget,
              reward: '送全年高级会员',
              achieved: user?.memberLevel != null && user!.memberLevel >= 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardItem({
    required String icon,
    required String title,
    required String condition,
    required String current,
    required double progress,
    required String reward,
    required bool achieved,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: achieved ? Colors.green.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: achieved ? Colors.green : Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              if (achieved) const Icon(Icons.check_circle, color: Colors.green, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(condition, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(achieved ? Colors.green : Colors.orange),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(current, style: const TextStyle(fontSize: 12)),
              Text(reward, style: const TextStyle(fontSize: 12, color: Colors.red)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionRulesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 8),
                Text('推广说明', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            _buildRuleItem('1. 分享推广码给好友注册'),
            _buildRuleItem('2. 好友注册时填写您的推广码'),
            _buildRuleItem('3. 好友付费后您获得永久分润'),
            _buildRuleItem('4. 直推达200人送中级会员'),
            _buildRuleItem('5. 直推达500人送高级会员'),
            _buildRuleItem('6. 卷轴等级越高日常收益加成越多'),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(8)),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('注意事项', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  SizedBox(height: 4),
                  Text('• 必须是实名认证用户才算有效推广', style: TextStyle(fontSize: 11)),
                  Text('• 同一手机号只能注册一个账号', style: TextStyle(fontSize: 11)),
                  Text('• 违规行为将取消推广资格', style: TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(text, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
    );
  }
}
