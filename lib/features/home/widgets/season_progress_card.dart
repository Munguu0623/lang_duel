import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../mock/fake_models.dart';

/// Season tier progression — modernized, game-like feel.
/// Squircle tier badge with gradient, thicker progress bar,
/// countdown tension with "X days left".
class SeasonProgressCard extends StatelessWidget {
  const SeasonProgressCard({
    super.key,
    required this.season,
  });

  final Season season;

  Color _tierColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'gold':
        return Palette.gold;
      case 'silver':
        return Palette.silver;
      case 'bronze':
        return Palette.bronze;
      case 'diamond':
        return Palette.accent;
      default:
        return Palette.silver;
    }
  }

  String _nextTier(String tier) {
    switch (tier.toLowerCase()) {
      case 'bronze':
        return 'Silver';
      case 'silver':
        return 'Gold';
      case 'gold':
        return 'Diamond';
      default:
        return 'Next';
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tierColor = _tierColor(season.tier);
    final nextTier = _nextTier(season.tier);
    final isUrgent = season.daysRemaining <= 7;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SpacingTokens.base),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: RadiusTokens.card,
        boxShadow: context.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Tier badge — squircle with gradient
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      tierColor,
                      tierColor.withValues(alpha: 0.6),
                    ],
                  ),
                  borderRadius: RadiusTokens.medium,
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: SpacingTokens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${season.tier} Tier',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Season 1',
                      style:
                          TextStyles.caption.copyWith(color: c.textTertiary),
                    ),
                  ],
                ),
              ),
              // Progress percentage
              Text(
                '${(season.progress * 100).round()}%',
                style: TextStyles.labelLarge.copyWith(color: c.primary),
              ),
            ],
          ),
          const SizedBox(height: SpacingTokens.base),
          // Progress bar — thicker, game-like
          ClipRRect(
            borderRadius: RadiusTokens.pill,
            child: LinearProgressIndicator(
              value: season.progress,
              minHeight: 10,
              backgroundColor: c.surfaceSecondary,
              valueColor: AlwaysStoppedAnimation<Color>(tierColor),
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          // Bottom row — next tier + countdown tension
          Row(
            children: [
              Text(
                'Next: $nextTier Tier',
                style: TextStyles.caption.copyWith(color: c.textSecondary),
              ),
              const Spacer(),
              Icon(
                Icons.timer_outlined,
                size: 14,
                color: isUrgent ? c.danger : c.textSecondary,
              ),
              const SizedBox(width: SpacingTokens.xs),
              Text(
                '${season.daysRemaining} days left',
                style: TextStyles.caption.copyWith(
                  color: isUrgent ? c.danger : c.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
