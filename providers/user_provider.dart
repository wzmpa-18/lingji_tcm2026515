import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../services/database_service.dart';
import '../services/verification_service.dart';

class UserProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final VerificationService _verificationService = VerificationService();

  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  String? _tempPasswordHash;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  Future<void> init() async {
    final userId = await _secureStorage.read(key: 'user_id');
    if (userId != null) {
      _currentUser = await _dbService.getUserById(userId);
      notifyListeners();
    }
  }

  Future<bool> login(String phone, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      User? user = await _dbService.getUser(phone);
      if (user == null) {
        _error = '用戶不存在，請先註冊';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _currentUser = user;
      await _secureStorage.write(key: 'user_id', value: user.id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = '登入失敗: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String phone, String password, String nickname, String? invitationCode) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final existingUser = await _dbService.getUser(phone);
      if (existingUser != null) {
        _error = '該手機號已註冊';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final uuid = const Uuid();
      final now = DateTime.now();
      final user = User(
        id: uuid.v4(),
        phone: phone,
        nickname: nickname,
        memberLevel: 0,
        lingjiBalance: 100,
        invitationCode: uuid.v4().substring(0, 8).toUpperCase(),
        invitedBy: invitationCode,
        createdAt: now,
        updatedAt: now,
        passwordHash: _hashPassword(password),
      );

      await _dbService.insertUser(user);
      _currentUser = user;
      await _secureStorage.write(key: 'user_id', value: user.id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = '註冊失敗: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'user_id');
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    bool requireVerification = true,
  }) async {
    if (_currentUser == null) return false;

    if (requireVerification) {
      if (_currentUser!.phoneVerified || _currentUser!.emailVerified) {
        return false;
      }
      return false;
    }

    final storedHash = _currentUser!.passwordHash ?? '';
    if (storedHash.isNotEmpty && storedHash != _hashPassword(currentPassword)) {
      _error = '當前密碼錯誤';
      notifyListeners();
      return false;
    }

    _currentUser = _currentUser!.copyWith(
      passwordHash: _hashPassword(newPassword),
      updatedAt: DateTime.now(),
    );

    await _dbService.updateUser(_currentUser!);
    notifyListeners();
    return true;
  }

  Future<bool> verifyAndChangePassword({
    required String newPassword,
    required String phone,
    required String code,
  }) async {
    if (_currentUser == null) return false;

    final result = await _verificationService.verifyCode(
      identifier: phone,
      type: VerificationType.phone,
      code: code,
    );

    if (!result.success) {
      _error = result.message;
      notifyListeners();
      return false;
    }

    _currentUser = _currentUser!.copyWith(
      passwordHash: _hashPassword(newPassword),
      phoneVerified: true,
      phoneVerifiedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _dbService.updateUser(_currentUser!);
    notifyListeners();
    return true;
  }

  Future<bool> bindEmail({
    required String email,
    required String code,
  }) async {
    if (_currentUser == null) return false;

    final result = await _verificationService.verifyCode(
      identifier: email,
      type: VerificationType.email,
      code: code,
    );

    if (!result.success) {
      _error = result.message;
      notifyListeners();
      return false;
    }

    _currentUser = _currentUser!.copyWith(
      email: email,
      emailVerified: true,
      emailVerifiedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _dbService.updateUser(_currentUser!);
    notifyListeners();
    return true;
  }

  Future<bool> sendEmailVerification(String email) async {
    final result = await _verificationService.sendVerificationCode(
      identifier: email,
      type: VerificationType.email,
    );

    if (!result.success) {
      _error = result.message;
      notifyListeners();
    }

    return result.success;
  }

  Future<bool> sendPhoneVerification(String phone) async {
    final result = await _verificationService.sendVerificationCode(
      identifier: phone,
      type: VerificationType.phone,
    );

    if (!result.success) {
      _error = result.message;
      notifyListeners();
    }

    return result.success;
  }

  Future<bool> verifyPhone(String code) async {
    if (_currentUser == null) return false;

    final result = await _verificationService.verifyCode(
      identifier: _currentUser!.phone,
      type: VerificationType.phone,
      code: code,
    );

    if (!result.success) {
      _error = result.message;
      notifyListeners();
      return false;
    }

    _currentUser = _currentUser!.copyWith(
      phoneVerified: true,
      phoneVerifiedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _dbService.updateUser(_currentUser!);
    notifyListeners();
    return true;
  }

  Future<bool> verifyFace() async {
    if (_currentUser == null) return false;

    final faceService = FaceVerificationService();
    final result = await faceService.verifyFace(userId: _currentUser!.id);

    if (!result.success) {
      _error = result.message;
      notifyListeners();
      return false;
    }

    _currentUser = _currentUser!.copyWith(
      faceVerified: true,
      faceVerifiedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _dbService.updateUser(_currentUser!);
    notifyListeners();
    return true;
  }

  String? get tempPasswordHash => _tempPasswordHash;

  void setTempPasswordHash(String hash) {
    _tempPasswordHash = hash;
  }

  void clearTempPasswordHash() {
    _tempPasswordHash = null;
  }

  String _hashPassword(String password) {
    return password.hashCode.toString();
  }

  Future<void> updateProfile({String? nickname, String? avatar}) async {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(
      nickname: nickname ?? _currentUser!.nickname,
      avatar: avatar ?? _currentUser!.avatar,
      updatedAt: DateTime.now(),
    );

    await _dbService.updateUser(_currentUser!);
    notifyListeners();
  }

  Future<void> updateLingjiBalance(int amount) async {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(
      lingjiBalance: _currentUser!.lingjiBalance + amount,
      updatedAt: DateTime.now(),
    );

    await _dbService.updateUser(_currentUser!);
    notifyListeners();
  }

  Future<void> upgradeMember(int level) async {
    if (_currentUser == null) return;

    final now = DateTime.now();
    DateTime expireDate;

    switch (level) {
      case 1:
        expireDate = now.add(const Duration(days: 30));
        break;
      case 2:
        expireDate = now.add(const Duration(days: 365));
        break;
      case 3:
        expireDate = now.add(const Duration(days: 365));
        break;
      default:
        return;
    }

    _currentUser = _currentUser!.copyWith(
      memberLevel: level,
      memberExpireDate: expireDate,
      cloudBackupEnabled: level >= 1,
      updatedAt: now,
    );

    await _dbService.updateUser(_currentUser!);
    notifyListeners();
  }
}
