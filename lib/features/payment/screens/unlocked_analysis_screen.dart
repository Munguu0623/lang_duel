import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../mock/fake_models.dart';
import '../../../ui/widgets/primary_button.dart';
import '../../../ui/widgets/soft_card.dart';

/// SCREEN 4 — Unlocked AI Analysis Screen.
class UnlockedAnalysisScreen extends StatefulWidget {
  const UnlockedAnalysisScreen({
    super.key,
    required this.result,
    required this.onStartNextDuel,
  });

  final DuelResult result;
  final VoidCallback onStartNextDuel;

  @override
  State<UnlockedAnalysisScreen> createState() => _UnlockedAnalysisScreenState();
}

class _UnlockedAnalysisScreenState extends State<UnlockedAnalysisScreen>
    with TickerProviderStateMixin {
  late final AnimationController _headerAnim;
  late final AnimationController _scoresAnim;
  late final AnimationController _insightsAnim;
  late final AnimationController _progressAnim;

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scoresAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _insightsAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _progressAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    Future.microtask(() async {
      _headerAnim.forward();
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      _scoresAnim.forward();
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      _insightsAnim.forward();
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      _progressAnim.forward();
    });
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    _scoresAnim.dispose();
    _insightsAnim.dispose();
    _progressAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final b = widget.result.userBreakdown;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: SpacingTokens.base),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: SpacingTokens.xl),
                    _fadeSlide(_headerAnim, child: _buildHeader(c)),
                    const SizedBox(height: SpacingTokens.xl),
                    _fadeSlide(_scoresAnim, child: _buildScoreBreakdown(c, b)),
                    const SizedBox(height: SpacingTokens.xl),
                    _fadeSlide(_insightsAnim, child: _buildInsights(c)),
                    const SizedBox(height: SpacingTokens.xl),
                    _fadeSlide(_progressAnim, child: _buildProgressSection(c)),
                    const SizedBox(height: SpacingTokens.xxl),
                  ],
                ),
              ),
            ),

            // ── Bottom CTA ──
            Container(
              padding: const EdgeInsets.all(SpacingTokens.base),
              decoration: BoxDecoration(
                color: c.background,
                border: Border(top: BorderSide(color: c.border)),
              ),
              child: SafeArea(
                top: false,
                child: PrimaryButton(
                  label: 'Start Next Duel',
                  size: ButtonSize.lg,
                  onPressed: widget.onStartNextDuel,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fadeSlide(AnimationController controller, {required Widget child}) {
    final curved =
        CurvedAnimation(parent: controller, curve: Curves.easeOut);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }

  Widget _buildHeader(AppColors c) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: c.primaryLight,
            borderRadius: RadiusTokens.small,
          ),
          child: Icon(
            Icons.auto_awesome_rounded,
            color: c.primary,
            size: 22,
          ),
        ),
        const SizedBox(width: SpacingTokens.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Analysis',
              style: TextStyles.headlineMedium.copyWith(color: c.textPrimary),
            ),
            Text(
              'Detailed performance breakdown',
              style: TextStyles.bodyMedium.copyWith(color: c.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreBreakdown(AppColors c, ScoreBreakdown b) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Score Breakdown',
            style: TextStyles.titleLarge.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: SpacingTokens.lg),
          _ScoreBar(
            label: 'Pronunciation',
            score: b.pronunciation,
            maxScore: 25,
            icon: Icons.record_voice_over_rounded,
            color: c.primary,
            animController: _scoresAnim,
          ),
          const SizedBox(height: SpacingTokens.base),
          _ScoreBar(
            label: 'Grammar',
            score: b.grammar,
            maxScore: 25,
            icon: Icons.spellcheck_rounded,
            color: c.accent,
            animController: _scoresAnim,
          ),
          const SizedBox(height: SpacingTokens.base),
          _ScoreBar(
            label: 'Fluency',
            score: b.fluency,
            maxScore: 25,
            icon: Icons.speed_rounded,
            color: c.success,
            animController: _scoresAnim,
          ),
          const SizedBox(height: SpacingTokens.base),
          _ScoreBar(
            label: 'Vocabulary',
            score: b.vocabulary,
            maxScore: 25,
            icon: Icons.auto_stories_rounded,
            color: c.warning,
            animController: _scoresAnim,
          ),
        ],
      ),
    );
  }

  Widget _buildInsights(AppColors c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Weak words
        SoftCard(
          leadingIcon: Icons.warning_amber_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weak Words',
                style: TextStyles.titleMedium.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: SpacingTokens.md),
              Wrap(
                spacing: SpacingTokens.sm,
                runSpacing: SpacingTokens.sm,
                children: ['nevertheless', 'consequently', 'furthermore', 'particularly']
                    .map((tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: SpacingTokens.md,
                            vertical: SpacingTokens.sm,
                          ),
                          decoration: BoxDecoration(
                            color: c.warning.withValues(alpha: 0.1),
                            borderRadius: RadiusTokens.pill,
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: c.warning,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: SpacingTokens.md),

        // Pronunciation mistakes
        SoftCard(
          leadingIcon: Icons.mic_off_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pronunciation Mistakes',
                style: TextStyles.titleMedium.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: SpacingTokens.md),
              _MistakeRow(word: 'thoroughly', issue: 'Stress on wrong syllable'),
              const SizedBox(height: SpacingTokens.sm),
              _MistakeRow(word: 'entrepreneur', issue: 'Missing final syllable'),
              const SizedBox(height: SpacingTokens.sm),
              _MistakeRow(word: 'specifically', issue: 'Vowel substitution in 2nd syllable'),
            ],
          ),
        ),
        const SizedBox(height: SpacingTokens.md),

        // AI suggestions
        SoftCard(
          leadingIcon: Icons.lightbulb_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Suggestions',
                style: TextStyles.titleMedium.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: SpacingTokens.md),
              _SuggestionItem(text: 'Practice linking words between sentences for smoother flow.'),
              const SizedBox(height: SpacingTokens.sm),
              _SuggestionItem(text: 'Use more varied vocabulary — try replacing "good" with specific adjectives.'),
              const SizedBox(height: SpacingTokens.sm),
              _SuggestionItem(text: 'Work on your intonation patterns for questions vs statements.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(AppColors c) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skill Improvement',
            style: TextStyles.titleLarge.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: SpacingTokens.xs),
          Text(
            'Based on your last 10 duels',
            style: TextStyles.caption.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: SpacingTokens.lg),
          _ProgressRow(label: 'Overall', progress: 0.72, change: '+8%', animController: _progressAnim),
          const SizedBox(height: SpacingTokens.md),
          _ProgressRow(label: 'Pronunciation', progress: 0.65, change: '+12%', animController: _progressAnim),
          const SizedBox(height: SpacingTokens.md),
          _ProgressRow(label: 'Grammar', progress: 0.78, change: '+5%', animController: _progressAnim),
          const SizedBox(height: SpacingTokens.md),
          _ProgressRow(label: 'Fluency', progress: 0.58, change: '+15%', animController: _progressAnim),
          const SizedBox(height: SpacingTokens.md),
          _ProgressRow(label: 'Vocabulary', progress: 0.82, change: '+3%', animController: _progressAnim),
        ],
      ),
    );
  }
}

/// Animated score bar.
class _ScoreBar extends StatelessWidget {
  const _ScoreBar({
    required this.label,
    required this.score,
    required this.maxScore,
    required this.icon,
    required this.color,
    required this.animController,
  });

  final String label;
  final int score;
  final int maxScore;
  final IconData icon;
  final Color color;
  final AnimationController animController;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final ratio = score / maxScore;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: SpacingTokens.sm),
            Text(
              label,
              style: TextStyles.bodyMedium.copyWith(color: c.textSecondary),
            ),
            const Spacer(),
            Text(
              '$score / $maxScore',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: c.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: SpacingTokens.sm),
        ClipRRect(
          borderRadius: RadiusTokens.small,
          child: SizedBox(
            height: 6,
            child: AnimatedBuilder(
              animation: animController,
              builder: (context, child) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: ratio * animController.value),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  builder: (_, value, _) => LinearProgressIndicator(
                    value: value,
                    backgroundColor: c.surfaceSecondary,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Pronunciation mistake row.
class _MistakeRow extends StatelessWidget {
  const _MistakeRow({required this.word, required this.issue});

  final String word;
  final String issue;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: c.danger,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: SpacingTokens.sm),
        Text(
          '"$word"',
          style: TextStyles.labelLarge.copyWith(color: c.textPrimary),
        ),
        const SizedBox(width: SpacingTokens.sm),
        Flexible(
          child: Text(
            '— $issue',
            style: TextStyles.caption.copyWith(color: c.textSecondary),
          ),
        ),
      ],
    );
  }
}

/// AI suggestion item.
class _SuggestionItem extends StatelessWidget {
  const _SuggestionItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Icon(Icons.arrow_forward_rounded, size: 14, color: c.primary),
        ),
        const SizedBox(width: SpacingTokens.sm),
        Expanded(
          child: Text(
            text,
            style: TextStyles.bodyMedium.copyWith(
              color: c.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

/// Animated progress row.
class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.progress,
    required this.change,
    required this.animController,
  });

  final String label;
  final double progress;
  final String change;
  final AnimationController animController;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyles.bodyMedium.copyWith(color: c.textSecondary),
            ),
            const Spacer(),
            Text(
              change,
              style: TextStyles.caption.copyWith(
                color: c.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: SpacingTokens.sm),
        ClipRRect(
          borderRadius: RadiusTokens.small,
          child: SizedBox(
            height: 6,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 800),
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
