import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';
import '../../app/routes.dart';
import 'duel_flow_controller.dart';
import 'duel_state.dart';
import 'screens/mode_select_screen.dart';
import 'screens/searching_screen.dart';
import 'screens/opponent_found_screen.dart';
import 'screens/live_duel_screen.dart';
import 'screens/scoring_screen.dart';
import 'screens/result_screen.dart';

/// Fullscreen duel flow — bottom nav is hidden during the entire session.
///
/// Performance notes:
/// - ValueListenableBuilder scopes rebuilds to the body only, not the Scaffold.
/// - AnimatedSwitcher cross-fades between screens without rebuilding siblings.
/// - Each child screen has a unique ValueKey so AnimatedSwitcher knows when to animate.
/// - PopScope prevents accidental back-navigation during a live duel.
/// - DuelStateNotifier is created once and disposed with this widget — no leaks.
class DuelFlowScreen extends StatefulWidget {
  const DuelFlowScreen({super.key});

  @override
  State<DuelFlowScreen> createState() => _DuelFlowScreenState();
}

class _DuelFlowScreenState extends State<DuelFlowScreen> {
  final DuelController _controller = DuelController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_controller.value.status == DuelStatus.idle) {
          Routes.backToHomeRoot(context);
        } else {
          _controller.reset();
        }
      },
      child: Scaffold(
        body: ValueListenableBuilder<DuelState>(
          valueListenable: _controller,
          builder: (context, state, _) {
            return AnimatedSwitcher(
              duration: DurationTokens.medium,
              child: _buildScreen(state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScreen(DuelState state) {
    return switch (state.status) {
      DuelStatus.idle => ModeSelectScreen(
          key: const ValueKey('mode'),
          onModeSelected: (d) => _controller.startSearching(d),
          onBack: () => Navigator.of(context).pop(),
        ),
      DuelStatus.searching => SearchingScreen(
          key: const ValueKey('search'),
          onCancel: () => _controller.reset(),
          onFound: (opp) {
            _controller.opponentFound(opp);
            _controller.startCountdown();
          },
        ),
      DuelStatus.found || DuelStatus.countdown => OpponentFoundScreen(
          key: const ValueKey('found'),
          opponent: state.opponent!,
          onCountdownDone: () => _controller.startDuel(),
        ),
      DuelStatus.live => LiveDuelScreen(
          key: const ValueKey('live'),
          opponent: state.opponent!,
          prompt: state.prompt!,
          durationSeconds: state.durationSeconds,
          onTimeUp: () => _controller.startScoring(),
        ),
      DuelStatus.scoring => ScoringScreen(
          key: const ValueKey('scoring'),
          onDone: (result) => _controller.showResult(result),
        ),
      DuelStatus.result => ResultScreen(
          key: const ValueKey('result'),
          result: state.result!,
          opponent: state.opponent!,
          onRematch: () => _controller.startSearching(state.durationSeconds),
          onHome: () => Routes.backToHomeRoot(context),
        ),
    };
  }
}
