import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/permission_config.dart';
import '../models/human_body_3d.dart';
import '../providers/user_provider.dart';
import '../services/permission_service.dart';

class PermissionWrapper extends StatelessWidget {
  final String permissionId;
  final Widget child;
  final Widget? lockedWidget;
  final String? lockedMessage;
  final bool showUpgradeButton;

  const PermissionWrapper({
    super.key,
    required this.permissionId,
    required this.child,
    this.lockedWidget,
    this.lockedMessage,
    this.showUpgradeButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().currentUser;
    final userLevel = _getMemberLevel(user?.memberLevel ?? 0);
    final service = PermissionService();
    service.initialize();

    final hasAccess = service.checkPermission(permissionId, userLevel);

    if (hasAccess) {
      return child;
    }

    return lockedWidget ?? _buildDefaultLockedWidget(context, permissionId, userLevel);
  }

  Widget _buildDefaultLockedWidget(BuildContext context, String permissionId, MemberLevel userLevel) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock_outline,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 12),
          Text(
            lockedMessage ?? _getLockedMessage(permissionId),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          if (showUpgradeButton) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upgrade),
              label: Text('升级解锁'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  MemberLevel _getMemberLevel(int level) {
    switch (level) {
      case 0:
        return MemberLevel.free;
      case 1:
        return MemberLevel.basic;
      case 2:
        return MemberLevel.standard;
      case 3:
        return MemberLevel.premium;
      case 4:
        return MemberLevel.ultimate;
      default:
        return MemberLevel.free;
    }
  }

  String _getLockedMessage(String permissionId) {
    if (permissionId.startsWith('acu_needle')) {
      return '针刺手法教学需要高级会员\n立即升级获取完整教学内容';
    } else if (permissionId.startsWith('acu_joint')) {
      return '关节动态演示需要高级会员\n立即升级观看完整动画';
    } else if (permissionId.startsWith('acu_3d_all')) {
      return '高清3D全部视角需要至尊会员\n立即升级体验完整功能';
    } else if (permissionId.startsWith('bone_full') || permissionId.startsWith('bone_secret')) {
      return '正骨完整实操需要高级会员\n立即升级获取秘传内容';
    } else if (permissionId.startsWith('massage_detail') || permissionId.startsWith('massage_full')) {
      return '按摩实操图解需要高级会员\n立即升级观看完整教学';
    } else if (permissionId.startsWith('storage_')) {
      return '云存储特权需要会员开通\n立即升级享受更多空间';
    }
    return '此内容需要更高会员级别\n立即升级获取访问权限';
  }
}

class AcupointDetailWithPermission extends StatelessWidget {
  final Acupoint3D acupoint;
  final VoidCallback? onClose;

  const AcupointDetailWithPermission({
    super.key,
    required this.acupoint,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().currentUser;
    final userLevel = _getMemberLevel(user?.memberLevel ?? 0);
    final service = PermissionService();
    service.initialize();

    final canViewTechnique = service.checkPermission('acu_needle_angle', userLevel);
    final canViewDepth = service.checkPermission('acu_needle_depth', userLevel);
    final canViewNeedleTech = service.checkPermission('acu_needle_technique', userLevel);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('穴', style: TextStyle(color: Colors.red)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        acupoint.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${acupoint.code} · ${acupoint.meridian}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailSection('穴位描述', acupoint.description),
            _buildDetailSection('主治功效', acupoint.主治),
            _buildDetailSection('配伍应用', acupoint.配伍应用),
            _buildTechniqueSection(acupoint.technique, canViewTechnique, canViewDepth, canViewNeedleTech),
            if (acupoint.taboos.isNotEmpty) _buildTabooSection(acupoint.taboos),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: TextStyle(
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTechniqueSection(AcupointTechnique technique, bool canViewTechnique, bool canViewDepth, bool canViewNeedleTech) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '针刺手法',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTechniqueRow('进针角度', technique.angleType.displayName, canViewTechnique),
              if (canViewTechnique)
                _buildTechniqueRow('角度说明', technique.angleType.description, true),
              if (canViewDepth)
                _buildTechniqueRow('针刺深度', '${technique.depth}寸', true),
              if (canViewNeedleTech)
                _buildTechniqueRow('针刺方向', technique.direction.displayName, true),
              if (canViewNeedleTech)
                _buildTechniqueRow('操作手法', technique.manipulation, true),
            ],
          ),
        ),
        if (!canViewTechnique) ...[
          const SizedBox(height: 8),
          _buildLockedHint('进针角度详解需要高级会员'),
        ],
        if (!canViewDepth) ...[
          const SizedBox(height: 4),
          _buildLockedHint('针刺深浅详解需要高级会员'),
        ],
        if (!canViewNeedleTech) ...[
          const SizedBox(height: 4),
          _buildLockedHint('捻针手法教学需要高级会员'),
        ],
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTechniqueRow(String label, String value, bool hasAccess) {
    if (!hasAccess) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              child: Text(
                '$label:',
                style: TextStyle(color: Colors.grey[500], fontSize: 12, decoration: TextDecoration.lineThrough),
              ),
            ),
            Expanded(
              child: Text(
                '***',
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedHint(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock, size: 12, color: Colors.orange),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 11, color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabooSection(List<AcupointTaboo> taboos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '禁忌说明',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
        ),
        const SizedBox(height: 8),
        ...taboos.map((taboo) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red[100]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning, size: 16, color: Colors.red[700]),
                  const SizedBox(width: 4),
                  Text(
                    taboo.type,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: taboo.severity == '高' ? Colors.red : Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${taboo.severity}风险',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                taboo.description,
                style: TextStyle(fontSize: 12, color: Colors.red[700]),
              ),
            ],
          ),
        )),
      ],
    );
  }

  MemberLevel _getMemberLevel(int level) {
    switch (level) {
      case 0:
        return MemberLevel.free;
      case 1:
        return MemberLevel.basic;
      case 2:
        return MemberLevel.standard;
      case 3:
        return MemberLevel.premium;
      case 4:
        return MemberLevel.ultimate;
      default:
        return MemberLevel.free;
    }
  }
}

class JointDetailWithPermission extends StatelessWidget {
  final Joint3D joint;

  const JointDetailWithPermission({
    super.key,
    required this.joint,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().currentUser;
    final userLevel = _getMemberLevel(user?.memberLevel ?? 0);
    final service = PermissionService();
    service.initialize();

    final canViewAnimation = service.checkPermission('acu_joint_animation', userLevel);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey[300]!)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('关', style: TextStyle(color: Colors.blue)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        joint.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${joint.type.displayName} · ${joint.type.description}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              joint.description,
              style: TextStyle(color: Colors.grey[700], height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              '运动范围',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            ...joint.movements.map((movement) => _buildMovementItem(movement, canViewAnimation)),
            if (!canViewAnimation) ...[
              const SizedBox(height: 16),
              _buildLockedAnimationHint(),
            ],
            const SizedBox(height: 16),
            const Text(
              '相关肌肉',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: joint.relatedMuscles.map((muscle) => Chip(
                label: Text(muscle, style: const TextStyle(fontSize: 12)),
                backgroundColor: Colors.orange[50],
              )).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              '相关骨骼',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: joint.relatedBones.map((bone) => Chip(
                label: Text(bone, style: const TextStyle(fontSize: 12)),
                backgroundColor: Colors.grey[200],
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovementItem(JointMovement movement, bool canViewAnimation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: canViewAnimation ? Colors.green[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movement.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: canViewAnimation ? Colors.black : Colors.grey,
                  ),
                ),
                Text(
                  '角度范围: ${movement.minAngle}° - ${movement.maxAngle}°',
                  style: TextStyle(
                    color: canViewAnimation ? Colors.grey[600] : Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (movement.canAnimate && canViewAnimation)
            IconButton(
              icon: const Icon(Icons.play_circle, color: Colors.green),
              onPressed: () {},
            )
          else if (movement.canAnimate && !canViewAnimation)
            const Icon(Icons.lock, color: Colors.grey)
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildLockedAnimationHint() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        children: [
          const Icon(Icons.animation, size: 48, color: Colors.orange),
          const SizedBox(height: 8),
          const Text(
            '关节动态演示',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '需要高级会员才能观看完整动画演示',
            style: TextStyle(
              color: Colors.orange[700],
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('立即升级'),
          ),
        ],
      ),
    );
  }

  MemberLevel _getMemberLevel(int level) {
    switch (level) {
      case 0:
        return MemberLevel.free;
      case 1:
        return MemberLevel.basic;
      case 2:
        return MemberLevel.standard;
      case 3:
        return MemberLevel.premium;
      case 4:
        return MemberLevel.ultimate;
      default:
        return MemberLevel.free;
    }
  }
}
