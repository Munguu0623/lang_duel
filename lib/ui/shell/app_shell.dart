import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/theme/tokens.dart';
import '../../features/home/home_screen.dart';
import '../../features/leaderboard/leaderboard_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../widgets/duel_bottom_nav.dart';
import '../widgets/primary_button.dart';

/// Root shell that manages bottom navigation and tab persistence.
///
/// Performance notes:
/// - IndexedStack keeps all tabs alive so switching is instant (no rebuild).
/// - Only _currentIndex triggers setState — tab content stays untouched.
/// - Duel flow launches as a fullscreen route (not inside the stack)
///   so bottom nav is hidden during duels without extra logic.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    // Duel tab (index 1) launches fullscreen flow instead of switching tab.
    if (index == 1) {
      Routes.goToDuelMode(context);
      return;
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: const [
            HomeScreen(),
            // Duel tab placeholder — tapping nav launches fullscreen flow,
            // so this widget is rarely seen. Kept in stack for index parity.
            _DuelTabPlaceholder(),
            LeaderboardScreen(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: DuelBottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

/// Simple CTA placeholder for the Duel tab slot in IndexedStack.
class _DuelTabPlaceholder extends StatelessWidget {
  const _DuelTabPlaceholder();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SpacingTokens.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bolt_rounded,
              size: 48,
              color: c.primary,
            ),
            const SizedBox(height: SpacingTokens.base),
            Text(
              'Ready to duel?',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: SpacingTokens.sm),
            Text(
              'Tap the button below to start.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: SpacingTokens.xl),
            PrimaryButton(
              label: 'Start Duel',
              onPressed: () => Routes.goToDuelMode(context),
              expanded: false,
            ),
          ],
        ),
      ),
    );
  }
}
