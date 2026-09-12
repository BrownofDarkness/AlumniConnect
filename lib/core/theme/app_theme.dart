import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static const Color _darkSurface = Color(0xFF142E52);
  static const Color _darkSurfaceHigh = Color(0xFF1E3B60);
  static const Color _darkMuted = Color(0xFF8FA0B8);
  static const Color _darkError = Color(0xFFFF7A7A);

  static ThemeData light() {
    const scheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.amber,
      onSecondary: AppColors.navy,
      surface: Colors.white,
      onSurface: AppColors.ink,
      surfaceContainerLowest: AppColors.cream,
      outline: AppColors.divider,
      error: AppColors.error,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.cream,
      textTheme: _textTheme(AppColors.ink, AppColors.muted),
      appBarTheme: _appBarTheme(AppColors.cream, AppColors.navy),
      inputDecorationTheme: _inputDecorationTheme(
        fill: Colors.white,
        border: AppColors.divider,
        focus: AppColors.primary,
        hint: AppColors.muted,
      ),
      elevatedButtonTheme: _elevatedButtonTheme(AppColors.primary, Colors.white),
      outlinedButtonTheme: _outlinedButtonTheme(AppColors.primary),
      textButtonTheme: _textButtonTheme(AppColors.primary),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      cardTheme: _cardTheme(Colors.white, AppColors.divider),
    );
  }

  static ThemeData dark() {
    const scheme = ColorScheme.dark(
      primary: AppColors.amber,
      onPrimary: AppColors.navy,
      secondary: AppColors.primaryLight,
      onSecondary: Colors.white,
      surface: _darkSurface,
      onSurface: AppColors.cream,
      surfaceContainerLowest: AppColors.navy,
      surfaceContainerHigh: _darkSurfaceHigh,
      outline: Color(0x33FFFFFF),
      error: _darkError,
      onError: AppColors.navy,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.navy,
      textTheme: _textTheme(AppColors.cream, _darkMuted),
      appBarTheme: _appBarTheme(AppColors.navy, AppColors.cream),
      inputDecorationTheme: _inputDecorationTheme(
        fill: _darkSurface,
        border: const Color(0x1FFFFFFF),
        focus: AppColors.amber,
        hint: _darkMuted,
      ),
      elevatedButtonTheme: _elevatedButtonTheme(AppColors.amber, AppColors.navy),
      outlinedButtonTheme: _outlinedButtonTheme(AppColors.amber),
      textButtonTheme: _textButtonTheme(AppColors.amber),
      dividerTheme: const DividerThemeData(
        color: Color(0x14FFFFFF),
        thickness: 1,
        space: 1,
      ),
      cardTheme: _cardTheme(_darkSurface, const Color(0x14FFFFFF)),
    );
  }

  static TextTheme _textTheme(Color primary, Color muted) {
    return TextTheme(
      displayLarge: AppTextStyles.displayXL.copyWith(color: primary),
      displayMedium: AppTextStyles.display.copyWith(color: primary),
      headlineLarge: AppTextStyles.display.copyWith(color: primary),
      headlineMedium: AppTextStyles.title.copyWith(color: primary),
      headlineSmall: AppTextStyles.title.copyWith(color: primary),
      titleLarge: AppTextStyles.title.copyWith(color: primary),
      titleMedium: AppTextStyles.heading.copyWith(color: primary),
      titleSmall: AppTextStyles.heading.copyWith(color: primary),
      bodyLarge: AppTextStyles.bodyLg.copyWith(color: primary),
      bodyMedium: AppTextStyles.body.copyWith(color: primary),
      bodySmall: AppTextStyles.bodySm.copyWith(color: muted),
      labelLarge: AppTextStyles.heading.copyWith(color: primary),
      labelMedium: AppTextStyles.caption.copyWith(color: muted),
      labelSmall: AppTextStyles.labelCaps.copyWith(color: muted),
    );
  }

  static AppBarTheme _appBarTheme(Color background, Color foreground) {
    return AppBarTheme(
      backgroundColor: background,
      foregroundColor: foreground,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.heading.copyWith(color: foreground),
      iconTheme: IconThemeData(color: foreground),
    );
  }

  static InputDecorationTheme _inputDecorationTheme({
    required Color fill,
    required Color border,
    required Color focus,
    required Color hint,
  }) {
    OutlineInputBorder outline(Color c, {double width = 1}) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: c, width: width),
        );
    return InputDecorationTheme(
      filled: true,
      fillColor: fill,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      hintStyle: AppTextStyles.body.copyWith(color: hint),
      labelStyle: AppTextStyles.caption.copyWith(color: hint),
      border: outline(border),
      enabledBorder: outline(border),
      focusedBorder: outline(focus, width: 1.5),
      errorBorder: outline(AppColors.error),
      focusedErrorBorder: outline(AppColors.error, width: 1.5),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(Color bg, Color fg) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        elevation: 0,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        textStyle: AppTextStyles.heading,
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(Color color) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color, width: 1.5),
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        textStyle: AppTextStyles.heading,
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(Color color) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: color,
        textStyle: AppTextStyles.heading,
      ),
    );
  }

  static CardThemeData _cardTheme(Color surface, Color border) {
    return CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        side: BorderSide(color: border),
      ),
      margin: EdgeInsets.zero,
    );
  }
}
