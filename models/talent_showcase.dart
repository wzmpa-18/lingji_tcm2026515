import 'package:flutter/material.dart';
import 'blogger_level.dart';

class TalentShowcase {
  final String id;
  final String talentId;
  final String name;
  final String avatar;
  final String bio;
  final String specialties;
  final List<String> tags;
  final BloggerLevel level;
  final TalentStats stats;
  final List<ServiceRecord> historyRecords;
  final TalentServicePricing pricing;
  final DateTime createdAt;
  final DateTime updatedAt;

  TalentShowcase({
    required this.id,
    required this.talentId,
    required this.name,
    required this.avatar,
    required this.bio,
    required this.specialties,
    this.tags = const [],
    required this.level,
    required this.stats,
    this.historyRecords = const [],
    required this.pricing,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'talent_id': talentId,
      'name': name,
      'avatar': avatar,
      'bio': bio,
      'specialties': specialties,
      'tags': tags.join(','),
      'level': level.name,
      'stats': stats.toMap(),
      'history_records': historyRecords.map((r) => r.toMap()).toList(),
      'pricing': pricing.toMap(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory TalentShowcase.fromMap(Map<String, dynamic> map) {
    return TalentShowcase(
      id: map['id'],
      talentId: map['talent_id'],
      name: map['name'],
      avatar: map['avatar'] ?? '',
      bio: map['bio'] ?? '',
      specialties: map['specialties'] ?? '',
      tags: (map['tags'] as String?)?.split(',').where((e) => e.isNotEmpty).toList() ?? [],
      level: BloggerLevel.values.firstWhere(
        (e) => e.name == map['level'],
        orElse: () => BloggerLevel.level0,
      ),
      stats: TalentStats.fromMap(map['stats']),
      historyRecords: (map['history_records'] as List?)
              ?.map((r) => ServiceRecord.fromMap(r))
              .toList() ??
          [],
      pricing: TalentServicePricing.fromMap(map['pricing']),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}

class TalentStats {
  final int totalServices;
  final int monthlyServices;
  final int goodReviews;
  final int neutralReviews;
  final int badReviews;
  final int correctServices;
  final double goodRate;
  final double accuracyRate;
  final double averageRating;
  final int exposureWeight;

  TalentStats({
    this.totalServices = 0,
    this.monthlyServices = 0,
    this.goodReviews = 0,
    this.neutralReviews = 0,
    this.badReviews = 0,
    this.correctServices = 0,
    this.goodRate = 0.0,
    this.accuracyRate = 0.0,
    this.averageRating = 0.0,
    this.exposureWeight = 0,
  });

  String get ratingStars {
    final stars = averageRating.round();
    return '★' * stars + '☆' * (5 - stars);
  }

  String get goodRatePercent => '${(goodRate * 100).toStringAsFixed(1)}%';

  String get accuracyRatePercent => '${(accuracyRate * 100).toStringAsFixed(1)}%';

  Map<String, dynamic> toMap() {
    return {
      'total_services': totalServices,
      'monthly_services': monthlyServices,
      'good_reviews': goodReviews,
      'neutral_reviews': neutralReviews,
      'bad_reviews': badReviews,
      'correct_services': correctServices,
      'good_rate': goodRate,
      'accuracy_rate': accuracyRate,
      'average_rating': averageRating,
      'exposure_weight': exposureWeight,
    };
  }

  factory TalentStats.fromMap(Map<String, dynamic> map) {
    return TalentStats(
      totalServices: map['total_services'] ?? 0,
      monthlyServices: map['monthly_services'] ?? 0,
      goodReviews: map['good_reviews'] ?? 0,
      neutralReviews: map['neutral_reviews'] ?? 0,
      badReviews: map['bad_reviews'] ?? 0,
      correctServices: map['correct_services'] ?? 0,
      goodRate: (map['good_rate'] as num?)?.toDouble() ?? 0.0,
      accuracyRate: (map['accuracy_rate'] as num?)?.toDouble() ?? 0.0,
      averageRating: (map['average_rating'] as num?)?.toDouble() ?? 0.0,
      exposureWeight: map['exposure_weight'] ?? 0,
    );
  }
}

class TalentServicePricing {
  final int fortuneConsultationPrice;
  final int tcmConsultationPrice;
  final int prescriptionPrice;
  final int followUpPrice;
  final bool isCustomPricing;
  final DateTime? lastUpdated;

  TalentServicePricing({
    this.fortuneConsultationPrice = 29,
    this.tcmConsultationPrice = 39,
    this.prescriptionPrice = 49,
    this.followUpPrice = 9,
    this.isCustomPricing = false,
    this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'fortune_consultation_price': fortuneConsultationPrice,
      'tcm_consultation_price': tcmConsultationPrice,
      'prescription_price': prescriptionPrice,
      'follow_up_price': followUpPrice,
      'is_custom_pricing': isCustomPricing ? 1 : 0,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  factory TalentServicePricing.fromMap(Map<String, dynamic> map) {
    return TalentServicePricing(
      fortuneConsultationPrice: map['fortune_consultation_price'] ?? 29,
      tcmConsultationPrice: map['tcm_consultation_price'] ?? 39,
      prescriptionPrice: map['prescription_price'] ?? 49,
      followUpPrice: map['follow_up_price'] ?? 9,
      isCustomPricing: map['is_custom_pricing'] == 1,
      lastUpdated: map['last_updated'] != null
          ? DateTime.parse(map['last_updated'])
          : null,
    );
  }

  TalentServicePricing copyWith({
    int? fortuneConsultationPrice,
    int? tcmConsultationPrice,
    int? prescriptionPrice,
    int? followUpPrice,
    bool? isCustomPricing,
    DateTime? lastUpdated,
  }) {
    return TalentServicePricing(
      fortuneConsultationPrice: fortuneConsultationPrice ?? this.fortuneConsultationPrice,
      tcmConsultationPrice: tcmConsultationPrice ?? this.tcmConsultationPrice,
      prescriptionPrice: prescriptionPrice ?? this.prescriptionPrice,
      followUpPrice: followUpPrice ?? this.followUpPrice,
      isCustomPricing: isCustomPricing ?? this.isCustomPricing,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class TalentShowcasePage {
  final String id;
  final String talentId;
  final String pageTitle;
  final String pageSubtitle;
  final String coverImage;
  final List<String> highlightServices;
  final String contactNote;
  final bool enableOnlineBooking;
  final DateTime createdAt;

  TalentShowcasePage({
    required this.id,
    required this.talentId,
    required this.pageTitle,
    required this.pageSubtitle,
    required this.coverImage,
    this.highlightServices = const [],
    required this.contactNote,
    this.enableOnlineBooking = true,
    required this.createdAt,
  });

  String get shareUrl => 'https://lingji.com/talent/$talentId';

  String get shareTitle => '$pageTitle - 专业达人服务';

  String get shareDescription => contactNote;
}

class TalentShowcaseSettings {
  final String talentId;
  final bool showPrice;
  final bool showStats;
  final bool showHistory;
  final bool enableComments;
  final bool enableBooking;
  final String? customBanner;

  TalentShowcaseSettings({
    required this.talentId,
    this.showPrice = true,
    this.showStats = true,
    this.showHistory = true,
    this.enableComments = true,
    this.enableBooking = true,
    this.customBanner,
  });
}
