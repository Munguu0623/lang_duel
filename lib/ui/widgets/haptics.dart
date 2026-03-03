import 'package:flutter/services.dart';

/// Centralized haptics helpers — keep usage consistent.
abstract final class Haptics {
  static Future<void> lightTap() async {
    await HapticFeedback.selectionClick();
  }

  static Future<void> tick() async {
    await HapticFeedback.selectionClick();
  }

  static Future<void> success() async {
    await HapticFeedback.mediumImpact();
  }

  static Future<void> warning() async {
    await HapticFeedback.lightImpact();
  }
}

