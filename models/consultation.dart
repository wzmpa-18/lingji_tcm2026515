import 'dart:convert';

class Consultation {
  final String id;
  final String userId;
  final Map<String, dynamic> symptoms;
  final String? tongue;
  final String? pulse;
  final String? diagnosis;
  final Map<String, dynamic>? prescription;
  final String? masterId;
  final DateTime createdAt;
  final bool synced;

  Consultation({
    required this.id,
    required this.userId,
    required this.symptoms,
    this.tongue,
    this.pulse,
    this.diagnosis,
    this.prescription,
    this.masterId,
    required this.createdAt,
    this.synced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'symptoms': jsonEncode(symptoms),
      'tongue': tongue,
      'pulse': pulse,
      'diagnosis': diagnosis,
      'prescription': prescription != null ? jsonEncode(prescription) : null,
      'master_id': masterId,
      'created_at': createdAt.toIso8601String(),
      'synced': synced ? 1 : 0,
    };
  }

  factory Consultation.fromMap(Map<String, dynamic> map) {
    return Consultation(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      symptoms: map['symptoms'] != null ? jsonDecode(map['symptoms']) : {},
      tongue: map['tongue'],
      pulse: map['pulse'],
      diagnosis: map['diagnosis'],
      prescription: map['prescription'] != null ? jsonDecode(map['prescription']) : null,
      masterId: map['master_id'],
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      synced: map['synced'] == 1,
    );
  }
}

class Prescription {
  final String id;
  final String name;
  final String origin;
  final List<Map<String, dynamic>> composition;
  final String indications;
  final String usage;
  final String? contraindications;
  final String masterId;
  final String category;
  final DateTime createdAt;

  Prescription({
    required this.id,
    required this.name,
    required this.origin,
    required this.composition,
    required this.indications,
    required this.usage,
    this.contraindications,
    required this.masterId,
    required this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'origin': origin,
      'composition': jsonEncode(composition),
      'indications': indications,
      'usage': usage,
      'contraindications': contraindications,
      'master_id': masterId,
      'category': category,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Prescription.fromMap(Map<String, dynamic> map) {
    return Prescription(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      origin: map['origin'] ?? '',
      composition: map['composition'] != null ? List<Map<String, dynamic>>.from(jsonDecode(map['composition'])) : [],
      indications: map['indications'] ?? '',
      usage: map['usage'] ?? '',
      contraindications: map['contraindications'],
      masterId: map['master_id'] ?? '',
      category: map['category'] ?? '',
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class Master {
  final String id;
  final String name;
  final String dynasty;
  final String era;
  final String bio;
  final String theory;
  final String features;
  final bool isDefault;

  Master({
    required this.id,
    required this.name,
    required this.dynasty,
    required this.era,
    required this.bio,
    required this.theory,
    required this.features,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dynasty': dynasty,
      'era': era,
      'bio': bio,
      'theory': theory,
      'features': features,
      'is_default': isDefault ? 1 : 0,
    };
  }

  factory Master.fromMap(Map<String, dynamic> map) {
    return Master(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      dynasty: map['dynasty'] ?? '',
      era: map['era'] ?? '',
      bio: map['bio'] ?? '',
      theory: map['theory'] ?? '',
      features: map['features'] ?? '',
      isDefault: map['is_default'] == 1,
    );
  }
}
