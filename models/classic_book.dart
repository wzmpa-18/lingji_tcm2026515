class ClassicBook {
  final String id;
  final String title;
  final String subtitle;
  final String author;
  final String dynasty;
  final BookCategory category;
  final String coverImage;
  final String description;
  final int totalChapters;
  final int totalWords;
  final List<String> tags;
  final List<String> interestTags;
  final bool isPremium;
  final int unlockPrice;
  final int unlockLevel;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClassicBook({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.dynasty,
    required this.category,
    required this.coverImage,
    required this.description,
    required this.totalChapters,
    required this.totalWords,
    required this.tags,
    this.interestTags = const [],
    this.isPremium = false,
    this.unlockPrice = 0,
    this.unlockLevel = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'author': author,
      'dynasty': dynasty,
      'category': category.name,
      'cover_image': coverImage,
      'description': description,
      'total_chapters': totalChapters,
      'total_words': totalWords,
      'tags': tags.join(','),
      'interest_tags': interestTags.join(','),
      'is_premium': isPremium ? 1 : 0,
      'unlock_price': unlockPrice,
      'unlock_level': unlockLevel,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory ClassicBook.fromMap(Map<String, dynamic> map) {
    return ClassicBook(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'] ?? '',
      author: map['author'],
      dynasty: map['dynasty'] ?? '',
      category: BookCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => BookCategory.other,
      ),
      coverImage: map['cover_image'] ?? '',
      description: map['description'] ?? '',
      totalChapters: map['total_chapters'] ?? 0,
      totalWords: map['total_words'] ?? 0,
      tags: (map['tags'] as String?)?.split(',').where((e) => e.isNotEmpty).toList() ?? [],
      interestTags: (map['interest_tags'] as String?)?.split(',').where((e) => e.isNotEmpty).toList() ?? [],
      isPremium: map['is_premium'] == 1,
      unlockPrice: map['unlock_price'] ?? 0,
      unlockLevel: map['unlock_level'] ?? 0,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  ClassicBook copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? author,
    String? dynasty,
    BookCategory? category,
    String? coverImage,
    String? description,
    int? totalChapters,
    int? totalWords,
    List<String>? tags,
    List<String>? interestTags,
    bool? isPremium,
    int? unlockPrice,
    int? unlockLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClassicBook(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      author: author ?? this.author,
      dynasty: dynasty ?? this.dynasty,
      category: category ?? this.category,
      coverImage: coverImage ?? this.coverImage,
      description: description ?? this.description,
      totalChapters: totalChapters ?? this.totalChapters,
      totalWords: totalWords ?? this.totalWords,
      tags: tags ?? this.tags,
      interestTags: interestTags ?? this.interestTags,
      isPremium: isPremium ?? this.isPremium,
      unlockPrice: unlockPrice ?? this.unlockPrice,
      unlockLevel: unlockLevel ?? this.unlockLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum BookCategory {
  tcm,
  daoism,
  buddhism,
  folkMedicine,
  folkReligion,
  wuxing,
  fortune,
  other,
}

extension BookCategoryExtension on BookCategory {
  String get displayName {
    switch (this) {
      case BookCategory.tcm:
        return '中医典籍';
      case BookCategory.daoism:
        return '道家经典';
      case BookCategory.buddhism:
        return '佛家经典';
      case BookCategory.folkMedicine:
        return '民族医药';
      case BookCategory.folkReligion:
        return '民间门派';
      case BookCategory.wuxing:
        return '五运六气';
      case BookCategory.fortune:
        return '命理术数';
      case BookCategory.other:
        return '其他';
    }
  }

  String get icon {
    switch (this) {
      case BookCategory.tcm:
        return '🏥';
      case BookCategory.daoism:
        return '⚪';
      case BookCategory.buddhism:
        return '🔵';
      case BookCategory.folkMedicine:
        return '🌿';
      case BookCategory.folkReligion:
        return '🙏';
      case BookCategory.wuxing:
        return '☀️';
      case BookCategory.fortune:
        return '📜';
      case BookCategory.other:
        return '📚';
    }
  }
}

class BookChapter {
  final String id;
  final String bookId;
  final int chapterNumber;
  final String title;
  final String content;
  final int wordCount;
  final List<Annotation> annotations;
  final List<CharacterAnnotation> characterAnnotations;
  final DateTime createdAt;

  BookChapter({
    required this.id,
    required this.bookId,
    required this.chapterNumber,
    required this.title,
    required this.content,
    required this.wordCount,
    this.annotations = const [],
    this.characterAnnotations = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'book_id': bookId,
      'chapter_number': chapterNumber,
      'title': title,
      'content': content,
      'word_count': wordCount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory BookChapter.fromMap(Map<String, dynamic> map) {
    return BookChapter(
      id: map['id'],
      bookId: map['book_id'],
      chapterNumber: map['chapter_number'] ?? 0,
      title: map['title'],
      content: map['content'],
      wordCount: map['word_count'] ?? 0,
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}

class Annotation {
  final String id;
  final String authorName;
  final String authorTitle;
  final String content;
  final int startPosition;
  final int endPosition;
  final DateTime createdAt;

  Annotation({
    required this.id,
    required this.authorName,
    this.authorTitle = '',
    required this.content,
    required this.startPosition,
    required this.endPosition,
    required this.createdAt,
  });
}

class CharacterAnnotation {
  final String id;
  final String character;
  final String pinyin;
  final String interpretation;
  final String source;
  final int position;

  CharacterAnnotation({
    required this.id,
    required this.character,
    required this.pinyin,
    required this.interpretation,
    this.source = '说文解字',
    required this.position,
  });
}

class UserReadingProgress {
  final String id;
  final String userId;
  final String bookId;
  final String lastReadChapterId;
  final int lastReadChapterNumber;
  final int totalReadingMinutes;
  final List<String> bookmarks;
  final List<String> highlights;
  final int lastReadPosition;
  final DateTime lastReadAt;

  UserReadingProgress({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.lastReadChapterId,
    required this.lastReadChapterNumber,
    this.totalReadingMinutes = 0,
    this.bookmarks = const [],
    this.highlights = const [],
    this.lastReadPosition = 0,
    required this.lastReadAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'book_id': bookId,
      'last_read_chapter_id': lastReadChapterId,
      'last_read_chapter_number': lastReadChapterNumber,
      'total_reading_minutes': totalReadingMinutes,
      'bookmarks': bookmarks.join(','),
      'highlights': highlights.join(','),
      'last_read_position': lastReadPosition,
      'last_read_at': lastReadAt.toIso8601String(),
    };
  }

  factory UserReadingProgress.fromMap(Map<String, dynamic> map) {
    return UserReadingProgress(
      id: map['id'],
      userId: map['user_id'],
      bookId: map['book_id'],
      lastReadChapterId: map['last_read_chapter_id'],
      lastReadChapterNumber: map['last_read_chapter_number'] ?? 0,
      totalReadingMinutes: map['total_reading_minutes'] ?? 0,
      bookmarks: (map['bookmarks'] as String?)?.split(',').where((e) => e.isNotEmpty).toList() ?? [],
      highlights: (map['highlights'] as String?)?.split(',').where((e) => e.isNotEmpty).toList() ?? [],
      lastReadPosition: map['last_read_position'] ?? 0,
      lastReadAt: DateTime.parse(map['last_read_at']),
    );
  }
}
