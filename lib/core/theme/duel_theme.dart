import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens.dart';

/// Builds the app-wide ThemeData from design tokens.
/// Every visual property flows from tokens — no local magic numbers.
class DuelTheme {
  DuelTheme._();

  static ThemeData get light {
    final c = AppColors.light();
    return _buildTheme(c);
  }

  static ThemeData get dark {
    final c = AppColors.dark();
    return _buildTheme(c);
  }

  static ThemeData _buildTheme(AppColors c) {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();
    final brightness = c.isDark ? Brightness.dark : Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: c.background,

      // ─── Color Scheme ──────────────────────────────────────
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: c.primary,
        onPrimary: Colors.white,
        secondary: c.primaryLight,
        onSecondary: c.primary,
        surface: c.surface,
        onSurface: c.textPrimary,
        error: c.danger,
        onError: Colors.white,
      ),

      // ─── Typography ────────────────────────────────────────
      textTheme: baseTextTheme.copyWith(
        headlineLarge: TextStyles.headlineLarge.copyWith(color: c.textPrimary),
        headlineMedium: TextStyles.headlineMedium.copyWith(color: c.textPrimary),
        titleLarge: TextStyles.titleLarge.copyWith(color: c.textPrimary),
        titleMedium: TextStyles.titleMedium.copyWith(color: c.textPrimary),
        bodyLarge: TextStyles.bodyLarge.copyWith(color: c.textPrimary),
        bodyMedium: TextStyles.bodyMedium.copyWith(color: c.textSecondary),
        labelLarge: TextStyles.labelLarge.copyWith(color: c.textPrimary),
      ),

      // ─── AppBar ───────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyles.titleLarge.copyWith(color: c.textPrimary),
        iconTheme: IconThemeData(color: c.textPrimary),
      ),

      // ─── Card ─────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: RadiusTokens.card),
        margin: EdgeInsets.zero,
      ),

      // ─── Elevated Button (Primary) ────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: c.surfaceSecondary,
          disabledForegroundColor: c.textSecondary,
          elevation: 0,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.xl,
            vertical: SpacingTokens.md,
          ),
          textStyle: TextStyles.titleMedium.copyWith(color: Colors.white),
        ),
      ),

      // ─── Outlined Button ──────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.textPrimary,
          shape: const StadiumBorder(),
          side: BorderSide(color: c.border),
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.xl,
            vertical: SpacingTokens.md,
          ),
          textStyle: TextStyles.titleMedium.copyWith(color: c.textPrimary),
        ),
      ),

      // ─── Text Button ──────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.primary,
          shape: const StadiumBorder(),
          textStyle: TextStyles.labelLarge,
        ),
      ),

      // ─── Chip ─────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: c.surfaceSecondary,
        selectedColor: c.primary,
        labelStyle: TextStyles.bodyMedium.copyWith(color: c.textSecondary),
        secondaryLabelStyle: TextStyles.bodyMedium.copyWith(
          color: Colors.white,
        ),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.md,
          vertical: SpacingTokens.xs,
        ),
        side: BorderSide.none,
      ),

      // ─── Page Transitions ─────────────────────────────────
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
