import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  normal,
  einkLight,
  einkDark,
}

class EInkThemeService with ChangeNotifier {
  static final EInkThemeService _instance = EInkThemeService._internal();
  factory EInkThemeService() => _instance;
  EInkThemeService._internal();

  static const String _themeKey = 'app_theme_mode';
  AppThemeMode _currentMode = AppThemeMode.normal;

  AppThemeMode get currentMode => _currentMode;
  bool get isEInkMode => _currentMode != AppThemeMode.normal;
  bool get isEInkLight => _currentMode == AppThemeMode.einkLight;
  bool get isEInkDark => _currentMode == AppThemeMode.einkDark;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey) ?? 'normal';
    _currentMode = AppThemeMode.values.firstWhere(
      (e) => e.name == savedTheme,
      orElse: () => AppThemeMode.normal,
    );
    notifyListeners();
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    _currentMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
    notifyListeners();
  }

  Future<void> toggleEInkMode() async {
    if (_currentMode == AppThemeMode.normal) {
      await setThemeMode(AppThemeMode.einkLight);
    } else {
      await setThemeMode(AppThemeMode.normal);
    }
  }

  Future<void> setEInkLight() async {
    await setThemeMode(AppThemeMode.einkLight);
  }

  Future<void> setEInkDark() async {
    await setThemeMode(AppThemeMode.einkDark);
  }

  Future<void> setNormalMode() async {
    await setThemeMode(AppThemeMode.normal);
  }

  String getModeDisplayName() {
    switch (_currentMode) {
      case AppThemeMode.normal:
        return '普通模式';
      case AppThemeMode.einkLight:
        return '墨水屏·护眼';
      case AppThemeMode.einkDark:
        return '墨水屏·深色';
    }
  }

  IconData getModeIcon() {
    switch (_currentMode) {
      case AppThemeMode.normal:
        return Icons.brightness_6;
      case AppThemeMode.einkLight:
        return Icons.menu_book;
      case AppThemeMode.einkDark:
        return Icons.brightness_2;
    }
  }
}

class EInkTheme {
  static ThemeData getTheme(EInkThemeService service) {
    switch (service.currentMode) {
      case AppThemeMode.normal:
        return _normalTheme;
      case AppThemeMode.einkLight:
        return _eInkLightTheme;
      case AppThemeMode.einkDark:
        return _eInkDarkTheme;
    }
  }

  static const Color _eInkBackground = Color(0xFFF5F5DC);
  static const Color _eInkBackgroundDark = Color(0xFF2C2C2C);
  static const Color _eInkText = Color(0xFF333333);
  static const Color _eInkTextDark = Color(0xFFE8E8E8);
  static const Color _eInkPrimary = Color(0xFF4A4A4A);
  static const Color _eInkAccent = Color(0xFF666666);

  static ThemeData get _eInkLightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _eInkBackground,
      primaryColor: _eInkPrimary,
      colorScheme: ColorScheme.light(
        primary: _eInkPrimary,
        secondary: _eInkAccent,
        surface: _eInkBackground,
        onSurface: _eInkText,
        onPrimary: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _eInkBackground,
        foregroundColor: _eInkText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: _eInkText,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: IconThemeData(color: _eInkText),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: _eInkText, fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: _eInkText, fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: _eInkText, fontSize: 24, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: _eInkText, fontSize: 22, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: _eInkText, fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: _eInkText, fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: _eInkText, fontSize: 16, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: _eInkText, fontSize: 14, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: _eInkText, fontSize: 12, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: _eInkText, fontSize: 16, height: 1.6),
        bodyMedium: TextStyle(color: _eInkText, fontSize: 14, height: 1.5),
        bodySmall: TextStyle(color: _eInkText, fontSize: 12, height: 1.4),
        labelLarge: TextStyle(color: _eInkText, fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: _eInkText, fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: _eInkText, fontSize: 10, fontWeight: FontWeight.w500),
      ),
      iconTheme: const IconThemeData(color: _eInkText),
      dividerTheme: DividerThemeData(color: Colors.grey.shade400, thickness: 0.5),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _eInkBackground,
        selectedItemColor: _eInkPrimary,
        unselectedItemColor: Colors.grey,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _eInkPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _eInkPrimary,
          side: const BorderSide(color: _eInkPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _eInkPrimary, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: _eInkPrimary.withOpacity(0.2),
        labelStyle: const TextStyle(color: _eInkText),
        side: BorderSide(color: Colors.grey.shade400),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: _eInkBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _eInkPrimary,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get _eInkDarkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _eInkBackgroundDark,
      primaryColor: Colors.grey.shade300,
      colorScheme: ColorScheme.dark(
        primary: Colors.grey.shade300,
        secondary: Colors.grey.shade400,
        surface: _eInkBackgroundDark,
        onSurface: _eInkTextDark,
        onPrimary: _eInkBackgroundDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _eInkBackgroundDark,
        foregroundColor: _eInkTextDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: _eInkTextDark,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: IconThemeData(color: _eInkTextDark),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF3A3A3A),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade700),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: _eInkTextDark, fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: _eInkTextDark, fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: _eInkTextDark, fontSize: 24, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: _eInkTextDark, fontSize: 22, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: _eInkTextDark, fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: _eInkTextDark, fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: _eInkTextDark, fontSize: 16, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: _eInkTextDark, fontSize: 14, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: _eInkTextDark, fontSize: 12, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: _eInkTextDark, fontSize: 16, height: 1.6),
        bodyMedium: TextStyle(color: _eInkTextDark, fontSize: 14, height: 1.5),
        bodySmall: TextStyle(color: _eInkTextDark, fontSize: 12, height: 1.4),
        labelLarge: TextStyle(color: _eInkTextDark, fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: _eInkTextDark, fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: _eInkTextDark, fontSize: 10, fontWeight: FontWeight.w500),
      ),
      iconTheme: const IconThemeData(color: _eInkTextDark),
      dividerTheme: DividerThemeData(color: Colors.grey.shade700, thickness: 0.5),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _eInkBackgroundDark,
        selectedItemColor: _eInkTextDark,
        unselectedItemColor: Colors.grey,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade700,
          foregroundColor: _eInkTextDark,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _eInkTextDark,
          side: BorderSide(color: Colors.grey.shade600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF3A3A3A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF3A3A3A),
        selectedColor: Colors.grey.shade700,
        labelStyle: const TextStyle(color: _eInkTextDark),
        side: BorderSide(color: Colors.grey.shade700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: _eInkBackgroundDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey.shade800,
        contentTextStyle: const TextStyle(color: _eInkTextDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get _normalTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF8B4513),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF8B4513),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.grey.shade50,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF333333),
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class EInkModeIndicator extends StatelessWidget {
  final EInkThemeService themeService;
  final bool showLabel;

  const EInkModeIndicator({
    super.key,
    required this.themeService,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    if (themeService.currentMode == AppThemeMode.normal) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: themeService.isEInkLight
            ? const Color(0xFFF5F5DC)
            : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeService.isEInkLight
              ? const Color(0xFF4A4A4A)
              : Colors.grey.shade600,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.menu_book,
            size: 14,
            color: themeService.isEInkLight
                ? const Color(0xFF4A4A4A)
                : _eInkTextDark,
          ),
          if (showLabel) ...[
            const SizedBox(width: 4),
            Text(
              '墨水屏',
              style: TextStyle(
                fontSize: 12,
                color: themeService.isEInkLight
                    ? const Color(0xFF4A4A4A)
                    : _eInkTextDark,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
