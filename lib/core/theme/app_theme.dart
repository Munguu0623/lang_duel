import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 🎨 Design Tokens — Single source of truth for all
//    colors, typography, spacing, and visual constants
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// App color palette.
/// Usage: `AppColors.primary` or `AppColors.tier(TierLevel.gold)`
abstract final class AppColors {
  // ── Brand ──
  static const primary = Color(0xFF6C5CE7);
  static const primaryLight = Color(0xFFA29BFE);
  static const secondary = Color(0xFF00B894);
  static const accent = Color(0xFFFDCB6E);
  static const accentOrange = Color(0xFFE17055);

  // ── Semantic ──
  static const success = Color(0xFF00B894);
  static const danger = Color(0xFFFF6B6B);
  static const warning = Color(0xFFFDCB6E);
  static const info = Color(0xFF0984E3);

  // ── Neutral ──
  static const dark = Color(0xFF2D3436);
  static const darkSoft = Color(0xFF636E72);
  static const light = Color(0xFFDFE6E9);
  static const lightBg = Color(0xFFF8F9FD);
  static const white = Color(0xFFFFFFFF);

  // ── Tier / Rank ──
  static const gold = Color(0xFFF9CA24);
  static const silver = Color(0xFF95A5A6);
  static const bronze = Color(0xFFE67E22);

  // ── Gradients ──
  static const primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF0984E3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const dangerGradient = LinearGradient(
    colors: [accentOrange, danger],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const accentGradient = LinearGradient(
    colors: [accent, Color(0xFFF0932B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Consistent spacing scale (multiples of 4).
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

/// Border radius presets.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double pill = 100;
}

/// App-wide text styles built on Nunito + Lilita One.
abstract final class AppText {
  // ── Display — Lilita One (game titles, big numbers) ──
  static TextStyle displayLg = GoogleFonts.lilitaOne(
    fontSize: 38,
    letterSpacing: 2,
    color: AppColors.dark,
  );

  static TextStyle displayMd = GoogleFonts.lilitaOne(
    fontSize: 24,
    letterSpacing: 1,
    color: AppColors.dark,
  );

  static TextStyle displaySm = GoogleFonts.lilitaOne(
    fontSize: 18,
    color: AppColors.dark,
  );

  // ── Heading — Nunito ExtraBold ──
  static TextStyle headingLg = GoogleFonts.nunito(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.dark,
  );

  static TextStyle headingMd = GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.dark,
  );

  static TextStyle headingSm = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: AppColors.dark,
  );

  // ── Body — Nunito ──
  static TextStyle bodyLg = GoogleFonts.nunito(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.dark,
  );

  static TextStyle bodyMd = GoogleFonts.nunito(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.dark,
  );

  static TextStyle bodySm = GoogleFonts.nunito(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.darkSoft,
  );

  // ── Label — Nunito Bold, compact ──
  static TextStyle label = GoogleFonts.nunito(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.darkSoft,
    letterSpacing: 0.5,
  );
}

/// Material [ThemeData] wired to our tokens.
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBg,
    fontFamily: GoogleFonts.nunito().fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppText.headingLg.copyWith(color: AppColors.white),
    ),
  );
}
