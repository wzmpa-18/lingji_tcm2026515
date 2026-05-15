class Feedback {
  final String id;
  final String userId;
  final String type;
  final String content;
  final List<String>? images;
  final String status;
  final String? reply;
  final DateTime createdAt;

  Feedback({
    required this.id,
    required this.userId,
    required this.type,
    required this.content,
    this.images,
    this.status = 'pending',
    this.reply,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'content': content,
      'images': images?.join(','),
      'status': status,
      'reply': reply,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Feedback.fromMap(Map<String, dynamic> map) {
    return Feedback(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      type: map['type'] ?? '',
      content: map['content'] ?? '',
      images: map['images'] != null ? (map['images'] as String).split(',') : null,
      status: map['status'] ?? 'pending',
      reply: map['reply'],
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
