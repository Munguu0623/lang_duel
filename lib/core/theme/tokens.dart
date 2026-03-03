import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for English Duel.
/// All visual constants flow from here — no magic numbers in widgets.
/// Changing a token value here updates the entire app consistently.

// ─── Raw Palette ─────────────────────────────────────────────
/// Static color references. Use [AppColors] via `context.colors` for
/// theme-aware resolution. These are kept as a shared reference palette.
abstract final class Palette {
  // Shared
  static const primary = Color(0xFF3B82F6);
  static const primaryDark = Color(0xFF2563EB);
  static const primaryLight = Color(0xFFDBEAFE);
  static const success = Color(0xFF10B981);
  static const danger = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const gold = Color(0xFFF59E0B);
  static const goldSoft = Color(0xFFFFF8E1);
  static const silver = Color(0xFF9CA3AF);
  static const silverSoft = Color(0xFFF3F4F6);
  static const bronze = Color(0xFFCD7F32);
  static const bronzeSoft = Color(0xFFFFF0E0);
}

// ─── Theme-Resolved Colors ───────────────────────────────────
/// Resolves colors per brightness. Access via `context.colors`.
class AppColors {
  final Brightness brightness;
  AppColors._(this.brightness);

  factory AppColors.light() => AppColors._(Brightness.light);
  factory AppColors.dark() => AppColors._(Brightness.dark);

  bool get isDark => brightness == Brightness.dark;

  // Background & surfaces
  Color get background => isDark ? const Color(0xFF0B0F1A) : const Color(0xFFF7F8FC);
  Color get surface => isDark ? const Color(0xFF141825) : const Color(0xFFFFFFFF);
  Color get surfaceSecondary =>
      isDark ? const Color(0xFF1C2030) : const Color(0xFFF0F1F5);
  Color get border => isDark ? const Color(0xFF2A2E3D) : const Color(0xFFE8E9ED);

  // Primary
  Color get primary => Palette.primary;
  Color get primaryDark => Palette.primaryDark;
  Color get primaryLight =>
      isDark ? const Color(0xFF1E2A4A) : const Color(0xFFDBEAFE);
  Color get primaryTint => isDark
      ? Palette.primary.withValues(alpha: 0.06)
      : Palette.primary.withValues(alpha: 0.04);

  // Text
  Color get textPrimary =>
      isDark ? const Color(0xFFF0F1F5) : const Color(0xFF1A1A2E);
  Color get textSecondary =>
      isDark ? const Color(0xFF8B8FA3) : const Color(0xFF9CA3AF);
  Color get textTertiary =>
      isDark ? const Color(0xFF5A5E72) : const Color(0xFFBEC1CC);

  // Status (same for both)
  Color get success => Palette.success;
  Color get danger => Palette.danger;
  Color get warning => Palette.warning;

  // Rank
  Color get gold => Palette.gold;
  Color get goldSoft => isDark ? const Color(0xFF2A2410) : Palette.goldSoft;
  Color get silver => Palette.silver;
  Color get silverSoft => isDark ? const Color(0xFF1E2028) : Palette.silverSoft;
  Color get bronze => Palette.bronze;
  Color get bronzeSoft => isDark ? const Color(0xFF2A2018) : Palette.bronzeSoft;
}

/// Extension for easy access: `context.colors.primary`
extension AppColorsX on BuildContext {
  AppColors get colors {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.dark ? AppColors.dark() : AppColors.light();
  }
}

// ─── Legacy ColorTokens (backward-compatible, maps to light) ─
/// Kept for migration. New code should use `context.colors`.
abstract final class ColorTokens {
  // Background & surface
  static const background = Color(0xFFF7F8FC);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceGrey = Color(0xFFF0F1F5);
  static const border = Color(0xFFE8E9ED);

  // Primary blue
  static const primary = Color(0xFF3B82F6);
  static const primaryDark = Color(0xFF2563EB);
  static const primaryLight = Color(0xFFDBEAFE);

  // Text
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF9CA3AF);

  // Status
  static const success = Color(0xFF10B981);
  static const danger = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);

  // Rank — podium colors
  static const gold = Color(0xFFF59E0B);
  static const goldSoft = Color(0xFFFFF8E1);
  static const silver = Color(0xFF9CA3AF);
  static const silverSoft = Color(0xFFF3F4F6);
  static const bronze = Color(0xFFCD7F32);
  static const bronzeSoft = Color(0xFFFFF0E0);
}

// ─── Spacing (8pt grid) ───────────────────────────────────────
/// Consistent spacing scale based on 8pt grid.
abstract final class SpacingTokens {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
}

// ─── Radius ───────────────────────────────────────────────────
/// Controlled, not bubbly. Reduced from previous values.
abstract final class RadiusTokens {
  static const small = BorderRadius.all(Radius.circular(8));
  static const medium = BorderRadius.all(Radius.circular(12));
  static const card = BorderRadius.all(Radius.circular(16));
  static const large = BorderRadius.all(Radius.circular(20));
  static const pill = BorderRadius.all(Radius.circular(100));
}

// ─── Elevation / Shadows ──────────────────────────────────────
/// Theme-aware shadows. Light = soft shadows; dark = subtle border/glow.
class ElevationTokens {
  ElevationTokens._();

  static List<BoxShadow> soft({bool isDark = false}) {
    if (isDark) return const [];
    return const [
      BoxShadow(
        color: Color(0x06000000),
        blurRadius: 6,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: Color(0x0D000000),
        blurRadius: 16,
        offset: Offset(0, 3),
      ),
    ];
  }

  static List<BoxShadow> elevated({bool isDark = false}) {
    if (isDark) return const [];
    return const [
      BoxShadow(
        color: Color(0x08000000),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
      BoxShadow(
        color: Color(0x10000000),
        blurRadius: 24,
        offset: Offset(0, 6),
      ),
    ];
  }

  /// Colored glow for primary buttons.
  static List<BoxShadow> primaryGlow([double opacity = 0.3]) => [
        BoxShadow(
          color: Palette.primary.withValues(alpha: opacity),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];
}

/// Extension to get theme-aware shadows from context.
extension ElevationX on BuildContext {
  List<BoxShadow> get softShadow =>
      ElevationTokens.soft(isDark: colors.isDark);
  List<BoxShadow> get elevatedShadow =>
      ElevationTokens.elevated(isDark: colors.isDark);
}

// ─── Typography ───────────────────────────────────────────────
/// Plus Jakarta Sans — modern geometric sans with premium feel.
/// Tighter letter-spacing, heavier weights for headlines.
abstract final class TextStyles {
  static String? get _fontFamily =>
      GoogleFonts.plusJakartaSans().fontFamily;

  static TextStyle get headlineLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: ColorTokens.textPrimary,
        height: 1.12,
        letterSpacing: -0.8,
      );

  static TextStyle get headlineMedium => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: ColorTokens.textPrimary,
        height: 1.2,
        letterSpacing: -0.3,
      );

  static TextStyle get titleLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: ColorTokens.textPrimary,
      );

  static TextStyle get titleMedium => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ColorTokens.textPrimary,
      );

  static TextStyle get bodyLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: ColorTokens.textPrimary,
        letterSpacing: -0.1,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: ColorTokens.textSecondary,
      );

  static TextStyle get labelLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: ColorTokens.textPrimary,
      );

  static TextStyle get caption => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: ColorTokens.textSecondary,
      );

  /// Big stat number style — used in StatsGrid and similar.
  static TextStyle get statLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: ColorTokens.textPrimary,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}

// ─── Animation Durations ──────────────────────────────────────
abstract final class DurationTokens {
  static const quick = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 200);
  static const medium = Duration(milliseconds: 300);
}
