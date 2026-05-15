import 'package:flutter/material.dart';
import '../../models/permission_config.dart';
import '../../services/permission_service.dart';
import '../../config/theme.dart';

class PermissionCenterScreen extends StatefulWidget {
  const PermissionCenterScreen({super.key});

  @override
  State<PermissionCenterScreen> createState() => _PermissionCenterScreenState();
}

class _PermissionCenterScreenState extends State<PermissionCenterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PermissionService _service = PermissionService();
  PermissionCategory? _selectedCategory;
  bool _isEditMode = false;
  String? _editingPermissionId;
  List<MemberLevel>? _tempAllowedLevels;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _service.initialize();
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
        title: const Text('会员权限配置中心'),
        actions: [
          if (_isEditMode)
            TextButton.icon(
              onPressed: _saveChanges,
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text('保存', style: TextStyle(color: Colors.white)),
            ),
          IconButton(
            icon: Icon(_isEditMode ? Icons.close : Icons.edit),
            onPressed: () => setState(() {
              _isEditMode = !_isEditMode;
              if (!_isEditMode) {
                _editingPermissionId = null;
                _tempAllowedLevels = null;
              }
            }),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '权限配置'),
            Tab(text: '权益门槛'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPermissionConfigTab(),
          _buildThresholdTab(),
        ],
      ),
    );
  }

  Widget _buildPermissionConfigTab() {
    return Column(
      children: [
        _buildCategoryFilter(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: _buildPermissionList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: const Text('全部'),
              selected: _selectedCategory == null,
              onSelected: (_) => setState(() => _selectedCategory = null),
            ),
          ),
          ...PermissionCategory.values
              .where((c) => c != PermissionCategory.fortune &&
                             c != PermissionCategory.wuyun &&
                             c != PermissionCategory.trading)
              .map((category) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(category.icon, size: 16),
                          const SizedBox(width: 4),
                          Text(category.name),
                        ],
                      ),
                      selected: _selectedCategory == category,
                      onSelected: (_) => setState(() => _selectedCategory = category),
                    ),
                  )),
        ],
      ),
    );
  }

  List<Widget> _buildPermissionList() {
    final List<Widget> widgets = [];

    final categories = _selectedCategory != null
        ? [_selectedCategory!]
        : PermissionCategory.values.where((c) =>
            c != PermissionCategory.fortune &&
            c != PermissionCategory.wuyun &&
            c != PermissionCategory.trading);

    for (final category in categories) {
      final permissions = PermissionItem.getByCategory(category);
      if (permissions.isEmpty) continue;

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Row(
            children: [
              Icon(category.icon, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              Text(
                category.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${permissions.length}项',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      for (final permission in permissions) {
        widgets.add(_buildPermissionCard(permission));
      }
    }

    return widgets;
  }

  Widget _buildPermissionCard(PermissionItem permission) {
    final isEditing = _editingPermissionId == permission.id;
    final displayLevels = isEditing
        ? (_tempAllowedLevels ?? permission.allowedLevels)
        : permission.allowedLevels;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTypeColor(permission.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        permission.type.icon,
                        size: 14,
                        color: _getTypeColor(permission.type),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        permission.type.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getTypeColor(permission.type),
                        ),
                      ),
                    ],
                  ),
                ),
                if (permission.isLocked) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock, size: 12, color: Colors.red),
                        SizedBox(width: 2),
                        Text(
                          '已锁定',
                          style: TextStyle(fontSize: 10, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
                const Spacer(),
                if (_isEditMode && !isEditing)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _editingPermissionId = permission.id;
                        _tempAllowedLevels = List.from(permission.allowedLevels);
                      });
                    },
                    child: const Text('编辑'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              permission.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              permission.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '解锁会员级别:',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            if (isEditing)
              _buildLevelSelector(permission)
            else
              _buildLevelChips(displayLevels),
            if (permission.lastModified != null) ...[
              const SizedBox(height: 8),
              Text(
                '最后修改: ${_formatDate(permission.lastModified!)}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLevelSelector(PermissionItem permission) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: MemberLevel.values.map((level) {
            final isSelected = _tempAllowedLevels?.contains(level) ?? false;
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(level.icon, size: 14, color: level.color),
                  const SizedBox(width: 4),
                  Text(level.shortName),
                ],
              ),
              selected: isSelected,
              selectedColor: level.color.withOpacity(0.2),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _tempAllowedLevels?.add(level);
                  } else {
                    _tempAllowedLevels?.remove(level);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _editingPermissionId = null;
                  _tempAllowedLevels = null;
                });
              },
              child: const Text('取消'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                _service.updatePermission(
                  permission.id,
                  _tempAllowedLevels ?? [],
                  updatedBy: 'admin',
                );
                setState(() {
                  _editingPermissionId = null;
                  _tempAllowedLevels = null;
                });
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLevelChips(List<MemberLevel> levels) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: levels.map((level) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: level.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: level.color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(level.icon, size: 14, color: level.color),
              const SizedBox(width: 4),
              Text(
                level.shortName,
                style: TextStyle(
                  fontSize: 12,
                  color: level.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildThresholdTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildThresholdHeader(),
        const SizedBox(height: 16),
        ...MemberUpgradeThreshold.defaultThresholds.map((threshold) {
          if (threshold.level == MemberLevel.free) return const SizedBox.shrink();
          return _buildThresholdCard(threshold);
        }),
      ],
    );
  }

  Widget _buildThresholdHeader() {
    return Card(
      color: AppTheme.primaryColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text(
                  '权益门槛说明',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '用户可通过以下任一方式达到对应会员等级：\n'
              '• 累计持有足够灵积\n'
              '• 直接推荐足够人数\n'
              '• 团队达到足够规模\n'
              '• 学习时长达到要求',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThresholdCard(MemberUpgradeThreshold threshold) {
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
                    color: threshold.level.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    threshold.level.icon,
                    color: threshold.level.color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        threshold.level.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: threshold.level.color,
                        ),
                      ),
                      Text(
                        _getLevelDescription(threshold.level),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            _buildThresholdRow(
              Icons.diamond,
              '灵积要求',
              '${threshold.lingjiRequired} 灵积',
              Colors.blue,
            ),
            const SizedBox(height: 8),
            _buildThresholdRow(
              Icons.person_add,
              '直推人数',
              '${threshold.directReferrals} 人',
              Colors.green,
            ),
            const SizedBox(height: 8),
            _buildThresholdRow(
              Icons.group,
              '团队规模',
              '${threshold.teamSize} 人',
              Colors.purple,
            ),
            const SizedBox(height: 8),
            _buildThresholdRow(
              Icons.access_time,
              '学习时长',
              '${threshold.studyHours} 小时',
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThresholdRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600]),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('配置已保存'),
        backgroundColor: Colors.green,
      ),
    );
    setState(() {
      _isEditMode = false;
      _editingPermissionId = null;
      _tempAllowedLevels = null;
    });
  }

  Color _getTypeColor(PermissionType type) {
    switch (type) {
      case PermissionType.view:
        return Colors.blue;
      case PermissionType.feature:
        return Colors.green;
      case PermissionType.tutorial:
        return Colors.orange;
      case PermissionType.download:
        return Colors.purple;
      case PermissionType.export:
        return Colors.teal;
    }
  }

  String _getLevelDescription(MemberLevel level) {
    switch (level) {
      case MemberLevel.free:
        return '基础用户，仅可浏览基础内容';
      case MemberLevel.basic:
        return '解锁基础功能，享有云备份';
      case MemberLevel.standard:
        return '解锁中级功能，手续费优惠';
      case MemberLevel.premium:
        return '完整解锁全部功能，三级分润';
      case MemberLevel.ultimate:
        return '尊享全部特权，无限存储，多设备同步';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
