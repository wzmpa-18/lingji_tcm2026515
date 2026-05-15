import 'package:uuid/uuid.dart';

enum FeedbackCategory {
  tcmConsultation,
  pediatric,
  acupuncture,
  fortune,
  fengshui,
  numberEnergy,
  faceReading,
  nameAnalysis,
  baziMatch,
  toolIssue,
  payment,
  account,
  suggestion,
  other,
}

enum FeedbackStatus {
  pending,
  reviewing,
  resolved,
  rejected,
}

enum FeedbackPriority {
  low,
  medium,
  high,
  urgent,
}

extension FeedbackCategoryExtension on FeedbackCategory {
  String get name {
    switch (this) {
      case FeedbackCategory.tcmConsultation:
        return '中醫諮詢';
      case FeedbackCategory.pediatric:
        return '兒科調理';
      case FeedbackCategory.acupuncture:
        return '針灸推拿';
      case FeedbackCategory.fortune:
        return '命理預測';
      case FeedbackCategory.fengshui:
        return '風水測算';
      case FeedbackCategory.numberEnergy:
        return '數字能量';
      case FeedbackCategory.faceReading:
        return '面相手相';
      case FeedbackCategory.nameAnalysis:
        return '測字起名';
      case FeedbackCategory.baziMatch:
        return '八字合盤';
      case FeedbackCategory.toolIssue:
        return '工具問題';
      case FeedbackCategory.payment:
        return '支付問題';
      case FeedbackCategory.account:
        return '帳戶問題';
      case FeedbackCategory.suggestion:
        return '功能建議';
      case FeedbackCategory.other:
        return '其他';
    }
  }

  String get icon {
    switch (this) {
      case FeedbackCategory.tcmConsultation:
        return '🌿';
      case FeedbackCategory.pediatric:
        return '👶';
      case FeedbackCategory.acupuncture:
        return '💉';
      case FeedbackCategory.fortune:
        return '🔮';
      case FeedbackCategory.fengshui:
        return '🏠';
      case FeedbackCategory.numberEnergy:
        return '🔢';
      case FeedbackCategory.faceReading:
        return '👤';
      case FeedbackCategory.nameAnalysis:
        return '✍️';
      case FeedbackCategory.baziMatch:
        return '📊';
      case FeedbackCategory.toolIssue:
        return '🔧';
      case FeedbackCategory.payment:
        return '💰';
      case FeedbackCategory.account:
        return '👤';
      case FeedbackCategory.suggestion:
        return '💡';
      case FeedbackCategory.other:
        return '❓';
    }
  }
}

class Feedback {
  final String id;
  final String userId;
  final FeedbackCategory category;
  final String title;
  final String description;
  final String? problemPhenomenon;
  final String? errorReason;
  final String? problemBasis;
  final String? improvementSuggestion;
  final List<String> attachments;
  final FeedbackStatus status;
  final FeedbackPriority priority;
  final String? adminReply;
  final DateTime? adminReplyTime;
  final DateTime createdAt;
  final int? rewardPoints;
  final bool isEffective;

  const Feedback({
    required this.id,
    required this.userId,
    required this.category,
    required this.title,
    required this.description,
    this.problemPhenomenon,
    this.errorReason,
    this.problemBasis,
    this.improvementSuggestion,
    this.attachments = const [],
    this.status = FeedbackStatus.pending,
    this.priority = FeedbackPriority.medium,
    this.adminReply,
    this.adminReplyTime,
    required this.createdAt,
    this.rewardPoints,
    this.isEffective = false,
  });

  Feedback copyWith({
    String? id,
    String? userId,
    FeedbackCategory? category,
    String? title,
    String? description,
    String? problemPhenomenon,
    String? errorReason,
    String? problemBasis,
    String? improvementSuggestion,
    List<String>? attachments,
    FeedbackStatus? status,
    FeedbackPriority? priority,
    String? adminReply,
    DateTime? adminReplyTime,
    DateTime? createdAt,
    int? rewardPoints,
    bool? isEffective,
  }) {
    return Feedback(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      problemPhenomenon: problemPhenomenon ?? this.problemPhenomenon,
      errorReason: errorReason ?? this.errorReason,
      problemBasis: problemBasis ?? this.problemBasis,
      improvementSuggestion: improvementSuggestion ?? this.improvementSuggestion,
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      adminReply: adminReply ?? this.adminReply,
      adminReplyTime: adminReplyTime ?? this.adminReplyTime,
      createdAt: createdAt ?? this.createdAt,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      isEffective: isEffective ?? this.isEffective,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'category': category.index,
      'title': title,
      ' description': description,
      'problemPhenomenon': problemPhenomenon,
      'errorReason': errorReason,
      'problemBasis': problemBasis,
      'improvementSuggestion': improvementSuggestion,
      'attachments': attachments,
      'status': status.index,
      'priority': priority.index,
      'adminReply': adminReply,
      'adminReplyTime': adminReplyTime?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'rewardPoints': rewardPoints,
      'isEffective': isEffective,
    };
  }
}

class UserPreferences {
  final String userId;
  final Map<String, dynamic> themeSettings;
  final Map<String, dynamic> languageSettings;
  final Map<String, dynamic> notificationSettings;
  final Map<String, dynamic> displaySettings;
  final List<String> favoriteModules;
  final Map<String, dynamic> customShortcuts;
  final DateTime lastUpdated;

  const UserPreferences({
    required this.userId,
    this.themeSettings = const {},
    this.languageSettings = const {},
    this.notificationSettings = const {},
    this.displaySettings = const {},
    this.favoriteModules = const [],
    this.customShortcuts = const {},
    required this.lastUpdated,
  });

  UserPreferences copyWith({
    String? userId,
    Map<String, dynamic>? themeSettings,
    Map<String, dynamic>? languageSettings,
    Map<String, dynamic>? notificationSettings,
    Map<String, dynamic>? displaySettings,
    List<String>? favoriteModules,
    Map<String, dynamic>? customShortcuts,
    DateTime? lastUpdated,
  }) {
    return UserPreferences(
      userId: userId ?? this.userId,
      themeSettings: themeSettings ?? this.themeSettings,
      languageSettings: languageSettings ?? this.languageSettings,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      displaySettings: displaySettings ?? this.displaySettings,
      favoriteModules: favoriteModules ?? this.favoriteModules,
      customShortcuts: customShortcuts ?? this.customShortcuts,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  factory FeedbackService() => _instance;
  FeedbackService._internal();

  List<Feedback> _feedbacks = [];
  Map<String, UserPreferences> _preferences = {};

  Future<void> init(String userId) async {
    _preferences[userId] = await _loadPreferences(userId);
  }

  Future<UserPreferences> _loadPreferences(String userId) async {
    return UserPreferences(
      userId: userId,
      lastUpdated: DateTime.now(),
    );
  }

  Future<Feedback> submitFeedback({
    required String userId,
    required FeedbackCategory category,
    required String title,
    required String description,
    String? problemPhenomenon,
    String? errorReason,
    String? problemBasis,
    String? improvementSuggestion,
    List<String> attachments = const [],
  }) async {
    final feedback = Feedback(
      id: const Uuid().v4(),
      userId: userId,
      category: category,
      title: title,
      description: description,
      problemPhenomenon: problemPhenomenon,
      errorReason: errorReason,
      problemBasis: problemBasis,
      improvementSuggestion: improvementSuggestion,
      attachments: attachments,
      createdAt: DateTime.now(),
    );

    _feedbacks.insert(0, feedback);
    return feedback;
  }

  Future<List<Feedback>> getUserFeedbacks(String userId) async {
    return _feedbacks.where((f) => f.userId == userId).toList();
  }

  Future<void> updateFeedbackStatus(String feedbackId, FeedbackStatus status) async {
    final index = _feedbacks.indexWhere((f) => f.id == feedbackId);
    if (index >= 0) {
      _feedbacks[index] = _feedbacks[index].copyWith(status: status);
    }
  }

  Future<void> addAdminReply(String feedbackId, String reply) async {
    final index = _feedbacks.indexWhere((f) => f.id == feedbackId);
    if (index >= 0) {
      _feedbacks[index] = _feedbacks[index].copyWith(
        adminReply: reply,
        adminReplyTime: DateTime.now(),
        status: FeedbackStatus.resolved,
      );
    }
  }

  Future<int> evaluateFeedback(String feedbackId, bool isEffective, {int? rewardPoints}) async {
    final index = _feedbacks.indexWhere((f) => f.id == feedbackId);
    if (index >= 0) {
      int points = rewardPoints ?? 10;
      if (isEffective) {
        _feedbacks[index] = _feedbacks[index].copyWith(
          isEffective: true,
          rewardPoints: points,
        );
      }
      return points;
    }
    return 0;
  }

  UserPreferences getPreferences(String userId) {
    return _preferences[userId] ?? UserPreferences(
      userId: userId,
      lastUpdated: DateTime.now(),
    );
  }

  Future<void> updatePreferences(String userId, UserPreferences preferences) async {
    _preferences[userId] = preferences.copyWith(lastUpdated: DateTime.now());
  }

  Future<void> updateThemeSetting(String userId, String key, dynamic value) async {
    final prefs = getPreferences(userId);
    final newThemeSettings = Map<String, dynamic>.from(prefs.themeSettings);
    newThemeSettings[key] = value;
    _preferences[userId] = prefs.copyWith(
      themeSettings: newThemeSettings,
      lastUpdated: DateTime.now(),
    );
  }

  Future<void> updateLanguageSetting(String userId, String languageCode) async {
    final prefs = getPreferences(userId);
    final newLanguageSettings = Map<String, dynamic>.from(prefs.languageSettings);
    newLanguageSettings['languageCode'] = languageCode;
    _preferences[userId] = prefs.copyWith(
      languageSettings: newLanguageSettings,
      lastUpdated: DateTime.now(),
    );
  }

  Future<void> addFavoriteModule(String userId, String module) async {
    final prefs = getPreferences(userId);
    if (!prefs.favoriteModules.contains(module)) {
      final newFavorites = List<String>.from(prefs.favoriteModules)..add(module);
      _preferences[userId] = prefs.copyWith(
        favoriteModules: newFavorites,
        lastUpdated: DateTime.now(),
      );
    }
  }

  Future<void> removeFavoriteModule(String userId, String module) async {
    final prefs = getPreferences(userId);
    final newFavorites = List<String>.from(prefs.favoriteModules)..remove(module);
    _preferences[userId] = prefs.copyWith(
      favoriteModules: newFavorites,
      lastUpdated: DateTime.now(),
    );
  }

  bool isVersionUpgradeSafe(String userId, String oldVersion, String newVersion) {
    final prefs = getPreferences(userId);
    return prefs.lastUpdated.isAfter(DateTime.now().subtract(const Duration(days: 30)));
  }
}
