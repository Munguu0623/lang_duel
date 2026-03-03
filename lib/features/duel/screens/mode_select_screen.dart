import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../ui/widgets/soft_card.dart';
import '../../../ui/widgets/top_bar.dart';

/// Duel mode selection — "Choose your battle".
/// Quick Duel is enabled, Entry Duel is disabled (coming soon).
class ModeSelectScreen extends StatelessWidget {
  const ModeSelectScreen({
    super.key,
    required this.onModeSelected,
    required this.onBack,
  });

  final ValueChanged<int> onModeSelected;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopBar(
              title: 'Choose your battle',
              onBack: onBack,
            ),
            const SizedBox(height: SpacingTokens.xl),
            // Quick Duel — enabled
            _ModeCard(
              icon: Icons.bolt_rounded,
              title: 'Quick Duel',
              subtitle: '60 seconds. AI judges. Fast-paced.',
              duration: '1:00',
              enabled: true,
              onTap: () => onModeSelected(10), // 10s for demo
            ),
            const SizedBox(height: SpacingTokens.md),
            // Entry Duel — disabled
            _ModeCard(
              icon: Icons.school_rounded,
              title: 'Entry Duel',
              subtitle: 'Practice mode for beginners.',
              duration: '2:00',
              enabled: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String duration;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = enabled ? c.primary : c.textSecondary;
    final opacity = enabled ? 1.0 : 0.5;

    return Opacity(
      opacity: opacity,
      child: SoftCard(
        onTap: enabled ? onTap : null,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: RadiusTokens.small,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: SpacingTokens.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title,
                          style: Theme.of(context).textTheme.titleLarge),
                      if (!enabled) ...[
                        const SizedBox(width: SpacingTokens.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: SpacingTokens.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: c.surfaceSecondary,
                            borderRadius: RadiusTokens.small,
                          ),
                          child: Text(
                            'Soon',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: c.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: SpacingTokens.xs),
                  Text(subtitle,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.md,
                vertical: SpacingTokens.xs,
              ),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: RadiusTokens.small,
              ),
              child: Text(
                duration,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: enabled ? c.textPrimary : c.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
