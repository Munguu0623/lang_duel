import 'package:go_router/go_router.dart';
import 'package:voice_duel/features/splash/splash_screen.dart';
import 'package:voice_duel/features/auth/login_screen.dart';
import 'package:voice_duel/features/auth/screens/register_screen.dart';
import 'package:voice_duel/features/auth/screens/forgot_password_screen.dart';
import 'package:voice_duel/features/home/home_screen.dart';
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
