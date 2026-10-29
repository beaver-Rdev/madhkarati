import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const cream = Color(0xFFFAF6EC);      // الخلفية الكريمية
  static const surface = Color(0xFFFFFDF7);
  static const ink = Color(0xFF2B2A26);
  static const muted = Color(0xFF7A766B);
  static const border = Color(0xFFE6DFCC);
  static const green = Color(0xFF14532D);      // أخضر عشبي داكن
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.green,
      surface: AppColors.surface,
    ),
    scaffoldBackgroundColor: AppColors.cream,
  );
  // Cairo للعناوين، Tajawal للنصوص
  final body = GoogleFonts.tajawalTextTheme(base.textTheme).apply(
    bodyColor: AppColors.ink,
    displayColor: AppColors.ink,
  );
  final heads = GoogleFonts.cairoTextTheme(body);
  return base.copyWith(
    textTheme: body.copyWith(
      titleLarge: heads.titleLarge?.copyWith(fontWeight: FontWeight.w800),
      titleMedium: heads.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      headlineSmall: heads.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cream,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: AppColors.ink,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? AppColors.green : null),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: AppColors.surface,
      selectedColor: const Color(0xFFD9EBDD),
      side: const BorderSide(color: AppColors.border),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      indicatorColor: Color(0xFFD9EBDD),
    ),
  );
}
