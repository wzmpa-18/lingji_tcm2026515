import '../models/blogger_level.dart';

class BloggerService {
  static final BloggerService _instance = BloggerService._internal();
  factory BloggerService() => _instance;
  BloggerService._internal();

  final Map<String, BloggerStats> _statsCache = {};

  void updateStats(String bloggerId, BloggerStats stats) {
    _statsCache[bloggerId] = stats;
  }

  BloggerStats? getStats(String bloggerId) {
    return _statsCache[bloggerId];
  }

  BloggerLevel calculateLevel(BloggerStats stats) {
    final serviceCount = stats.monthlyServices;
    final goodRate = stats.goodRate;
    final accuracyRate = stats.accuracyRate;

    if (serviceCount >= 80 && goodRate >= 0.85 && accuracyRate >= 0.75) {
      return BloggerLevel.level5;
    } else if (serviceCount >= 50 && goodRate >= 0.8 && accuracyRate >= 0.7) {
      return BloggerLevel.level4;
    } else if (serviceCount >= 30 && goodRate >= 0.7 && accuracyRate >= 0.6) {
      return BloggerLevel.level3;
    } else if (serviceCount >= 15 && goodRate >= 0.6 && accuracyRate >= 0.5) {
      return BloggerLevel.level2;
    } else if (serviceCount >= 5 && goodRate >= 0.5 && accuracyRate >= 0.4) {
      return BloggerLevel.level1;
    }
    return BloggerLevel.level0;
  }

  BloggerMonthlyRating evaluateMonthly(String bloggerId, int year, int month) {
    final stats = _statsCache[bloggerId];
    if (stats == null) {
      return BloggerMonthlyRating(
        id: '${bloggerId}_$year$month',
        bloggerId: bloggerId,
        year: year,
        month: month,
        level: BloggerLevel.level0,
        serviceCount: 0,
        goodRate: 0,
        accuracyRate: 0,
        ratingDate: DateTime.now(),
      );
    }

    final newLevel = calculateLevel(stats);
    final currentLevel = _getCurrentLevel(bloggerId);
    final isPromoted = newLevel.index > currentLevel.index;
    final isDemoted = newLevel.index < currentLevel.index;

    return BloggerMonthlyRating(
      id: '${bloggerId}_$year$month',
      bloggerId: bloggerId,
      year: year,
      month: month,
      level: newLevel,
      serviceCount: stats.monthlyServices,
      goodRate: stats.goodRate,
      accuracyRate: stats.accuracyRate,
      isPromoted: isPromoted,
      isDemoted: isDemoted,
      ratingDate: DateTime.now(),
    );
  }

  BloggerLevel _getCurrentLevel(String bloggerId) {
    return BloggerLevel.level0;
  }

  void recordService(String bloggerId, ServiceRecord record) {
    final stats = _statsCache[bloggerId] ?? BloggerStats(
      bloggerId: bloggerId,
      lastReviewDate: DateTime.now(),
      lastServiceDate: DateTime.now(),
      statsUpdatedAt: DateTime.now(),
    );

    _statsCache[bloggerId] = stats.copyWith(
      totalServices: stats.totalServices + 1,
      monthlyServices: stats.monthlyServices + 1,
      lastServiceDate: DateTime.now(),
      statsUpdatedAt: DateTime.now(),
    );
  }

  void recordReview(String bloggerId, ReviewRecord review) {
    final stats = _statsCache[bloggerId] ?? BloggerStats(
      bloggerId: bloggerId,
      lastReviewDate: DateTime.now(),
      lastServiceDate: DateTime.now(),
      statsUpdatedAt: DateTime.now(),
    );

    int goodReviews = stats.goodReviews;
    int neutralReviews = stats.neutralReviews;
    int badReviews = stats.badReviews;

    if (review.rating >= 4) {
      goodReviews++;
    } else if (review.rating >= 2) {
      neutralReviews++;
    } else {
      badReviews++;
    }

    _statsCache[bloggerId] = stats.copyWith(
      goodReviews: goodReviews,
      neutralReviews: neutralReviews,
      badReviews: badReviews,
      lastReviewDate: DateTime.now(),
      statsUpdatedAt: DateTime.now(),
    );
  }

  void recordAccuracy(String bloggerId, bool isCorrect) {
    final stats = _statsCache[bloggerId] ?? BloggerStats(
      bloggerId: bloggerId,
      lastReviewDate: DateTime.now(),
      lastServiceDate: DateTime.now(),
      statsUpdatedAt: DateTime.now(),
    );

    _statsCache[bloggerId] = stats.copyWith(
      correctServices: stats.correctServices + (isCorrect ? 1 : 0),
      statsUpdatedAt: DateTime.now(),
    );
  }

  void resetMonthlyStats(String bloggerId) {
    final stats = _statsCache[bloggerId];
    if (stats != null) {
      _statsCache[bloggerId] = stats.copyWith(
        monthlyServices: 0,
        statsUpdatedAt: DateTime.now(),
      );
    }
  }

  Map<String, dynamic> getStatistics(String bloggerId) {
    final stats = _statsCache[bloggerId];
    if (stats == null) {
      return {
        'totalServices': 0,
        'goodReviews': 0,
        'neutralReviews': 0,
        'badReviews': 0,
        'correctServices': 0,
        'monthlyServices': 0,
        'goodRate': 0.0,
        'accuracyRate': 0.0,
        'averageRating': 0.0,
        'currentLevel': BloggerLevel.level0.name,
      };
    }

    return {
      'totalServices': stats.totalServices,
      'goodReviews': stats.goodReviews,
      'neutralReviews': stats.neutralReviews,
      'badReviews': stats.badReviews,
      'correctServices': stats.correctServices,
      'monthlyServices': stats.monthlyServices,
      'goodRate': (stats.goodRate * 100).toStringAsFixed(1) + '%',
      'accuracyRate': (stats.accuracyRate * 100).toStringAsFixed(1) + '%',
      'averageRating': stats.averageRating.toStringAsFixed(1),
      'currentLevel': calculateLevel(stats).name,
    };
  }
}
