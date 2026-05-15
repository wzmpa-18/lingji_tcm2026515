import 'package:flutter/material.dart';

enum MemberLevel {
  free,
  basic,
  standard,
  premium,
  ultimate,
}

extension MemberLevelExtension on MemberLevel {
  String get name {
    switch (this) {
      case MemberLevel.free:
        return '免费会员';
      case MemberLevel.basic:
        return '初级会员';
      case MemberLevel.standard:
        return '中级会员';
      case MemberLevel.premium:
        return '高级会员';
      case MemberLevel.ultimate:
        return '至尊会员';
    }
  }

  String get shortName {
    switch (this) {
      case MemberLevel.free:
        return '免费';
      case MemberLevel.basic:
        return '初级';
      case MemberLevel.standard:
        return '中级';
      case MemberLevel.premium:
        return '高级';
      case MemberLevel.ultimate:
        return '至尊';
    }
  }

  Color get color {
    switch (this) {
      case MemberLevel.free:
        return Colors.grey;
      case MemberLevel.basic:
        return Colors.blue;
      case MemberLevel.standard:
        return Colors.green;
      case MemberLevel.premium:
        return Colors.purple;
      case MemberLevel.ultimate:
        return Colors.amber;
    }
  }

  IconData get icon {
    switch (this) {
      case MemberLevel.free:
        return Icons.person_outline;
      case MemberLevel.basic:
        return Icons.person;
      case MemberLevel.standard:
        return Icons.star_half;
      case MemberLevel.premium:
        return Icons.star;
      case MemberLevel.ultimate:
        return Icons.diamond;
    }
  }

  int get level {
    switch (this) {
      case MemberLevel.free:
        return 0;
      case MemberLevel.basic:
        return 1;
      case MemberLevel.standard:
        return 2;
      case MemberLevel.premium:
        return 3;
      case MemberLevel.ultimate:
        return 4;
    }
  }

  bool canAccess(MemberLevel required) {
    return this.level >= required.level;
  }
}

enum PermissionCategory {
  tcm,
  acupuncture,
  boneSetting,
  massage,
  fortune,
  wuyun,
  books,
  storage,
  trading,
}

extension PermissionCategoryExtension on PermissionCategory {
  String get name {
    switch (this) {
      case PermissionCategory.tcm:
        return '中医经方';
      case PermissionCategory.acupuncture:
        return '针灸穴位';
      case PermissionCategory.boneSetting:
        return '正骨推拿';
      case PermissionCategory.massage:
        return '按摩技法';
      case PermissionCategory.fortune:
        return '命理八字';
      case PermissionCategory.wuyun:
        return '五运六气';
      case PermissionCategory.books:
        return '典籍阅读';
      case PermissionCategory.storage:
        return '云存储';
      case PermissionCategory.trading:
        return '积分交易';
    }
  }

  IconData get icon {
    switch (this) {
      case PermissionCategory.tcm:
        return Icons.local_hospital;
      case PermissionCategory.acupuncture:
        return Icons.spa;
      case PermissionCategory.boneSetting:
        return Icons.accessibility_new;
      case PermissionCategory.massage:
        return Icons.self_improvement;
      case PermissionCategory.fortune:
        return Icons.auto_awesome;
      case PermissionCategory.wuyun:
        return Icons.wb_sunny;
      case PermissionCategory.books:
        return Icons.menu_book;
      case PermissionCategory.storage:
        return Icons.cloud;
      case PermissionCategory.trading:
        return Icons.currency_exchange;
    }
  }
}

class PermissionItem {
  final String id;
  final String name;
  final String description;
  final PermissionCategory category;
  final PermissionType type;
  final List<MemberLevel> allowedLevels;
  final bool isLocked;
  final DateTime? lastModified;

  PermissionItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.type,
    required this.allowedLevels,
    this.isLocked = false,
    this.lastModified,
  });

  bool isAccessible(MemberLevel userLevel) {
    return allowedLevels.contains(userLevel) && !isLocked;
  }

  PermissionItem copyWith({
    String? id,
    String? name,
    String? description,
    PermissionCategory? category,
    PermissionType? type,
    List<MemberLevel>? allowedLevels,
    bool? isLocked,
    DateTime? lastModified,
  }) {
    return PermissionItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      type: type ?? this.type,
      allowedLevels: allowedLevels ?? this.allowedLevels,
      isLocked: isLocked ?? this.isLocked,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category.name,
      'type': type.name,
      'allowed_levels': allowedLevels.map((e) => e.name).toList(),
      'is_locked': isLocked,
      'last_modified': lastModified?.toIso8601String(),
    };
  }

  factory PermissionItem.fromMap(Map<String, dynamic> map) {
    return PermissionItem(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: PermissionCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => PermissionCategory.tcm,
      ),
      type: PermissionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => PermissionType.view,
      ),
      allowedLevels: (map['allowed_levels'] as List?)
              ?.map((e) => MemberLevel.values.firstWhere(
                    (m) => m.name == e,
                    orElse: () => MemberLevel.free,
                  ))
              .toList() ??
          [],
      isLocked: map['is_locked'] ?? false,
      lastModified: map['last_modified'] != null
          ? DateTime.parse(map['last_modified'])
          : null,
    );
  }

  static List<PermissionItem> getAllItems() {
    return [
      ..._tcmPermissions,
      ..._acupuncturePermissions,
      ..._boneSettingPermissions,
      ..._massagePermissions,
      ..._booksPermissions,
      ..._storagePermissions,
    ];
  }

  static final List<PermissionItem> _tcmPermissions = [
    PermissionItem(
      id: 'tcm_basic_view',
      name: '经方基础浏览',
      description: '查看经方库基本内容',
      category: PermissionCategory.tcm,
      type: PermissionType.view,
      allowedLevels: MemberLevel.values,
    ),
    PermissionItem(
      id: 'tcm_ai_prescription',
      name: 'AI智能开方',
      description: '使用AI辅助开方功能',
      category: PermissionCategory.tcm,
      type: PermissionType.feature,
      allowedLevels: [MemberLevel.standard, MemberLevel.premium, MemberLevel.ultimate],
    ),
    PermissionItem(
      id: 'tcm_herb_detail',
      name: '药材详细解读',
      description: '查看药材的性味归经、功效主治等详细内容',
      category: PermissionCategory.tcm,
      type: PermissionType.view,
      allowedLevels: [MemberLevel.standard, MemberLevel.premium, MemberLevel.ultimate],
    ),
  ];

  static final List<PermissionItem> _acupuncturePermissions = [
    PermissionItem(
      id: 'acu_3d_basic',
      name: '3D人体基础外观',
      description: '查看3D人体模型基础外观',
      category: PermissionCategory.acupuncture,
      type: PermissionType.view,
      allowedLevels: MemberLevel.values,
    ),
    PermissionItem(
      id: 'acu_point_name',
      name: '穴位名称查看',
      description: '查看穴位名称和基本信息',
      category: PermissionCategory.acupuncture,
      type: PermissionType.view,
      allowedLevels: MemberLevel.values,
    ),
    PermissionItem(
      id: 'acu_meridian_simple',
      name: '粗略经络线路',
      description: '查看简化的经络循行路线图',
      category: PermissionCategory.acupuncture,
      type: PermissionType.view,
      allowedLevels: MemberLevel.values,
    ),
    PermissionItem(
      id: 'acu_muscle_basic',
      name: '静态肌肉骨骼基础结构图',
      description: '查看静态肌肉和骨骼基础结构图',
      category: PermissionCategory.acupuncture,
      type: PermissionType.view,
      allowedLevels: [MemberLevel.standard, MemberLevel.premium, MemberLevel.ultimate],
    ),
    PermissionItem(
      id: 'acu_needle_angle',
      name: '穴位进针角度详解',
      description: '查看直刺、斜刺角度详细图解',
      category: PermissionCategory.acupuncture,
      type: PermissionType.view,
      allowedLevels: [MemberLevel.premium, MemberLevel.ultimate],
      isLocked: true,
    ),
    PermissionItem(
      id: 'acu_needle_depth',
      name: '针刺深浅详解',
      description: '查看不同穴位的针刺深度标准',
      category: PermissionCategory.acupuncture,
      type: PermissionType.view,
      allowedLevels: [MemberLevel.premium, MemberLevel.ultimate],
      isLocked: true,
    ),
    PermissionItem(
      id: 'acu_needle_technique',
      name: '捻针手法教学',
      description: '查看高阶捻针、补泻操作手法',
      category: PermissionCategory.acupuncture,
      type: PermissionType.tutorial,
      allowedLevels: [MemberLevel.premium, MemberLevel.ultimate],
      isLocked: true,
    ),
    PermissionItem(
      id: 'acu_joint_animation',
      name: '关节动态运动演示',
      description: '观看关节屈伸、旋转等动态演示动画',
      category: PermissionCategory.acupuncture,
      type: PermissionType.view,
      allowedLevels: [MemberLevel.premium, MemberLevel.ultimate],
      isLocked: true,
    ),
    PermissionItem(
      id: 'acu_3d_all_angles',
      name: '高清3D全部视角',
      description: '无限制查看高清3D模型所有角度',
      category: PermissionCategory.acupuncture,
      type: PermissionType.feature,
      allowedLevels: [MemberLevel.ultimate],
    ),
  ];

  static final List<PermissionItem> _boneSettingPermissions = [
    PermissionItem(
      id: 'bone_intro',
      name: '正骨流派简介',
      description: '查看正骨各流派基本介绍',
      category: PermissionCategory.boneSetting,
      type: PermissionType.view,
      allowedLevels: MemberLevel.values,
    ),
    PermissionItem(
      id: 'bone_static_view',
      name: '静态正骨原理图',
      description: '查看正骨基本原理的静态示意图',
      category: PermissionCategory.boneSetting,
      type: PermissionType.view,
      allowedLevels: [MemberLevel.standard, MemberLevel.premium, MemberLevel.ultimate],
    ),
    PermissionItem(
      id: 'bone_basic_steps',
      name: '正骨基础步骤',
      description: '查看正骨基础操作步骤概述',
      category: PermissionCategory.boneSetting,
      type: PermissionType.view,
      allowedLevels: [MemberLevel.premium, MemberLevel.ultimate],
      isLocked: true,
    ),
    PermissionItem(
      id: 'bone_full_steps',
      name: '正骨完整实操流程',
      description: '查看正骨全套分步实操教学内容',
      category: PermissionCategory.boneSetting,
      type: PermissionType.tutorial,
      allowedLevels: [MemberLevel.premium, MemberLevel.ultimate],
      isLocked: true,
    ),
    PermissionItem(
      id: 'bone_secret_docs',
      name: '正骨秘传古籍注解',
      description: '查看正骨秘传古籍的详细注解',
      category: PermissionCategory.boneSetting,
      type: PermissionType.view,
      allowedLevels: [MemberLevel.ultimate],
    ),
  ];

  static final List<PermissionItem> _massagePermissions = [
    PermissionItem(
      id: 'massage_catalog',
      name: '推拿按摩书籍目录',
      description: '查看推拿按摩相关书籍目录',
      category: PermissionCategory.massage,
      type: PermissionType.view,
      allowedLevels: MemberLevel.values,
    ),
    PermissionItem(
      id: 'massage_basic_knowledge',
      name: '简易养生推拿常识',
      description: '查看基础养生推拿小知识',
      category: PermissionCategory.massage,
      type: PermissionType.view,
      allowedLevels: [MemberLevel.standard, MemberLevel.premium, MemberLevel.ultimate],
    ),
    PermissionItem(
      id: 'massage_detail_diagram',
      name: '按摩手法细节图解',
      description: '查看按摩技法的详细图解说明',
      category: PermissionCategory.massage,
      type: PermissionType.view,
      allowedLevels: [MemberLevel.premium, MemberLevel.ultimate],
      isLocked: true,
    ),
    PermissionItem(
      id: 'massage_full_tutorial',
      name: '按摩实操图解及教学',
      description: '完整的按摩实操图解及教学视频',
      category: PermissionCategory.massage,
      type: PermissionType.tutorial,
      allowedLevels: [MemberLevel.premium, MemberLevel.ultimate],
      isLocked: true,
    ),
  ];

  static final List<PermissionItem> _booksPermissions = [
    PermissionItem(
      id: 'books_free',
      name: '免费典籍阅读',
      description: '阅读免费的经典典籍',
      category: PermissionCategory.books,
      type: PermissionType.view,
      allowedLevels: MemberLevel.values,
    ),
    PermissionItem(
      id: 'books_premium',
      name: '付费典籍解锁',
      description: '解锁付费典籍的阅读权限',
      category: PermissionCategory.books,
      type: PermissionType.feature,
      allowedLevels: [MemberLevel.basic, MemberLevel.standard, MemberLevel.premium, MemberLevel.ultimate],
    ),
    PermissionItem(
      id: 'books_expert_annotations',
      name: '名家实操批注',
      description: '查看名家对典籍的实操批注',
      category: PermissionCategory.books,
      type: PermissionType.view,
      allowedLevels: [MemberLevel.ultimate],
    ),
  ];

  static final List<PermissionItem> _storagePermissions = [
    PermissionItem(
      id: 'storage_basic',
      name: '基础云备份',
      description: '有限容量的云端数据备份',
      category: PermissionCategory.storage,
      type: PermissionType.feature,
      allowedLevels: [MemberLevel.basic, MemberLevel.standard, MemberLevel.premium, MemberLevel.ultimate],
    ),
    PermissionItem(
      id: 'storage_unlimited',
      name: '无限云备份',
      description: '无限制的云端存储空间',
      category: PermissionCategory.storage,
      type: PermissionType.feature,
      allowedLevels: [MemberLevel.ultimate],
    ),
    PermissionItem(
      id: 'storage_multi_device',
      name: '多设备同步',
      description: '支持多设备数据同步',
      category: PermissionCategory.storage,
      type: PermissionType.feature,
      allowedLevels: [MemberLevel.standard, MemberLevel.premium, MemberLevel.ultimate],
    ),
  ];

  static List<PermissionItem> getByCategory(PermissionCategory category) {
    switch (category) {
      case PermissionCategory.tcm:
        return _tcmPermissions;
      case PermissionCategory.acupuncture:
        return _acupuncturePermissions;
      case PermissionCategory.boneSetting:
        return _boneSettingPermissions;
      case PermissionCategory.massage:
        return _massagePermissions;
      case PermissionCategory.fortune:
        return [];
      case PermissionCategory.wuyun:
        return [];
      case PermissionCategory.books:
        return _booksPermissions;
      case PermissionCategory.storage:
        return _storagePermissions;
      case PermissionCategory.trading:
        return [];
    }
  }
}

enum PermissionType {
  view,
  feature,
  tutorial,
  download,
  export,
}

extension PermissionTypeExtension on PermissionType {
  String get name {
    switch (this) {
      case PermissionType.view:
        return '浏览';
      case PermissionType.feature:
        return '功能';
      case PermissionType.tutorial:
        return '教学';
      case PermissionType.download:
        return '下载';
      case PermissionType.export:
        return '导出';
    }
  }

  IconData get icon {
    switch (this) {
      case PermissionType.view:
        return Icons.visibility;
      case PermissionType.feature:
        return Icons.extension;
      case PermissionType.tutorial:
        return Icons.school;
      case PermissionType.download:
        return Icons.download;
      case PermissionType.export:
        return Icons.upload;
    }
  }
}

class MemberUpgradeThreshold {
  final MemberLevel level;
  final int lingjiRequired;
  final int directReferrals;
  final int teamSize;
  final int studyHours;

  const MemberUpgradeThreshold({
    required this.level,
    required this.lingjiRequired,
    required this.directReferrals,
    required this.teamSize,
    required this.studyHours,
  });

  static const List<MemberUpgradeThreshold> defaultThresholds = [
    MemberUpgradeThreshold(
      level: MemberLevel.free,
      lingjiRequired: 0,
      directReferrals: 0,
      teamSize: 0,
      studyHours: 0,
    ),
    MemberUpgradeThreshold(
      level: MemberLevel.basic,
      lingjiRequired: 100,
      directReferrals: 5,
      teamSize: 20,
      studyHours: 10,
    ),
    MemberUpgradeThreshold(
      level: MemberLevel.standard,
      lingjiRequired: 500,
      directReferrals: 20,
      teamSize: 100,
      studyHours: 50,
    ),
    MemberUpgradeThreshold(
      level: MemberLevel.premium,
      lingjiRequired: 2000,
      directReferrals: 100,
      teamSize: 500,
      studyHours: 200,
    ),
    MemberUpgradeThreshold(
      level: MemberLevel.ultimate,
      lingjiRequired: 10000,
      directReferrals: 500,
      teamSize: 2000,
      studyHours: 500,
    ),
  ];
}
