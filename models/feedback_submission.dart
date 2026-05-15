import 'package:flutter/material.dart';

class FeedbackSubmission {
  final String id;
  final String userId;
  final String userName;
  final FeedbackCategory category;
  final String title;
  final String content;
  final List<String> images;
  final FeedbackStatus status;
  final String? officialReply;
  final DateTime createdAt;
  final DateTime? processedAt;
  final int? lingjiReward;

  FeedbackSubmission({
    required this.id,
    required this.userId,
    required this.userName,
    required this.category,
    required this.title,
    required this.content,
    this.images = const [],
    this.status = FeedbackStatus.pending,
    this.officialReply,
    required this.createdAt,
    this.processedAt,
    this.lingjiReward,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'category': category.name,
      'title': title,
      'content': content,
      'images': images.join(','),
      'status': status.name,
      'official_reply': officialReply,
      'created_at': createdAt.toIso8601String(),
      'processed_at': processedAt?.toIso8601String(),
      'lingji_reward': lingjiReward,
    };
  }

  factory FeedbackSubmission.fromMap(Map<String, dynamic> map) {
    return FeedbackSubmission(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      userName: map['user_name'] ?? '',
      category: FeedbackCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => FeedbackCategory.other,
      ),
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      images: (map['images'] as String?)?.split(',').where((s) => s.isNotEmpty).toList() ?? [],
      status: FeedbackStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => FeedbackStatus.pending,
      ),
      officialReply: map['official_reply'],
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      processedAt: map['processed_at'] != null ? DateTime.parse(map['processed_at']) : null,
      lingjiReward: map['lingji_reward'],
    );
  }
}

enum FeedbackCategory {
  appBug,
  mingliError,
  tcmError,
  acupointError,
  featureRequest,
  experienceOptimization,
  contentCorrection,
  other,
}

enum FeedbackStatus {
  pending,
  reviewing,
  processing,
  resolved,
  rejected,
  closed,
}

extension FeedbackCategoryExtension on FeedbackCategory {
  String get displayName {
    switch (this) {
      case FeedbackCategory.appBug:
        return 'APP卡顿';
      case FeedbackCategory.mingliError:
        return '命理排盘误差';
      case FeedbackCategory.tcmError:
        return '中医内容错误';
      case FeedbackCategory.acupointError:
        return '3D穴位偏差';
      case FeedbackCategory.featureRequest:
        return '新增功能建议';
      case FeedbackCategory.experienceOptimization:
        return '使用体验优化';
      case FeedbackCategory.contentCorrection:
        return '专业内容校正';
      case FeedbackCategory.other:
        return '其他问题';
    }
  }

  String get description {
    switch (this) {
      case FeedbackCategory.appBug:
        return 'APP崩溃、卡顿、功能异常等问题';
      case FeedbackCategory.mingliError:
        return '命理排盘结果与典籍不符';
      case FeedbackCategory.tcmError:
        return '中医经方、诊断等专业知识错误';
      case FeedbackCategory.acupointError:
        return '穴位定位、主治等功能偏差';
      case FeedbackCategory.featureRequest:
        return '您希望我们增加的新功能';
      case FeedbackCategory.experienceOptimization:
        return '提升APP使用体验的建议';
      case FeedbackCategory.contentCorrection:
        return '纠错、校对、优化建议';
      case FeedbackCategory.other:
        return '其他问题反馈';
    }
  }

  IconData get icon {
    switch (this) {
      case FeedbackCategory.appBug:
        return Icons.bug_report;
      case FeedbackCategory.mingliError:
        return Icons.auto_awesome;
      case FeedbackCategory.tcmError:
        return Icons.local_hospital;
      case FeedbackCategory.acupointError:
        return Icons.spa;
      case FeedbackCategory.featureRequest:
        return Icons.lightbulb;
      case FeedbackCategory.experienceOptimization:
        return Icons.touch_app;
      case FeedbackCategory.contentCorrection:
        return Icons.edit_note;
      case FeedbackCategory.other:
        return Icons.more_horiz;
    }
  }
}

extension FeedbackStatusExtension on FeedbackStatus {
  String get displayName {
    switch (this) {
      case FeedbackStatus.pending:
        return '待处理';
      case FeedbackStatus.reviewing:
        return '审核中';
      case FeedbackStatus.processing:
        return '处理中';
      case FeedbackStatus.resolved:
        return '已解决';
      case FeedbackStatus.rejected:
        return '已驳回';
      case FeedbackStatus.closed:
        return '已关闭';
    }
  }

  Color get color {
    switch (this) {
      case FeedbackStatus.pending:
        return Colors.grey;
      case FeedbackStatus.reviewing:
        return Colors.orange;
      case FeedbackStatus.processing:
        return Colors.blue;
      case FeedbackStatus.resolved:
        return Colors.green;
      case FeedbackStatus.rejected:
        return Colors.red;
      case FeedbackStatus.closed:
        return Colors.grey;
    }
  }
}

import 'package:flutter/material.dart';
