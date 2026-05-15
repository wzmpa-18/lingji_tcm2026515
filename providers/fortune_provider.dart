import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/fortune.dart';
import '../services/database_service.dart';

class FortuneProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  
  List<Fortune> _fortunes = [];
  Map<String, dynamic>? _currentChart;
  String _selectedChartType = '四柱八字';

  List<Fortune> get fortunes => _fortunes;
  Map<String, dynamic>? get currentChart => _currentChart;
  String get selectedChartType => _selectedChartType;

  Future<void> loadFortunes(String userId) async {
    _fortunes = await _dbService.getFortunes(userId);
    notifyListeners();
  }

  void setChartType(String type) {
    _selectedChartType = type;
    notifyListeners();
  }

  Future<Fortune?> calculateChart({
    required String userId,
    required String name,
    required DateTime birthTime,
    required String gender,
  }) async {
    Map<String, dynamic> chartData;
    
    switch (_selectedChartType) {
      case '四柱八字':
        chartData = await _dbService.calculateBazi(birthTime, gender);
        break;
      default:
        chartData = await _dbService.calculateBazi(birthTime, gender);
    }

    _currentChart = chartData;
    
    final fortune = Fortune(
      id: const Uuid().v4(),
      userId: userId,
      name: name,
      birthTime: birthTime,
      gender: gender,
      chartType: _selectedChartType,
      chartData: chartData,
      createdAt: DateTime.now(),
    );

    await _dbService.insertFortune(fortune);
    _fortunes.insert(0, fortune);
    notifyListeners();
    
    return fortune;
  }

  Future<Map<String, dynamic>> getWuYunLiuQi(int year) async {
    final data = await _dbService.calculateWuYunLiuQi(year);
    return data;
  }

  void clearCurrentChart() {
    _currentChart = null;
    notifyListeners();
  }
}
