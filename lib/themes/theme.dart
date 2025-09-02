import 'package:flutter/material.dart';

class AppTheme {
  // ========== CORES PRINCIPAIS ==========

  static const Color darkBackgroundPrimary = Color(0xFF1a1a1a);
  static const Color darkBackgroundSecondary = Color(0xFF2d2d2d);

  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xB3FFFFFF);
  static const Color darkTextTertiary = Color(0x4DFFFFFF);

  static const Color darkItemBackground = Color(0xFF1a1a1a);

  static const Color darkButtonBackground = Color(0xFF4285F4);

  static const Color darkTextButton = Color(0xFFFFFFFF);

  static const Color lightBackgroundPrimary = Color(0xFFFFF9B3);
  static const Color lightBackgroundSecondary = Color(0xFFE5E5E5);

  static const Color lightTextPrimary = Color(0xFF000000);
  static const Color lightTextSecondary = Color(0xB3000000);
  static const Color lightTextTertiary = Color(0x4D000000);

  static const Color lightItemBackground = Color(0xFFFFF9B3);

  static const Color lightButtonBackground = Color(0xFF4285F4);

  static const Color lightTextButton = Color(0xFFFFFFFF);



  static const Color primaryBlue = Color(0xFF4285f4);

  static const Color successGreen = Color(0xFF34a853);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color amberOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFF44336);
  static const Color deleteRed = Color(0xFFFF5252);

  static const Color iconDownload = Color(0xFF40C4FF);
  static const Color iconEdit = Color(0xFFFFAB40);
  static const Color iconDelete = Color(0xFFFF5252);

  static const Color borderDefault = Color(0x4DFFFFFF);
  static const Color borderFocused = Color(0xFF4285f4);
  static const Color borderAccent = Color(0xFF4285f4);

  static const Color performanceGreen = Color(0xFF34a853);
  static const Color performanceBackground = Color(0xFF34a853);
  static const Color chipGreen = Color(0xFF4CAF50);
  static const Color chipGreenBackground = Color(0xFF4CAF50);

  static const Color shadowColor = Color(0xFF000000);

  static const Color emptyStateIcon = Color(0xFFFFFFFF);
  static const Color errorIcon = Color(0xFFF44336);

  static const double opacityLow = 0.1;
  static const double opacityMediumLow = 0.2;
  static const double opacityMedium = 0.3;
  static const double opacityHigh = 0.5;
  static const double opacityVeryHigh = 0.7;

// ========== TEMA DARK COMPLETO ==========
static ThemeData get darkTheme {
  final base = ThemeData.dark();

  return base.copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackgroundPrimary,
    cardColor: darkBackgroundSecondary,
    canvasColor: darkItemBackground,
    colorScheme: base.colorScheme.copyWith(
      primary: primaryBlue,
      secondary: successGreen,
      background: darkBackgroundPrimary,
      surface: darkBackgroundSecondary,
      error: errorRed,
      onSurface: darkButtonBackground,
      onPrimary: darkTextButton,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackgroundPrimary,
      foregroundColor: darkTextPrimary,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: darkBackgroundSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      shadowColor: shadowColor.withOpacity(opacityLow),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: darkTextPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: darkTextSecondary,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: darkTextPrimary,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: darkTextSecondary),
      hintStyle: TextStyle(color: darkTextTertiary),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderDefault),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderFocused),
      ),
      filled: false,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: darkBackgroundSecondary,
      titleTextStyle: const TextStyle(
        color: darkTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: const TextStyle(
        color: darkTextSecondary,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: darkBackgroundSecondary,
      contentTextStyle: const TextStyle(color: darkTextPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryBlue,
    ),
    iconTheme: const IconThemeData(
      color: darkTextPrimary,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: darkTextPrimary),
      displayMedium: TextStyle(color: darkTextPrimary),
      displaySmall: TextStyle(color: darkTextPrimary),
      headlineLarge: TextStyle(color: darkTextPrimary),
      headlineMedium: TextStyle(color: darkTextPrimary),
      headlineSmall: TextStyle(color: darkTextPrimary),
      titleLarge: TextStyle(color: darkTextPrimary),
      titleMedium: TextStyle(color: darkTextPrimary),
      titleSmall: TextStyle(color: darkTextPrimary),
      bodyLarge: TextStyle(color: darkTextPrimary),
      bodyMedium: TextStyle(color: darkTextPrimary),
      bodySmall: TextStyle(color: darkTextSecondary),
      labelLarge: TextStyle(color: darkTextPrimary),
      labelMedium: TextStyle(color: darkTextPrimary),
      labelSmall: TextStyle(color: darkTextSecondary),
    ),
  );
}

// ========== TEMA LIGHT COMPLETO ==========
static ThemeData get lightTheme {
  final base = ThemeData.light();

  return base.copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackgroundPrimary,
    cardColor: lightBackgroundSecondary,
    canvasColor: lightItemBackground, // ✅ NOVO
    colorScheme: base.colorScheme.copyWith(
      primary: primaryBlue,
      secondary: successGreen,
      background: lightBackgroundPrimary,
      surface: lightBackgroundSecondary,
      error: errorRed,
      onSurface: lightButtonBackground,
      onPrimary: lightTextButton,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackgroundPrimary,
      foregroundColor: lightTextPrimary,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: lightBackgroundSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      shadowColor: shadowColor.withOpacity(opacityLow),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: lightTextPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: lightTextSecondary,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: lightTextPrimary,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: lightTextSecondary),
      hintStyle: TextStyle(color: lightTextTertiary),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderDefault),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderFocused),
      ),
      filled: false,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: lightBackgroundSecondary,
      titleTextStyle: const TextStyle(
        color: lightTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: const TextStyle(
        color: lightTextSecondary,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: lightBackgroundSecondary,
      contentTextStyle: const TextStyle(color: lightTextPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryBlue,
    ),
    iconTheme: const IconThemeData(
      color: lightTextPrimary,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: lightTextPrimary),
      displayMedium: TextStyle(color: lightTextPrimary),
      displaySmall: TextStyle(color: lightTextPrimary),
      headlineLarge: TextStyle(color: lightTextPrimary),
      headlineMedium: TextStyle(color: lightTextPrimary),
      headlineSmall: TextStyle(color: lightTextPrimary),
      titleLarge: TextStyle(color: lightTextPrimary),
      titleMedium: TextStyle(color: lightTextPrimary),
      titleSmall: TextStyle(color: lightTextPrimary),
      bodyLarge: TextStyle(color: lightTextPrimary),
      bodyMedium: TextStyle(color: lightTextPrimary),
      bodySmall: TextStyle(color: lightTextSecondary),
      labelLarge: TextStyle(color: lightTextPrimary),
      labelMedium: TextStyle(color: lightTextPrimary),
      labelSmall: TextStyle(color: lightTextSecondary),
    ),
  );
}

  // ========== MÉTODOS HELPER ==========
  static Color get primaryBlueWithLowOpacity => primaryBlue.withOpacity(opacityMedium);
  static Color get successGreenWithLowOpacity => successGreen.withOpacity(opacityMediumLow);
  static Color get amberOrangeWithLowOpacity => amberOrange.withOpacity(opacityMediumLow);
  static Color get chipGreenWithLowOpacity => chipGreen.withOpacity(opacityMediumLow);
  static Color get shadowWithOpacity => shadowColor.withOpacity(opacityLow);
  static Color get emptyStateIconWithOpacity => emptyStateIcon.withOpacity(opacityHigh);
  static Color get errorIconWithOpacity => errorIcon.withOpacity(opacityVeryHigh);

  static List<BoxShadow> get defaultShadow => [
        BoxShadow(
          color: shadowWithOpacity,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static Border get accentBorder => Border.all(
        color: primaryBlueWithLowOpacity,
        width: 1,
      );
}

// ========== EXTENSÕES PARA FACILITAR USO ==========
extension AppThemeExtension on BuildContext {
  Color get primaryBackground => AppTheme.darkBackgroundPrimary;
  Color get secondaryBackground => AppTheme.darkBackgroundSecondary;
  Color get primaryText => AppTheme.darkTextPrimary;
  Color get secondaryText => AppTheme.darkTextSecondary;
  Color get primaryBlue => AppTheme.primaryBlue;
  Color get successGreen => AppTheme.successGreen;
  Color get amberOrange => AppTheme.amberOrange;
  Color get errorRed => AppTheme.errorRed;

  Color get itemBackground => Theme.of(this).canvasColor; // ✅ novo
}
