import 'package:flutter/material.dart';

enum MembershipPaymentMode {
  monthly,
  quarterly,
  yearly,
  oneTime,
}

extension MembershipPaymentModeExtension on MembershipPaymentMode {
  String get name {
    switch (this) {
      case MembershipPaymentMode.monthly:
        return '月卡';
      case MembershipPaymentMode.quarterly:
        return '季卡';
      case MembershipPaymentMode.yearly:
        return '年卡';
      case MembershipPaymentMode.oneTime:
        return '单次付费';
    }
  }

  String get description {
    switch (this) {
      case MembershipPaymentMode.monthly:
        return '按月订阅，自动续费';
      case MembershipPaymentMode.quarterly:
        return '按季订阅，节省更多';
      case MembershipPaymentMode.yearly:
        return '按年订阅，超值优惠';
      case MembershipPaymentMode.oneTime:
        return '单次付费，无需订阅';
    }
  }

  IconData get icon {
    switch (this) {
      case MembershipPaymentMode.monthly:
        return Icons.calendar_month;
      case MembershipPaymentMode.quarterly:
        return Icons.calendar_view_month;
      case MembershipPaymentMode.yearly:
        return Icons.calendar_today;
      case MembershipPaymentMode.oneTime:
        return Icons.payments;
    }
  }

  int get durationDays {
    switch (this) {
      case MembershipPaymentMode.monthly:
        return 30;
      case MembershipPaymentMode.quarterly:
        return 90;
      case MembershipPaymentMode.yearly:
        return 365;
      case MembershipPaymentMode.oneTime:
        return 0;
    }
  }

  double get discountRate {
    switch (this) {
      case MembershipPaymentMode.monthly:
        return 1.0;
      case MembershipPaymentMode.quarterly:
        return 0.9;
      case MembershipPaymentMode.yearly:
        return 0.75;
      case MembershipPaymentMode.oneTime:
        return 1.0;
    }
  }
}

class MembershipPrice {
  final MembershipPaymentMode mode;
  final int basePrice;
  final int? discountedPrice;
  final bool isCustomizable;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final bool isActive;

  const MembershipPrice({
    required this.mode,
    required this.basePrice,
    this.discountedPrice,
    this.isCustomizable = true,
    this.validFrom,
    this.validUntil,
    this.isActive = true,
  });

  int get finalPrice => discountedPrice ?? basePrice;

  bool get hasDiscount => discountedPrice != null && discountedPrice! < basePrice;

  double get discountPercent {
    if (!hasDiscount) return 0;
    return (1 - discountedPrice! / basePrice) * 100;
  }

  Map<String, dynamic> toMap() {
    return {
      'mode': mode.name,
      'base_price': basePrice,
      'discounted_price': discountedPrice,
      'is_customizable': isCustomizable,
      'valid_from': validFrom?.toIso8601String(),
      'valid_until': validUntil?.toIso8601String(),
      'is_active': isActive,
    };
  }

  factory MembershipPrice.fromMap(Map<String, dynamic> map) {
    return MembershipPrice(
      mode: MembershipPaymentMode.values.firstWhere(
        (e) => e.name == map['mode'],
        orElse: () => MembershipPaymentMode.monthly,
      ),
      basePrice: map['base_price'],
      discountedPrice: map['discounted_price'],
      isCustomizable: map['is_customizable'] ?? true,
      validFrom: map['valid_from'] != null ? DateTime.parse(map['valid_from']) : null,
      validUntil: map['valid_until'] != null ? DateTime.parse(map['valid_until']) : null,
      isActive: map['is_active'] ?? true,
    );
  }

  MembershipPrice copyWith({
    MembershipPaymentMode? mode,
    int? basePrice,
    int? discountedPrice,
    bool? isCustomizable,
    DateTime? validFrom,
    DateTime? validUntil,
    bool? isActive,
  }) {
    return MembershipPrice(
      mode: mode ?? this.mode,
      basePrice: basePrice ?? this.basePrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      isCustomizable: isCustomizable ?? this.isCustomizable,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      isActive: isActive ?? this.isActive,
    );
  }
}

class GoldMembership {
  static const String id = 'gold_member';
  static const String name = '金牌会员';
  static const String description = '解锁博客发文、配图转发功能';

  static const int yearlyPrice = 299;
  static const int quarterlyPrice = 99;
  static const int monthlyPrice = 39;

  static const int maxPostsPerDay = 1;
  static const int maxImageCount = 9;
  static const int maxImageWidth = 1080;
  static const int maxImageHeight = 1080;
  static const int maxStoragePerPostMB = 50;
  static const int maxStorageTotalMB = 500;

  static bool canPost(bool isGoldMember) => isGoldMember;
  static bool canShare(bool isGoldMember) => isGoldMember;
  static bool canComment(bool isGoldMember) => isGoldMember;

  static String getStorageLimitText() => '$maxStorageTotalMB MB';
  static String getPostLimitText() => '每日$maxPostsPerDay篇';
  static String getImageLimitText() => '最多$maxImageCount张图片';
}

class MembershipSubscription {
  final String id;
  final String userId;
  final MembershipLevel level;
  final MembershipPaymentMode paymentMode;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final bool isAutoRenew;
  final String? paymentMethod;
  final String? transactionId;

  MembershipSubscription({
    required this.id,
    required this.userId,
    required this.level,
    required this.paymentMode,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    this.isAutoRenew = false,
    this.paymentMethod,
    this.transactionId,
  });

  bool get isExpired => DateTime.now().isAfter(endDate);

  int get remainingDays {
    if (isExpired) return 0;
    return endDate.difference(DateTime.now()).inDays;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'level': level.name,
      'payment_mode': paymentMode.name,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_active': isActive ? 1 : 0,
      'is_auto_renew': isAutoRenew ? 1 : 0,
      'payment_method': paymentMethod,
      'transaction_id': transactionId,
    };
  }

  factory MembershipSubscription.fromMap(Map<String, dynamic> map) {
    return MembershipSubscription(
      id: map['id'],
      userId: map['user_id'],
      level: MembershipLevel.values.firstWhere(
        (e) => e.name == map['level'],
        orElse: () => MembershipLevel.free,
      ),
      paymentMode: MembershipPaymentMode.values.firstWhere(
        (e) => e.name == map['payment_mode'],
        orElse: () => MembershipPaymentMode.monthly,
      ),
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      isActive: map['is_active'] == 1,
      isAutoRenew: map['is_auto_renew'] == 1,
      paymentMethod: map['payment_method'],
      transactionId: map['transaction_id'],
    );
  }
}

enum MembershipLevel {
  free,
  basic,
  standard,
  premium,
  ultimate,
  gold,
}

extension MembershipLevelExtension on MembershipLevel {
  String get name {
    switch (this) {
      case MembershipLevel.free:
        return '免费会员';
      case MembershipLevel.basic:
        return '初级会员';
      case MembershipLevel.standard:
        return '中级会员';
      case MembershipLevel.premium:
        return '高级会员';
      case MembershipLevel.ultimate:
        return '至尊会员';
      case MembershipLevel.gold:
        return '金牌会员';
    }
  }

  String get shortName {
    switch (this) {
      case MembershipLevel.free:
        return '免费';
      case MembershipLevel.basic:
        return '初级';
      case MembershipLevel.standard:
        return '中级';
      case MembershipLevel.premium:
        return '高级';
      case MembershipLevel.ultimate:
        return '至尊';
      case MembershipLevel.gold:
        return '金牌';
    }
  }

  Color get color {
    switch (this) {
      case MembershipLevel.free:
        return Colors.grey;
      case MembershipLevel.basic:
        return Colors.blue;
      case MembershipLevel.standard:
        return Colors.green;
      case MembershipLevel.premium:
        return Colors.purple;
      case MembershipLevel.ultimate:
        return Colors.amber;
      case MembershipLevel.gold:
        return const Color(0xFFFFD700);
    }
  }

  IconData get icon {
    switch (this) {
      case MembershipLevel.free:
        return Icons.person_outline;
      case MembershipLevel.basic:
        return Icons.person;
      case MembershipLevel.standard:
        return Icons.star_half;
      case MembershipLevel.premium:
        return Icons.star;
      case MembershipLevel.ultimate:
        return Icons.diamond;
      case MembershipLevel.gold:
        return Icons.workspace_premium;
    }
  }

  int get levelValue {
    switch (this) {
      case MembershipLevel.free:
        return 0;
      case MembershipLevel.basic:
        return 1;
      case MembershipLevel.standard:
        return 2;
      case MembershipLevel.premium:
        return 3;
      case MembershipLevel.ultimate:
        return 4;
      case MembershipLevel.gold:
        return 5;
    }
  }

  bool canAccess(MembershipLevel required) {
    return this.levelValue >= required.levelValue;
  }

  List<String> get privileges {
    switch (this) {
      case MembershipLevel.free:
        return [
          '基础功能浏览',
          '免费典籍阅读',
          '3D模型基础外观',
          '穴位名称查看',
        ];
      case MembershipLevel.basic:
        return [
          '免费会员全部权限',
          '基础云备份',
          '付费典籍解锁',
        ];
      case MembershipLevel.standard:
        return [
          '初级会员全部权限',
          'AI智能开方',
          '药材详细解读',
          '静态肌肉骨骼图',
          '多设备同步',
          '手续费优惠',
        ];
      case MembershipLevel.premium:
        return [
          '中级会员全部权限',
          '完整穴位进针教学',
          '关节动态演示',
          '正骨完整实操',
          '按摩手法详解',
          '手续费全免',
        ];
      case MembershipLevel.ultimate:
        return [
          '高级会员全部权限',
          '高清3D全部视角',
          '正骨秘传古籍',
          '名家实操批注',
          '无限云备份',
        ];
      case MembershipLevel.gold:
        return [
          '至尊会员全部权限',
          '博客发文功能',
          '配图转发朋友圈',
          '外部平台分享',
        ];
    }
  }
}

class OneTimePaymentService {
  final String id;
  final String serviceName;
  final String description;
  final int price;
  final ServiceScope scope;
  final bool isActive;

  const OneTimePaymentService({
    required this.id,
    required this.serviceName,
    required this.description,
    required this.price,
    required this.scope,
    this.isActive = true,
  });

  static const List<OneTimePaymentService> defaultServices = [
    OneTimePaymentService(
      id: 'fortune_single',
      serviceName: '单次命理测算',
      description: '单一问题咨询，无需开通会员',
      price: 29,
      scope: ServiceScope.fortune,
    ),
    OneTimePaymentService(
      id: 'tcm_single',
      serviceName: '单次经方咨询',
      description: '单一症状咨询，无需开通会员',
      price: 39,
      scope: ServiceScope.tcm,
    ),
    OneTimePaymentService(
      id: 'prescription_single',
      serviceName: '单次开方服务',
      description: '获得一个经方建议',
      price: 49,
      scope: ServiceScope.prescription,
    ),
  ];
}

enum ServiceScope {
  fortune,
  tcm,
  prescription,
  consultation,
  all,
}

extension ServiceScopeExtension on ServiceScope {
  String get name {
    switch (this) {
      case ServiceScope.fortune:
        return '命理测算';
      case ServiceScope.tcm:
        return '中医咨询';
      case ServiceScope.prescription:
        return '经方开方';
      case ServiceScope.consultation:
        return '综合咨询';
      case ServiceScope.all:
        return '全部服务';
    }
  }
}
