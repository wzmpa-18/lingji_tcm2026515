class AcupunctureClassic {
  final String id;
  final String name;
  final String dynasty;
  final String author;
  final String description;
  final String content;
  final String category;

  AcupunctureClassic({
    required this.id,
    required this.name,
    required this.dynasty,
    required this.author,
    required this.description,
    required this.content,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dynasty': dynasty,
      'author': author,
      'description': description,
      'content': content,
      'category': category,
    };
  }

  factory AcupunctureClassic.fromMap(Map<String, dynamic> map) {
    return AcupunctureClassic(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      dynasty: map['dynasty'] ?? '',
      author: map['author'] ?? '',
      description: map['description'] ?? '',
      content: map['content'] ?? '',
      category: map['category'] ?? '',
    );
  }
}

class AcupunctureSchool {
  final String id;
  final String name;
  final String description;
  final String theory;
  final List<String> features;
  final List<String> keyPoints;
  final List<String> techniques;

  AcupunctureSchool({
    required this.id,
    required this.name,
    required this.description,
    required this.theory,
    required this.features,
    required this.keyPoints,
    required this.techniques,
  });
}

class Zibufaluzhu {
  final String hour;
  final String meridian;
  final String acupoint;
  final String function;
  final String indication;

  Zibufaluzhu({
    required this.hour,
    required this.meridian,
    required this.acupoint,
    required this.function,
    required this.indication,
  });
}

class BodyLayer {
  final String id;
  final String name;
  final String description;
  final Map<String, dynamic> positions;
  final List<String> meridians;
  final List<String> acupoints;

  BodyLayer({
    required this.id,
    required this.name,
    required this.description,
    required this.positions,
    required this.meridians,
    required this.acupoints,
  });
}

class BoneMeasurement {
  final String name;
  final String location;
  final String measurement;
  final String application;

  BoneMeasurement({
    required this.name,
    required this.location,
    required this.measurement,
    required this.application,
  });
}

class AcupointDetail {
  final String id;
  final String name;
  final String nameEn;
  final String meridian;
  final String location;
  final String methods;
  final String indication;
  final String technique;
  final String moxibustion;
  final String contraindication;
  final String mnemonic;
  final Map<String, String> schoolPositions;
  final String anatomical;

  AcupointDetail({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.meridian,
    required this.location,
    required this.methods,
    required this.indication,
    required this.technique,
    required this.moxibustion,
    required this.contraindication,
    required this.mnemonic,
    this.schoolPositions = const {},
    this.anatomical = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'meridian': meridian,
      'location': location,
      'methods': methods,
      'indication': indication,
      'technique': technique,
      'moxibustion': moxibustion,
      'contraindication': contraindication,
      'mnemonic': mnemonic,
      'school_positions': schoolPositions.entries.map((e) => '${e.key}:${e.value}').join(';'),
      'anatomical': anatomical,
    };
  }
}

class AIZuoxue {
  final String disease;
  final String symptom;
  final String meridian;
  final List<String> mainPoints;
  final List<String> secondaryPoints;
  final List<String> adjunctPoints;
  final String principle;
  final String explanation;

  AIZuoxue({
    required this.disease,
    required this.symptom,
    required this.meridian,
    required this.mainPoints,
    required this.secondaryPoints,
    required this.adjunctPoints,
    required this.principle,
    required this.explanation,
  });
}
