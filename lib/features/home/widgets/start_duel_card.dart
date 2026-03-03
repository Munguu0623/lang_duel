import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../ui/widgets/pressable_scale.dart';
import '../../../ui/widgets/primary_button.dart';

/// Big CTA card — "Start a Duel" with subtitle and Quick Duel button.
class StartDuelCard extends StatefulWidget {
  const StartDuelCard({
    super.key,
    required this.onStartDuel,
  });

  final VoidCallback onStartDuel;

  @override
  State<StartDuelCard> createState() => _StartDuelCardState();
}

class _StartDuelCardState extends State<StartDuelCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(_fadeAnimation);
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: PressableScale(
          onTap: widget.onStartDuel,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(SpacingTokens.xl),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: RadiusTokens.card,
              boxShadow: context.softShadow,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  c.primary.withValues(alpha: 0.06),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon badge — circle
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: c.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.bolt_rounded,
                    size: 28,
                    color: c.primary,
                  ),
                ),
                const SizedBox(height: SpacingTokens.base),
                Text(
                  'Start a Duel',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: SpacingTokens.xs),
                Text(
                  '60 seconds. AI judges.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: SpacingTokens.lg),
                PrimaryButton(
                  label: 'Quick Duel',
                  onPressed: widget.onStartDuel,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
