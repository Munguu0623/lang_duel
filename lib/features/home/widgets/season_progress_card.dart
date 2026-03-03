import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../mock/fake_models.dart';

/// Season tier badge + progress bar + days remaining.
class SeasonProgressCard extends StatelessWidget {
  const SeasonProgressCard({
    super.key,
    required this.season,
  });

  final Season season;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
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
              // Tier badge
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: c.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shield_rounded,
                  size: 18,
                  color: c.primary,
                ),
              ),
              const SizedBox(width: SpacingTokens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${season.tier} tier',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Season ends in ${season.daysRemaining} days',
                      style: TextStyles.caption.copyWith(color: c.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: SpacingTokens.md),
          // Progress bar
          ClipRRect(
            borderRadius: RadiusTokens.pill,
            child: LinearProgressIndicator(
              value: season.progress,
              minHeight: 8,
              backgroundColor: c.surfaceSecondary,
              valueColor: AlwaysStoppedAnimation<Color>(c.primary),
            ),
          ),
          const SizedBox(height: SpacingTokens.xs),
          Text(
            '${(season.progress * 100).round()}% to next tier',
            style: TextStyles.caption.copyWith(color: c.textSecondary),
          ),
        ],
      ),
    );
  }
}
