import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../ui/widgets/primary_button.dart';

/// Hero section — borderless, immersive, arena feel.
/// Competitive headline + dynamic status badges + powerful CTA with glow.
class StartDuelCard extends StatefulWidget {
  const StartDuelCard({
    super.key,
    required this.onStartDuel,
    this.streak = 0,
    this.rankChange = 0,
  });

  final VoidCallback onStartDuel;
  final int streak;
  final int rankChange;

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
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Competitive headline
            Text(
              'Ready to\ndominate?',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 36,
                    height: 1.08,
                    letterSpacing: -1.0,
                  ),
            ),
            const SizedBox(height: SpacingTokens.base),
            // Dynamic status indicators
            Wrap(
              spacing: SpacingTokens.sm,
              runSpacing: SpacingTokens.sm,
              children: [
                if (widget.streak > 0)
                  _DynamicBadge(
                    icon: Icons.local_fire_department_rounded,
                    label: '${widget.streak} win streak',
                    color: c.success,
                  ),
                if (widget.rankChange != 0)
                  _DynamicBadge(
                    icon: Icons.bolt_rounded,
                    label: widget.rankChange > 0
                        ? 'Rank +${widget.rankChange} this week'
                        : 'Rank ${widget.rankChange} this week',
                    color: c.accent,
                  ),
              ],
            ),
            const SizedBox(height: SpacingTokens.xxl),
            // CTA with radial glow
            Stack(
              alignment: Alignment.center,
              children: [
                // Blue-purple radial glow behind button
                Container(
                  width: double.infinity,
                  height: 88,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.4,
                      colors: [
                        c.primary.withValues(alpha: 0.10),
                        c.accent.withValues(alpha: 0.04),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Primary CTA
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    label: 'Quick Duel',
                    size: ButtonSize.lg,
                    onPressed: widget.onStartDuel,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Small pill badge showing dynamic status (streak, rank change).
class _DynamicBadge extends StatelessWidget {
  const _DynamicBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.md,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: RadiusTokens.pill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: SpacingTokens.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
