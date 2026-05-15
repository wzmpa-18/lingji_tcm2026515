import 'dart:async';
import 'dart:convert';

enum SensitiveLevel {
  low,
  medium,
  high,
  critical,
}

enum TriggerAction {
  block,
  warn,
  mute,
  notifyAdmin,
  allow,
}

class SensitiveWord {
  final String word;
  final String category;
  final SensitiveLevel level;
  final TriggerAction defaultAction;

  const SensitiveWord({
    required this.word,
    required this.category,
    required this.level,
    this.defaultAction = TriggerAction.block,
  });
}

class RiskAlert {
  final String id;
  final String groupId;
  final String userId;
  final String content;
  final List<String> matchedWords;
  final SensitiveLevel level;
  final TriggerAction action;
  final DateTime timestamp;
  final bool processed;
  final String? adminNote;

  RiskAlert({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.content,
    required this.matchedWords,
    required this.level,
    required this.action,
    required this.timestamp,
    this.processed = false,
    this.adminNote,
  });

  RiskAlert copyWith({
    String? id,
    String? groupId,
    String? userId,
    String? content,
    List<String>? matchedWords,
    SensitiveLevel? level,
    TriggerAction? action,
    DateTime? timestamp,
    bool? processed,
    String? adminNote,
  }) {
    return RiskAlert(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      matchedWords: matchedWords ?? this.matchedWords,
      level: level ?? this.level,
      action: action ?? this.action,
      timestamp: timestamp ?? this.timestamp,
      processed: processed ?? this.processed,
      adminNote: adminNote ?? this.adminNote,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'userId': userId,
      'content': content,
      'matchedWords': matchedWords,
      'level': level.name,
      'action': action.name,
      'timestamp': timestamp.toIso8601String(),
      'processed': processed,
      'adminNote': adminNote,
    };
  }
}

class GroupRiskConfig {
  final String groupId;
  final bool enabled;
  final Map<String, TriggerAction> categoryActions;
  final int muteDurationMinutes;
  final List<String> adminNotifyList;
  final bool logEnabled;

  GroupRiskConfig({
    required this.groupId,
    this.enabled = true,
    Map<String, TriggerAction>? categoryActions,
    this.muteDurationMinutes = 30,
    List<String>? adminNotifyList,
    this.logEnabled = true,
  }) : categoryActions = categoryActions ?? {},
       adminNotifyList = adminNotifyList ?? [];
}

class SensitiveWordDatabase {
  static final List<SensitiveWord> defaultWords = [
    const SensitiveWord(
      word: '赌博',
      category: '违法行为',
      level: SensitiveLevel.critical,
      defaultAction: TriggerAction.block,
    ),
    const SensitiveWord(
      word: '吸毒',
      category: '违法行为',
      level: SensitiveLevel.critical,
      defaultAction: TriggerAction.block,
    ),
    const SensitiveWord(
      word: '诈骗',
      category: '违法行为',
      level: SensitiveLevel.high,
      defaultAction: TriggerAction.block,
    ),
    const SensitiveWord(
      word: '枪支',
      category: '违法行为',
      level: SensitiveLevel.critical,
      defaultAction: TriggerAction.block,
    ),
    const SensitiveWord(
      word: '色情',
      category: '违规内容',
      level: SensitiveLevel.high,
      defaultAction: TriggerAction.block,
    ),
    const SensitiveWord(
      word: '暴力',
      category: '违规内容',
      level: SensitiveLevel.medium,
      defaultAction: TriggerAction.warn,
    ),
    const SensitiveWord(
      word: '政治敏感',
      category: '违规内容',
      level: SensitiveLevel.high,
      defaultAction: TriggerAction.block,
    ),
    const SensitiveWord(
      word: '邪教',
      category: '违规内容',
      level: SensitiveLevel.critical,
      defaultAction: TriggerAction.block,
    ),
    const SensitiveWord(
      word: '封建迷信',
      category: '违规内容',
      level: SensitiveLevel.medium,
      defaultAction: TriggerAction.warn,
    ),
    const SensitiveWord(
      word: '算命',
      category: '违规内容',
      level: SensitiveLevel.low,
      defaultAction: TriggerAction.allow,
    ),
    const SensitiveWord(
      word: '看相',
      category: '违规内容',
      level: SensitiveLevel.low,
      defaultAction: TriggerAction.allow,
    ),
  ];

  static List<SensitiveWord> get words => defaultWords;
}

class GroupRiskControlService {
  static final GroupRiskControlService _instance = GroupRiskControlService._internal();
  factory GroupRiskControlService() => _instance;
  GroupRiskControlService._internal();

  final List<SensitiveWord> _customWords = [];
  final Map<String, GroupRiskConfig> _groupConfigs = {};
  final List<RiskAlert> _alerts = [];
  final StreamController<RiskAlert> _alertStream = StreamController<RiskAlert>.broadcast();

  Stream<RiskAlert> get alertStream => _alertStream.stream;

  void addCustomWord(SensitiveWord word) {
    _customWords.add(word);
  }

  void removeCustomWord(String word) {
    _customWords.removeWhere((w) => w.word == word);
  }

  void setGroupConfig(GroupRiskConfig config) {
    _groupConfigs[config.groupId] = config;
  }

  void removeGroupConfig(String groupId) {
    _groupConfigs.remove(groupId);
  }

  GroupRiskConfig? getGroupConfig(String groupId) {
    return _groupConfigs[groupId];
  }

  RiskCheckResult checkContent(String groupId, String userId, String content) {
    final config = _groupConfigs[groupId];
    if (config == null || !config.enabled) {
      return RiskCheckResult(
        isSafe: true,
        alerts: [],
      );
    }

    final alerts = <RiskAlert>[];
    final allWords = [...SensitiveWordDatabase.words, ..._customWords];

    for (final word in allWords) {
      if (content.contains(word.word)) {
        TriggerAction action = word.defaultAction;

        if (config.categoryActions.containsKey(word.category)) {
          action = config.categoryActions[word.category]!;
        }

        if (action == TriggerAction.allow) continue;

        final alert = RiskAlert(
          id: 'ALERT_${DateTime.now().millisecondsSinceEpoch}',
          groupId: groupId,
          userId: userId,
          content: content,
          matchedWords: [word.word],
          level: word.level,
          action: action,
          timestamp: DateTime.now(),
        );

        alerts.add(alert);
        _alerts.add(alert);
        _alertStream.add(alert);
      }
    }

    if (alerts.isEmpty) {
      return RiskCheckResult(
        isSafe: true,
        alerts: [],
      );
    }

    final highestLevel = alerts
        .map((a) => a.level)
        .reduce((a, b) => a.index > b.index ? a : b);

    return RiskCheckResult(
      isSafe: false,
      alerts: alerts,
      highestLevel: highestLevel,
    );
  }

  List<RiskAlert> getAlerts({
    String? groupId,
    bool? processed,
    int limit = 50,
  }) {
    var filtered = _alerts.toList();

    if (groupId != null) {
      filtered = filtered.where((a) => a.groupId == groupId).toList();
    }

    if (processed != null) {
      filtered = filtered.where((a) => a.processed == processed).toList();
    }

    filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return filtered.take(limit).toList();
  }

  Future<void> processAlert(String alertId, {String? note}) async {
    final index = _alerts.indexWhere((a) => a.id == alertId);
    if (index != -1) {
      _alerts[index] = _alerts[index].copyWith(
        processed: true,
        adminNote: note,
      );
    }
  }

  String getWarningMessage(RiskAlert alert) {
    switch (alert.action) {
      case TriggerAction.block:
        return '⚠️ 您的消息包含敏感内容，已被系统屏蔽。';
      case TriggerAction.warn:
        return '⚠️ 警告：您的消息可能包含不当内容，请注意言行。';
      case TriggerAction.mute:
        return '⛔ 您已被临时禁言 ${_getGroupConfig(alert.groupId)?.muteDurationMinutes ?? 30} 分钟，原因：发送敏感内容。';
      case TriggerAction.notifyAdmin:
        return '📢 您的消息已提交管理员审核。';
      case TriggerAction.allow:
        return '';
    }
  }

  GroupRiskConfig? _getGroupConfig(String groupId) {
    return _groupConfigs[groupId];
  }

  Map<String, dynamic> exportConfig() {
    return {
      'customWords': _customWords.map((w) => {
        'word': w.word,
        'category': w.category,
        'level': w.level.name,
        'action': w.defaultAction.name,
      }).toList(),
      'groupConfigs': _groupConfigs.map((key, value) => MapEntry(key, {
        'groupId': value.groupId,
        'enabled': value.enabled,
        'categoryActions': value.categoryActions.map((k, v) => MapEntry(k, v.name)),
        'muteDurationMinutes': value.muteDurationMinutes,
        'adminNotifyList': value.adminNotifyList,
        'logEnabled': value.logEnabled,
      })),
    };
  }

  void importConfig(Map<String, dynamic> config) {
    if (config['customWords'] != null) {
      for (final wordData in config['customWords']) {
        _customWords.add(SensitiveWord(
          word: wordData['word'],
          category: wordData['category'],
          level: SensitiveLevel.values.firstWhere((e) => e.name == wordData['level']),
          defaultAction: TriggerAction.values.firstWhere((e) => e.name == wordData['action']),
        ));
      }
    }

    if (config['groupConfigs'] != null) {
      for (final entry in config['groupConfigs'].entries) {
        final configData = entry.value;
        _groupConfigs[entry.key] = GroupRiskConfig(
          groupId: configData['groupId'],
          enabled: configData['enabled'] ?? true,
          muteDurationMinutes: configData['muteDurationMinutes'] ?? 30,
          adminNotifyList: List<String>.from(configData['adminNotifyList'] ?? []),
          logEnabled: configData['logEnabled'] ?? true,
        );
      }
    }
  }

  void dispose() {
    _alertStream.close();
  }
}

class RiskCheckResult {
  final bool isSafe;
  final List<RiskAlert> alerts;
  final SensitiveLevel? highestLevel;

  RiskCheckResult({
    required this.isSafe,
    required this.alerts,
    this.highestLevel,
  });
}
