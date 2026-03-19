import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Dark theme
  static const Color darkBg = Color(0xFF0F0F14);
  static const Color darkSurface = Color(0xFF1A1A24);
  static const Color darkCard = Color(0xFF1E1E2C);
  static const Color darkCardHover = Color(0xFF252535);
  static const Color darkDivider = Color(0xFF2A2A3D);
  static const Color darkTextPrimary = Color(0xFFF0F0FF);
  static const Color darkTextSec = Color(0xFF9090B0);
  static const Color darkTextHint = Color(0xFF55556A);

  // Light theme
  static const Color lightBg = Color(0xFFF5F5FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardHover = Color(0xFFF0F0F8);
  static const Color lightDivider = Color(0xFFE5E5F0);
  static const Color lightTextPrimary = Color(0xFF14141E);
  static const Color lightTextSec = Color(0xff6060808);
  static const Color lightTextHint = Color(0xFFAAAAAA);

  // Accents — same in both themes
  static const Color primary = Color(0xFF7C6EF7);
  static const Color primaryLight = Color(0xFF9D92F9);
  static const Color primaryDark = Color(0xFF5A4ED4);
  static const Color success = Color(0xFF4ECDC4);
  static const Color warning = Color(0xFFFFD93D);
  static const Color danger = Color(0xFFFF6B6B);

  // Note card palette — 8 colours per theme
  static const List<Color> noteColorsDark = [
    Color(0xFF1E1E2C), // default (no colour)
    Color(0xFF2D1B2E), // purple
    Color(0xFF1B2D2D), // teal
    Color(0xFF2D2518), // amber
    Color(0xFF2D1B1B), // red
    Color(0xFF1B2520), // green
    Color(0xFF1B1F2D), // blue
    Color(0xFF2D1F2A), // pink
  ];

  static const List<Color> noteColorsLight = [
    Color(0xFFFFFFFF), // default
    Color(0xFFF3E8FF), // purple
    Color(0xFFE0F7F6), // teal
    Color(0xFFFFF8E1), // amber
    Color(0xFFFFEBEB), // red
    Color(0xFFE8F5E9), // green
    Color(0xFFE8EAF6), // blue
    Color(0xFFFCE4EC), // pink
  ];

  static const List<Color> noteAccents = [
    Color(0xFF7C6EF7),
    Color(0xFFB266CC),
    Color(0xFF4ECDC4),
    Color(0xFFFFB74D),
    Color(0xFFFF6B6B),
    Color(0xFF66BB6A),
    Color(0xFF5C9BD6),
    Color(0xFFF06292),
  ];

  static const List<String> noteColorNames = [
    'Default',
    'Purple',
    'Teal',
    'Amber',
    'Red',
    'Green',
    'Blue',
    'Pink',
  ];
}

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle displayLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );
  static const TextStyle displayMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData dark() => _build(Brightness.dark);
  static ThemeData light() => _build(Brightness.light);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final text = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final divider = isDark ? AppColors.darkDivider : AppColors.lightDivider;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.success,
        onSecondary: Colors.white,
        surface: surface,
        onSurface: text,
        error: AppColors.danger,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: false,
        foregroundColor: text,
        titleTextStyle: AppTextStyles.displayMedium.copyWith(color: text),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: divider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        hintStyle: AppTextStyles.bodyLarge.copyWith(
          color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: DividerThemeData(color: divider, thickness: 1),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }
}
