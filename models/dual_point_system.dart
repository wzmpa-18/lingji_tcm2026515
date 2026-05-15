class DualPointSystem {
  static const String lingji = 'lingji';
  static const String xuehai = 'xuehai';
}

class XueHaiPoint {
  final String id;
  final String userId;
  final int points;
  final int totalEarned;
  final int totalSpent;
  final DateTime lastUpdated;

  XueHaiPoint({
    required this.id,
    required this.userId,
    required this.points,
    this.totalEarned = 0,
    this.totalSpent = 0,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'points': points,
      'total_earned': totalEarned,
      'total_spent': totalSpent,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  factory XueHaiPoint.fromMap(Map<String, dynamic> map) {
    return XueHaiPoint(
      id: map['id'],
      userId: map['user_id'],
      points: map['points'] ?? 0,
      totalEarned: map['total_earned'] ?? 0,
      totalSpent: map['total_spent'] ?? 0,
      lastUpdated: DateTime.parse(map['last_updated']),
    );
  }

  XueHaiPoint copyWith({
    String? id,
    String? userId,
    int? points,
    int? totalEarned,
    int? totalSpent,
    DateTime? lastUpdated,
  }) {
    return XueHaiPoint(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      points: points ?? this.points,
      totalEarned: totalEarned ?? this.totalEarned,
      totalSpent: totalSpent ?? this.totalSpent,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class StudySession {
  final String id;
  final String userId;
  final String bookId;
  final DateTime startTime;
  final DateTime endTime;
  final int totalSeconds;
  final int earnedPoints;
  final bool isValid;
  final DateTime createdAt;

  StudySession({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.startTime,
    required this.endTime,
    required this.totalSeconds,
    required this.earnedPoints,
    this.isValid = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'book_id': bookId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'total_seconds': totalSeconds,
      'earned_points': earnedPoints,
      'is_valid': isValid ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory StudySession.fromMap(Map<String, dynamic> map) {
    return StudySession(
      id: map['id'],
      userId: map['user_id'],
      bookId: map['book_id'],
      startTime: DateTime.parse(map['start_time']),
      endTime: DateTime.parse(map['end_time']),
      totalSeconds: map['total_seconds'] ?? 0,
      earnedPoints: map['earned_points'] ?? 0,
      isValid: map['is_valid'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}

class DailyPointLimit {
  final String userId;
  final DateTime date;
  final int earnedToday;
  final int maxDailyPoints;
  final int maxDailyMinutes;

  DailyPointLimit({
    required this.userId,
    required this.date,
    required this.earnedToday,
    this.maxDailyPoints = 16,
    this.maxDailyMinutes = 120,
  });

  bool get isLimitReached => earnedToday >= maxDailyPoints;

  int get remainingPoints => maxDailyPoints - earnedToday;

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'date': date.toIso8601String().split('T')[0],
      'earned_today': earnedToday,
    };
  }

  factory DailyPointLimit.fromMap(Map<String, dynamic> map) {
    return DailyPointLimit(
      userId: map['user_id'],
      date: DateTime.parse(map['date']),
      earnedToday: map['earned_today'] ?? 0,
    );
  }
}
