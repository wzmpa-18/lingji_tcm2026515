import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

enum MessageType {
  text,
  image,
  file,
  system,
}

enum MessageStorage {
  local,
  cloud,
}

class ChatStorageConfig {
  static const int defaultImageRetentionDays = 7;
  static const int maxImageSizeKB = 5000;
  static const String cloudStoragePath = '/api/chat/media/';
}

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String? groupId;
  final MessageType type;
  final String content;
  final String? mediaUrl;
  final DateTime timestamp;
  final bool isRead;
  final MessageStorage storage;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.groupId,
    required this.type,
    required this.content,
    this.mediaUrl,
    required this.timestamp,
    this.isRead = false,
    this.storage = MessageStorage.local,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'groupId': groupId,
      'type': type.name,
      'content': content,
      'mediaUrl': mediaUrl,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead ? 1 : 0,
      'storage': storage.name,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      groupId: json['groupId'],
      type: MessageType.values.firstWhere((e) => e.name == json['type']),
      content: json['content'],
      mediaUrl: json['mediaUrl'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] == 1,
      storage: MessageStorage.values.firstWhere(
        (e) => e.name == json['storage'],
        orElse: () => MessageStorage.local,
      ),
    );
  }
}

class ChatStorageService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  Database? _localDb;
  String? _localPath;

  Future<void> initialize() async {
    if (kIsWeb) return;

    final directory = await getApplicationDocumentsDirectory();
    _localPath = '${directory.path}/chat_data';

    if (!kIsWeb) {
      final dir = Directory(_localPath!);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      _localDb = await openDatabase(
        '$_localPath/chat.db',
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE private_messages (
              id TEXT PRIMARY KEY,
              senderId TEXT NOT NULL,
              receiverId TEXT NOT NULL,
              type TEXT NOT NULL,
              content TEXT NOT NULL,
              mediaUrl TEXT,
              timestamp TEXT NOT NULL,
              isRead INTEGER DEFAULT 0,
              storage TEXT DEFAULT 'local'
            )
          ''');

          await db.execute('''
            CREATE TABLE group_messages (
              id TEXT PRIMARY KEY,
              groupId TEXT NOT NULL,
              senderId TEXT NOT NULL,
              type TEXT NOT NULL,
              content TEXT NOT NULL,
              mediaUrl TEXT,
              timestamp TEXT NOT NULL,
              isRead INTEGER DEFAULT 0,
              storage TEXT DEFAULT 'local'
            )
          ''');

          await db.execute('''
            CREATE TABLE media_cache (
              id TEXT PRIMARY KEY,
              localPath TEXT,
              cloudUrl TEXT,
              sizeKB INTEGER,
              createdAt TEXT NOT NULL,
              expiresAt TEXT,
              type TEXT NOT NULL
            )
          ''');

          await db.execute('''
            CREATE INDEX idx_private_messages_time ON private_messages(timestamp)
          ''');

          await db.execute('''
            CREATE INDEX idx_group_messages_time ON group_messages(timestamp)
          ''');
        },
      );
    }
  }

  Future<void> savePrivateMessage(ChatMessage message) async {
    if (_localDb == null || kIsWeb) return;

    await _localDb!.insert(
      'private_messages',
      {
        ...message.toJson(),
        'storage': MessageStorage.local.name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> saveGroupMessage(ChatMessage message) async {
    if (_localDb == null || kIsWeb) return;

    await _localDb!.insert(
      'group_messages',
      {
        ...message.toJson(),
        'storage': MessageStorage.local.name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ChatMessage>> getPrivateMessages(
    String userId,
    String friendId, {
    int limit = 50,
    int offset = 0,
  }) async {
    if (_localDb == null || kIsWeb) return [];

    final List<Map<String, dynamic>> results = await _localDb!.rawQuery('''
      SELECT * FROM private_messages
      WHERE (senderId = ? AND receiverId = ?)
         OR (senderId = ? AND receiverId = ?)
      ORDER BY timestamp DESC
      LIMIT ? OFFSET ?
    ''', [userId, friendId, friendId, userId, limit, offset]);

    return results.map((json) => ChatMessage.fromJson(json)).toList();
  }

  Future<List<ChatMessage>> getGroupMessages(
    String groupId, {
    int limit = 50,
    int offset = 0,
  }) async {
    if (_localDb == null || kIsWeb) return [];

    final List<Map<String, dynamic>> results = await _localDb!.rawQuery('''
      SELECT * FROM group_messages
      WHERE groupId = ?
      ORDER BY timestamp DESC
      LIMIT ? OFFSET ?
    ''', [groupId, limit, offset]);

    return results.map((json) => ChatMessage.fromJson(json)).toList();
  }

  Future<void> markAsRead(String messageId) async {
    if (_localDb == null || kIsWeb) return;

    await _localDb!.update(
      'private_messages',
      {'isRead': 1},
      where: 'id = ?',
      whereArgs: [messageId],
    );
  }

  Future<int> getUnreadCount(String userId) async {
    if (_localDb == null || kIsWeb) return 0;

    final result = await _localDb!.rawQuery('''
      SELECT COUNT(*) as count FROM private_messages
      WHERE receiverId = ? AND isRead = 0
    ''', [userId]);

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> cleanExpiredMedia({int retentionDays = 7}) async {
    if (_localDb == null || kIsWeb) return;

    final cutoffDate = DateTime.now().subtract(Duration(days: retentionDays));

    final expiredMedia = await _localDb!.query(
      'media_cache',
      where: 'expiresAt < ?',
      whereArgs: [cutoffDate.toIso8601String()],
    );

    for (final media in expiredMedia) {
      final localPath = media['localPath'] as String?;
      if (localPath != null && !kIsWeb) {
        final file = File(localPath);
        if (await file.exists()) {
          await file.delete();
        }
      }
    }

    await _localDb!.delete(
      'media_cache',
      where: 'expiresAt < ?',
      whereArgs: [cutoffDate.toIso8601String()],
    );
  }

  Future<int> getCacheSize() async {
    if (_localDb == null || _localPath == null || kIsWeb) return 0;

    int totalSize = 0;
    final dir = Directory(_localPath!);

    if (await dir.exists()) {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
    }

    return totalSize ~/ 1024;
  }

  Future<void> clearCache() async {
    if (_localDb == null || _localPath == null || kIsWeb) return;

    final dir = Directory(_localPath!);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
      await dir.create(recursive: true);
    }

    await _localDb!.delete('media_cache');
  }

  Future<void> close() async {
    await _localDb?.close();
    _localDb = null;
  }
}

class ChatService {
}
