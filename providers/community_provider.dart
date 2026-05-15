import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/community.dart';
import '../services/database_service.dart';

class CommunityProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  
  List<Community> _communities = [];
  List<Message> _messages = [];
  String? _currentCommunityId;

  List<Community> get communities => _communities;
  List<Message> get messages => _messages;
  String? get currentCommunityId => _currentCommunityId;

  Future<void> loadCommunities() async {
    _communities = await _dbService.getCommunities();
    notifyListeners();
  }

  Future<void> createCommunity({
    required String name,
    required String description,
    required String ownerId,
  }) async {
    final community = Community(
      id: const Uuid().v4(),
      name: name,
      description: description,
      ownerId: ownerId,
      createdAt: DateTime.now(),
    );
    await _dbService.insertCommunity(community);
    _communities.insert(0, community);
    notifyListeners();
  }

  Future<void> loadMessages(String communityId) async {
    _currentCommunityId = communityId;
    _messages = await _dbService.getMessages(communityId);
    notifyListeners();
  }

  Future<void> sendMessage({
    required String communityId,
    required String senderId,
    required String senderName,
    required String content,
    String type = 'text',
  }) async {
    final message = Message(
      id: const Uuid().v4(),
      communityId: communityId,
      senderId: senderId,
      senderName: senderName,
      content: content,
      type: type,
      createdAt: DateTime.now(),
    );
    await _dbService.insertMessage(message);
    _messages.add(message);
    notifyListeners();
  }
}
