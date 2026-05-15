import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';

class MemberScreen extends StatelessWidget {
  const MemberScreen({super.key});

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
              _buildBenefitsCard(),
              const SizedBox(height: 24),
              _buildMemberPackages(context, currentLevel),
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
          const Icon(
            Icons.workspace_premium,
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            _getMemberName(level),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            level == 0 ? '升级会员解锁更多功能' : '感谢您的支持',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '会员权益',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildBenefitRow(Icons.cloud_done, '云备份', '本地数据云端同步', _getMemberColor(1)),
            _buildBenefitRow(Icons.sync, '多设备同步', '手机平板无缝切换', _getMemberColor(2)),
            _buildBenefitRow(Icons.priority_high, '优先客服', '专属客服快速响应', _getMemberColor(3)),
            _buildBenefitRow(Icons.remove_red_eye, '命理解读', 'AI命理深度解读', _getMemberColor(3)),
            _buildBenefitRow(Icons.analytics, '高级分析', '更多脉象舌诊分析', _getMemberColor(2)),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String title, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberPackages(BuildContext context, int currentLevel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '选择套餐',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...AppConstants.memberPrices.entries.map((entry) {
          return _buildPackageCard(context, entry.key, entry.value, currentLevel);
        }),
      ],
    );
  }

  Widget _buildPackageCard(BuildContext context, int level, double price, int currentLevel) {
    final isCurrent = level <= currentLevel;
    final isUpgrade = level > currentLevel;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isUpgrade ? _getMemberColor(level) : Colors.grey.shade300,
          width: isUpgrade ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: isCurrent ? null : () => _showUpgradeDialog(context, level, price),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getMemberColor(level).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.workspace_premium,
                  color: _getMemberColor(level),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getMemberName(level),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getMemberDesc(level),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '¥$price',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isCurrent ? Colors.grey : Colors.red,
                    ),
                  ),
                  if (isCurrent)
                    const Text(
                      '当前',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context, int level, double price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('升级到${_getMemberName(level)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('价格: ¥$price'),
            const SizedBox(height: 8),
            const Text('确认升级？'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<UserProvider>().upgradeMember(level);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('升级成功'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('确认升级'),
          ),
        ],
      ),
    );
  }

  String _getMemberName(int level) {
    return AppConstants.memberLevels[level] ?? '免费会员';
  }

  String _getMemberDesc(int level) {
    switch (level) {
      case 1:
        return '云备份·30天有效';
      case 2:
        return '云备份+多设备同步·1年';
      case 3:
        return '全功能·1年·优先客服';
      default:
        return '';
    }
  }

  Color _getMemberColor(int level) {
    switch (level) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.purple;
      case 3:
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}
