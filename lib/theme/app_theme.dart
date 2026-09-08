import 'package:flutter/material.dart';

/// A soft, cozy, minimal palette built on the 60-30-10 rule.
///
/// 60% — dominant background: warm cream / blush white
/// 30% — secondary: dusty rose / muted mauve (cards, surfaces)
/// 10% — accent: deeper berry rose (numbers, progress, heart, buttons)
class AppColors {
  AppColors._();

  // 60% — dominant
  static const Color background = Color(0xFFFCF4F1);
  static const Color backgroundAlt = Color(0xFFF9ECE8);

  // 30% — secondary
  static const Color secondary = Color(0xFFF1D6DC);
  static const Color secondarySoft = Color(0xFFF6E3E7);
  static const Color secondaryDeep = Color(0xFFE7BFC9);

  // 10% — accent
  static const Color accent = Color(0xFFC96379);
  static const Color accentDeep = Color(0xFFB14D66);
  static const Color accentSoft = Color(0xFFE39AAC);

  // Text
  static const Color textPrimary = Color(0xFF5B4048);
  static const Color textSecondary = Color(0xFF8B6B72);
  static const Color textOnAccent = Color(0xFFFFF8F6);
}

class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Georgia',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        primary: AppColors.accent,
        secondary: AppColors.secondaryDeep,
        surface: AppColors.background,
        brightness: Brightness.light,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          height: 1.4,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
