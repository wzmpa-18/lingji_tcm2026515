import 'dart:convert';

class Fortune {
  final String id;
  final String userId;
  final String name;
  final DateTime birthTime;
  final String gender;
  final String chartType;
  final Map<String, dynamic> chartData;
  final String? interpretation;
  final DateTime createdAt;
  final bool synced;

  Fortune({
    required this.id,
    required this.userId,
    required this.name,
    required this.birthTime,
    required this.gender,
    required this.chartType,
    required this.chartData,
    this.interpretation,
    required this.createdAt,
    this.synced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'birth_time': birthTime.toIso8601String(),
      'gender': gender,
      'chart_type': chartType,
      'chart_data': jsonEncode(chartData),
      'interpretation': interpretation,
      'created_at': createdAt.toIso8601String(),
      'synced': synced ? 1 : 0,
    };
  }

  factory Fortune.fromMap(Map<String, dynamic> map) {
    return Fortune(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      name: map['name'] ?? '',
      birthTime: DateTime.parse(map['birth_time'] ?? DateTime.now().toIso8601String()),
      gender: map['gender'] ?? '',
      chartType: map['chart_type'] ?? '',
      chartData: map['chart_data'] != null ? jsonDecode(map['chart_data']) : {},
      interpretation: map['interpretation'],
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      synced: map['synced'] == 1,
    );
  }
}

class WuYunLiuQi {
  final String id;
  final int year;
  final String tiangans;
  final String dizhis;
  final String yun;
  final String qi;
  final String weather;
  final String disease;
  final String prevention;

  WuYunLiuQi({
    required this.id,
    required this.year,
    required this.tiangans,
    required this.dizhis,
    required this.yun,
    required this.qi,
    required this.weather,
    required this.disease,
    required this.prevention,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'year': year,
      'tiangans': tiangans,
      'dizhis': dizhis,
      'yun': yun,
      'qi': qi,
      'weather': weather,
      'disease': disease,
      'prevention': prevention,
    };
  }

  factory WuYunLiuQi.fromMap(Map<String, dynamic> map) {
    return WuYunLiuQi(
      id: map['id'] ?? '',
      year: map['year'] ?? 0,
      tiangans: map['tiangans'] ?? '',
      dizhis: map['dizhis'] ?? '',
      yun: map['yun'] ?? '',
      qi: map['qi'] ?? '',
      weather: map['weather'] ?? '',
      disease: map['disease'] ?? '',
      prevention: map['prevention'] ?? '',
    );
  }
}
