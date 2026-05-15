import '../models/permission_config.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  List<PermissionItem> _permissions = [];
  DateTime _lastUpdated = DateTime.now();
  String _updatedBy = 'system';

  List<PermissionItem> get permissions => _permissions;
  DateTime get lastUpdated => _lastUpdated;
  String get updatedBy => _updatedBy;

  void initialize() {
    _permissions = PermissionItem.getAllItems();
  }

  bool checkPermission(String permissionId, MemberLevel userLevel) {
    final permission = _permissions.firstWhere(
      (p) => p.id == permissionId,
      orElse: () => PermissionItem(
        id: permissionId,
        name: 'Unknown',
        description: '',
        category: PermissionCategory.tcm,
        type: PermissionType.view,
        allowedLevels: [MemberLevel.free],
      ),
    );
    return permission.isAccessible(userLevel);
  }

  bool checkFeature(String featureId, MemberLevel userLevel) {
    return checkPermission(featureId, userLevel);
  }

  void updatePermission(String permissionId, List<MemberLevel> newAllowedLevels, {String updatedBy = 'admin'}) {
    final index = _permissions.indexWhere((p) => p.id == permissionId);
    if (index != -1) {
      _permissions[index] = _permissions[index].copyWith(
        allowedLevels: newAllowedLevels,
        lastModified: DateTime.now(),
      );
      _lastUpdated = DateTime.now();
      _updatedBy = updatedBy;
    }
  }

  void lockPermission(String permissionId, {String updatedBy = 'admin'}) {
    final index = _permissions.indexWhere((p) => p.id == permissionId);
    if (index != -1) {
      _permissions[index] = _permissions[index].copyWith(
        isLocked: true,
        lastModified: DateTime.now(),
      );
      _lastUpdated = DateTime.now();
      _updatedBy = updatedBy;
    }
  }

  void unlockPermission(String permissionId, {String updatedBy = 'admin'}) {
    final index = _permissions.indexWhere((p) => p.id == permissionId);
    if (index != -1) {
      _permissions[index] = _permissions[index].copyWith(
        isLocked: false,
        lastModified: DateTime.now(),
      );
      _lastUpdated = DateTime.now();
      _updatedBy = updatedBy;
    }
  }

  void resetToDefault() {
    _permissions = PermissionItem.getAllItems();
    _lastUpdated = DateTime.now();
    _updatedBy = 'system';
  }

  List<PermissionItem> getPermissionsForLevel(MemberLevel level) {
    return _permissions.where((p) => p.isAccessible(level)).toList();
  }

  List<PermissionItem> getLockedPermissionsForLevel(MemberLevel level) {
    return _permissions.where((p) => p.allowedLevels.contains(level) && p.isLocked).toList();
  }

  List<PermissionItem> getAvailablePermissionsForLevel(MemberLevel level) {
    return _permissions.where((p) => !p.allowedLevels.contains(level)).toList();
  }

  Map<String, dynamic> exportConfig() {
    return {
      'permissions': _permissions.map((p) => p.toMap()).toList(),
      'last_updated': _lastUpdated.toIso8601String(),
      'updated_by': _updatedBy,
    };
  }

  void importConfig(Map<String, dynamic> config) {
    if (config['permissions'] != null) {
      _permissions = (config['permissions'] as List)
          .map((p) => PermissionItem.fromMap(p))
          .toList();
    }
    if (config['last_updated'] != null) {
      _lastUpdated = DateTime.parse(config['last_updated']);
    }
    if (config['updated_by'] != null) {
      _updatedBy = config['updated_by'];
    }
  }

  String getPermissionSummary(MemberLevel level) {
    final accessible = getPermissionsForLevel(level).length;
    final total = _permissions.length;
    final locked = getLockedPermissionsForLevel(level).length;
    return '已解锁 $accessible/$total 项权限，$locked 项已锁定';
  }
}

class PermissionGuard {
  static bool canAccess(MemberLevel userLevel, MemberLevel requiredLevel) {
    return userLevel.canAccess(requiredLevel);
  }

  static bool canAccessFeature(String featureId, MemberLevel userLevel) {
    final service = PermissionService();
    return service.checkPermission(featureId, userLevel);
  }

  static Widget buildRestrictedWidget({
    required Widget child,
    required Widget lockedWidget,
    required MemberLevel userLevel,
    required MemberLevel requiredLevel,
    String? featureId,
  }) {
    final canAccess = featureId != null
        ? canAccessFeature(featureId, userLevel)
        : canAccess(userLevel, requiredLevel);

    return canAccess ? child : lockedWidget;
  }
}

class PermissionRequired extends StatelessWidget {
  final MemberLevel requiredLevel;
  final MemberLevel userLevel;
  final Widget child;
  final Widget? lockedContent;
  final String? featureId;
  final String? lockedMessage;
  final bool showUpgradeButton;

  const PermissionRequired({
    super.key,
    required this.requiredLevel,
    required this.userLevel,
    required this.child,
    this.lockedContent,
    this.featureId,
    this.lockedMessage,
    this.showUpgradeButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final service = PermissionService();
    final hasAccess = featureId != null
        ? service.checkPermission(featureId!, userLevel)
        : userLevel.canAccess(requiredLevel);

    if (hasAccess) {
      return child;
    }

    return lockedContent ?? _buildDefaultLockedContent(context);
  }

  Widget _buildDefaultLockedContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock_outline,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            lockedMessage ?? '此内容需要${requiredLevel.name}及以上会员',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          if (showUpgradeButton) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upgrade),
              label: const Text('立即升级'),
            ),
          ],
        ],
      ),
    );
  }
}
