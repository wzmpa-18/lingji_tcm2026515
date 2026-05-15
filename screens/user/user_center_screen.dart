import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserCenterScreen extends StatefulWidget {
  const UserCenterScreen({super.key});

  @override
  State<UserCenterScreen> createState() => _UserCenterScreenState();
}

class _UserCenterScreenState extends State<UserCenterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人中心'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          final user = userProvider.currentUser;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileCard(user),
                const SizedBox(height: 24),
                _buildVerificationStatus(),
                const SizedBox(height: 24),
                _buildMenuSection('资料管理', [
                  _MenuItem(Icons.person, '头像昵称', () {}),
                  _MenuItem(Icons.article, '个人简介', () {}),
                  _MenuItem(Icons.qr_code, '我的二维码', () {}),
                ]),
                const SizedBox(height: 16),
                _buildMenuSection('账号安全', [
                  _MenuItem(Icons.lock, '登录密码', () {}),
                  _MenuItem(Icons.password, '支付密码', () {}),
                  _MenuItem(Icons.phone, '更换手机号', () {}),
                  _MenuItem(Icons.devices, '登录设备', () {}),
                ]),
                const SizedBox(height: 16),
                _buildMenuSection('钱包管理', [
                  _MenuItem(Icons.account_balance_wallet, '我的钱包', () => context.go('/wallet')),
                  _MenuItem(Icons.credit_card, '银行卡管理', () {}),
                  _MenuItem(Icons.payment, '收款账户', () {}),
                  _MenuItem(Icons.history, '交易记录', () {}),
                ]),
                const SizedBox(height: 16),
                _buildMenuSection('系统设置', [
                  _MenuItem(Icons.palette, '主题设置', () {}),
                  _MenuItem(Icons.language, '语言切换', () {}),
                  _MenuItem(Icons.notifications, '通知设置', () {}),
                  _MenuItem(Icons.privacy_tip, '隐私设置', () {}),
                ]),
                const SizedBox(height: 16),
                _buildMenuSection('其他', [
                  _MenuItem(Icons.help, '帮助中心', () {}),
                  _MenuItem(Icons.info, '关于我们', () {}),
                  _MenuItem(Icons.logout, '退出登录', () => _showLogoutDialog(context)),
                ]),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(dynamic user) {
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
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: Text(
              user?.nickname.substring(0, 1) ?? '游',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.nickname ?? '未登录',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '手机号: ${user?.phone.replaceRange(3, 7, '****') ?? ''}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildBadge('VIP${user?.memberLevel ?? 0}'),
                    const SizedBox(width: 8),
                    _buildBadge('Lv.${user?.memberLevel ?? 0}'),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildVerificationStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '实名认证',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => context.go('/my/verification'),
                child: const Text('认证中心'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildVerifyItem(Icons.phone_android, '手机号', true)),
              Expanded(child: _buildVerifyItem(Icons.email, '邮箱', false)),
              Expanded(child: _buildVerifyItem(Icons.badge, '身份证', false)),
              Expanded(child: _buildVerifyItem(Icons.face, '人脸', false)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyItem(IconData icon, String label, bool verified) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: verified ? Colors.green.shade100 : Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: verified ? Colors.green : Colors.grey,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: verified ? Colors.green : Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Icon(
          verified ? Icons.check_circle : Icons.circle_outlined,
          size: 14,
          color: verified ? Colors.green : Colors.grey.shade300,
        ),
      ],
    );
  }

  Widget _buildMenuSection(String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  ListTile(
                    leading: Icon(item.icon, color: AppTheme.primaryColor),
                    title: Text(item.label),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: item.onTap,
                  ),
                  if (index < items.length - 1)
                    Divider(height: 1, indent: 56),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<UserProvider>().logout();
              if (context.mounted) {
                Navigator.pop(context);
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _MenuItem(this.icon, this.label, this.onTap);
}
