import 'package:flutter/material.dart';
import '../models/consultation.dart';
import '../services/database_service.dart';

class TCMProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  
  List<Prescription> _prescriptions = [];
  List<Master> _masters = [];
  List<Consultation> _consultations = [];
  Master? _selectedMaster;
  bool _isMultiSelect = false;
  Set<String> _selectedMasters = {};

  List<Prescription> get prescriptions => _prescriptions;
  List<Master> get masters => _masters;
  List<Consultation> get consultations => _consultations;
  Master? get selectedMaster => _selectedMaster;
  bool get isMultiSelect => _isMultiSelect;
  Set<String> get selectedMasters => _selectedMasters;

  Future<void> loadMasters() async {
    _masters = await _dbService.getMasters();
    _selectedMasters = _masters.where((m) => m.isDefault).map((m) => m.id).toSet();
    if (_masters.isNotEmpty) {
      _selectedMaster = _masters.firstWhere((m) => m.isDefault, orElse: () => _masters.first);
    }
    notifyListeners();
  }

  Future<void> loadPrescriptions({String? masterId, String? category}) async {
    if (_isMultiSelect && _selectedMasters.isNotEmpty) {
      _prescriptions = [];
      for (var mid in _selectedMasters) {
        final rxList = await _dbService.getPrescriptions(masterId: mid, category: category);
        _prescriptions.addAll(rxList);
      }
    } else if (_selectedMaster != null) {
      _prescriptions = await _dbService.getPrescriptions(masterId: _selectedMaster!.id, category: category);
    } else {
      _prescriptions = await _dbService.getPrescriptions(category: category);
    }
    notifyListeners();
  }

  void setSelectedMaster(Master master) {
    _selectedMaster = master;
    _isMultiSelect = false;
    _selectedMasters.clear();
    loadPrescriptions();
  }

  void toggleMasterSelection(String masterId) {
    if (_selectedMasters.contains(masterId)) {
      _selectedMasters.remove(masterId);
    } else {
      _selectedMasters.add(masterId);
    }
    if (_selectedMasters.isEmpty && _masters.isNotEmpty) {
      _selectedMasters = _masters.where((m) => m.isDefault).map((m) => m.id).toSet();
    }
    notifyListeners();
    loadPrescriptions();
  }

  void setMultiSelect(bool value) {
    _isMultiSelect = value;
    if (value) {
      _selectedMasters = _masters.where((m) => m.isDefault).map((m) => m.id).toSet();
    } else {
      _selectedMasters.clear();
      if (_masters.isNotEmpty) {
        _selectedMaster = _masters.firstWhere((m) => m.isDefault, orElse: () => _masters.first);
      }
    }
    loadPrescriptions();
  }

  Future<void> loadConsultations(String userId) async {
    _consultations = await _dbService.getConsultations(userId);
    notifyListeners();
  }

  Future<void> saveConsultation(Consultation consultation) async {
    await _dbService.insertConsultation(consultation);
    _consultations.insert(0, consultation);
    notifyListeners();
  }

  List<Prescription> searchPrescriptions(String query) {
    if (query.isEmpty) return _prescriptions;
    return _prescriptions.where((rx) {
      return rx.name.contains(query) ||
             rx.indications.contains(query) ||
             rx.composition.any((c) => c['herb'].contains(query));
    }).toList();
  }

  List<String> get categories {
    final cats = _prescriptions.map((rx) => rx.category).toSet().toList();
    cats.insert(0, '全部');
    return cats;
  }
}
