import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/motion/motion.dart';
import '../../../core/theme/tokens.dart';
import '../../../mock/fake_models.dart';
import '../../../ui/widgets/duel_avatar.dart';
import '../../../ui/widgets/primary_button.dart';
import '../../../ui/widgets/soft_card.dart';

/// SCREEN 1 — Free user result screen with locked premium metrics.
class FreeResultScreen extends StatefulWidget {
  const FreeResultScreen({
    super.key,
    required this.result,
    required this.opponent,
    required this.onUnlockPro,
    required this.onMaybeLater,
  });

  final DuelResult result;
  final DuelUser opponent;
  final VoidCallback onUnlockPro;
  final VoidCallback onMaybeLater;

  @override
  State<FreeResultScreen> createState() => _FreeResultScreenState();
}

class _FreeResultScreenState extends State<FreeResultScreen>
    with TickerProviderStateMixin {
  late final AnimationController _headerAnim;
  late final AnimationController _cardsAnim;
  late final AnimationController _ctaAnim;

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _cardsAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _ctaAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    Future.microtask(() async {
      _headerAnim.forward();
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      _cardsAnim.forward();
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      _ctaAnim.forward();
    });
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    _cardsAnim.dispose();
    _ctaAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isWin = widget.result.isWin;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.base),
          child: Column(
            children: [
              const SizedBox(height: SpacingTokens.xl),

              // ── Result banner ──
              FadeTransition(
                opacity: CurvedAnimation(
                  parent: _headerAnim,
                  curve: Curves.easeOut,
                ),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _headerAnim,
                    curve: Curves.easeOut,
                  )),
                  child: Column(
                    children: [
                      // Result icon
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
                        isWin ? 'You Won!' : 'You Lost',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: isWin ? c.success : c.danger,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.xl),

                      // Score card
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: SpacingTokens.base),

              // ── Locked metric cards ──
              FadeTransition(
                opacity: CurvedAnimation(
                  parent: _cardsAnim,
                  curve: Curves.easeOut,
                ),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.08),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _cardsAnim,
                    curve: Curves.easeOut,
                  )),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _LockedMetricCard(
                              icon: Icons.record_voice_over_rounded,
                              label: 'Pronunciation',
                              score: widget.result.userBreakdown.pronunciation,
                            ),
                          ),
                          const SizedBox(width: SpacingTokens.md),
                          Expanded(
                            child: _LockedMetricCard(
                              icon: Icons.spellcheck_rounded,
                              label: 'Grammar',
                              score: widget.result.userBreakdown.grammar,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SpacingTokens.md),
                      Row(
                        children: [
                          Expanded(
                            child: _LockedMetricCard(
                              icon: Icons.speed_rounded,
                              label: 'Fluency',
                              score: widget.result.userBreakdown.fluency,
                            ),
                          ),
                          const SizedBox(width: SpacingTokens.md),
                          Expanded(
                            child: _LockedMetricCard(
                              icon: Icons.auto_stories_rounded,
                              label: 'Vocabulary',
                              score: widget.result.userBreakdown.vocabulary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: SpacingTokens.xl),

              // ── CTA section ──
              FadeTransition(
                opacity: CurvedAnimation(
                  parent: _ctaAnim,
                  curve: Curves.easeOut,
                ),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _ctaAnim,
                    curve: Curves.easeOut,
                  )),
                  child: Column(
                    children: [
                      // AI coaching banner
                      SoftCard(
                        onTap: widget.onUnlockPro,
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: c.primaryLight,
                                borderRadius: RadiusTokens.small,
                              ),
                              child: Icon(
                                Icons.auto_awesome_rounded,
                                size: 20,
                                color: c.primary,
                              ),
                            ),
                            const SizedBox(width: SpacingTokens.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Unlock AI Coaching',
                                    style: TextStyles.titleMedium
                                        .copyWith(color: c.textPrimary),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'See detailed analysis, pronunciation feedback and improvement tips.',
                                    style: TextStyles.caption
                                        .copyWith(color: c.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: c.primary,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.lg),

                      // Unlock Pro button
                      PrimaryButton(
                        label: 'Unlock Pro',
                        size: ButtonSize.lg,
                        onPressed: widget.onUnlockPro,
                      ),
                      const SizedBox(height: SpacingTokens.base),

                      // Maybe later
                      GestureDetector(
                        onTap: widget.onMaybeLater,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: SpacingTokens.sm),
                          child: Text(
                            'Maybe later',
                            style: TextStyles.bodyMedium
                                .copyWith(color: c.textSecondary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: SpacingTokens.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

/// Score column showing avatar + name + animated score.
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

/// Locked metric card with blur effect and lock icon.
class _LockedMetricCard extends StatelessWidget {
  const _LockedMetricCard({
    required this.icon,
    required this.label,
    required this.score,
  });

  final IconData icon;
  final String label;
  final int score;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(SpacingTokens.base),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: RadiusTokens.card,
        border: Border.all(color: c.border),
        boxShadow: context.softShadow,
      ),
      child: Stack(
        children: [
          // Blurred content
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 24, color: c.primary),
                const SizedBox(height: SpacingTokens.md),
                Text(
                  '$score',
                  style: TextStyles.statLarge.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: SpacingTokens.xs),
                Text(
                  label,
                  style: TextStyles.caption.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),

          // Lock overlay
          Positioned.fill(
            child: Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: c.surface.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  border: Border.all(color: c.border),
                ),
                child: Icon(
                  Icons.lock_rounded,
                  size: 20,
                  color: c.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
