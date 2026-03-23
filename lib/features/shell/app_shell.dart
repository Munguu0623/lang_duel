import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_duel/core/router/app_router.dart';
import 'package:voice_duel/core/widgets/shared_widgets.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 🐚 App Shell — persistent bottom nav wrapper
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    AppRoutes.home,
    AppRoutes.home, // "Duels" tab → same as home for MVP
    AppRoutes.leaderboard,
    AppRoutes.profile,
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.profile)) return 3;
    if (location.startsWith(AppRoutes.leaderboard)) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex(context),
        onTap: (index) => context.go(_tabs[index]),
      ),
    );
  }
}
