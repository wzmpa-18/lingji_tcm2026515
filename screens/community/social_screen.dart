import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/social.dart';
import '../../models/user_badge.dart';
import '../../providers/user_provider.dart';
import '../../config/theme.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Friend> _friends = [];
  List<Group> _joinedGroups = [];
  List<PrivateChat> _chats = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('社群'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: '消息'),
            Tab(text: '好友'),
            Tab(text: '群聊'),
            Tab(text: '发现'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMessagesTab(),
          _buildFriendsTab(),
          _buildGroupsTab(),
          _buildDiscoverTab(),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildMessagesTab() {
    if (_chats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text('暂无消息', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            const Text('开始聊天吧', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _chats.length,
      itemBuilder: (context, index) {
        final chat = _chats[index];
        return _buildChatTile(chat);
      },
    );
  }

  Widget _buildChatTile(PrivateChat chat) {
    final user = context.read<UserProvider>().currentUser;
    final otherUserId = chat.userId1 == user?.id ? chat.userId2 : chat.userId1;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: Text(otherUserId.substring(0, 1), style: const TextStyle(color: AppTheme.primaryColor)),
        ),
        title: Text(otherUserId),
        subtitle: Text(chat.lastMessage ?? '开始聊天吧', maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (chat.lastMessageAt != null)
              Text(
                _formatTime(chat.lastMessageAt!),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            if (chat.unreadCount > 0)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('${chat.unreadCount}', style: const TextStyle(color: Colors.white, fontSize: 10)),
              ),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildFriendsTab() {
    return Column(
      children: [
        _buildFriendRequests(),
        Expanded(
          child: _friends.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      const Text('暂无好友', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.search),
                        label: const Text('添加好友'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _friends.length,
                  itemBuilder: (context, index) {
                    final friend = _friends[index];
                    return _buildFriendTile(friend);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFriendRequests() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.amber.shade50,
      child: Row(
        children: [
          const Icon(Icons.person_add, color: Colors.amber),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('好友申请', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('0个待处理', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          TextButton(onPressed: () {}, child: const Text('查看')),
        ],
      ),
    );
  }

  Widget _buildFriendTile(Friend friend) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.accentColor.withOpacity(0.1),
          child: Text(friend.friendName.substring(0, 1), style: const TextStyle(color: AppTheme.accentColor)),
        ),
        title: Text(friend.friendName),
        subtitle: const Text('好友'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildGroupsTab() {
    final user = context.read<UserProvider>().currentUser;
    final canCreateGroup = (user?.memberLevel ?? 0) >= 1;

    return Column(
      children: [
        if (canCreateGroup)
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('创建社群'),
              ),
            ),
          ),
        Expanded(
          child: _joinedGroups.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.group_add, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      const Text('暂未加入任何群', style: TextStyle(color: Colors.grey)),
                      if (canCreateGroup) ...[
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                          label: const Text('创建社群'),
                        ),
                      ] else ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.lock, size: 14, color: Colors.amber),
                              SizedBox(width: 4),
                              Text('中级会员解锁', style: TextStyle(fontSize: 12, color: Colors.amber)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _joinedGroups.length,
                  itemBuilder: (context, index) {
                    final group = _joinedGroups[index];
                    return _buildGroupTile(group);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildGroupTile(Group group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppTheme.secondaryColor.withOpacity(0.1),
          child: Text(group.name.substring(0, 1), style: const TextStyle(color: AppTheme.secondaryColor, fontWeight: FontWeight.bold)),
        ),
        title: Text(group.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${group.memberCount}/${group.maxMembers}人', style: const TextStyle(fontSize: 12)),
            Text(group.type.displayName, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }

  Widget _buildDiscoverTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDiscoverSection('推荐群', [
          _DiscoverItem(Icons.local_hospital, '中医交流群', '中医从业者交流'),
          _DiscoverItem(Icons.auto_awesome, '命理研究群', '命理爱好者聚集'),
          _DiscoverItem(Icons.favorite, '养生保健群', '分享养生心得'),
        ]),
        const SizedBox(height: 24),
        _buildDiscoverSection('热门话题', [
          _DiscoverItem(Icons.trending_up, '倪海厦经方', '经典方剂讨论'),
          _DiscoverItem(Icons.spa, '针灸技法', '穴位与针法交流'),
          _DiscoverItem(Icons.wb_sunny, '五运六气', '气运养生'),
        ]),
        const SizedBox(height: 24),
        _buildDiscoverSection('活跃用户', [
          _DiscoverItem(Icons.star, '专业认证用户', '平台认证专家'),
          _DiscoverItem(Icons.emoji_events, '贡献榜', '优秀共建者'),
        ]),
      ],
    );
  }

  Widget _buildDiscoverSection(String title, List<_DiscoverItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) => ActionChip(
            avatar: Icon(item.icon, size: 18),
            label: Text(item.title),
            onPressed: () {},
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildFAB() {
    final user = context.read<UserProvider>().currentUser;
    final canCreateGroup = (user?.memberLevel ?? 0) >= 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.small(
          heroTag: 'friend',
          onPressed: () {},
          backgroundColor: AppTheme.accentColor,
          child: const Icon(Icons.person_add),
        ),
        const SizedBox(height: 8),
        if (canCreateGroup)
          FloatingActionButton(
            heroTag: 'group',
            onPressed: () {},
            backgroundColor: AppTheme.primaryColor,
            child: const Icon(Icons.group_add),
          ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inDays > 0) return '${diff.inDays}天前';
    if (diff.inHours > 0) return '${diff.inHours}小时前';
    if (diff.inMinutes > 0) return '${diff.inMinutes}分钟前';
    return '刚刚';
  }
}

class _DiscoverItem {
  final IconData icon;
  final String title;
  final String subtitle;

  _DiscoverItem(this.icon, this.title, this.subtitle);
}
