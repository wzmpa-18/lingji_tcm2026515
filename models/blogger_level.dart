import 'package:flutter/material.dart';

enum BloggerLevel {
  level0,
  level1,
  level2,
  level3,
  level4,
  level5,
}

extension BloggerLevelExtension on BloggerLevel {
  String get name {
    switch (this) {
      case BloggerLevel.level0:
        return '无星级';
      case BloggerLevel.level1:
        return '一星博主';
      case BloggerLevel.level2:
        return '二星博主';
      case BloggerLevel.level3:
        return '三星博主';
      case BloggerLevel.level4:
        return '四星博主';
      case BloggerLevel.level5:
        return '五星博主';
    }
  }

  String get shortName {
    switch (this) {
      case BloggerLevel.level0:
        return '无星';
      case BloggerLevel.level1:
        return '一星';
      case BloggerLevel.level2:
        return '二星';
      case BloggerLevel.level3:
        return '三星';
      case BloggerLevel.level4:
        return '四星';
      case BloggerLevel.level5:
        return '五星';
    }
  }

  int get stars {
    return index;
  }

  Color get color {
    switch (this) {
      case BloggerLevel.level0:
        return Colors.grey;
      case BloggerLevel.level1:
        return Colors.brown;
      case BloggerLevel.level2:
        return Colors.grey[600]!;
      case BloggerLevel.level3:
        return Colors.blue;
      case BloggerLevel.level4:
        return Colors.purple;
      case BloggerLevel.level5:
        return Colors.amber;
    }
  }

  String get icon {
    switch (this) {
      case BloggerLevel.level0:
        return '☆';
      case BloggerLevel.level1:
        return '★';
      case BloggerLevel.level2:
        return '★★';
      case BloggerLevel.level3:
        return '★★★';
      case BloggerLevel.level4:
        return '★★★★';
      case BloggerLevel.level5:
        return '★★★★★';
    }
  }

  double get exposureWeight {
    switch (this) {
      case BloggerLevel.level0:
        return 0.1;
      case BloggerLevel.level1:
        return 0.3;
      case BloggerLevel.level2:
        return 0.5;
      case BloggerLevel.level3:
        return 0.7;
      case BloggerLevel.level4:
        return 0.9;
      case BloggerLevel.level5:
        return 1.0;
    }
  }

  bool get canAcceptOrders {
    return this.index >= BloggerLevel.level2.index;
  }

  bool get hasHomepageBadge {
    return this.index >= BloggerLevel.level3.index;
  }

  int get monthlyServiceThreshold {
    switch (this) {
      case BloggerLevel.level0:
        return 0;
      case BloggerLevel.level1:
        return 5;
      case BloggerLevel.level2:
        return 15;
      case BloggerLevel.level3:
        return 30;
      case BloggerLevel.level4:
        return 50;
      case BloggerLevel.level5:
        return 80;
    }
  }

  double get minGoodRate {
    switch (this) {
      case BloggerLevel.level0:
        return 0.0;
      case BloggerLevel.level1:
        return 0.5;
      case BloggerLevel.level2:
        return 0.6;
      case BloggerLevel.level3:
        return 0.7;
      case BloggerLevel.level4:
        return 0.8;
      case BloggerLevel.level5:
        return 0.85;
    }
  }

  double get minAccuracyRate {
    switch (this) {
      case BloggerLevel.level0:
        return 0.0;
      case BloggerLevel.level1:
        return 0.4;
      case BloggerLevel.level2:
        return 0.5;
      case BloggerLevel.level3:
        return 0.6;
      case BloggerLevel.level4:
        return 0.7;
      case BloggerLevel.level5:
        return 0.75;
    }
  }
}

class BloggerStats {
  final String bloggerId;
  final int totalServices;
  final int goodReviews;
  final int neutralReviews;
  final int badReviews;
  final int correctServices;
  final int monthlyServices;
  final DateTime lastReviewDate;
  final DateTime lastServiceDate;
  final DateTime statsUpdatedAt;

  BloggerStats({
    required this.bloggerId,
    this.totalServices = 0,
    this.goodReviews = 0,
    this.neutralReviews = 0,
    this.badReviews = 0,
    this.correctServices = 0,
    this.monthlyServices = 0,
    required this.lastReviewDate,
    required this.lastServiceDate,
    required this.statsUpdatedAt,
  });

  double get goodRate {
    if (totalServices == 0) return 0.0;
    return goodReviews / totalServices;
  }

  double get accuracyRate {
    if (totalServices == 0) return 0.0;
    return correctServices / totalServices;
  }

  double get averageRating {
    if (totalServices == 0) return 0.0;
    return (goodReviews * 5.0 + neutralReviews * 3.0 + badReviews * 1.0) / totalServices;
  }

  Map<String, dynamic> toMap() {
    return {
      'blogger_id': bloggerId,
      'total_services': totalServices,
      'good_reviews': goodReviews,
      'neutral_reviews': neutralReviews,
      'bad_reviews': badReviews,
      'correct_services': correctServices,
      'monthly_services': monthlyServices,
      'last_review_date': lastReviewDate.toIso8601String(),
      'last_service_date': lastServiceDate.toIso8601String(),
      'stats_updated_at': statsUpdatedAt.toIso8601String(),
    };
  }

  factory BloggerStats.fromMap(Map<String, dynamic> map) {
    return BloggerStats(
      bloggerId: map['blogger_id'],
      totalServices: map['total_services'] ?? 0,
      goodReviews: map['good_reviews'] ?? 0,
      neutralReviews: map['neutral_reviews'] ?? 0,
      badReviews: map['bad_reviews'] ?? 0,
      correctServices: map['correct_services'] ?? 0,
      monthlyServices: map['monthly_services'] ?? 0,
      lastReviewDate: DateTime.parse(map['last_review_date']),
      lastServiceDate: DateTime.parse(map['last_service_date']),
      statsUpdatedAt: DateTime.parse(map['stats_updated_at']),
    );
  }

  BloggerStats copyWith({
    String? bloggerId,
    int? totalServices,
    int? goodReviews,
    int? neutralReviews,
    int? badReviews,
    int? correctServices,
    int? monthlyServices,
    DateTime? lastReviewDate,
    DateTime? lastServiceDate,
    DateTime? statsUpdatedAt,
  }) {
    return BloggerStats(
      bloggerId: bloggerId ?? this.bloggerId,
      totalServices: totalServices ?? this.totalServices,
      goodReviews: goodReviews ?? this.goodReviews,
      neutralReviews: neutralReviews ?? this.neutralReviews,
      badReviews: badReviews ?? this.badReviews,
      correctServices: correctServices ?? this.correctServices,
      monthlyServices: monthlyServices ?? this.monthlyServices,
      lastReviewDate: lastReviewDate ?? this.lastReviewDate,
      lastServiceDate: lastServiceDate ?? this.lastServiceDate,
      statsUpdatedAt: statsUpdatedAt ?? this.statsUpdatedAt,
    );
  }
}

class ServiceRecord {
  final String id;
  final String bloggerId;
  final String userId;
  final ServiceType serviceType;
  final String serviceContent;
  final String? result;
  final DateTime serviceTime;
  final ReviewRecord? review;
  final bool isCorrect;
  final String? notes;

  ServiceRecord({
    required this.id,
    required this.bloggerId,
    required this.userId,
    required this.serviceType,
    required this.serviceContent,
    this.result,
    required this.serviceTime,
    this.review,
    this.isCorrect = false,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'blogger_id': bloggerId,
      'user_id': userId,
      'service_type': serviceType.name,
      'service_content': serviceContent,
      'result': result,
      'service_time': serviceTime.toIso8601String(),
      'review': review?.toMap(),
      'is_correct': isCorrect ? 1 : 0,
      'notes': notes,
    };
  }

  factory ServiceRecord.fromMap(Map<String, dynamic> map) {
    return ServiceRecord(
      id: map['id'],
      bloggerId: map['blogger_id'],
      userId: map['user_id'],
      serviceType: ServiceType.values.firstWhere(
        (e) => e.name == map['service_type'],
        orElse: () => ServiceType.consultation,
      ),
      serviceContent: map['service_content'],
      result: map['result'],
      serviceTime: DateTime.parse(map['service_time']),
      review: map['review'] != null ? ReviewRecord.fromMap(map['review']) : null,
      isCorrect: map['is_correct'] == 1,
      notes: map['notes'],
    );
  }
}

enum ServiceType {
  fortune,
  tcm,
  consultation,
  other,
}

extension ServiceTypeExtension on ServiceType {
  String get displayName {
    switch (this) {
      case ServiceType.fortune:
        return '命理测算';
      case ServiceType.tcm:
        return '中医开方';
      case ServiceType.consultation:
        return '咨询服务';
      case ServiceType.other:
        return '其他服务';
    }
  }
}

class ReviewRecord {
  final String id;
  final String serviceId;
  final String userId;
  final int rating;
  final String? comment;
  final DateTime reviewTime;
  final ReviewType type;

  ReviewRecord({
    required this.id,
    required this.serviceId,
    required this.userId,
    required this.rating,
    this.comment,
    required this.reviewTime,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'service_id': serviceId,
      'user_id': userId,
      'rating': rating,
      'comment': comment,
      'review_time': reviewTime.toIso8601String(),
      'type': type.name,
    };
  }

  factory ReviewRecord.fromMap(Map<String, dynamic> map) {
    return ReviewRecord(
      id: map['id'],
      serviceId: map['service_id'],
      userId: map['user_id'],
      rating: map['rating'],
      comment: map['comment'],
      reviewTime: DateTime.parse(map['review_time']),
      type: ReviewType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => ReviewType.rating,
      ),
    );
  }
}

enum ReviewType {
  rating,
  accuracy,
  correction,
}

extension ReviewTypeExtension on ReviewType {
  String get displayName {
    switch (this) {
      case ReviewType.rating:
        return '评分';
      case ReviewType.accuracy:
        return '正确率评价';
      case ReviewType.correction:
        return '纠错反馈';
    }
  }
}

class BloggerMonthlyRating {
  final String id;
  final String bloggerId;
  final int year;
  final int month;
  final BloggerLevel level;
  final int serviceCount;
  final double goodRate;
  final double accuracyRate;
  final bool isPromoted;
  final bool isDemoted;
  final DateTime ratingDate;
  final String? notes;

  BloggerMonthlyRating({
    required this.id,
    required this.bloggerId,
    required this.year,
    required this.month,
    required this.level,
    required this.serviceCount,
    required this.goodRate,
    required this.accuracyRate,
    this.isPromoted = false,
    this.isDemoted = false,
    required this.ratingDate,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'blogger_id': bloggerId,
      'year': year,
      'month': month,
      'level': level.name,
      'service_count': serviceCount,
      'good_rate': goodRate,
      'accuracy_rate': accuracyRate,
      'is_promoted': isPromoted ? 1 : 0,
      'is_demoted': isDemoted ? 1 : 0,
      'rating_date': ratingDate.toIso8601String(),
      'notes': notes,
    };
  }

  factory BloggerMonthlyRating.fromMap(Map<String, dynamic> map) {
    return BloggerMonthlyRating(
      id: map['id'],
      bloggerId: map['blogger_id'],
      year: map['year'],
      month: map['month'],
      level: BloggerLevel.values.firstWhere(
        (e) => e.name == map['level'],
        orElse: () => BloggerLevel.level0,
      ),
      serviceCount: map['service_count'],
      goodRate: (map['good_rate'] as num).toDouble(),
      accuracyRate: (map['accuracy_rate'] as num).toDouble(),
      isPromoted: map['is_promoted'] == 1,
      isDemoted: map['is_demoted'] == 1,
      ratingDate: DateTime.parse(map['rating_date']),
      notes: map['notes'],
    );
  }
}
