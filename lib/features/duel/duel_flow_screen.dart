import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';
import '../../app/routes.dart';
import '../../features/auth/auth_flow_controller.dart';
import '../../features/auth/auth_service.dart';
import 'data/duel_models.dart';
import 'duel_flow_controller.dart';
import 'duel_state.dart';
import 'screens/mode_select_screen.dart';
import 'screens/searching_screen.dart';
import 'screens/opponent_found_screen.dart';
import 'screens/live_duel_screen.dart';
import 'screens/scoring_screen.dart';
import 'screens/unified_result_screen.dart';

/// Дуэлийн бүтэн дэлгэцийн урсгал — сесс явагдах хугацаанд доод навигаци нуугдана.
///
/// Гүйцэтгэлийн тэмдэглэл:
/// - ValueListenableBuilder зөвхөн body-г дахин байгуулж, Scaffold-г дахин байгуулдаггүй.
/// - AnimatedSwitcher дэлгэцүүдийн хооронд cross-fade хийж, ах дүү widget-уудыг
///   дахин байгуулдаггүй.
/// - Хүүхэд дэлгэц бүрд өвөрмөц ValueKey байгаа тул AnimatedSwitcher анимаци мэднэ.
/// - PopScope нь дуэль явагдах үед санамсаргүй буцах навигацийг хаана.
/// - DuelController нэг удаа үүсч, widget устахад dispose хийгднэ — санах ой алдагддаггүй.
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
        final status = _controller.value.status;
        if (status == DuelStatus.idle || status == DuelStatus.result) {
          // Горим сонголт эсвэл үр дүн → Нүүр хуудас руу
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
    final opponent = state.opponent;
    final prompt = state.prompt;
    final result = state.result;

    return switch (state.status) {
      DuelStatus.idle => ModeSelectScreen(
          key: const ValueKey('mode'),
          onModeSelected: (d) => _controller.startSearching(d),
          onBack: () => Navigator.of(context).pop(),
        ),
      DuelStatus.searching => SearchingScreen(
          key: const ValueKey('search'),
          // Онбординг үед хэрэглэгчийн сонгосон CEFR түвшин.
          // Түвшин сонгоогүй бол B1 буцаана.
          cefrLevel: authFlowController.level ?? 'B1',
          onCancel: () => _controller.reset(),
          // MatchedTicket — жинхэнэ өрсөлдөгч + серверийн сонгосон prompt агуулна.
          onFound: (MatchedTicket match) {
            _controller.opponentFound(
              match.opponent.toDuelUser(),
              prompt: match.prompt,
              matchId: match.matchId,
            );
            _controller.startCountdown();
          },
        ),
      DuelStatus.found || DuelStatus.countdown => opponent == null
          ? const SizedBox.shrink()
          : OpponentFoundScreen(
              key: const ValueKey('found'),
              opponent: opponent,
              onCountdownDone: () => _controller.startDuel(),
            ),
      DuelStatus.live => (opponent == null || prompt == null || state.matchId == null)
          ? const SizedBox.shrink()
          : LiveDuelScreen(
              key: const ValueKey('live'),
              opponent: opponent,
              prompt: prompt,
              matchId: state.matchId!,
              currentUserId: authService.currentUser?.id ?? '',
              durationSeconds: state.durationSeconds,
              onTimeUp: () => _controller.startScoring(),
            ),
      DuelStatus.scoring => ScoringScreen(
          key: const ValueKey('scoring'),
          matchId: state.matchId ?? '',
          currentUserId: authService.currentUser?.id ?? '',
          onDone: (r) => _controller.showResult(r),
        ),
      DuelStatus.result => (result == null || opponent == null)
          ? const SizedBox.shrink()
          : UnifiedResultScreen(
              key: const ValueKey('result'),
              result: result,
              opponent: opponent,
              onHome: () => Routes.backToHomeRoot(context),
              onRematch: () => _controller.reset(),
            ),
    };
  }
}
