class BoneSettingTechnique {
  final String id;
  final String name;
  final String origin;
  final BoneSettingSchool school;
  final String principle;
  final String features;
  final List<String> applicableConditions;
  final List<String> contraindications;
  final List<BoneSettingStep> steps;
  final List<String> techniqueImages;
  final List<String> videoUrls;
  final String history;
  final String founder;
  final DateTime createdAt;

  BoneSettingTechnique({
    required this.id,
    required this.name,
    required this.origin,
    required this.school,
    required this.principle,
    required this.features,
    required this.applicableConditions,
    required this.contraindications,
    required this.steps,
    required this.techniqueImages,
    required this.videoUrls,
    required this.history,
    required this.founder,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'origin': origin,
      'school': school.name,
      'principle': principle,
      'features': features,
      'applicable_conditions': applicableConditions.join(','),
      'contraindications': contraindications.join(','),
      'steps': steps.map((s) => s.toMap()).toList(),
      'technique_images': techniqueImages.join(','),
      'video_urls': videoUrls.join(','),
      'history': history,
      'founder': founder,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

enum BoneSettingSchool {
  rong Tian,
  megnet,
  painRelief,
  folkTradition,
  美式正骨,
  龙氏正骨,
  罗氏正骨,
  柔性正骨,
  民间传统正骨,
}

extension BoneSettingSchoolExtension on BoneSettingSchool {
  String get displayName {
    switch (this) {
      case BoneSettingSchool.柔性正骨:
        return '柔性正骨';
      case BoneSettingSchool.美式正骨:
        return '美式正骨';
      case BoneSettingSchool.龙氏正骨:
        return '龙氏正骨';
      case BoneSettingSchool.罗氏正骨:
        return '罗氏正骨';
      case BoneSettingSchool.民间传统正骨:
        return '民间传统正骨';
      case BoneSettingSchool.rong Tian:
        return '柔性正骨';
      case BoneSettingSchool.megnet:
        return '美式正骨';
      case BoneSettingSchool.painRelief:
        return '龙氏正骨';
      case BoneSettingSchool.folkTradition:
        return '罗氏正骨';
    }
  }

  String get icon {
    switch (this) {
      case BoneSettingSchool.柔性正骨:
        return '🧘';
      case BoneSettingSchool.美式正骨:
        return '🇺🇸';
      case BoneSettingSchool.龙氏正骨:
        return '🐉';
      case BoneSettingSchool.罗氏正骨:
        return '🦴';
      case BoneSettingSchool.民间传统正骨:
        return '🏮';
      default:
        return '💆';
    }
  }

  String get description {
    switch (this) {
      case BoneSettingSchool.柔性正骨:
        return '以柔和手法为主，强调无痛操作，适合各类人群';
      case BoneSettingSchool.美式正骨:
        return '源自美国脊骨神经医学，强调脊柱整体调理';
      case BoneSettingSchool.龙氏正骨:
        return '广州龙层花创立，擅长脊椎相关疾病';
      case BoneSettingSchool.罗氏正骨:
        return '北京罗有名创立，以稳准轻巧著称';
      case BoneSettingSchool.民间传统正骨:
        return '民间传承技法，博大精深，各具特色';
      default:
        return '';
    }
  }
}

class BoneSettingStep {
  final int stepNumber;
  final String title;
  final String description;
  final String keyPoint;
  final List<String> techniques;
  final String caution;
  final List<String> images;
  final int durationSeconds;

  BoneSettingStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.keyPoint,
    required this.techniques,
    required this.caution,
    required this.images,
    required this.durationSeconds,
  });

  Map<String, dynamic> toMap() {
    return {
      'step_number': stepNumber,
      'title': title,
      'description': description,
      'key_point': keyPoint,
      'techniques': techniques.join(','),
      'caution': caution,
      'images': images.join(','),
      'duration_seconds': durationSeconds,
    };
  }
}

class MassageTechnique {
  final String id;
  final String name;
  final MassageType type;
  final String description;
  final List<String> applicableConditions;
  final List<String> contraindications;
  final List<MassageStep> steps;
  final List<String> techniqueImages;
  final int duration;
  final String difficulty;
  final DateTime createdAt;

  MassageTechnique({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.applicableConditions,
    required this.contraindications,
    required this.steps,
    required this.techniqueImages,
    required this.duration,
    required this.difficulty,
    required this.createdAt,
  });
}

enum MassageType {
  tuina,
  anmo,
  acupressure,
  reflexology,
  aromatherapy,
  hotStone,
  guaSha,
  cupping,
}

extension MassageTypeExtension on MassageType {
  String get displayName {
    switch (this) {
      case MassageType.tuina:
        return '推拿';
      case MassageType.anmo:
        return '按摩';
      case MassageType.acupressure:
        return '指压';
      case MassageType.reflexology:
        return '足底反射';
      case MassageType.aromatherapy:
        return '芳香疗法';
      case MassageType.hotStone:
        return '热石疗法';
      case MassageType.guaSha:
        return '刮痧';
      case MassageType.cupping:
        return '拔罐';
    }
  }

  String get icon {
    switch (this) {
      case MassageType.tuina:
        return '🖐️';
      case MassageType.anmo:
        return '💆';
      case MassageType.acupressure:
        return '👆';
      case MassageType.reflexology:
        return '🦶';
      case MassageType.aromatherapy:
        return '🌸';
      case MassageType.hotStone:
        return '🔥';
      case MassageType.guaSha:
        return '💨';
      case MassageType.cupping:
        return '🏺';
    }
  }
}

class MassageStep {
  final int stepNumber;
  final String title;
  final String description;
  final String technique;
  final String pressure;
  final int duration;
  final List<String> images;
  final String tip;

  MassageStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.technique,
    required this.pressure,
    required this.duration,
    required this.images,
    required this.tip,
  });
}

class BoneSettingBook {
  final String id;
  final String title;
  final String author;
  final String dynasty;
  final String description;
  final String category;
  final String coverImage;
  final List<String> chapters;
  final int wordCount;
  final bool isPremium;
  final int unlockPrice;
  final List<String> tags;
  final DateTime createdAt;

  BoneSettingBook({
    required this.id,
    required this.title,
    required this.author,
    required this.dynasty,
    required this.description,
    required this.category,
    required this.coverImage,
    required this.chapters,
    required this.wordCount,
    this.isPremium = false,
    this.unlockPrice = 0,
    this.tags = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'dynasty': dynasty,
      'description': description,
      'category': category,
      'cover_image': coverImage,
      'chapters': chapters.join(','),
      'word_count': wordCount,
      'is_premium': isPremium ? 1 : 0,
      'unlock_price': unlockPrice,
      'tags': tags.join(','),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory BoneSettingBook.fromMap(Map<String, dynamic> map) {
    return BoneSettingBook(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      dynasty: map['dynasty'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      coverImage: map['cover_image'] ?? '',
      chapters: (map['chapters'] as String?)?.split(',').where((e) => e.isNotEmpty).toList() ?? [],
      wordCount: map['word_count'] ?? 0,
      isPremium: map['is_premium'] == 1,
      unlockPrice: map['unlock_price'] ?? 0,
      tags: (map['tags'] as String?)?.split(',').where((e) => e.isNotEmpty).toList() ?? [],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}

class BoneSettingCategory {
  static const String all = '全部';
  static const String boneSetting = '正骨';
  static const String massage = '推拿按摩';
  static const String tuina = '推拿';
  static const String anmo = '按摩';
  static const String guasha = '刮痧';
  static const String cupping = '拔罐';
  static const String folk = '民间技法';

  static List<String> get allCategories => [
    all,
    boneSetting,
    massage,
    tuina,
    anmo,
    guasha,
    cupping,
    folk,
  ];
}
