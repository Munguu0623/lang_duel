import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/theme/tokens.dart';
import '../../mock/fake_models.dart';
import 'screens/premium_paywall_screen.dart';
import 'screens/purchase_confirmation_screen.dart';
import 'screens/unlocked_analysis_screen.dart';

/// Payment flow states (starts at paywall — free result is shown in duel flow).
enum PaymentFlowStep { paywall, confirmation, analysis }

/// Fullscreen payment flow — manages the paywall → confirmation → analysis UX.
///
/// Launched from the free result screen after the user taps "Unlock Pro".
/// Accepts [DuelResult] via route arguments for the analysis screen.
class PaymentFlowScreen extends StatefulWidget {
  const PaymentFlowScreen({super.key});

  @override
  State<PaymentFlowScreen> createState() => _PaymentFlowScreenState();
}

class _PaymentFlowScreenState extends State<PaymentFlowScreen> {
  PaymentFlowStep _step = PaymentFlowStep.paywall;

  DuelResult get _result {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is DuelResult) return args;
    // Fallback mock data
    return const DuelResult(
      userScore: 72,
      opponentScore: 65,
      isWin: true,
      userBreakdown: ScoreBreakdown(
        pronunciation: 18,
        grammar: 20,
        fluency: 16,
        vocabulary: 18,
      ),
      opponentBreakdown: ScoreBreakdown(
        pronunciation: 15,
        grammar: 17,
        fluency: 18,
        vocabulary: 15,
      ),
    );
  }

  void _goToConfirmation() {
    setState(() => _step = PaymentFlowStep.confirmation);
  }

  void _goToAnalysis() {
    setState(() => _step = PaymentFlowStep.analysis);
  }

  void _onClose() {
    Navigator.of(context).pop();
  }

  void _onFinish() {
    Routes.backToHomeRoot(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _step == PaymentFlowStep.paywall,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        // Don't go back from confirmation/analysis — user committed
      },
      child: AnimatedSwitcher(
        duration: DurationTokens.medium,
        transitionBuilder: (child, animation) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.03),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
        child: _buildCurrentScreen(),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    return switch (_step) {
      PaymentFlowStep.paywall => PremiumPaywallScreen(
          key: const ValueKey('paywall'),
          onStartTrial: _goToConfirmation,
          onClose: _onClose,
        ),
      PaymentFlowStep.confirmation => PurchaseConfirmationScreen(
          key: const ValueKey('confirmation'),
          onSeeAnalysis: _goToAnalysis,
        ),
      PaymentFlowStep.analysis => UnlockedAnalysisScreen(
          key: const ValueKey('analysis'),
          result: _result,
          onStartNextDuel: _onFinish,
        ),
    };
  }
}
