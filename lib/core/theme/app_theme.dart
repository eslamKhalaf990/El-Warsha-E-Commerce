import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';

export 'package:warsha_commerce/core/theme/app_colors.dart';
export 'package:warsha_commerce/core/theme/app_radius.dart';
export 'package:warsha_commerce/core/theme/app_spacing.dart';

abstract final class AppTheme {
  /// Builds the light theme for the application.
  /// Light mode only: no dark theme is supported, and themeMode is always ThemeMode.light.
  static ThemeData light([Locale locale = const Locale('ar')]) {
    final textTheme = _buildTextTheme();

    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.burgundy,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.blush,
      onPrimaryContainer: AppColors.deepWine,
      secondary: AppColors.champagne,
      onSecondary: AppColors.ink,
      secondaryContainer: AppColors.blush,
      onSecondaryContainer: AppColors.deepWine,
      tertiary: AppColors.deepWine,
      onTertiary: AppColors.white,
      error: AppStatusColors.errorText,
      onError: AppColors.white,
      errorContainer: AppStatusColors.errorBackground,
      onErrorContainer: AppStatusColors.errorText,
      surface: AppColors.white,
      onSurface: AppColors.ink,
      surfaceContainerLowest: AppColors.white,
      surfaceContainerLow: AppColors.ivory,
      surfaceContainer: AppColors.blush,
      outline: AppColors.line,
      outlineVariant: AppColors.line,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.ivory,
      colorScheme: colorScheme,
      textTheme: textTheme,
      primaryColor: AppColors.burgundy,
      canvasColor: AppColors.ivory,
      dividerColor: AppColors.line,

      // AppBar Theme (ivory, no elevation)
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.ivory,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.deepWine,
        ),
        iconTheme: const IconThemeData(color: AppColors.ink),
      ),

      // Card Theme (0 elevation, 1px line border, 12px radius)
      cardTheme: const CardThemeData(
        elevation: 0,
        color: AppColors.white,
        surfaceTintColor: AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardBorderRadius,
          side: BorderSide(color: AppColors.line, width: 1),
        ),
      ),

      // Buttons (pill shape, min height 48)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.burgundy,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.line,
          disabledForegroundColor: AppColors.muted,
          elevation: 0,
          shadowColor: AppColors.transparent,
          minimumSize: const Size(88, 48),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s12,
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.burgundy,
          disabledForegroundColor: AppColors.muted,
          side: const BorderSide(color: AppColors.burgundy, width: 1),
          minimumSize: const Size(88, 48),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s12,
          ),
          textStyle: textTheme.labelLarge?.copyWith(color: AppColors.burgundy),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.burgundy,
          disabledForegroundColor: AppColors.muted,
          minimumSize: const Size(64, 48),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s12,
          ),
          textStyle: textTheme.labelLarge?.copyWith(color: AppColors.burgundy),
        ),
      ),

      // InputDecoration Theme (8px radius, line border, burgundy focus)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s12,
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(color: AppColors.muted),
        border: const OutlineInputBorder(
          borderRadius: AppRadius.inputBorderRadius,
          borderSide: BorderSide(color: AppColors.line, width: 1),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.inputBorderRadius,
          borderSide: BorderSide(color: AppColors.line, width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.inputBorderRadius,
          borderSide: BorderSide(color: AppColors.burgundy, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.inputBorderRadius,
          borderSide: BorderSide(color: AppStatusColors.errorText, width: 1),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.inputBorderRadius,
          borderSide: BorderSide(color: AppStatusColors.errorText, width: 1.5),
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.blush,
        disabledColor: AppColors.line,
        selectedColor: AppColors.burgundy,
        labelStyle: textTheme.bodySmall?.copyWith(color: AppColors.ink),
        secondaryLabelStyle: textTheme.bodySmall?.copyWith(
          color: AppColors.white,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: AppSpacing.s8,
        ),
        shape: const StadiumBorder(
          side: BorderSide(color: AppColors.line, width: 1),
        ),
        elevation: 0,
        pressElevation: 0,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.line,
        thickness: 1,
        space: 1,
      ),

      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.deepWine,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.white,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.cardBorderRadius,
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Checkbox, Radio, Switch (burgundy)
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.burgundy;
          }
          return AppColors.white;
        }),
        checkColor: WidgetStateProperty.all(AppColors.white),
        side: const BorderSide(color: AppColors.line, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.small / 2),
        ),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.burgundy;
          }
          return AppColors.muted;
        }),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.white;
          }
          return AppColors.muted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.burgundy;
          }
          return AppColors.line;
        }),
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      // display: 40/1.05 Cairo 700
      displayLarge: GoogleFonts.cairo(
        fontSize: 38,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
      // headline: 26 Cairo 700
      headlineMedium: GoogleFonts.cairo(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.deepWine,
      ),
      // title: 20 Cairo 600
      titleLarge: GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      // titleSmall: 16 Cairo 600
      titleSmall: GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      // body: 15 Cairo 400
      bodyLarge: GoogleFonts.cairo(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.ink,
      ),
      // bodySmall: 13 Cairo 400
      bodySmall: GoogleFonts.cairo(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.ink,
      ),
      // caption: 12 muted Cairo
      labelSmall: GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.muted,
      ),
      // label (buttons): 14 Cairo 600
      labelLarge: GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      // price: 16 Cairo 700
      titleMedium: GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
    );
  }
}
