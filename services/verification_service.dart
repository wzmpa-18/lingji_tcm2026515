import 'dart:async';
import 'package:flutter/foundation.dart';

enum VerificationType {
  email,
  phone,
  face,
}

enum VerificationStatus {
  pending,
  sent,
  verified,
  failed,
  expired,
}

class VerificationCode {
  final String code;
  final DateTime createdAt;
  final DateTime expiresAt;
  final VerificationStatus status;

  VerificationCode({
    required this.code,
    required this.createdAt,
    required this.expiresAt,
    this.status = VerificationStatus.pending,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  VerificationCode copyWith({
    String? code,
    DateTime? createdAt,
    DateTime? expiresAt,
    VerificationStatus? status,
  }) {
    return VerificationCode(
      code: code ?? this.code,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
    );
  }
}

class VerificationService {
  static final VerificationService _instance = VerificationService._internal();
  factory VerificationService() => _instance;
  VerificationService._internal();

  static const int codeLength = 6;
  static const int codeValidityMinutes = 10;
  static const int maxVerificationAttempts = 5;

  final Map<String, VerificationCode> _verificationCodes = {};
  final Map<String, int> _verificationAttempts = {};
  final Map<String, UserVerification> _userVerifications = {};

  String _generateCode() {
    final random = DateTime.now().millisecondsSinceEpoch;
    final code = (random % 900000 + 100000).toString();
    return code;
  }

  Future<VerificationResult> sendVerificationCode({
    required String identifier,
    required VerificationType type,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (type == VerificationType.phone) {
      if (!_isValidPhone(identifier)) {
        return VerificationResult(
          success: false,
          message: '請輸入有效的手機號碼',
        );
      }
    } else if (type == VerificationType.email) {
      if (!_isValidEmail(identifier)) {
        return VerificationResult(
          success: false,
          message: '請輸入有效的電子郵箱',
        );
      }
    }

    final code = _generateCode();
    final now = DateTime.now();
    final verification = VerificationCode(
      code: code,
      createdAt: now,
      expiresAt: now.add(const Duration(minutes: codeValidityMinutes)),
      status: VerificationStatus.sent,
    );

    _verificationCodes['${type.name}_$identifier'] = verification;
    _verificationAttempts['${type.name}_$identifier'] = 0;

    if (kDebugMode) {
      print('[VerificationService] 驗證碼已發送: $code');
    }

    return VerificationResult(
      success: true,
      message: '驗證碼已發送至${type == VerificationType.phone ? '手機' : '郵箱'}',
      verificationCode: code,
    );
  }

  Future<VerificationResult> verifyCode({
    required String identifier,
    required VerificationType type,
    required String code,
  }) async {
    final key = '${type.name}_$identifier';
    final verification = _verificationCodes[key];

    if (verification == null) {
      return VerificationResult(
        success: false,
        message: '請先獲取驗證碼',
      );
    }

    if (verification.isExpired) {
      _verificationCodes[key] = verification.copyWith(
        status: VerificationStatus.expired,
      );
      return VerificationResult(
        success: false,
        message: '驗證碼已過期，請重新獲取',
      );
    }

    final attempts = _verificationAttempts[key] ?? 0;
    if (attempts >= maxVerificationAttempts) {
      return VerificationResult(
        success: false,
        message: '驗證次數過多，請稍後再試',
      );
    }

    _verificationAttempts[key] = attempts + 1;

    if (verification.code == code) {
      _verificationCodes[key] = verification.copyWith(
        status: VerificationStatus.verified,
      );
      return VerificationResult(
        success: true,
        message: '驗證成功',
      );
    } else {
      final remainingAttempts = maxVerificationAttempts - attempts - 1;
      return VerificationResult(
        success: false,
        message: '驗證碼錯誤，剩餘$remainingAttempts次嘗試機會',
      );
    }
  }

  bool isVerified(String userId, VerificationType type) {
    final verification = _userVerifications[userId];
    if (verification == null) return false;

    switch (type) {
      case VerificationType.email:
        return verification.emailVerified;
      case VerificationType.phone:
        return verification.phoneVerified;
      case VerificationType.face:
        return verification.faceVerified;
    }
  }

  void setUserVerified(String userId, VerificationType type) {
    final existing = _userVerifications[userId] ?? UserVerification(userId: userId);

    switch (type) {
      case VerificationType.email:
        _userVerifications[userId] = UserVerification(
          userId: userId,
          emailVerified: true,
          phoneVerified: existing.phoneVerified,
          faceVerified: existing.faceVerified,
          emailVerifiedAt: DateTime.now(),
        );
        break;
      case VerificationType.phone:
        _userVerifications[userId] = UserVerification(
          userId: userId,
          emailVerified: existing.emailVerified,
          phoneVerified: true,
          faceVerified: existing.faceVerified,
          phoneVerifiedAt: DateTime.now(),
        );
        break;
      case VerificationType.face:
        _userVerifications[userId] = UserVerification(
          userId: userId,
          emailVerified: existing.emailVerified,
          phoneVerified: existing.phoneVerified,
          faceVerified: true,
          faceVerifiedAt: DateTime.now(),
        );
        break;
    }
  }

  UserVerification? getUserVerification(String userId) {
    return _userVerifications[userId];
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^[1-9]\d{10}$|^[1-9]\d{9}$');
    return phoneRegex.hasMatch(phone);
  }

  int getRemainingTime(String identifier, VerificationType type) {
    final key = '${type.name}_$identifier';
    final verification = _verificationCodes[key];
    if (verification == null) return 0;

    final remaining = verification.expiresAt.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  void clearVerification(String identifier, VerificationType type) {
    final key = '${type.name}_$identifier';
    _verificationCodes.remove(key);
    _verificationAttempts.remove(key);
  }
}

class VerificationResult {
  final bool success;
  final String message;
  final String? verificationCode;

  VerificationResult({
    required this.success,
    required this.message,
    this.verificationCode,
  });
}

class UserVerification {
  final String userId;
  final bool emailVerified;
  final bool phoneVerified;
  final bool faceVerified;
  final DateTime? emailVerifiedAt;
  final DateTime? phoneVerifiedAt;
  final DateTime? faceVerifiedAt;

  UserVerification({
    required this.userId,
    this.emailVerified = false,
    this.phoneVerified = false,
    this.faceVerified = false,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.faceVerifiedAt,
  });

  int get verifiedCount {
    int count = 0;
    if (emailVerified) count++;
    if (phoneVerified) count++;
    if (faceVerified) count++;
    return count;
  }

  bool get hasEmail => emailVerified;
  bool get hasPhone => phoneVerified;
  bool get hasFace => faceVerified;
  bool get hasMultiFactor => verifiedCount >= 2;

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'email_verified': emailVerified,
      'phone_verified': phoneVerified,
      'face_verified': faceVerified,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'phone_verified_at': phoneVerifiedAt?.toIso8601String(),
      'face_verified_at': faceVerifiedAt?.toIso8601String(),
    };
  }

  factory UserVerification.fromMap(Map<String, dynamic> map) {
    return UserVerification(
      userId: map['user_id'] ?? '',
      emailVerified: map['email_verified'] ?? false,
      phoneVerified: map['phone_verified'] ?? false,
      faceVerified: map['face_verified'] ?? false,
      emailVerifiedAt: map['email_verified_at'] != null
          ? DateTime.parse(map['email_verified_at'])
          : null,
      phoneVerifiedAt: map['phone_verified_at'] != null
          ? DateTime.parse(map['phone_verified_at'])
          : null,
      faceVerifiedAt: map['face_verified_at'] != null
          ? DateTime.parse(map['face_verified_at'])
          : null,
    );
  }
}

class FaceVerificationService {
  static final FaceVerificationService _instance = FaceVerificationService._internal();
  factory FaceVerificationService() => _instance;
  FaceVerificationService._internal();

  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    await Future.delayed(const Duration(milliseconds: 500));
    _isInitialized = true;
    return true;
  }

  Future<FaceVerificationResult> verifyFace({
    required String userId,
    bool requireLiveness = true,
  }) async {
    if (!_isInitialized) {
      final success = await initialize();
      if (!success) {
        return FaceVerificationResult(
          success: false,
          message: '人臉驗證服務初始化失敗',
        );
      }
    }

    await Future.delayed(const Duration(seconds: 1));

    return FaceVerificationResult(
      success: true,
      message: '人臉驗證通過',
      confidence: 0.95,
      verifiedAt: DateTime.now(),
    );
  }

  Future<bool> isFaceVerified(String userId) async {
    final verification = VerificationService().getUserVerification(userId);
    return verification?.faceVerified ?? false;
  }
}

class FaceVerificationResult {
  final bool success;
  final String message;
  final double? confidence;
  final DateTime? verifiedAt;

  FaceVerificationResult({
    required this.success,
    required this.message,
    this.confidence,
    this.verifiedAt,
  });
}
