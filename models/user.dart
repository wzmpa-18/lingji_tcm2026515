import '../models/blogger_level.dart';
import '../models/membership_payment.dart';

class User {
  final String id;
  final String phone;
  final String? email;
  final String nickname;
  final String? avatar;
  final int memberLevel;
  final DateTime? memberExpireDate;
  final int lingjiBalance;
  final String? invitationCode;
  final String? invitedBy;
  final bool cloudBackupEnabled;
  final bool isGoldMember;
  final DateTime? goldMemberExpireDate;
  final BloggerLevel bloggerLevel;
  final int postsToday;
  final DateTime? lastPostDate;
  final bool hasAcceptedDisclaimer;
  final DateTime createdAt;
  final DateTime updatedAt;

  final bool phoneVerified;
  final bool emailVerified;
  final bool faceVerified;
  final DateTime? phoneVerifiedAt;
  final DateTime? emailVerifiedAt;
  final DateTime? faceVerifiedAt;
  final String? passwordHash;

  User({
    required this.id,
    required this.phone,
    this.email,
    required this.nickname,
    this.avatar,
    this.memberLevel = 0,
    this.memberExpireDate,
    this.lingjiBalance = 0,
    this.invitationCode,
    this.invitedBy,
    this.cloudBackupEnabled = false,
    this.isGoldMember = false,
    this.goldMemberExpireDate,
    this.bloggerLevel = BloggerLevel.level0,
    this.postsToday = 0,
    this.lastPostDate,
    this.hasAcceptedDisclaimer = false,
    required this.createdAt,
    required this.updatedAt,
    this.phoneVerified = false,
    this.emailVerified = false,
    this.faceVerified = false,
    this.phoneVerifiedAt,
    this.emailVerifiedAt,
    this.faceVerifiedAt,
    this.passwordHash,
  });

  MembershipLevel get membershipLevel {
    switch (memberLevel) {
      case 0:
        return MembershipLevel.free;
      case 1:
        return MembershipLevel.basic;
      case 2:
        return MembershipLevel.standard;
      case 3:
        return MembershipLevel.premium;
      case 4:
        return MembershipLevel.ultimate;
      case 5:
        return MembershipLevel.gold;
      default:
        return MembershipLevel.free;
    }
  }

  bool get isMemberExpired {
    if (memberExpireDate == null) return memberLevel > 0;
    return DateTime.now().isAfter(memberExpireDate!);
  }

  bool get isGoldMemberExpired {
    if (goldMemberExpireDate == null) return isGoldMember;
    return DateTime.now().isAfter(goldMemberExpireDate!);
  }

  bool get canPostBlog {
    if (!isGoldMember || isGoldMemberExpired) return false;
    if (lastPostDate == null) return true;
    final today = DateTime.now();
    if (lastPostDate!.year == today.year &&
        lastPostDate!.month == today.month &&
        lastPostDate!.day == today.day) {
      return postsToday < BlogPostLimits.postsPerDay;
    }
    return true;
  }

  int get remainingBlogPosts {
    if (!canPostBlog) return 0;
    if (lastPostDate == null) return BlogPostLimits.postsPerDay;
    final today = DateTime.now();
    if (lastPostDate!.year == today.year &&
        lastPostDate!.month == today.month &&
        lastPostDate!.day == today.day) {
      return BlogPostLimits.postsPerDay - postsToday;
    }
    return BlogPostLimits.postsPerDay;
  }

  bool get isPhoneBound => phone.isNotEmpty && phoneVerified;

  bool get isEmailBound => email != null && email!.isNotEmpty && emailVerified;

  bool get isFaceBound => faceVerified;

  int get verificationLevel {
    int level = 0;
    if (phoneVerified) level++;
    if (emailVerified) level++;
    if (faceVerified) level++;
    return level;
  }

  String get verificationStatus {
    final count = verificationLevel;
    if (count == 0) return '未認證';
    if (count == 1) return '單重認證';
    if (count == 2) return '雙重認證';
    return '三重認證';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'email': email,
      'nickname': nickname,
      'avatar': avatar,
      'member_level': memberLevel,
      'member_expire_date': memberExpireDate?.toIso8601String(),
      'lingji_balance': lingjiBalance,
      'invitation_code': invitationCode,
      'invited_by': invitedBy,
      'cloud_backup_enabled': cloudBackupEnabled ? 1 : 0,
      'is_gold_member': isGoldMember ? 1 : 0,
      'gold_member_expire_date': goldMemberExpireDate?.toIso8601String(),
      'blogger_level': bloggerLevel.name,
      'posts_today': postsToday,
      'last_post_date': lastPostDate?.toIso8601String(),
      'has_accepted_disclaimer': hasAcceptedDisclaimer ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'phone_verified': phoneVerified ? 1 : 0,
      'email_verified': emailVerified ? 1 : 0,
      'face_verified': faceVerified ? 1 : 0,
      'phone_verified_at': phoneVerifiedAt?.toIso8601String(),
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'face_verified_at': faceVerifiedAt?.toIso8601String(),
      'password_hash': passwordHash,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'],
      nickname: map['nickname'] ?? '',
      avatar: map['avatar'],
      memberLevel: map['member_level'] ?? 0,
      memberExpireDate: map['member_expire_date'] != null
          ? DateTime.parse(map['member_expire_date'])
          : null,
      lingjiBalance: map['lingji_balance'] ?? 0,
      invitationCode: map['invitation_code'],
      invitedBy: map['invited_by'],
      cloudBackupEnabled: map['cloud_backup_enabled'] == 1,
      isGoldMember: map['is_gold_member'] == 1,
      goldMemberExpireDate: map['gold_member_expire_date'] != null
          ? DateTime.parse(map['gold_member_expire_date'])
          : null,
      bloggerLevel: BloggerLevel.values.firstWhere(
        (e) => e.name == map['blogger_level'],
        orElse: () => BloggerLevel.level0,
      ),
      postsToday: map['posts_today'] ?? 0,
      lastPostDate: map['last_post_date'] != null
          ? DateTime.parse(map['last_post_date'])
          : null,
      hasAcceptedDisclaimer: map['has_accepted_disclaimer'] == 1,
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updated_at'] ?? DateTime.now().toIso8601String()),
      phoneVerified: map['phone_verified'] == 1,
      emailVerified: map['email_verified'] == 1,
      faceVerified: map['face_verified'] == 1,
      phoneVerifiedAt: map['phone_verified_at'] != null
          ? DateTime.parse(map['phone_verified_at'])
          : null,
      emailVerifiedAt: map['email_verified_at'] != null
          ? DateTime.parse(map['email_verified_at'])
          : null,
      faceVerifiedAt: map['face_verified_at'] != null
          ? DateTime.parse(map['face_verified_at'])
          : null,
      passwordHash: map['password_hash'],
    );
  }

  User copyWith({
    String? id,
    String? phone,
    String? email,
    String? nickname,
    String? avatar,
    int? memberLevel,
    DateTime? memberExpireDate,
    int? lingjiBalance,
    String? invitationCode,
    String? invitedBy,
    bool? cloudBackupEnabled,
    bool? isGoldMember,
    DateTime? goldMemberExpireDate,
    BloggerLevel? bloggerLevel,
    int? postsToday,
    DateTime? lastPostDate,
    bool? hasAcceptedDisclaimer,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? phoneVerified,
    bool? emailVerified,
    bool? faceVerified,
    DateTime? phoneVerifiedAt,
    DateTime? emailVerifiedAt,
    DateTime? faceVerifiedAt,
    String? passwordHash,
  }) {
    return User(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      memberLevel: memberLevel ?? this.memberLevel,
      memberExpireDate: memberExpireDate ?? this.memberExpireDate,
      lingjiBalance: lingjiBalance ?? this.lingjiBalance,
      invitationCode: invitationCode ?? this.invitationCode,
      invitedBy: invitedBy ?? this.invitedBy,
      cloudBackupEnabled: cloudBackupEnabled ?? this.cloudBackupEnabled,
      isGoldMember: isGoldMember ?? this.isGoldMember,
      goldMemberExpireDate: goldMemberExpireDate ?? this.goldMemberExpireDate,
      bloggerLevel: bloggerLevel ?? this.bloggerLevel,
      postsToday: postsToday ?? this.postsToday,
      lastPostDate: lastPostDate ?? this.lastPostDate,
      hasAcceptedDisclaimer: hasAcceptedDisclaimer ?? this.hasAcceptedDisclaimer,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      emailVerified: emailVerified ?? this.emailVerified,
      faceVerified: faceVerified ?? this.faceVerified,
      phoneVerifiedAt: phoneVerifiedAt ?? this.phoneVerifiedAt,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      faceVerifiedAt: faceVerifiedAt ?? this.faceVerifiedAt,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }
}
