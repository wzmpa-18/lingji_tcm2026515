import 'dart:async';
import 'dart:math';
import '../models/dual_point_system.dart';
import '../models/classic_book.dart';

class StudyTimerService {
  static const int pointsPerHour = 8;
  static const int secondsPerMinute = 60;
  static const int secondsPerHour = 3600;
  static const int maxDailyMinutes = 120;
  static const int maxDailyPoints = 16;
  static const int idleThreshold = 5 * 60;

  final Map<String, StudySession> _activeSessions = {};
  final Map<String, int> _activeSeconds = {};
  final Map<String, Timer?> _timers = {};
  final Map<String, DateTime> _lastActivity = {};

  bool isSessionActive(String userId) {
    return _activeSessions.containsKey(userId) && !_isIdle(userId);
  }

  bool _isIdle(String userId) {
    if (!_lastActivity.containsKey(userId)) return true;
    final now = DateTime.now();
    final last = _lastActivity[userId]!;
    return now.difference(last).inSeconds > idleThreshold;
  }

  void updateActivity(String userId) {
    _lastActivity[userId] = DateTime.now();
  }

  StudySession? startSession(String userId, String bookId) {
    if (_activeSessions.containsKey(userId)) {
      return null;
    }

    final session = StudySession(
      id: _generateId(),
      userId: userId,
      bookId: bookId,
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      totalSeconds: 0,
      earnedPoints: 0,
      isValid: true,
      createdAt: DateTime.now(),
    );

    _activeSessions[userId] = session;
    _activeSeconds[userId] = 0;
    _lastActivity[userId] = DateTime.now();
    _startTimer(userId);

    return session;
  }

  void _startTimer(String userId) {
    _timers[userId]?.cancel();
    _timers[userId] = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isIdle(userId)) {
        pauseSession(userId);
        return;
      }
      _activeSeconds[userId] = (_activeSeconds[userId] ?? 0) + 1;
    });
  }

  void pauseSession(String userId) {
    _timers[userId]?.cancel();
    _timers[userId] = null;
  }

  void resumeSession(String userId) {
    if (!_activeSessions.containsKey(userId)) return;
    _lastActivity[userId] = DateTime.now();
    _startTimer(userId);
  }

  StopSessionResult stopSession(String userId, DailyPointLimit dailyLimit) {
    if (!_activeSessions.containsKey(userId)) {
      return StopSessionResult(success: false, earnedPoints: 0);
    }

    final session = _activeSessions[userId]!;
    final sessionSeconds = _activeSeconds[userId] ?? 0;
    final endTime = DateTime.now();

    final earnedPoints = _calculateEarnedPoints(sessionSeconds, dailyLimit.remainingPoints);

    final finalSession = StudySession(
      id: session.id,
      userId: session.userId,
      bookId: session.bookId,
      startTime: session.startTime,
      endTime: endTime,
      totalSeconds: sessionSeconds,
      earnedPoints: earnedPoints,
      isValid: !_isIdle(userId) || sessionSeconds > 60,
      createdAt: session.createdAt,
    );

    _activeSessions.remove(userId);
    _activeSeconds.remove(userId);
    _lastActivity.remove(userId);
    _timers[userId]?.cancel();
    _timers.remove(userId);

    return StopSessionResult(
      success: true,
      earnedPoints: earnedPoints,
      session: finalSession,
    );
  }

  int _calculateEarnedPoints(int totalSeconds, int remainingPoints) {
    final totalMinutes = (totalSeconds / secondsPerMinute).floor();
    final fullHours = (totalMinutes / 60).floor();
    final pointsFromHours = fullHours * pointsPerHour;
    return min(pointsFromHours, remainingPoints);
  }

  SessionProgress getSessionProgress(String userId) {
    if (!_activeSessions.containsKey(userId)) {
      return SessionProgress(
        isActive: false,
        currentSeconds: 0,
        earnedPoints: 0,
      );
    }

    final seconds = _activeSeconds[userId] ?? 0;
    final dummyLimit = DailyPointLimit(userId: userId, date: DateTime.now(), earnedToday: 0);
    final earned = _calculateEarnedPoints(seconds, maxDailyPoints);

    return SessionProgress(
      isActive: !_isIdle(userId),
      currentSeconds: seconds,
      earnedPoints: earned,
    );
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(9999).toString().padLeft(4, '0');
  }
}

class StopSessionResult {
  final bool success;
  final int earnedPoints;
  final StudySession? session;

  StopSessionResult({
    required this.success,
    required this.earnedPoints,
    this.session,
  });
}

class SessionProgress {
  final bool isActive;
  final int currentSeconds;
  final int earnedPoints;

  SessionProgress({
    required this.isActive,
    required this.currentSeconds,
    required this.earnedPoints,
  });

  String get formattedTime {
    final hours = (currentSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((currentSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (currentSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
