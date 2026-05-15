import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserPreferencesService {
  static final UserPreferencesService _instance = UserPreferencesService._internal();
  factory UserPreferencesService() => _instance;
  UserPreferencesService._internal();

  SharedPreferences? _prefs;

  static const String _keyThemeMode = 'theme_mode';
  static const String _keyLanguage = 'language';
  static const String _keyEinkMode = 'eink_mode';
  static const String _keyShowWatermark = 'show_watermark';
  static const String _keyShowQRCode = 'show_qr_code';
  static const String _keyWatermarkPosition = 'watermark_position';
  static const String _keyDisclaimerAccepted = 'disclaimer_accepted';
  static const String _keyCustomSettings = 'custom_settings';
  static const String _keyLastVersion = 'last_version';
  static const String _keyUserArchive = 'user_archive';
  static const String _keySearchHistory = 'search_history';

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('UserPreferencesService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  Future<void> ensureInitialized() async {
    if (_prefs == null) {
      await init();
    }
  }

  Future<bool> saveString(String key, String value) async {
    await ensureInitialized();
    return prefs.setString(key, value);
  }

  String? getString(String key) {
    return prefs.getString(key);
  }

  Future<bool> saveInt(String key, int value) async {
    await ensureInitialized();
    return prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return prefs.getInt(key);
  }

  Future<bool> saveBool(String key, bool value) async {
    await ensureInitialized();
    return prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return prefs.getBool(key);
  }

  Future<bool> saveDouble(String key, double value) async {
    await ensureInitialized();
    return prefs.setDouble(key, value);
  }

  double? getDouble(String key) {
    return prefs.getDouble(key);
  }

  Future<bool> saveStringList(String key, List<String> value) async {
    await ensureInitialized();
    return prefs.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return prefs.getStringList(key);
  }

  Future<bool> saveJson(String key, Map<String, dynamic> value) async {
    await ensureInitialized();
    return prefs.setString(key, jsonEncode(value));
  }

  Map<String, dynamic>? getJson(String key) {
    final str = prefs.getString(key);
    if (str == null) return null;
    try {
      return jsonDecode(str) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error decoding JSON for key $key: $e');
      return null;
    }
  }

  ThemeMode get themeMode {
    final value = prefs.getString(_keyThemeMode);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    String value;
    switch (mode) {
      case ThemeMode.light:
        value = 'light';
        break;
      case ThemeMode.dark:
        value = 'dark';
        break;
      case ThemeMode.system:
        value = 'system';
        break;
    }
    await saveString(_keyThemeMode, value);
  }

  String get language {
    return prefs.getString(_keyLanguage) ?? 'zh_TW';
  }

  Future<void> setLanguage(String langCode) async {
    await saveString(_keyLanguage, langCode);
  }

  bool get showWatermark {
    return prefs.getBool(_keyShowWatermark) ?? true;
  }

  Future<void> setShowWatermark(bool value) async {
    await saveBool(_keyShowWatermark, value);
  }

  bool get showQRCode {
    return prefs.getBool(_keyShowQRCode) ?? true;
  }

  Future<void> setShowQRCode(bool value) async {
    await saveBool(_keyShowQRCode, value);
  }

  int get watermarkPosition {
    return prefs.getInt(_keyWatermarkPosition) ?? 4;
  }

  Future<void> setWatermarkPosition(int position) async {
    await saveInt(_keyWatermarkPosition, position);
  }

  bool get disclaimerAccepted {
    return prefs.getBool(_keyDisclaimerAccepted) ?? false;
  }

  Future<void> setDisclaimerAccepted(bool value) async {
    await saveBool(_keyDisclaimerAccepted, value);
  }

  String get lastVersion {
    return prefs.getString(_keyLastVersion) ?? '0.0.0';
  }

  Future<void> setLastVersion(String version) async {
    await saveString(_keyLastVersion, version);
  }

  Future<void> saveUserArchive(Map<String, dynamic> archive) async {
    await saveJson(_keyUserArchive, archive);
  }

  Map<String, dynamic>? getUserArchive() {
    return getJson(_keyUserArchive);
  }

  Future<void> addSearchHistory(String query) async {
    final history = getStringList(_keySearchHistory) ?? [];
    history.remove(query);
    history.insert(0, query);
    if (history.length > 50) {
      history.removeRange(50, history.length);
    }
    await saveStringList(_keySearchHistory, history);
  }

  List<String> getSearchHistory() {
    return getStringList(_keySearchHistory) ?? [];
  }

  Future<void> clearSearchHistory() async {
    await saveStringList(_keySearchHistory, []);
  }

  Future<void> saveCustomSettings(Map<String, dynamic> settings) async {
    await saveJson(_keyCustomSettings, settings);
  }

  Map<String, dynamic> getCustomSettings() {
    return getJson(_keyCustomSettings) ?? {};
  }

  Future<void> updateCustomSetting(String key, dynamic value) async {
    final settings = getCustomSettings();
    settings[key] = value;
    await saveCustomSettings(settings);
  }

  Future<void> clearAllData() async {
    await ensureInitialized();
    await prefs.clear();
  }

  Future<Map<String, dynamic>> exportAllData() async {
    await ensureInitialized();
    return {
      'theme_mode': themeMode.toString(),
      'language': language,
      'show_watermark': showWatermark,
      'show_qr_code': showQRCode,
      'watermark_position': watermarkPosition,
      'disclaimer_accepted': disclaimerAccepted,
      'last_version': lastVersion,
      'custom_settings': getCustomSettings(),
      'search_history': getSearchHistory(),
      'user_archive': getUserArchive(),
    };
  }

  Future<void> importData(Map<String, dynamic> data) async {
    if (data.containsKey('theme_mode')) {
      final mode = data['theme_mode'] as String;
      await setThemeMode(
        mode == 'ThemeMode.light'
            ? ThemeMode.light
            : mode == 'ThemeMode.dark'
                ? ThemeMode.dark
                : ThemeMode.system,
      );
    }
    if (data.containsKey('language')) {
      await setLanguage(data['language'] as String);
    }
    if (data.containsKey('show_watermark')) {
      await setShowWatermark(data['show_watermark'] as bool);
    }
    if (data.containsKey('show_qr_code')) {
      await setShowQRCode(data['show_qr_code'] as bool);
    }
    if (data.containsKey('watermark_position')) {
      await setWatermarkPosition(data['watermark_position'] as int);
    }
    if (data.containsKey('custom_settings')) {
      await saveCustomSettings(data['custom_settings'] as Map<String, dynamic>);
    }
    if (data.containsKey('search_history')) {
      await saveStringList(_keySearchHistory, List<String>.from(data['search_history']));
    }
    if (data.containsKey('user_archive')) {
      await saveUserArchive(data['user_archive'] as Map<String, dynamic>);
    }
  }

  bool shouldMigrateData(String oldVersion, String newVersion) {
    final oldParts = oldVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final newParts = newVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    for (int i = 0; i < 3; i++) {
      final old = i < oldParts.length ? oldParts[i] : 0;
      final newV = i < newParts.length ? newParts[i] : 0;
      if (newV > old) return true;
    }
    return false;
  }

  Future<void> migrateUserDataIfNeeded(String newVersion) async {
    final currentVersion = lastVersion;
    if (shouldMigrateData(currentVersion, newVersion)) {
      final archive = getUserArchive();
      if (archive != null) {
        await saveUserArchive(archive);
      }
      await setLastVersion(newVersion);
    }
  }
}

class SettingsKeys {
  static const String userId = 'user_id';
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String memberLevel = 'member_level';
  static const String nickname = 'nickname';
  static const String avatar = 'avatar';
  static const String phone = 'phone';
  static const String email = 'email';
  static const String referralCode = 'referral_code';
  static const String lingjiBalance = 'lingji_balance';
  static const String xuehaiBalance = 'xuehai_balance';
  static const String lingjiPoints = 'lingji_points';
  static const String xuehaiPoints = 'xuehai_points';
}
