import 'package:flutter/material.dart';

/// Centralized route names and navigation helpers for English Duel.
abstract final class Routes {
  static const root = '/';

  // Auth / entry flow routes.
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const authChoice = '/auth/choice';
  static const register = '/auth/register';
  static const username = '/auth/username';
  static const avatar = '/auth/avatar';
  static const level = '/auth/level';

  // Duel flow routes — currently all map to the fullscreen duel flow.
  static const duelMode = '/duel/mode';
  static const duelSearch = '/duel/search';
  static const duelFound = '/duel/found';
  static const duelLive = '/duel/live';
  static const duelScoring = '/duel/scoring';
  static const duelResult = '/duel/result';

  static void goToDuelMode(BuildContext context) {
    Navigator.of(context).pushNamed(duelMode);
  }

  static void goToDuelLive(BuildContext context) {
    Navigator.of(context).pushNamed(duelLive);
  }

  static void backToHomeRoot(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

