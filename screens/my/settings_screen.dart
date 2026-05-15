import 'package:flutter/material.dart';
import '../../config/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('账户安全', [
            _buildSettingItem(
              Icons.lock,
              '修改密码',
              () {},
            ),
            _buildSettingItem(
              Icons.phone,
              '更换手机号',
              () {},
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection('云同步', [
            _buildSwitchItem(
              Icons.cloud_sync,
              '自动云备份',
              '开启后自动同步数据到云端',
              false,
              (value) {},
            ),
            _buildSwitchItem(
              Icons.wifi,
              '仅Wi-Fi同步',
              '仅在连接Wi-Fi时自动同步',
              true,
              (value) {},
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection('通知', [
            _buildSwitchItem(
              Icons.notifications,
              '推送通知',
              '接收系统推送',
              true,
              (value) {},
            ),
            _buildSwitchItem(
              Icons.message,
              '消息通知',
              '接收私信和群聊消息',
              true,
              (value) {},
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection('其他', [
            _buildSettingItem(
              Icons.language,
              '语言',
              () => _showLanguageDialog(context),
            ),
            _buildSettingItem(
              Icons.storage,
              '清除缓存',
              () => _showClearCacheDialog(context),
            ),
            _buildSettingItem(
              Icons.info,
              '关于我们',
              () => _showAboutDialog(context),
            ),
          ]),
          const SizedBox(height: 32),
          Center(
            child: Text(
              '灵积中医 v1.0.0',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primaryColor,
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择语言'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('简体中文'),
              leading: Radio(
                value: 'zh',
                groupValue: 'zh',
                onChanged: (_) => Navigator.pop(context),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('English'),
              leading: Radio(
                value: 'en',
                groupValue: 'zh',
                onChanged: (_) => Navigator.pop(context),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除缓存'),
        content: const Text('确定要清除缓存吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('缓存已清除')),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: '灵积中医',
        applicationVersion: '1.0.0',
        applicationIcon: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              '灵',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        children: const [
          Text('专业中医经方+命理+五运六气+社群社交+积分交易综合平台'),
          SizedBox(height: 8),
          Text('© 2024 灵积中医 版权所有'),
        ],
      ),
    );
  }
}
