import 'package:flutter/material.dart';

import '../core/utils/page_transitions.dart';
import '../ui/shell/app_shell.dart';
import 'routes.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/auth_choice_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/username_screen.dart';
import '../features/auth/screens/avatar_select_screen.dart';
import '../features/auth/screens/level_select_screen.dart';
import '../features/duel/duel_flow_screen.dart';


/// Application router using Navigator 1.0 with custom transitions.
abstract final class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );

      case Routes.onboarding:
        return AppPageTransitions.fadeUpwards(
          settings: settings,
          builder: (_) => const OnboardingScreen(),
        );

      case Routes.authChoice:
        return AppPageTransitions.fadeUpwards(
          settings: settings,
          builder: (_) => const AuthChoiceScreen(),
        );

      case Routes.register:
        return AppPageTransitions.fadeUpwards(
          settings: settings,
          builder: (_) => const RegisterScreen(),
        );

      case Routes.username:
        return AppPageTransitions.fadeUpwards(
          settings: settings,
          builder: (_) => const UsernameScreen(),
        );

      case Routes.avatar:
        return AppPageTransitions.fadeUpwards(
          settings: settings,
          builder: (_) => const AvatarSelectScreen(),
        );

      case Routes.level:
        return AppPageTransitions.fadeUpwards(
          settings: settings,
          builder: (_) => const LevelSelectScreen(),
        );

      case Routes.root:
        return AppPageTransitions.fadeUpwards(
          settings: settings,
          builder: (_) => const AppShell(),
        );

      // All duel flow routes currently map to the same fullscreen flow.
      case Routes.duelMode:
      case Routes.duelSearch:
      case Routes.duelFound:
      case Routes.duelLive:
      case Routes.duelScoring:
      case Routes.duelResult:
        return AppPageTransitions.fadeUpwards(
          settings: settings,
          builder: (_) => const DuelFlowScreen(),
        );

    }

    // Fallback: go to root shell.
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => const AppShell(),
    );
  }
}

