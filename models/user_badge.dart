class UserBadge {
  final String id;
  final String userId;
  final BadgeType type;
  final String name;
  final String description;
  final DateTime earnedAt;
  final String? source;

  UserBadge({
    required this.id,
    required this.userId,
    required this.type,
    required this.name,
    required this.description,
    required this.earnedAt,
    this.source,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.name,
      'name': name,
      'description': description,
      'earned_at': earnedAt.toIso8601String(),
      'source': source,
    };
  }

  factory UserBadge.fromMap(Map<String, dynamic> map) {
    return UserBadge(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      type: BadgeType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => BadgeType.contributor,
      ),
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      earnedAt: DateTime.parse(map['earned_at'] ?? DateTime.now().toIso8601String()),
      source: map['source'],
    );
  }
}

enum BadgeType {
  bugHunter,
  contentExpert,
  communityStar,
  topContributor,
  verifiedProfessional,
  platformAmbassador,
  earlyUser,
  milestone,
}

extension BadgeTypeExtension on BadgeType {
  String get displayName {
    switch (this) {
      case BadgeType.bugHunter:
        return 'BUG猎人';
      case BadgeType.contentExpert:
        return '内容专家';
      case BadgeType.communityStar:
        return '社群之星';
      case BadgeType.topContributor:
        return '顶级贡献者';
      case BadgeType.verifiedProfessional:
        return '认证专业人士';
      case BadgeType.platformAmbassador:
        return '平台大使';
      case BadgeType.earlyUser:
        return '资深用户';
      case BadgeType.milestone:
        return '里程碑';
    }
  }

  String get description {
    switch (this) {
      case BadgeType.bugHunter:
        return '发现并报告有效BUG的用户';
      case BadgeType.contentExpert:
        return '校正专业内容被采纳的用户';
      case BadgeType.communityStar:
        return '活跃社群互动帮助他人的用户';
      case BadgeType.topContributor:
        return '多次贡献优质内容的用户';
      case BadgeType.verifiedProfessional:
        return '通过平台认证的中医或命理专业人士';
      case BadgeType.platformAmbassador:
        return '推广平台有突出贡献的用户';
      case BadgeType.earlyUser:
        return '平台早期注册用户';
      case BadgeType.milestone:
        return '达成重要里程碑的用户';
    }
  }

  String get icon {
    switch (this) {
      case BadgeType.bugHunter:
        return '🐛';
      case BadgeType.contentExpert:
        return '📚';
      case BadgeType.communityStar:
        return '⭐';
      case BadgeType.topContributor:
        return '🏆';
      case BadgeType.verifiedProfessional:
        return '✅';
      case BadgeType.platformAmbassador:
        return '🎖️';
      case BadgeType.earlyUser:
        return '🌟';
      case BadgeType.milestone:
        return '🎯';
    }
  }

  int get lingjiReward {
    switch (this) {
      case BadgeType.bugHunter:
        return 50;
      case BadgeType.contentExpert:
        return 100;
      case BadgeType.communityStar:
        return 80;
      case BadgeType.topContributor:
        return 200;
      case BadgeType.verifiedProfessional:
        return 300;
      case BadgeType.platformAmbassador:
        return 500;
      case BadgeType.earlyUser:
        return 100;
      case BadgeType.milestone:
        return 150;
    }
  }
}

class UserViolation {
  final String id;
  final String userId;
  final ViolationType type;
  final String description;
  final int lingjiPenalty;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool isActive;

  UserViolation({
    required this.id,
    required this.userId,
    required this.type,
    required this.description,
    required this.lingjiPenalty,
    required this.createdAt,
    this.expiresAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.name,
      'description': description,
      'lingji_penalty': lingjiPenalty,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'is_active': isActive ? 1 : 0,
    };
  }

  factory UserViolation.fromMap(Map<String, dynamic> map) {
    return UserViolation(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      type: ViolationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => ViolationType.spam,
      ),
      description: map['description'] ?? '',
      lingjiPenalty: map['lingji_penalty'] ?? 0,
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      expiresAt: map['expires_at'] != null ? DateTime.parse(map['expires_at']) : null,
      isActive: map['is_active'] == 1,
    );
  }
}

enum ViolationType {
  spam,
  misinformation,
  harassment,
  contentTampering,
  accountViolation,
}

extension ViolationTypeExtension on ViolationType {
  String get displayName {
    switch (this) {
      case ViolationType.spam:
        return '垃圾信息';
      case ViolationType.misinformation:
        return '传播错误信息';
      case ViolationType.harassment:
        return '恶意骚扰';
      case ViolationType.contentTampering:
        return '篡改专业知识';
      case ViolationType.accountViolation:
        return '账号违规';
    }
  }

  int get defaultPenalty {
    switch (this) {
      case ViolationType.spam:
        return 50;
      case ViolationType.misinformation:
        return 200;
      case ViolationType.harassment:
        return 100;
      case ViolationType.contentTampering:
        return 500;
      case ViolationType.accountViolation:
        return 1000;
    }
  }

  List<String> get possiblePunishments {
    switch (this) {
      case ViolationType.spam:
        return ['扣除灵积', '限制发言'];
      case ViolationType.misinformation:
        return ['扣除灵积', '取消共建资格', '限制功能'];
      case ViolationType.harassment:
        return ['扣除灵积', '临时封禁', '永久封禁'];
      case ViolationType.contentTampering:
        return ['扣除灵积', '取消共建资格', '永久封禁'];
      case ViolationType.accountViolation:
        return ['扣除灵积', '功能限制', '永久封禁'];
    }
  }
}

class CoBuildContribution {
  final String id;
  final String userId;
  final String userName;
  final ContributionType type;
  final String content;
  final String? reference;
  final ContributionStatus status;
  final String? reviewComment;
  final int? lingjiReward;
  final int? memberDaysReward;
  final DateTime createdAt;
  final DateTime? reviewedAt;

  CoBuildContribution({
    required this.id,
    required this.userId,
    required this.userName,
    required this.type,
    required this.content,
    this.reference,
    this.status = ContributionStatus.pending,
    this.reviewComment,
    this.lingjiReward,
    this.memberDaysReward,
    required this.createdAt,
    this.reviewedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'type': type.name,
      'content': content,
      'reference': reference,
      'status': status.name,
      'review_comment': reviewComment,
      'lingji_reward': lingjiReward,
      'member_days_reward': memberDaysReward,
      'created_at': createdAt.toIso8601String(),
      'reviewed_at': reviewedAt?.toIso8601String(),
    };
  }

  factory CoBuildContribution.fromMap(Map<String, dynamic> map) {
    return CoBuildContribution(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      userName: map['user_name'] ?? '',
      type: ContributionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => ContributionType.contentCorrection,
      ),
      content: map['content'] ?? '',
      reference: map['reference'],
      status: ContributionStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ContributionStatus.pending,
      ),
      reviewComment: map['review_comment'],
      lingjiReward: map['lingji_reward'],
      memberDaysReward: map['member_days_reward'],
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      reviewedAt: map['reviewed_at'] != null ? DateTime.parse(map['reviewed_at']) : null,
    );
  }
}

enum ContributionType {
  bugReport,
  contentCorrection,
  contentSuggestion,
  technicalImprovement,
  other,
}

extension ContributionTypeExtension on ContributionType {
  String get displayName {
    switch (this) {
      case ContributionType.bugReport:
        return 'BUG报告';
      case ContributionType.contentCorrection:
        return '内容校正';
      case ContributionType.contentSuggestion:
        return '内容建议';
      case ContributionType.technicalImprovement:
        return '技术改进';
      case ContributionType.other:
        return '其他';
    }
  }

  int get baseReward {
    switch (this) {
      case ContributionType.bugReport:
        return 30;
      case ContributionType.contentCorrection:
        return 50;
      case ContributionType.contentSuggestion:
        return 20;
      case ContributionType.technicalImprovement:
        return 100;
      case ContributionType.other:
        return 10;
    }
  }
}

enum ContributionStatus {
  pending,
  reviewing,
  accepted,
  rejected,
  partiallyAccepted,
}

extension ContributionStatusExtension on ContributionStatus {
  String get displayName {
    switch (this) {
      case ContributionStatus.pending:
        return '待审核';
      case ContributionStatus.reviewing:
        return '审核中';
      case ContributionStatus.accepted:
        return '已采纳';
      case ContributionStatus.rejected:
        return '未采纳';
      case ContributionStatus.partiallyAccepted:
        return '部分采纳';
    }
  }
}
