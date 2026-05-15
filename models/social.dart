class Friend {
  final String id;
  final String userId;
  final String friendId;
  final String friendName;
  final String? friendAvatar;
  final FriendStatus status;
  final DateTime createdAt;
  final DateTime? lastChatAt;
  final bool isBlocked;

  Friend({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.friendName,
    this.friendAvatar,
    this.status = FriendStatus.pending,
    required this.createdAt,
    this.lastChatAt,
    this.isBlocked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'friend_id': friendId,
      'friend_name': friendName,
      'friend_avatar': friendAvatar,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'last_chat_at': lastChatAt?.toIso8601String(),
      'is_blocked': isBlocked ? 1 : 0,
    };
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      friendId: map['friend_id'] ?? '',
      friendName: map['friend_name'] ?? '',
      friendAvatar: map['friend_avatar'],
      status: FriendStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => FriendStatus.pending,
      ),
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      lastChatAt: map['last_chat_at'] != null ? DateTime.parse(map['last_chat_at']) : null,
      isBlocked: map['is_blocked'] == 1,
    );
  }
}

enum FriendStatus {
  pending,
  accepted,
  blocked,
}

class Group {
  final String id;
  final String name;
  final String? description;
  final String? avatar;
  final String ownerId;
  final String ownerName;
  final GroupType type;
  final int memberCount;
  final int maxMembers;
  final DateTime createdAt;
  final bool isPublic;
  final List<String> adminIds;
  final bool allowMemberInvite;
  final bool allowMemberPost;

  Group({
    required this.id,
    required this.name,
    this.description,
    this.avatar,
    required this.ownerId,
    required this.ownerName,
    this.type = GroupType.general,
    this.memberCount = 1,
    this.maxMembers = 500,
    required this.createdAt,
    this.isPublic = true,
    this.adminIds = const [],
    this.allowMemberInvite = true,
    this.allowMemberPost = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avatar': avatar,
      'owner_id': ownerId,
      'owner_name': ownerName,
      'type': type.name,
      'member_count': memberCount,
      'max_members': maxMembers,
      'created_at': createdAt.toIso8601String(),
      'is_public': isPublic ? 1 : 0,
      'admin_ids': adminIds.join(','),
      'allow_member_invite': allowMemberInvite ? 1 : 0,
      'allow_member_post': allowMemberPost ? 1 : 0,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      avatar: map['avatar'],
      ownerId: map['owner_id'] ?? '',
      ownerName: map['owner_name'] ?? '',
      type: GroupType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => GroupType.general,
      ),
      memberCount: map['member_count'] ?? 1,
      maxMembers: map['max_members'] ?? 500,
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      isPublic: map['is_public'] == 1,
      adminIds: (map['admin_ids'] as String?)?.split(',').where((s) => s.isNotEmpty).toList() ?? [],
      allowMemberInvite: map['allow_member_invite'] == 1,
      allowMemberPost: map['allow_member_post'] == 1,
    );
  }
}

enum GroupType {
  general,
  tcm,
  mingli,
  health,
  social,
  official,
}

extension GroupTypeExtension on GroupType {
  String get displayName {
    switch (this) {
      case GroupType.general:
        return '综合群';
      case GroupType.tcm:
        return '中医交流群';
      case GroupType.mingli:
        return '命理研究群';
      case GroupType.health:
        return '养生保健群';
      case GroupType.social:
        return '社交群';
      case GroupType.official:
        return '官方群';
    }
  }
}

class GroupMember {
  final String id;
  final String groupId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final GroupMemberRole role;
  final DateTime joinedAt;
  final bool isMuted;
  final DateTime? muteUntil;

  GroupMember({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    this.role = GroupMemberRole.member,
    required this.joinedAt,
    this.isMuted = false,
    this.muteUntil,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'group_id': groupId,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'role': role.name,
      'joined_at': joinedAt.toIso8601String(),
      'is_muted': isMuted ? 1 : 0,
      'mute_until': muteUntil?.toIso8601String(),
    };
  }

  factory GroupMember.fromMap(Map<String, dynamic> map) {
    return GroupMember(
      id: map['id'] ?? '',
      groupId: map['group_id'] ?? '',
      userId: map['user_id'] ?? '',
      userName: map['user_name'] ?? '',
      userAvatar: map['user_avatar'],
      role: GroupMemberRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => GroupMemberRole.member,
      ),
      joinedAt: DateTime.parse(map['joined_at'] ?? DateTime.now().toIso8601String()),
      isMuted: map['is_muted'] == 1,
      muteUntil: map['mute_until'] != null ? DateTime.parse(map['mute_until']) : null,
    );
  }
}

enum GroupMemberRole {
  owner,
  admin,
  member,
}

extension GroupMemberRoleExtension on GroupMemberRole {
  String get displayName {
    switch (this) {
      case GroupMemberRole.owner:
        return '群主';
      case GroupMemberRole.admin:
        return '管理员';
      case GroupMemberRole.member:
        return '成员';
    }
  }

  bool get canManage {
    return this == GroupMemberRole.owner || this == GroupMemberRole.admin;
  }

  bool get canMute {
    return this == GroupMemberRole.owner || this == GroupMemberRole.admin;
  }

  bool get canRemoveMember {
    return this == GroupMemberRole.owner;
  }

  bool get canEditGroup {
    return this == GroupMemberRole.owner;
  }
}

class PrivateChat {
  final String id;
  final String userId1;
  final String userId2;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final DateTime createdAt;

  PrivateChat({
    required this.id,
    required this.userId1,
    required this.userId2,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id_1': userId1,
      'user_id_2': userId2,
      'last_message': lastMessage,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'unread_count': unreadCount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory PrivateChat.fromMap(Map<String, dynamic> map) {
    return PrivateChat(
      id: map['id'] ?? '',
      userId1: map['user_id_1'] ?? '',
      userId2: map['user_id_2'] ?? '',
      lastMessage: map['last_message'],
      lastMessageAt: map['last_message_at'] != null ? DateTime.parse(map['last_message_at']) : null,
      unreadCount: map['unread_count'] ?? 0,
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String content;
  final MessageType type;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isRead;
  final int? tipAmount;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.content,
    this.type = MessageType.text,
    this.imageUrl,
    required this.createdAt,
    this.isRead = false,
    this.tipAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'sender_name': senderName,
      'content': content,
      'type': type.name,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead ? 1 : 0,
      'tip_amount': tipAmount,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      chatId: map['chat_id'] ?? '',
      senderId: map['sender_id'] ?? '',
      senderName: map['sender_name'] ?? '',
      content: map['content'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => MessageType.text,
      ),
      imageUrl: map['image_url'],
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      isRead: map['is_read'] == 1,
      tipAmount: map['tip_amount'],
    );
  }
}

enum MessageType {
  text,
  image,
  tip,
  system,
  question,
}

extension MessageTypeExtension on MessageType {
  String get displayName {
    switch (this) {
      case MessageType.text:
        return '文本';
      case MessageType.image:
        return '图片';
      case MessageType.tip:
        return '打赏';
      case MessageType.system:
        return '系统';
      case MessageType.question:
        return '付费问题';
    }
  }
}

class Question {
  final String id;
  final String questionerId;
  final String questionerName;
  final String content;
  final int price;
  final List<String> images;
  final QuestionStatus status;
  final String? answer;
  final String? answererId;
  final String? answererName;
  final int? tipAmount;
  final DateTime createdAt;
  final DateTime? answeredAt;
  final DateTime? expiresAt;

  Question({
    required this.id,
    required this.questionerId,
    required this.questionerName,
    required this.content,
    this.price = 0,
    this.images = const [],
    this.status = QuestionStatus.open,
    this.answer,
    this.answererId,
    this.answererName,
    this.tipAmount,
    required this.createdAt,
    this.answeredAt,
    this.expiresAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questioner_id': questionerId,
      'questioner_name': questionerName,
      'content': content,
      'price': price,
      'images': images.join(','),
      'status': status.name,
      'answer': answer,
      'answerer_id': answererId,
      'answerer_name': answererName,
      'tip_amount': tipAmount,
      'created_at': createdAt.toIso8601String(),
      'answered_at': answeredAt?.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] ?? '',
      questionerId: map['questioner_id'] ?? '',
      questionerName: map['questioner_name'] ?? '',
      content: map['content'] ?? '',
      price: map['price'] ?? 0,
      images: (map['images'] as String?)?.split(',').where((s) => s.isNotEmpty).toList() ?? [],
      status: QuestionStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => QuestionStatus.open,
      ),
      answer: map['answer'],
      answererId: map['answerer_id'],
      answererName: map['answerer_name'],
      tipAmount: map['tip_amount'],
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      answeredAt: map['answered_at'] != null ? DateTime.parse(map['answered_at']) : null,
      expiresAt: map['expires_at'] != null ? DateTime.parse(map['expires_at']) : null,
    );
  }
}

enum QuestionStatus {
  open,
  answered,
  expired,
  closed,
}

extension QuestionStatusExtension on QuestionStatus {
  String get displayName {
    switch (this) {
      case QuestionStatus.open:
        return '待回答';
      case QuestionStatus.answered:
        return '已回答';
      case QuestionStatus.expired:
        return '已过期';
      case QuestionStatus.closed:
        return '已关闭';
    }
  }
}
