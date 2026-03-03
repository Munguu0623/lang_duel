import 'package:flutter/material.dart';

import '../../../core/motion/motion.dart';
import '../../../core/theme/tokens.dart';
import '../../../mock/fake_models.dart';
import '../../../ui/widgets/duel_avatar.dart';
import '../../../ui/widgets/haptics.dart';
import '../../../ui/widgets/primary_button.dart';
import '../../../ui/widgets/soft_card.dart';
import '../../../ui/widgets/top_bar.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.result,
    required this.opponent,
    required this.onRematch,
    required this.onHome,
  });

  final DuelResult result;
  final DuelUser opponent;
  final VoidCallback onRematch;
  final VoidCallback onHome;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _showHeader = false;
  bool _showBreakdown = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      setState(() {
        _showHeader = true;
      });
      Future.delayed(const Duration(milliseconds: 160), () {
        if (!mounted) return;
        setState(() {
          _showBreakdown = true;
        });
      });
      if (widget.result.isWin) {
        Haptics.success();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isWin = widget.result.isWin;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.base),
        child: Column(
          children: [
            TopBar(
              title: 'Result',
              onBack: widget.onHome,
            ),
            const SizedBox(height: SpacingTokens.xl),

            // Outcome badge + title
            AnimatedOpacity(
              duration: MotionDurations.med,
              opacity: _showHeader ? 1 : 0,
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: (isWin ? c.success : c.danger)
                          .withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isWin
                          ? Icons.emoji_events_rounded
                          : Icons.sentiment_dissatisfied_rounded,
                      size: 40,
                      color: isWin ? c.success : c.danger,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.base),
                  Text(
                    isWin ? 'Victory!' : 'Defeat',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: isWin ? c.success : c.danger,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SpacingTokens.xl),

            // Score comparison card
            SoftCard(
              child: Row(
                children: [
                  Expanded(
                    child: _ScoreColumn(
                      label: 'You',
                      score: widget.result.userScore,
                    ),
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
                      label: widget.opponent.name.split(' ').first,
                      score: widget.result.opponentScore,
                      avatarName: widget.opponent.name,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SpacingTokens.base),

            // Score breakdown
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Score Breakdown',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: SpacingTokens.base),
                  AnimatedSwitcher(
                    duration: MotionDurations.slow,
                    child: _showBreakdown
                        ? Column(
                            key: const ValueKey('breakdown'),
                            children: [
                              _ScoreRow(
                                label: 'Pronunciation',
                                userScore: widget
                                    .result.userBreakdown.pronunciation,
                                opponentScore: widget
                                    .result.opponentBreakdown.pronunciation,
                              ),
                              const SizedBox(height: SpacingTokens.md),
                              _ScoreRow(
                                label: 'Grammar',
                                userScore:
                                    widget.result.userBreakdown.grammar,
                                opponentScore: widget
                                    .result.opponentBreakdown.grammar,
                              ),
                              const SizedBox(height: SpacingTokens.md),
                              _ScoreRow(
                                label: 'Fluency',
                                userScore:
                                    widget.result.userBreakdown.fluency,
                                opponentScore: widget
                                    .result.opponentBreakdown.fluency,
                              ),
                              const SizedBox(height: SpacingTokens.md),
                              _ScoreRow(
                                label: 'Vocabulary',
                                userScore:
                                    widget.result.userBreakdown.vocabulary,
                                opponentScore: widget
                                    .result.opponentBreakdown.vocabulary,
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SpacingTokens.xl),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      onPressed: widget.onHome,
                      style: OutlinedButton.styleFrom(
                        shape: const StadiumBorder(),
                        side: BorderSide(color: c.border),
                      ),
                      child: Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: c.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: SpacingTokens.md),
                Expanded(
                  child: PrimaryButton(
                    label: 'Rematch',
                    onPressed: widget.onRematch,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SpacingTokens.xxl),
          ],
        ),
      ),
    );
  }
}

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
        Text(label, style: TextStyles.caption.copyWith(color: c.textSecondary)),
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

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({
    required this.label,
    required this.userScore,
    required this.opponentScore,
  });

  final String label;
  final int userScore;
  final int opponentScore;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: TextStyles.bodyMedium.copyWith(color: c.textSecondary)),
            const Spacer(),
            Text(
              '$userScore',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: c.primary,
              ),
            ),
            Text(
              ' / $opponentScore',
              style: TextStyles.caption.copyWith(color: c.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: SpacingTokens.xs),
        ClipRRect(
          borderRadius: RadiusTokens.small,
          child: SizedBox(
            height: 6,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: userScore / 25),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              builder: (_, value, _) => LinearProgressIndicator(
                value: value,
                backgroundColor: c.surfaceSecondary,
                valueColor: AlwaysStoppedAnimation<Color>(c.primary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
