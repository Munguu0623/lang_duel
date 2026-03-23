import 'package:flutter/material.dart';
import 'package:voice_duel/core/theme/app_theme.dart';
import 'package:voice_duel/core/data/stages.dart';

/// Level selector screen — shown as the entry point of the game flow.
///
/// Displays CEFR levels (A1, A2, ...) as large tap-able cards.
/// A1 is unlocked and navigates via [onSelectA1].
/// Other levels are locked with a "Coming soon" state.
class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({
    super.key,
    required this.onSelectA1,
    this.a1StagesCompleted = 0,
    this.a1TotalStars = 0,
  });

  final VoidCallback onSelectA1;
  final int a1StagesCompleted;
  final int a1TotalStars;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.bgGradient),
      child: Column(
        children: [
          const _Header(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              children: [
                // ── A1 — Unlocked ──
                _UnlockedLevelCard(
                  level: 'A1',
                  title: 'Beginner',
                  description:
                      'Мэндчилгээ · Гэр бүл · Өдөр тутам · Хоол · Сургууль',
                  emoji: '🌱',
                  stagesCompleted: a1StagesCompleted,
                  totalStages: a1Stages.length,
                  totalStars: a1TotalStars,
                  maxStars: a1Stages.length * 3,
                  onTap: onSelectA1,
                ),

                const SizedBox(height: AppSpacing.md),

                // ── A2 — Locked ──
                const _LockedLevelCard(
                  level: 'A2',
                  title: 'Elementary',
                  description:
                      'Shopping · Travel · Work · Opinions · Culture',
                  emoji: '🌿',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ───────────────────────────────────────────
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, Color(0xFF4834D4)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: AppSpacing.xl,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Түвшин сонгох',
                  style: AppText.displayMd.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'CEFR-ийн дагуу Англи хэлний сэдэв',
                  style: AppText.bodySm.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          const Text('🎓', style: TextStyle(fontSize: 36)),
        ],
      ),
    );
  }
}

// ── Unlocked Level Card ──────────────────────────────
class _UnlockedLevelCard extends StatelessWidget {
  const _UnlockedLevelCard({
    required this.level,
    required this.title,
    required this.description,
    required this.emoji,
    required this.stagesCompleted,
    required this.totalStages,
    required this.totalStars,
    required this.maxStars,
    required this.onTap,
  });

  final String level;
  final String title;
  final String description;
  final String emoji;
  final int stagesCompleted;
  final int totalStages;
  final int totalStars;
  final int maxStars;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xFF4834D4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level,
                      style: AppText.displayLg.copyWith(
                        color: AppColors.white,
                        fontSize: 52,
                      ),
                    ),
                    _LevelBadge(label: title.toUpperCase()),
                  ],
                ),
                const Spacer(),
                Text(emoji, style: const TextStyle(fontSize: 56)),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              description,
              style: AppText.bodySm.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // ── Stats row ──
            Row(
              children: [
                _InfoPill(
                  icon: '📚',
                  label: '$stagesCompleted/$totalStages stage',
                ),
                const SizedBox(width: AppSpacing.sm),
                _InfoPill(
                  icon: '⭐',
                  label: '$totalStars/$maxStars од',
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // ── Progress bar ──
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: LinearProgressIndicator(
                value: totalStages > 0 ? stagesCompleted / totalStages : 0,
                minHeight: 7,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation(AppColors.accent),
              ),
            ),

            const SizedBox(height: AppSpacing.base),

            // ── Play button ──
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(AppRadius.base),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '▶   ТОГЛОХ',
                style: AppText.headingMd.copyWith(
                  color: AppColors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Locked Level Card ────────────────────────────────
class _LockedLevelCard extends StatelessWidget {
  const _LockedLevelCard({
    required this.level,
    required this.title,
    required this.description,
    required this.emoji,
  });

  final String level;
  final String title;
  final String description;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF636E72), Color(0xFF2D3436)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level,
                      style: AppText.displayLg.copyWith(
                        color: AppColors.white,
                        fontSize: 52,
                      ),
                    ),
                    _LevelBadge(
                      label: title.toUpperCase(),
                      color: Colors.white24,
                      textColor: Colors.white54,
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 56)),
                    const SizedBox(height: 4),
                    const Icon(
                      Icons.lock_rounded,
                      color: Colors.white38,
                      size: 22,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              description,
              style: AppText.bodySm.copyWith(color: Colors.white38),
            ),

            const SizedBox(height: AppSpacing.base),

            // ── Locked button ──
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(AppRadius.base),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lock_rounded,
                    color: Colors.white38,
                    size: 16,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'УДАХГҮЙ НЭЭГДЭНЭ',
                    style: AppText.headingSm.copyWith(
                      color: Colors.white38,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared small widgets ─────────────────────────────

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({
    required this.label,
    this.color,
    this.textColor,
  });

  final String label;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color ?? Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppText.label.copyWith(
          color: textColor ?? AppColors.white,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppText.bodySm.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
