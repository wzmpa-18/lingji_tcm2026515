import 'package:uuid/uuid.dart';

enum RecordType {
  health,
  tcm,
  acupuncture,
  fortune,
  fengshui,
  pediatric,
  masterAppointment,
}

extension RecordTypeExtension on RecordType {
  String get name {
    switch (this) {
      case RecordType.health:
        return '健康記錄';
      case RecordType.tcm:
        return '中醫調理';
      case RecordType.acupuncture:
        return '針灸記錄';
      case RecordType.fortune:
        return '命理測算';
      case RecordType.fengshui:
        return '風水記錄';
      case RecordType.pediatric:
        return '育兒記錄';
      case RecordType.masterAppointment:
        return '師傅預約';
    }
  }

  String get icon {
    switch (this) {
      case RecordType.health:
        return '🏥';
      case RecordType.tcm:
        return '🌿';
      case RecordType.acupuncture:
        return '💉';
      case RecordType.fortune:
        return '🔮';
      case RecordType.fengshui:
        return '🏠';
      case RecordType.pediatric:
        return '👶';
      case RecordType.masterAppointment:
        return '👨‍🏫';
    }
  }
}

class UserRecord {
  final String id;
  final String userId;
  final RecordType type;
  final String title;
  final String? subtitle;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> data;
  final List<String> tags;
  final bool isFavorite;
  final String? summary;

  const UserRecord({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    this.subtitle,
    required this.createdAt,
    required this.updatedAt,
    required this.data,
    this.tags = const [],
    this.isFavorite = false,
    this.summary,
  });

  UserRecord copyWith({
    String? id,
    String? userId,
    RecordType? type,
    String? title,
    String? subtitle,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? data,
    List<String>? tags,
    bool? isFavorite,
    String? summary,
  }) {
    return UserRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      data: data ?? this.data,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      summary: summary ?? this.summary,
    );
  }
}

class HealthRecord {
  final String id;
  final String userId;
  final DateTime recordDate;
  final double? height;
  final double? weight;
  final String? bloodPressure;
  final String? bloodSugar;
  final String? tongueImage;
  final String? tongueDescription;
  final String? pulseDescription;
  final String? symptoms;
  final String? diagnosis;
  final String? prescription;
  final List<String> attachments;
  final String? doctorNote;

  const HealthRecord({
    required this.id,
    required this.userId,
    required this.recordDate,
    this.height,
    this.weight,
    this.bloodPressure,
    this.bloodSugar,
    this.tongueImage,
    this.tongueDescription,
    this.pulseDescription,
    this.symptoms,
    this.diagnosis,
    this.prescription,
    this.attachments = const [],
    this.doctorNote,
  });
}

class AcupunctureRecord {
  final String id;
  final String userId;
  final DateTime treatmentDate;
  final String diagnosis;
  final List<String> acupoints;
  final String? technique;
  final int? duration;
  final String? response;
  final String? note;
  final String? prescription;

  const AcupunctureRecord({
    required this.id,
    required this.userId,
    required this.treatmentDate,
    required this.diagnosis,
    required this.acupoints,
    this.technique,
    this.duration,
    this.response,
    this.note,
    this.prescription,
  });
}

class FortuneRecord {
  final String id;
  final String userId;
  final DateTime recordDate;
  final String fortuneType;
  final String? birthDate;
  final Map<String, dynamic> result;
  final String? simpleReport;
  final String? premiumReport;
  final bool isPremium;

  const FortuneRecord({
    required this.id,
    required this.userId,
    required this.recordDate,
    required this.fortuneType,
    this.birthDate,
    required this.result,
    this.simpleReport,
    this.premiumReport,
    this.isPremium = false,
  });
}

class FengShuiRecord {
  final String id;
  final String userId;
  final DateTime recordDate;
  final String propertyType;
  final String? address;
  final Map<String, dynamic> analysis;
  final String? report;
  final bool isPremium;

  const FengShuiRecord({
    required this.id,
    required this.userId,
    required this.recordDate,
    required this.propertyType,
    this.address,
    required this.analysis,
    this.report,
    this.isPremium = false,
  });
}

class PediatricRecord {
  final String id;
  final String userId;
  final String childName;
  final int? childAge;
  final DateTime recordDate;
  final String condition;
  final List<String> massageTechniques;
  final String? diagnosis;
  final String? nursingAdvice;
  final String? note;

  const PediatricRecord({
    required this.id,
    required this.userId,
    required this.childName,
    this.childAge,
    required this.recordDate,
    required this.condition,
    required this.massageTechniques,
    this.diagnosis,
    this.nursingAdvice,
    this.note,
  });
}

class UnifiedArchiveService {
  static final UnifiedArchiveService _instance = UnifiedArchiveService._internal();
  factory UnifiedArchiveService() => _instance;
  UnifiedArchiveService._internal();

  List<UserRecord> _records = [];

  Future<void> init(String userId) async {
    _records = await _loadRecords(userId);
  }

  Future<List<UserRecord>> _loadRecords(String userId) async {
    return [];
  }

  Future<void> _saveRecords() async {
  }

  Future<UserRecord> addRecord({
    required String userId,
    required RecordType type,
    required String title,
    String? subtitle,
    required Map<String, dynamic> data,
    List<String> tags = const [],
    String? summary,
  }) async {
    final record = UserRecord(
      id: const Uuid().v4(),
      userId: userId,
      type: type,
      title: title,
      subtitle: subtitle,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      data: data,
      tags: tags,
      summary: summary,
    );

    _records.insert(0, record);
    await _saveRecords();
    return record;
  }

  Future<List<UserRecord>> getRecordsByType(String userId, RecordType type) async {
    return _records.where((r) => r.userId == userId && r.type == type).toList();
  }

  Future<List<UserRecord>> getRecordsByDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    return _records.where((r) =>
      r.userId == userId &&
      r.createdAt.isAfter(start) &&
      r.createdAt.isBefore(end)
    ).toList();
  }

  Future<List<UserRecord>> searchRecords(String userId, String query) async {
    final lowerQuery = query.toLowerCase();
    return _records.where((r) =>
      r.userId == userId &&
      (r.title.toLowerCase().contains(lowerQuery) ||
       (r.subtitle?.toLowerCase().contains(lowerQuery) ?? false) ||
       r.tags.any((t) => t.toLowerCase().contains(lowerQuery)) ||
       (r.summary?.toLowerCase().contains(lowerQuery) ?? false))
    ).toList();
  }

  Future<UserRecord> updateRecord(UserRecord record) async {
    final index = _records.indexWhere((r) => r.id == record.id);
    if (index >= 0) {
      _records[index] = record.copyWith(updatedAt: DateTime.now());
      await _saveRecords();
      return _records[index];
    }
    throw Exception('Record not found');
  }

  Future<void> deleteRecord(String recordId) async {
    _records.removeWhere((r) => r.id == recordId);
    await _saveRecords();
  }

  Future<void> toggleFavorite(String recordId) async {
    final index = _records.indexWhere((r) => r.id == recordId);
    if (index >= 0) {
      _records[index] = _records[index].copyWith(
        isFavorite: !_records[index].isFavorite,
        updatedAt: DateTime.now(),
      );
      await _saveRecords();
    }
  }

  Future<List<UserRecord>> getFavoriteRecords(String userId) async {
    return _records.where((r) => r.userId == userId && r.isFavorite).toList();
  }

  Future<List<UserRecord>> getRecentRecords(String userId, {int limit = 10}) async {
    final userRecords = _records.where((r) => r.userId == userId).toList();
    userRecords.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return userRecords.take(limit).toList();
  }

  Map<RecordType, int> getRecordCounts(String userId) {
    final userRecords = _records.where((r) => r.userId == userId);
    final counts = <RecordType, int>{};
    for (final type in RecordType.values) {
      counts[type] = userRecords.where((r) => r.type == type).length;
    }
    return counts;
  }

  Future<UserRecord> addHealthRecord({
    required String userId,
    required DateTime recordDate,
    double? height,
    double? weight,
    String? bloodPressure,
    String? bloodSugar,
    String? tongueImage,
    String? tongueDescription,
    String? pulseDescription,
    String? symptoms,
    String? diagnosis,
    String? prescription,
    List<String> attachments = const [],
    String? doctorNote,
  }) async {
    final healthRecord = HealthRecord(
      id: const Uuid().v4(),
      userId: userId,
      recordDate: recordDate,
      height: height,
      weight: weight,
      bloodPressure: bloodPressure,
      bloodSugar: bloodSugar,
      tongueImage: tongueImage,
      tongueDescription: tongueDescription,
      pulseDescription: pulseDescription,
      symptoms: symptoms,
      diagnosis: diagnosis,
      prescription: prescription,
      attachments: attachments,
      doctorNote: doctorNote,
    );

    return addRecord(
      userId: userId,
      type: RecordType.health,
      title: '健康記錄 ${recordDate.month}/${recordDate.day}',
      subtitle: [height != null ? '身高$height' : null, weight != null ? '體重$weight' : null]
        .whereType<String>().join(' | '),
      data: {
        'height': height,
        'weight': weight,
        'bloodPressure': bloodPressure,
        'bloodSugar': bloodSugar,
        'tongueDescription': tongueDescription,
        'pulseDescription': pulseDescription,
        'symptoms': symptoms,
        'diagnosis': diagnosis,
        'prescription': prescription,
      },
      tags: ['健康', '體檢'],
      summary: diagnosis ?? symptoms,
    );
  }

  Future<UserRecord> addFortuneRecord({
    required String userId,
    required String fortuneType,
    String? birthDate,
    required Map<String, dynamic> result,
    String? simpleReport,
    String? premiumReport,
    bool isPremium = false,
  }) async {
    return addRecord(
      userId: userId,
      type: RecordType.fortune,
      title: fortuneType,
      subtitle: '測算記錄',
      data: {
        'fortuneType': fortuneType,
        'birthDate': birthDate,
        'result': result,
        'simpleReport': simpleReport,
        'premiumReport': premiumReport,
        'isPremium': isPremium,
      },
      tags: ['命理', fortuneType],
      summary: simpleReport?.substring(0, simpleReport.length.clamp(0, 100)),
    );
  }

  Future<UserRecord> addFengShuiRecord({
    required String userId,
    required String propertyType,
    String? address,
    required Map<String, dynamic> analysis,
    String? report,
    bool isPremium = false,
  }) async {
    return addRecord(
      userId: userId,
      type: RecordType.fengshui,
      title: '風水分析 - $propertyType',
      subtitle: address,
      data: {
        'propertyType': propertyType,
        'address': address,
        'analysis': analysis,
        'report': report,
        'isPremium': isPremium,
      },
      tags: ['風水', propertyType],
      summary: report?.substring(0, report.length.clamp(0, 100)),
    );
  }

  Future<UserRecord> addPediatricRecord({
    required String userId,
    required String childName,
    int? childAge,
    required String condition,
    List<String> massageTechniques = const [],
    String? diagnosis,
    String? nursingAdvice,
    String? note,
  }) async {
    return addRecord(
      userId: userId,
      type: RecordType.pediatric,
      title: '育兒記錄 - $childName',
      subtitle: condition,
      data: {
        'childName': childName,
        'childAge': childAge,
        'condition': condition,
        'massageTechniques': massageTechniques,
        'diagnosis': diagnosis,
        'nursingAdvice': nursingAdvice,
        'note': note,
      },
      tags: ['育兒', condition, childName],
      summary: '$condition - ${massageTechniques.join(", ")}',
    );
  }
}
