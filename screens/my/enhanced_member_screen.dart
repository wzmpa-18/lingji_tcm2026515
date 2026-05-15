import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../config/theme.dart';

class EnhancedMemberScreen extends StatelessWidget {
  const EnhancedMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('会员中心'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          final user = userProvider.currentUser;
          final currentLevel = user?.memberLevel ?? 0;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildCurrentMemberCard(context, currentLevel),
              const SizedBox(height: 24),
              _buildLingjiBonus(currentLevel),
              const SizedBox(height: 24),
              _buildMemberPackages(context, currentLevel),
              const SizedBox(height: 24),
              _buildMingLiPackage(context, currentLevel),
              const SizedBox(height: 24),
              _buildBenefitsDetail(currentLevel),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCurrentMemberCard(BuildContext context, int level) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getMemberColor(level),
            _getMemberColor(level).withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.workspace_premium, size: 64, color: Colors.white),
          const SizedBox(height: 16),
          Text(_getMemberName(level), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text(level == 0 ? '升级会员解锁全部功能' : '尊享会员特权', style: const TextStyle(color: Colors.white70, fontSize: 16)),
          if (level > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
              child: Text(_getMemberBonus(level), style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLingjiBonus(int level) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.stars, color: Colors.amber),
                SizedBox(width: 8),
                Text('灵积积分特权', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildLingjiItem('收益加成', _getLingjiBonus(level), Colors.green)),
                Expanded(child: _buildLingjiItem('交易手续费', _getTradeFee(level), Colors.orange)),
                Expanded(child: _buildLingjiItem('云存储', _getCloudStorage(level), Colors.blue)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLingjiItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildMemberPackages(BuildContext context, int currentLevel) {
    final packages = [
      _MemberPackage(level: 1, name: '中级会员', price: 350, color: Colors.blue, features: [
        '云备份基础存储',
        '3D穴位基础内容',
        '脉象基础教学',
        '完整八字解析',
        '个人命盘联动',
        '积分收益加成30%',
        '交易手续费8折',
      ]),
      _MemberPackage(level: 2, name: '高级会员', price: 700, color: Colors.purple, features: [
        '中级会员全部功能',
        '无限云存+多设备同步',
        '全名家辨证权限',
        '倪海厦全套教学',
        '命理全流派切换',
        '自建社群特权',
        '积分收益加成60%',
        '交易手续费5折',
      ]),
      _MemberPackage(level: 3, name: '至尊会员', price: 1000, color: Colors.amber, features: [
        '高级会员全部功能',
        '全功能永久全开',
        '交易免手续费',
        '积分收益翻倍',
        '无限云存储永久同步',
        '优先客服支持',
      ]),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('会员套餐', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...packages.map((pkg) => _buildPackageCard(context, pkg, currentLevel)),
      ],
    );
  }

  Widget _buildPackageCard(BuildContext context, _MemberPackage pkg, int currentLevel) {
    final isCurrent = pkg.level <= currentLevel;
    final isUpgrade = pkg.level > currentLevel;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isUpgrade ? pkg.color : Colors.grey.shade300, width: isUpgrade ? 2 : 1),
      ),
      child: InkWell(
        onTap: isCurrent ? null : () => _showUpgradeDialog(context, pkg),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: pkg.color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.workspace_premium, color: pkg.color, size: 20),
                        const SizedBox(width: 4),
                        Text(pkg.name, style: TextStyle(color: pkg.color, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (isCurrent) Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(8)),
                    child: const Text('已开通', style: TextStyle(color: Colors.green, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: pkg.features.map((f) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                  child: Text(f, style: const TextStyle(fontSize: 11)),
                )).toList(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('¥${pkg.price}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isCurrent ? Colors.grey : Colors.red)),
                  if (pkg.level > 1) Text('（年）', style: TextStyle(color: Colors.grey.shade600)),
                  const Spacer(),
                  if (!isCurrent)
                    ElevatedButton(
                      onPressed: () => _showUpgradeDialog(context, pkg),
                      style: ElevatedButton.styleFrom(backgroundColor: pkg.color),
                      child: const Text('立即开通'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMingLiPackage(BuildContext context, int currentLevel) {
    final user = context.read<UserProvider>().currentUser;
    final hasMingLi = (user?.memberLevel ?? 0) >= 2;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: hasMingLi ? Colors.green : Colors.grey.shade300, width: hasMingLi ? 2 : 1),
      ),
      child: InkWell(
        onTap: hasMingLi ? null : () => _showMingLiDialog(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.teal.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.auto_awesome, color: Colors.teal),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('命理全科套餐', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('解锁所有命理解读、典籍、名家批注', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  if (hasMingLi) Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(8)),
                    child: const Text('已开通', style: TextStyle(color: Colors.green, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  '八字四柱完整排盘', '奇门遁甲完整盘', '紫微斗数十二宫',
                  '大六壬袖中金标准', '六爻纳甲卦象', '梅花易数心易',
                  '全部典籍批注', '名家高阶解读',
                ].map((f) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                  child: Text(f, style: const TextStyle(fontSize: 11)),
                )).toList(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('¥300', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: hasMingLi ? Colors.grey : Colors.red)),
                  const Text('（永久）', style: TextStyle(color: Colors.grey)),
                  const Spacer(),
                  if (!hasMingLi)
                    ElevatedButton(
                      onPressed: () => _showMingLiDialog(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      child: const Text('解锁全科'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitsDetail(int level) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('特权对比', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildBenefitRow(Icons.chat, '加好友/私聊', level >= 0, level >= 1, level >= 2),
            _buildBenefitRow(Icons.group, '加群/群聊', level >= 0, level >= 1, level >= 2),
            _buildBenefitRow(Icons.add_circle, '自建社群', false, false, level >= 2),
            _buildBenefitRow(Icons.cloud_upload, '云备份', false, true, true),
            _buildBenefitRow(Icons.sync, '多设备同步', false, false, true),
            _buildBenefitRow(Icons.auto_awesome, '命理全流派', false, false, true),
            _buildBenefitRow(Icons.local_hospital, '倪海厦全套', false, false, true),
            _buildBenefitRow(Icons.workspace_premium, '全名家辨证', false, false, true),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String title, bool free, bool mid, bool high) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
          _buildCheckmark(free),
          _buildCheckmark(mid),
          _buildCheckmark(high),
        ],
      ),
    );
  }

  Widget _buildCheckmark(bool available) {
    return Container(
      width: 32,
      alignment: Alignment.center,
      child: Icon(
        available ? Icons.check_circle : Icons.cancel,
        color: available ? Colors.green : Colors.grey.shade300,
        size: 18,
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context, _MemberPackage pkg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('开通${pkg.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('价格: ¥${pkg.price}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('支付方式'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(label: const Text('微信支付'), avatar: const Icon(Icons.payment, size: 16), onPressed: () {}),
                ActionChip(label: const Text('支付宝'), avatar: const Icon(Icons.payment, size: 16), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(child: Text('使用灵积可抵扣部分金额，当前余额: 0', style: TextStyle(fontSize: 12, color: Colors.amber.shade800))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); },
            style: ElevatedButton.styleFrom(backgroundColor: pkg.color),
            child: const Text('确认支付'),
          ),
        ],
      ),
    );
  }

  void _showMingLiDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('解锁命理全科'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¥300 永久解锁'),
            SizedBox(height: 8),
            Text('包含：八字、奇门、紫微、大六壬、六爻、梅花全部解读'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('确认支付'),
          ),
        ],
      ),
    );
  }

  String _getMemberName(int level) {
    switch (level) {
      case 0: return '免费会员';
      case 1: return '中级会员';
      case 2: return '高级会员';
      case 3: return '至尊会员';
      default: return '免费会员';
    }
  }

  Color _getMemberColor(int level) {
    switch (level) {
      case 1: return Colors.blue;
      case 2: return Colors.purple;
      case 3: return Colors.amber;
      default: return Colors.grey;
    }
  }

  String _getMemberBonus(int level) {
    switch (level) {
      case 1: return '收益+30%';
      case 2: return '收益+60%';
      case 3: return '收益翻倍';
      default: return '无加成';
    }
  }

  String _getLingjiBonus(int level) {
    switch (level) {
      case 1: return '+30%';
      case 2: return '+60%';
      case 3: return 'x2';
      default: return '-';
    }
  }

  String _getTradeFee(int level) {
    switch (level) {
      case 1: return '8折';
      case 2: return '5折';
      case 3: return '免费';
      default: return '标准';
    }
  }

  String _getCloudStorage(int level) {
    switch (level) {
      case 1: return '基础';
      case 2: return '无限';
      case 3: return '永久';
      default: return '无';
    }
  }
}

class _MemberPackage {
  final int level;
  final String name;
  final int price;
  final Color color;
  final List<String> features;

  _MemberPackage({required this.level, required this.name, required this.price, required this.color, required this.features});
}
