// PMSSS Scholarship App - Theme Configuration
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTheme {
  // Light Theme (Professional Blue & White)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(AppColors.backgroundLight),
      colorScheme: const ColorScheme.light(
        primary: Color(AppColors.primaryStart),
        secondary: Color(AppColors.secondary),
        surface: Color(AppColors.surfaceLight),
        error: Color(AppColors.error),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(AppColors.textDark),
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: AppSizes.fontDisplay,
            fontWeight: FontWeight.bold,
            color: Color(AppColors.textDark),
          ),
          headlineLarge: TextStyle(
            fontSize: AppSizes.fontXxl,
            fontWeight: FontWeight.bold,
            color: Color(AppColors.textDark),
          ),
          headlineMedium: TextStyle(
            fontSize: AppSizes.fontXl,
            fontWeight: FontWeight.w600,
            color: Color(AppColors.textDark),
          ),
          titleLarge: TextStyle(
            fontSize: AppSizes.fontLg,
            fontWeight: FontWeight.w600,
            color: Color(AppColors.textDark),
          ),
          titleMedium: TextStyle(
            fontSize: AppSizes.fontMd,
            fontWeight: FontWeight.w500,
            color: Color(AppColors.textDark),
          ),
          bodyLarge: TextStyle(
            fontSize: AppSizes.fontMd,
            color: Color(AppColors.textDark),
          ),
          bodyMedium: TextStyle(
            fontSize: AppSizes.fontSm,
            color: Color(AppColors.textMuted),
          ),
          labelLarge: TextStyle(
            fontSize: AppSizes.fontSm,
            fontWeight: FontWeight.w600,
            color: Color(AppColors.textDark),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(AppColors.primaryStart),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          fontSize: AppSizes.fontLg,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(AppColors.cardWhite),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          side: const BorderSide(color: Color(AppColors.border)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(AppColors.primaryStart),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: AppSizes.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(AppColors.primaryStart),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: AppSizes.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          side: const BorderSide(color: Color(AppColors.primaryStart)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(AppColors.surfaceLight),
        contentPadding: const EdgeInsets.all(AppSizes.md),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: Color(AppColors.border)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: Color(AppColors.border)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: Color(AppColors.primaryStart), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: Color(AppColors.error)),
        ),
        hintStyle: const TextStyle(color: Color(AppColors.textMuted)),
        labelStyle: const TextStyle(color: Color(AppColors.textMuted)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(AppColors.surfaceLight),
        selectedItemColor: Color(AppColors.primaryStart),
        unselectedItemColor: Color(AppColors.textMuted),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(AppColors.divider),
        thickness: 1,
      ),
    );
  }

  // Keep dark theme for reference
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(AppColors.backgroundDark),
      colorScheme: const ColorScheme.dark(
        primary: Color(AppColors.primaryStart),
        secondary: Color(AppColors.secondary),
        surface: Color(AppColors.surfaceDark),
        error: Color(AppColors.error),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(AppColors.textLight),
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: AppSizes.fontDisplay,
            fontWeight: FontWeight.bold,
            color: Color(AppColors.textLight),
          ),
          headlineLarge: TextStyle(
            fontSize: AppSizes.fontXxl,
            fontWeight: FontWeight.bold,
            color: Color(AppColors.textLight),
          ),
          headlineMedium: TextStyle(
            fontSize: AppSizes.fontXl,
            fontWeight: FontWeight.w600,
            color: Color(AppColors.textLight),
          ),
          titleLarge: TextStyle(
            fontSize: AppSizes.fontLg,
            fontWeight: FontWeight.w600,
            color: Color(AppColors.textLight),
          ),
          titleMedium: TextStyle(
            fontSize: AppSizes.fontMd,
            fontWeight: FontWeight.w500,
            color: Color(AppColors.textLight),
          ),
          bodyLarge: TextStyle(
            fontSize: AppSizes.fontMd,
            color: Color(AppColors.textLight),
          ),
          bodyMedium: TextStyle(
            fontSize: AppSizes.fontSm,
            color: Color(AppColors.textSecondary),
          ),
          labelLarge: TextStyle(
            fontSize: AppSizes.fontSm,
            fontWeight: FontWeight.w600,
            color: Color(AppColors.textLight),
          ),
        ),
      ),
    );
  }

  // Primary blue gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(AppColors.primaryStart),
      Color(AppColors.primaryEnd),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Blue header gradient (for login/registration screens)
  static const LinearGradient blueHeaderGradient = LinearGradient(
    colors: [
      Color(AppColors.primaryStart),
      Color(AppColors.primaryEnd),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Background gradient (keep for dark theme)
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color(AppColors.backgroundDark),
      Color(0xFF1E1B4B),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // White card decoration for light theme
  static BoxDecoration get whiteCardDecoration => BoxDecoration(
    color: const Color(AppColors.cardWhite),
    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
    border: Border.all(
      color: const Color(AppColors.border),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Glassmorphism decoration (for blue areas)
  static BoxDecoration get glassDecoration => BoxDecoration(
    color: const Color(AppColors.glassBackground),
    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
    border: Border.all(
      color: const Color(AppColors.glassBorder),
      width: 1,
    ),
  );
}
