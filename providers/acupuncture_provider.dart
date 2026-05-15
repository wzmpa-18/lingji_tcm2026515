import 'package:flutter/material.dart';
import '../models/acupuncture/dong_acupoint.dart';
import '../models/acupuncture/nihaixia_acupoint.dart';
import '../models/acupoint.dart';
import 'acupuncture/acupuncture_prescription_service.dart';

class AcupunctureProvider with ChangeNotifier {
  final AcupuncturePrescriptionService _prescriptionService = AcupuncturePrescriptionService();
  
  List<DongAcupoint> _dongPoints = [];
  List<NiHaixiaAcupoint> _niHaixiaPoints = [];
  List<Acupoint> _traditionalPoints = [];
  
  DongAcupoint? _selectedDongPoint;
  NiHaixiaAcupoint? _selectedNiHaixiaPoint;
  Acupoint? _selectedTraditionalPoint;
  
  String _currentAcupointSystem = 'all';
  String _currentRegion = 'all';
  String _searchQuery = '';
  
  PatientSymptoms? _currentSymptoms;
  DiagnosisResult? _currentDiagnosis;
  List<AcupuncturePrescription> _currentPrescriptions = [];
  bool _isDiagnosing = false;
  
  List<DongAcupoint> get dongPoints => _dongPoints;
  List<NiHaixiaAcupoint> get niHaixiaPoints => _niHaixiaPoints;
  List<Acupoint> get traditionalPoints => _traditionalPoints;
  DongAcupoint? get selectedDongPoint => _selectedDongPoint;
  NiHaixiaAcupoint? get selectedNiHaixiaPoint => _selectedNiHaixiaPoint;
  Acupoint? get selectedTraditionalPoint => _selectedTraditionalPoint;
  String get currentAcupointSystem => _currentAcupointSystem;
  String get currentRegion => _currentRegion;
  String get searchQuery => _searchQuery;
  PatientSymptoms? get currentSymptoms => _currentSymptoms;
  DiagnosisResult? get currentDiagnosis => _currentDiagnosis;
  List<AcupuncturePrescription> get currentPrescriptions => _currentPrescriptions;
  bool get isDiagnosing => _isDiagnosing;

  void loadDongPoints() {
    _dongPoints = DongAcupointCollection.dongPoints;
    notifyListeners();
  }

  void loadNiHaixiaPoints() {
    _niHaixiaPoints = NiHaixiaCollection.specialPoints;
    notifyListeners();
  }

  void selectDongPoint(DongAcupoint point) {
    _selectedDongPoint = point;
    _selectedNiHaixiaPoint = null;
    _selectedTraditionalPoint = null;
    notifyListeners();
  }

  void selectNiHaixiaPoint(NiHaixiaAcupoint point) {
    _selectedNiHaixiaPoint = point;
    _selectedDongPoint = null;
    _selectedTraditionalPoint = null;
    notifyListeners();
  }

  void selectTraditionalPoint(Acupoint point) {
    _selectedTraditionalPoint = point;
    _selectedDongPoint = null;
    _selectedNiHaixiaPoint = null;
    notifyListeners();
  }

  void setAcupointSystem(String system) {
    _currentAcupointSystem = system;
    notifyListeners();
  }

  void setRegion(String region) {
    _currentRegion = region;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _dongPoints = DongAcupointCollection.dongPoints;
      _niHaixiaPoints = NiHaixiaCollection.specialPoints;
    } else {
      _dongPoints = DongAcupointCollection.search(query);
      _niHaixiaPoints = NiHaixiaCollection.search(query);
    }
    notifyListeners();
  }

  List<DongAcupoint> getDongPointsByRegion(DongRegion region) {
    return DongAcupointCollection.findByRegion(region);
  }

  List<NiHaixiaAcupoint> getNiHaixiaPointsByRegion(NiHaixiaRegion region) {
    return NiHaixiaCollection.findByRegion(region);
  }

  Future<void> performDiagnosis({
    required List<String> mainSymptoms,
    List<String> secondarySymptoms = const [],
    String painLocation = '',
    String painCharacter = '',
    String painTiming = '',
    bool isAcute = false,
    int? durationDays,
    List<String> accompanyingSymptoms = const [],
    String? tongueColor,
    String? tongueCoating,
    String? pulseType,
    int? age,
    bool isPregnant = false,
    List<String> medicalHistory = const [],
  }) async {
    _isDiagnosing = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _currentSymptoms = PatientSymptoms(
      mainSymptoms: mainSymptoms,
      secondarySymptoms: secondarySymptoms,
      painLocation: painLocation,
      painCharacter: painCharacter,
      painTiming: painTiming,
      isAcute: isAcute,
      durationDays: durationDays,
      accompanyingSymptoms: accompanyingSymptoms,
      tongueColor: tongueColor,
      tongueCoating: tongueCoating,
      pulseType: pulseType,
      age: age,
      isPregnant: isPregnant,
      medicalHistory: medicalHistory,
    );

    final diagnosisInfo = DiagnosisInfo(
      symptoms: mainSymptoms,
      tongueColor: tongueColor ?? '',
      tongueCoating: tongueCoating ?? '',
      pulseType: pulseType ?? '',
    );

    _currentDiagnosis = _prescriptionService.performDiagnosis(diagnosisInfo);

    final fullDiagnosisInfo = DiagnosisInfo(
      symptoms: mainSymptoms,
      tongueColor: tongueColor ?? '',
      tongueCoating: tongueCoating ?? '',
      pulseType: pulseType ?? '',
      syndromeType: _currentDiagnosis!.syndromeType,
      syndromeName: _currentDiagnosis!.syndromeName,
      therapeuticPrinciple: _currentDiagnosis!.therapeuticPrinciple,
    );

    _currentPrescriptions = _prescriptionService.generatePrescription(
      symptoms: _currentSymptoms!,
      diagnosis: fullDiagnosisInfo,
      mode: const AcupointSelectionMode(),
    );

    _isDiagnosing = false;
    notifyListeners();
  }

  void clearDiagnosis() {
    _currentSymptoms = null;
    _currentDiagnosis = null;
    _currentPrescriptions = [];
    notifyListeners();
  }

  List<AcupuncturePrescription> getMainPoints() {
    return _currentPrescriptions.where((p) => p.isMainPoint).toList();
  }

  List<AcupuncturePrescription> getPairedPoints() {
    return _currentPrescriptions.where((p) => p.isPairedPoint).toList();
  }

  List<AcupuncturePrescription> getDongPrescriptions() {
    return _currentPrescriptions
        .where((p) => p.acupointType == AcupointType.dongExtraordinary)
        .toList();
  }

  List<AcupuncturePrescription> getNiHaixiaPrescriptions() {
    return _currentPrescriptions
        .where((p) => p.acupointType == AcupointType.niHaixiaSpecial)
        .toList();
  }

  List<AcupuncturePrescription> getTraditionalPrescriptions() {
    return _currentPrescriptions
        .where((p) => p.acupointType == AcupointType.traditionalMeridian)
        .toList();
  }
}
