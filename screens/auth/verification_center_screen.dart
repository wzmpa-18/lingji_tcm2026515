import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';

class VerificationCenterScreen extends StatefulWidget {
  const VerificationCenterScreen({super.key});

  @override
  State<VerificationCenterScreen> createState() => _VerificationCenterScreenState();
}

class _VerificationCenterScreenState extends State<VerificationCenterScreen> {
  final List<VerificationItem> _verificationItems = [
    VerificationItem(
      id: 'phone',
      title: '手机号认证',
      subtitle: '已绑定手机号，用于登录和找回密码',
      icon: Icons.phone_android,
      color: Colors.blue,
      status: VerificationStatus.verified,
      description: '186****8888',
    ),
    VerificationItem(
      id: 'email',
      title: '邮箱认证',
      subtitle: '绑定邮箱，用于接收通知和找回密码',
      icon: Icons.email,
      color: Colors.orange,
      status: VerificationStatus.pending,
      description: '未绑定',
    ),
    VerificationItem(
      id: 'idcard',
      title: '身份证认证',
      subtitle: '实名认证，解锁更多功能和提现',
      icon: Icons.badge,
      color: Colors.green,
      status: VerificationStatus.pending,
      description: '未认证',
      unlockedFeatures: ['银行卡绑定', '提现功能', '达人入驻'],
    ),
    VerificationItem(
      id: 'face',
      title: '人脸认证',
      subtitle: '最高等级认证，保障账户安全',
      icon: Icons.face,
      color: Colors.purple,
      status: VerificationStatus.pending,
      description: '未认证',
      unlockedFeatures: ['全部高级功能', '一对一服务', '专属客服'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('认证中心'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildVerificationList(),
            const SizedBox(height: 24),
            _buildBenefits(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
                  Icons.verified_user,
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
                      '四重实名认证体系',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '认证等级越高，解锁功能越多',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('已完成', '1/4', Colors.green),
              _buildStatItem('待认证', '3/4', Colors.orange),
              _buildStatItem('解锁功能', '12项', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '认证项目',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ..._verificationItems.map((item) => _buildVerificationCard(item)),
      ],
    );
  }

  Widget _buildVerificationCard(VerificationItem item) {
    final isVerified = item.status == VerificationStatus.verified;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isVerified ? Colors.green.shade100 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isVerified ? '已认证' : '待认证',
                              style: TextStyle(
                                fontSize: 10,
                                color: isVerified ? Colors.green : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isVerified)
                  const Icon(Icons.check_circle, color: Colors.green)
                else
                  ElevatedButton(
                    onPressed: () => _showVerificationDialog(item),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: item.color,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('认证'),
                  ),
              ],
            ),
            if (item.unlockedFeatures != null && item.unlockedFeatures!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: item.unlockedFeatures!.map((feature) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isVerified ? Icons.lock_open : Icons.lock,
                          size: 12,
                          color: isVerified ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          feature,
                          style: TextStyle(
                            fontSize: 11,
                            color: isVerified ? Colors.green : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBenefits() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 8),
              const Text(
                '认证权益',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBenefitItem('完成身份证认证，解锁银行卡绑定和提现功能'),
          _buildBenefitItem('完成人脸认证，解锁全部高级功能和专属客服'),
          _buildBenefitItem('认证等级越高，获得平台信任度越高'),
          _buildBenefitItem('实名用户可申请成为平台达人接单'),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.amber)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Colors.amber.shade800,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showVerificationDialog(VerificationItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${item.title}认证'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.subtitle),
              const SizedBox(height: 16),
              const Text('请按照以下步骤完成认证：'),
              const SizedBox(height: 8),
              const Text('1. 输入您的${item.id == 'phone' ? '手机号' : item.id == 'email' ? '邮箱' : item.id == 'idcard' ? '身份证号' : '人脸信息'}'),
              const Text('2. 获取验证码（如适用）'),
              const Text('3. 完成验证'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.security, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '您的信息将安全加密存储，仅用于平台认证',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('认证功能开发中...')),
              );
            },
            child: const Text('开始认证'),
          ),
        ],
      ),
    );
  }
}

enum VerificationStatus { verified, pending, failed }

class VerificationItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VerificationStatus status;
  final String description;
  final List<String>? unlockedFeatures;

  VerificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.status,
    required this.description,
    this.unlockedFeatures,
  });
}
