import 'package:flutter/material.dart';

class BlogPost {
  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final String title;
  final String content;
  final List<String> images;
  final BlogCategory category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likes;
  final int comments;
  final int shares;
  final bool isPinned;
  final bool isDeleted;
  final String? status;

  BlogPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.title,
    required this.content,
    this.images = const [],
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isPinned = false,
    this.isDeleted = false,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author_id': authorId,
      'author_name': authorName,
      'author_avatar': authorAvatar,
      'title': title,
      'content': content,
      'images': images.join(','),
      'category': category.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'is_pinned': isPinned ? 1 : 0,
      'is_deleted': isDeleted ? 1 : 0,
      'status': status,
    };
  }

  factory BlogPost.fromMap(Map<String, dynamic> map) {
    return BlogPost(
      id: map['id'],
      authorId: map['author_id'],
      authorName: map['author_name'],
      authorAvatar: map['author_avatar'] ?? '',
      title: map['title'],
      content: map['content'],
      images: (map['images'] as String?)?.split(',').where((e) => e.isNotEmpty).toList() ?? [],
      category: BlogCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => BlogCategory.other,
      ),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      likes: map['likes'] ?? 0,
      comments: map['comments'] ?? 0,
      shares: map['shares'] ?? 0,
      isPinned: map['is_pinned'] == 1,
      isDeleted: map['is_deleted'] == 1,
      status: map['status'],
    );
  }

  BlogPost copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    String? title,
    String? content,
    List<String>? images,
    BlogCategory? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likes,
    int? comments,
    int? shares,
    bool? isPinned,
    bool? isDeleted,
    String? status,
  }) {
    return BlogPost(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      title: title ?? this.title,
      content: content ?? this.content,
      images: images ?? this.images,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isPinned: isPinned ?? this.isPinned,
      isDeleted: isDeleted ?? this.isDeleted,
      status: status ?? this.status,
    );
  }
}

enum BlogCategory {
  tcm,
  fortune,
  health,
  life,
  experience,
  other,
}

extension BlogCategoryExtension on BlogCategory {
  String get displayName {
    switch (this) {
      case BlogCategory.tcm:
        return '中医养生';
      case BlogCategory.fortune:
        return '命理探讨';
      case BlogCategory.health:
        return '健康心得';
      case BlogCategory.life:
        return '生活感悟';
      case BlogCategory.experience:
        return '学习经验';
      case BlogCategory.other:
        return '其他';
    }
  }

  IconData get icon {
    switch (this) {
      case BlogCategory.tcm:
        return Icons.local_hospital;
      case BlogCategory.fortune:
        return Icons.auto_awesome;
      case BlogCategory.health:
        return Icons.favorite;
      case BlogCategory.life:
        return Icons.self_improvement;
      case BlogCategory.experience:
        return Icons.school;
      case BlogCategory.other:
        return Icons.more_horiz;
    }
  }

  Color get color {
    switch (this) {
      case BlogCategory.tcm:
        return Colors.red;
      case BlogCategory.fortune:
        return Colors.purple;
      case BlogCategory.health:
        return Colors.green;
      case BlogCategory.life:
        return Colors.blue;
      case BlogCategory.experience:
        return Colors.orange;
      case BlogCategory.other:
        return Colors.grey;
    }
  }
}

class BlogPostLimits {
  static const int maxTitleLength = 100;
  static const int maxContentLength = 5000;
  static const int maxImages = 9;
  static const int maxImageWidth = 1080;
  static const int maxImageHeight = 1080;
  static const int maxStoragePerPostMB = 50;
  static const int maxStorageTotalMB = 500;
  static const int postsPerDay = 1;

  static String getTitleLimitText() => '$maxTitleLength字';
  static String getContentLimitText() => '$maxContentLength字';
  static String getImageLimitText() => '最多$maxImages张';
  static String getStorageLimitText() => '单篇$maxStoragePerPostMB MB';
}

class BlogComment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime createdAt;
  final int likes;

  BlogComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.createdAt,
    this.likes = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'likes': likes,
    };
  }

  factory BlogComment.fromMap(Map<String, dynamic> map) {
    return BlogComment(
      id: map['id'],
      postId: map['post_id'],
      userId: map['user_id'],
      userName: map['user_name'],
      userAvatar: map['user_avatar'] ?? '',
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
      likes: map['likes'] ?? 0,
    );
  }
}

class BlogShareRecord {
  final String id;
  final String postId;
  final String userId;
  final SharePlatform platform;
  final DateTime sharedAt;

  BlogShareRecord({
    required this.id,
    required this.postId,
    required this.userId,
    required this.platform,
    required this.sharedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'platform': platform.name,
      'shared_at': sharedAt.toIso8601String(),
    };
  }

  factory BlogShareRecord.fromMap(Map<String, dynamic> map) {
    return BlogShareRecord(
      id: map['id'],
      postId: map['post_id'],
      userId: map['user_id'],
      platform: SharePlatform.values.firstWhere(
        (e) => e.name == map['platform'],
        orElse: () => SharePlatform.other,
      ),
      sharedAt: DateTime.parse(map['shared_at']),
    );
  }
}

enum SharePlatform {
  wechat,
  moments,
  weibo,
  qq,
  dingtalk,
  external,
  other,
}

extension SharePlatformExtension on SharePlatform {
  String get displayName {
    switch (this) {
      case SharePlatform.wechat:
        return '微信';
      case SharePlatform.moments:
        return '朋友圈';
      case SharePlatform.weibo:
        return '微博';
      case SharePlatform.qq:
        return 'QQ';
      case SharePlatform.dingtalk:
        return '钉钉';
      case SharePlatform.external:
        return '外部平台';
      case SharePlatform.other:
        return '其他';
    }
  }

  IconData get icon {
    switch (this) {
      case SharePlatform.wechat:
        return Icons.chat;
      case SharePlatform.moments:
        return Icons.photo_camera;
      case SharePlatform.weibo:
        return Icons.alternate_email;
      case SharePlatform.qq:
        return Icons.person;
      case SharePlatform.dingtalk:
        return Icons.work;
      case SharePlatform.external:
        return Icons.open_in_new;
      case SharePlatform.other:
        return Icons.share;
    }
  }
}

class GoldMemberBlogService {
  static bool canPost(int postsToday, bool isGoldMember) {
    if (!isGoldMember) return false;
    return postsToday < BlogPostLimits.postsPerDay;
  }

  static bool canShare(bool isGoldMember) {
    return isGoldMember;
  }

  static int getRemainingPosts(int postsToday, bool isGoldMember) {
    if (!isGoldMember) return 0;
    return BlogPostLimits.postsPerDay - postsToday;
  }

  static String? validatePost(String title, String content, List<String> images) {
    if (title.isEmpty) {
      return '标题不能为空';
    }
    if (title.length > BlogPostLimits.maxTitleLength) {
      return '标题不能超过${BlogPostLimits.maxTitleLength}字';
    }
    if (content.isEmpty) {
      return '内容不能为空';
    }
    if (content.length > BlogPostLimits.maxContentLength) {
      return '内容不能超过${BlogPostLimits.maxContentLength}字';
    }
    if (images.length > BlogPostLimits.maxImages) {
      return '图片不能超过${BlogPostLimits.maxImages}张';
    }
    return null;
  }
}
