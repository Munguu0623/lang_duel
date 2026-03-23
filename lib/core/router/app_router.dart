import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_duel/core/providers/app_providers.dart';
import 'package:voice_duel/core/data/stages.dart';
import 'package:voice_duel/features/splash/splash_screen.dart';
import 'package:voice_duel/features/auth/login_screen.dart';
import 'package:voice_duel/features/auth/screens/register_screen.dart';
import 'package:voice_duel/features/auth/screens/forgot_password_screen.dart';
import 'package:voice_duel/features/home/home_screen.dart';
import 'package:voice_duel/features/game_hub/game_hub_screen.dart';
import 'package:voice_duel/features/map/level_map_screen.dart';
import 'package:voice_duel/features/duel/matchmaking_screen.dart';
import 'package:voice_duel/features/duel/duel_screen.dart';
import 'package:voice_duel/features/duel/result_screen.dart';
import 'package:voice_duel/features/payment/payment_screen.dart';
import 'package:voice_duel/features/profile/profile_screen.dart';
import 'package:voice_duel/features/leaderboard/leaderboard_screen.dart';
import 'package:voice_duel/features/shell/app_shell.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 🧭 Router — declarative navigation with GoRouter
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';
  static const gameHub = '/game-hub';
  static const levelMap = '/level-map';
  static const matchmaking = '/matchmaking';
  static const duel = '/duel';
  static const result = '/result';
  static const payment = '/payment';
  static const profile = '/profile';
  static const leaderboard = '/leaderboard';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    // ── Standalone screens (no bottom nav) ──
    GoRoute(
      path: AppRoutes.splash,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, __) => LoginScreen(
        onRegister: () => context.go(AppRoutes.register),
        onForgotPassword: () => context.go(AppRoutes.forgotPassword),
        onLoginSuccess: () => context.go(AppRoutes.home),
      ),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, __) => RegisterScreen(
        onLogin: () => context.go(AppRoutes.login),
        onRegisterSuccess: () => context.go(AppRoutes.home),
      ),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, __) => ForgotPasswordScreen(
        onBack: () => context.go(AppRoutes.login),
      ),
    ),
    GoRoute(
      path: AppRoutes.matchmaking,
      builder: (_, __) => const MatchmakingScreen(),
    ),
    GoRoute(
      path: AppRoutes.duel,
      builder: (_, __) => const DuelScreen(),
    ),
    GoRoute(
      path: AppRoutes.result,
      builder: (_, __) => const ResultScreen(),
    ),
    GoRoute(
      path: AppRoutes.payment,
      builder: (_, __) => const PaymentScreen(),
    ),

    // ── Game Hub — A1 progress & next stage CTA ──
    GoRoute(
      path: AppRoutes.gameHub,
      builder: (context, __) => Consumer(
        builder: (context, ref, _) {
          final currentStage = ref.watch(currentStageProvider);
          final stageStars = ref.watch(stageStarsProvider);
          final user = ref.watch(currentUserProvider);
          return Scaffold(
            body: GameHubScreen(
              currentStage: currentStage,
              stageStars: stageStars,
              coins: user?.coins ?? 0,
              streak: user?.streak ?? 0,
              onGoToMap: () => context.push(AppRoutes.levelMap),
            ),
          );
        },
      ),
    ),

    // ── Level Map — zigzag stage map ──
    GoRoute(
      path: AppRoutes.levelMap,
      builder: (context, __) => Consumer(
        builder: (context, ref, _) {
          final currentStage = ref.watch(currentStageProvider);
          final stageStars = ref.watch(stageStarsProvider);
          return Scaffold(
            body: LevelMapScreen(
              currentStage: currentStage,
              stageStars: stageStars,
              onPlayStage: (Stage stage) =>
                  context.push(AppRoutes.matchmaking),
            ),
          );
        },
      ),
    ),

    // ── Tabbed screens (with bottom nav) ──
    ShellRoute(
      builder: (_, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (_, __) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.leaderboard,
          pageBuilder: (_, __) => const NoTransitionPage(
            child: LeaderboardScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.profile,
          pageBuilder: (_, __) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),
  ],
);
