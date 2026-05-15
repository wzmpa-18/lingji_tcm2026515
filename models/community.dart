class Community {
  final String id;
  final String name;
  final String description;
  final String? avatar;
  final int memberCount;
  final String ownerId;
  final DateTime createdAt;

  Community({
    required this.id,
    required this.name,
    required this.description,
    this.avatar,
    this.memberCount = 0,
    required this.ownerId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avatar': avatar,
      'member_count': memberCount,
      'owner_id': ownerId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      avatar: map['avatar'],
      memberCount: map['member_count'] ?? 0,
      ownerId: map['owner_id'] ?? '',
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class Message {
  final String id;
  final String communityId;
  final String senderId;
  final String senderName;
  final String content;
  final String type;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.communityId,
    required this.senderId,
    required this.senderName,
    required this.content,
    this.type = 'text',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'community_id': communityId,
      'sender_id': senderId,
      'sender_name': senderName,
      'content': content,
      'type': type,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      communityId: map['community_id'] ?? '',
      senderId: map['sender_id'] ?? '',
      senderName: map['sender_name'] ?? '',
      content: map['content'] ?? '',
      type: map['type'] ?? 'text',
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
