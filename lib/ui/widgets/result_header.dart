import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/tokens.dart';
import 'duel_avatar.dart';
import 'soft_card.dart';

/// Outcome of a duel for display purposes.
enum DuelOutcome { win, loss, draw }

/// Reusable result header — always shows win/loss/draw banner + score comparison.
///
/// Place this at the top of any result screen. It is a pure display widget
/// with no navigation logic, so the analysis section beneath it can swap
/// between locked / unlocked without affecting the header.
class ResultHeaderWidget extends StatelessWidget {
  const ResultHeaderWidget({
    super.key,
    required this.outcome,
    required this.userScore,
    required this.opponentScore,
    required this.opponentName,
    this.seasonInfo,
  });

  final DuelOutcome outcome;
  final int userScore;
  final int opponentScore;
  final String opponentName;

  /// Optional season label shown beneath the score card (e.g. "Gold III · 2 340 RP").
  final String? seasonInfo;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Column(
      children: [
        // ── Outcome icon ──
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _accentColor(c).withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(_icon, size: 40, color: _accentColor(c)),
        ),
        const SizedBox(height: SpacingTokens.base),

        // ── Outcome text ──
        Text(
          _label,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: _accentColor(c),
          ),
        ),
        const SizedBox(height: SpacingTokens.xl),

        // ── Score card ──
        SoftCard(
          child: Row(
            children: [
              Expanded(
                child: _ScoreColumn(label: 'You', score: userScore),
              ),
              Text(
                'vs',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: c.textSecondary,
                ),
              ),
              Expanded(
                child: _ScoreColumn(
                  label: opponentName.split(' ').first,
                  score: opponentScore,
                  avatarName: opponentName,
                ),
              ),
            ],
          ),
        ),

        // ── Optional season info ──
        if (seasonInfo != null) ...[
          const SizedBox(height: SpacingTokens.md),
          Text(
            seasonInfo!,
            style: TextStyles.caption.copyWith(color: c.textSecondary),
          ),
        ],
      ],
    );
  }

  // ── Helpers ──

  String get _label => switch (outcome) {
        DuelOutcome.win => 'You Won!',
        DuelOutcome.loss => 'You Lost',
        DuelOutcome.draw => 'Draw',
      };

  IconData get _icon => switch (outcome) {
        DuelOutcome.win => Icons.emoji_events_rounded,
        DuelOutcome.loss => Icons.sentiment_dissatisfied_rounded,
        DuelOutcome.draw => Icons.handshake_rounded,
      };

  Color _accentColor(AppColors c) => switch (outcome) {
        DuelOutcome.win => c.success,
        DuelOutcome.loss => c.danger,
        DuelOutcome.draw => c.warning,
      };
}

/// Score column showing avatar + name + animated count-up score.
class _ScoreColumn extends StatelessWidget {
  const _ScoreColumn({
    required this.label,
    required this.score,
    this.avatarName,
  });

  final String label;
  final int score;
  final String? avatarName;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        DuelAvatar(name: avatarName ?? label, size: 44),
        const SizedBox(height: SpacingTokens.xs),
        Text(
          label,
          style: TextStyles.caption.copyWith(color: c.textSecondary),
        ),
        const SizedBox(height: SpacingTokens.xs),
        CountUpText(
          value: score,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: c.textPrimary,
          ),
        ),
      ],
    );
  }
}
