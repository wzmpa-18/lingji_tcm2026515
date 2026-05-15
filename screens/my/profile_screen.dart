import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../config/theme.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人资料'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          final user = userProvider.currentUser;
          if (user == null) {
            return const Center(child: Text('未登录'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeader(user.nickname, user.avatar),
              const SizedBox(height: 24),
              _buildInfoCard(context, user),
              const SizedBox(height: 16),
              _buildPromotionCard(context, user),
              const SizedBox(height: 16),
              _buildMemberCard(context, user),
              const SizedBox(height: 24),
              _buildMenuList(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(String nickname, String? avatar) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppTheme.primaryColor,
            child: Text(
              nickname.substring(0, 1),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            nickname,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, dynamic user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.phone, color: AppTheme.primaryColor),
              title: const Text('手机号'),
              trailing: Text(
                user.phone.replaceRange(3, 7, '****'),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.card_membership, color: AppTheme.primaryColor),
              title: const Text('会员等级'),
              trailing: Text(
                _getMemberLevelName(user.memberLevel),
                style: TextStyle(
                  color: _getMemberColor(user.memberLevel),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (user.memberExpireDate != null) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                title: const Text('会员到期'),
                trailing: Text(
                  DateFormat('yyyy-MM-dd').format(user.memberExpireDate),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionCard(BuildContext context, dynamic user) {
    final shareText = '''
我在使用灵积中医APP，非常好用的中医经方+命理工具！
免费注册即得100灵积新人奖励。
下载地址：https://example.com
我的邀请码：${user.invitationCode}
''';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.share, color: AppTheme.accentColor),
                SizedBox(width: 8),
                Text(
                  '推广赚灵积',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '我的邀请码：${user.invitationCode}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '每邀请1位好友，双方各得50灵积奖励',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('推广文案已复制')),
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text('复制推广文案'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, dynamic user) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/my/member'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getMemberColor(user.memberLevel),
                      _getMemberColor(user.memberLevel).withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.workspace_premium, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getMemberLevelName(user.memberLevel),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.memberLevel == 0 ? '升级解锁云备份' : '畅享全部功能',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuList(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.settings, color: AppTheme.primaryColor),
            title: const Text('设置'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/my/settings'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.feedback, color: AppTheme.primaryColor),
            title: const Text('问题反馈'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/my/feedback'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info, color: AppTheme.primaryColor),
            title: const Text('关于我们'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('退出登录', style: TextStyle(color: Colors.red)),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('退出登录'),
                  content: const Text('确定要退出登录吗？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('取消'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('退出'),
                    ),
                  ],
                ),
              );

              if (confirmed == true && context.mounted) {
                await context.read<UserProvider>().logout();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  String _getMemberLevelName(int level) {
    switch (level) {
      case 0:
        return '免费会员';
      case 1:
        return '中级会员';
      case 2:
        return '高级会员';
      case 3:
        return '至尊会员';
      default:
        return '免费会员';
    }
  }

  Color _getMemberColor(int level) {
    switch (level) {
      case 0:
        return Colors.grey;
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
