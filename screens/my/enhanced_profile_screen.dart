import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../models/member_permission.dart';
import '../../config/theme.dart';
import 'package:intl/intl.dart';

class EnhancedProfileScreen extends StatefulWidget {
  const EnhancedProfileScreen({super.key});

  @override
  State<EnhancedProfileScreen> createState() => _EnhancedProfileScreenState();
}

class _EnhancedProfileScreenState extends State<EnhancedProfileScreen> {
  final TextEditingController _bioController = TextEditingController();
  bool _isEditingBio = false;
  String _bio = '这个人很懒，什么都没写...';

  @override
  void initState() {
    super.initState();
    _bioController.text = _bio;
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人主页'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditDialog,
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          final user = userProvider.currentUser;
          if (user == null) {
            return const Center(child: Text('未登录'));
          }
          final permission = MemberPermission(user.memberLevel);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeader(user.nickname, user.avatar),
              const SizedBox(height: 16),
              _buildBioCard(permission),
              const SizedBox(height: 16),
              _buildInfoCard(user),
              const SizedBox(height: 16),
              _buildMemberCard(user),
              const SizedBox(height: 16),
              _buildQuickActions(user),
              const SizedBox(height: 24),
              _buildHistorySection(),
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
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(nickname, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBioCard(MemberPermission permission) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.article, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Text('个人简介', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                if (permission.maxProfileBioLength >= 2000)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.purple.shade100, borderRadius: BorderRadius.circular(8)),
                    child: const Text('VIP', style: TextStyle(fontSize: 10, color: Colors.purple)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(_bio, style: const TextStyle(fontSize: 14, height: 1.6)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('${_bio.length}/${permission.maxProfileBioLength}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _copyBio(),
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('复制'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(dynamic user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.phone, color: AppTheme.primaryColor),
              title: const Text('手机号'),
              trailing: Text(user.phone.replaceRange(3, 7, '****'), style: const TextStyle(color: Colors.grey)),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.card_membership, color: AppTheme.primaryColor),
              title: const Text('会员等级'),
              trailing: Text(_getMemberLevelName(user.memberLevel), style: TextStyle(color: _getMemberColor(user.memberLevel), fontWeight: FontWeight.bold)),
            ),
            if (user.memberExpireDate != null) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                title: const Text('会员到期'),
                trailing: Text(DateFormat('yyyy-MM-dd').format(user.memberExpireDate), style: const TextStyle(color: Colors.grey)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(dynamic user) {
    return Card(
      child: InkWell(
        onTap: () {},
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
                    colors: [_getMemberColor(user.memberLevel), _getMemberColor(user.memberLevel).withOpacity(0.7)],
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
                    Text(_getMemberLevelName(user.memberLevel), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(user.memberLevel == 0 ? '升级解锁云备份' : '畅享全部功能', style: TextStyle(color: Colors.grey.shade600)),
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

  Widget _buildQuickActions(dynamic user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('快捷操作', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildActionChip(Icons.history, '问诊记录', () {}),
                _buildActionChip(Icons.auto_graph, '命理排盘', () {}),
                _buildActionChip(Icons.wb_sunny, '五运六气', () {}),
                _buildActionChip(Icons.cloud_upload, '云备份', () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip(IconData icon, String label, VoidCallback onTap) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }

  Widget _buildHistorySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.history, color: AppTheme.secondaryColor),
                SizedBox(width: 8),
                Text('历史记录', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            const Text('问诊、脉象舌苔、命理排盘、五运六气记录', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const Text('本机永久查看，无数量限制', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.phone_android, color: Colors.green.shade600, size: 20),
                const SizedBox(width: 8),
                Text('本地SQLite存储', style: TextStyle(color: Colors.green.shade600, fontSize: 12)),
                const Spacer(),
                Icon(Icons.cloud_off, color: Colors.grey.shade400, size: 20),
                const SizedBox(width: 8),
                Text('免费会员无云端', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog() {
    final user = context.read<UserProvider>().currentUser;
    final permission = MemberPermission(user?.memberLevel ?? 0);

    _bioController.text = _bio;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑个人简介'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _bioController,
                maxLines: 5,
                maxLength: permission.maxProfileBioLength,
                decoration: InputDecoration(
                  hintText: '写感悟、命理语录、推广引流话术...',
                  border: const OutlineInputBorder(),
                  counterText: '${_bioController.text.length}/${permission.maxProfileBioLength}',
                ),
                onChanged: (value) => setState(() {}),
              ),
              if (permission.maxProfileBioLength < 2000) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.lock, size: 16, color: Colors.amber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '升级高级会员解锁更多字数和转发功能',
                          style: TextStyle(fontSize: 12, color: Colors.amber.shade800),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _bio = _bioController.text;
                _isEditingBio = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('简介已保存')));
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _copyBio() {
    Clipboard.setData(ClipboardData(text: _bio));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('简介已复制，可转发微信群和朋友圈')),
    );
  }

  String _getMemberLevelName(int level) {
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
      case 0: return Colors.grey;
      case 1: return Colors.blue;
      case 2: return Colors.purple;
      case 3: return Colors.amber;
      default: return Colors.grey;
    }
  }
}
