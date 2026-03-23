import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_duel/core/theme/app_theme.dart';
import 'package:voice_duel/core/router/app_router.dart';
import 'package:voice_duel/core/models/models.dart';
import 'package:voice_duel/core/providers/app_providers.dart';
import 'package:voice_duel/core/data/stages.dart';
import 'package:voice_duel/core/widgets/shared_widgets.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 🏠 Home Screen — main hub, start duel, pick level
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final dailyCount = ref.watch(dailyDuelCountProvider);
    final canPlay = ref.watch(canPlayDuelProvider);
    final currentStage = ref.watch(currentStageProvider);
    final stageStars = ref.watch(stageStarsProvider);

    if (user == null) return const SizedBox.shrink();

    final completed = (currentStage - 1).clamp(0, a1Stages.length);
    final totalStars = stageStars.values.fold(0, (a, b) => a + b);

    return Scaffold(
      body: Column(
        children: [
          // ── Header ──
          _Header(user: user, dailyCount: dailyCount),

          // ── Scrollable Content ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                // ── Start Duel Button ──
                _StartDuelCard(
                  canPlay: canPlay,
                  onTap: () => context.push(AppRoutes.matchmaking),
                ),

                const SizedBox(height: AppSpacing.xl),

                // ── Level Selection ──
                Text('🎮 Түвшин сонгон тоглох', style: AppText.headingMd),
                const SizedBox(height: AppSpacing.md),

                // A1 — Unlocked
                _A1LevelCard(
                  stagesCompleted: completed,
                  totalStages: a1Stages.length,
                  totalStars: totalStars,
                  maxStars: a1Stages.length * 3,
                  onTap: () => context.push(AppRoutes.gameHub),
                ),

                const SizedBox(height: AppSpacing.sm),

                // A2 — Locked
                const _A2LockedCard(),

                const SizedBox(height: AppSpacing.xl),

                // ── Quick Stats ──
                Text('📊 Миний статистик', style: AppText.headingMd),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    _StatTile(
                      label: 'Нийт',
                      value: '${user.totalDuels}',
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _StatTile(
                      label: 'Ялалт',
                      value: '${user.wins}',
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _StatTile(
                      label: 'Win Rate',
                      value: '${user.winRate.toStringAsFixed(0)}%',
                      color: AppColors.accent,
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header with gradient ─────────────────────────────
class _Header extends StatelessWidget {
  const _Header({required this.user, required this.dailyCount});

  final dynamic user;
  final int dailyCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Column(
        children: [
          // User row
          Row(
            children: [
              AppAvatar(size: 40, emoji: user.emoji, color: AppColors.accent),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: AppText.headingSm.copyWith(color: AppColors.white),
                    ),
                    Text(
                      '${user.tier.label} · Level ${user.level}',
                      style: AppText.bodySm
                          .copyWith(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
              _HeaderChip(icon: '🔥', value: '${user.streak}'),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Row(
                  children: [
                    const CoinIcon(size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${user.coins}',
                      style: AppText.headingSm
                          .copyWith(color: AppColors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Daily progress
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppRadius.base),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Өнөөдрийн duel: $dailyCount/3',
                      style: AppText.bodySm.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '🆓 Үнэгүй',
                      style: AppText.bodySm.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                AppProgressBar(
                  value: dailyCount.toDouble(),
                  max: 3,
                  color: AppColors.accent,
                  height: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({required this.icon, required this.value});
  final String icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            value,
            style: AppText.headingSm.copyWith(color: AppColors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ── Start Duel CTA Card ──────────────────────────────
class _StartDuelCard extends StatelessWidget {
  const _StartDuelCard({required this.canPlay, required this.onTap});
  final bool canPlay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canPlay ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          gradient: AppColors.dangerGradient,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentOrange.withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text('⚔️', style: TextStyle(fontSize: 42)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'START DUEL',
              style: AppText.displayMd.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: 4),
            Text(
              canPlay
                  ? 'Bot-той тэмцээд оноо цуглуул!'
                  : 'Өнөөдрийн лимит дууссан — Premium болох?',
              style: AppText.bodySm.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

// ── A1 Level Card — Unlocked ─────────────────────────
class _A1LevelCard extends StatelessWidget {
  const _A1LevelCard({
    required this.stagesCompleted,
    required this.totalStages,
    required this.totalStars,
    required this.maxStars,
    required this.onTap,
  });

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
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xFF4834D4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Left: level label ──
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A1',
                  style: AppText.displayLg.copyWith(
                    color: AppColors.white,
                    fontSize: 42,
                  ),
                ),
                const _LevelBadge('BEGINNER'),
              ],
            ),

            const SizedBox(width: AppSpacing.md),

            // ── Middle: progress ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Мэндчилгээ · Гэр бүл · Өдөр тутам',
                    style: AppText.bodySm.copyWith(
                      color: Colors.white.withOpacity(0.75),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      _InfoPill('📚 $stagesCompleted/$totalStages'),
                      const SizedBox(width: AppSpacing.xs),
                      _InfoPill('⭐ $totalStars/$maxStars'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: LinearProgressIndicator(
                      value: totalStages > 0
                          ? stagesCompleted / totalStages
                          : 0,
                      minHeight: 6,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.accent),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // ── Right: emoji + play ──
            Column(
              children: [
                const Text('🌱', style: TextStyle(fontSize: 32)),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    '▶ ТОГЛОХ',
                    style: AppText.label.copyWith(
                      color: AppColors.white,
                      letterSpacing: 1,
                    ),
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

// ── A2 Level Card — Locked ───────────────────────────
class _A2LockedCard extends StatelessWidget {
  const _A2LockedCard();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF636E72), Color(0xFF2D3436)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            // ── Left: level label ──
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A2',
                  style: AppText.displayLg.copyWith(
                    color: AppColors.white,
                    fontSize: 42,
                  ),
                ),
                const _LevelBadge(
                  'ELEMENTARY',
                  color: Colors.white24,
                  textColor: Colors.white54,
                ),
              ],
            ),

            const SizedBox(width: AppSpacing.md),

            // ── Middle: description ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shopping · Travel · Work · Opinions',
                    style: AppText.bodySm.copyWith(color: Colors.white38),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(
                        Icons.lock_rounded,
                        color: Colors.white38,
                        size: 14,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Удахгүй нээгдэнэ',
                        style: AppText.bodySm.copyWith(color: Colors.white38),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // ── Right: emoji + lock ──
            const Column(
              children: [
                Text('🌿', style: TextStyle(fontSize: 32)),
                SizedBox(height: AppSpacing.sm),
                Icon(Icons.lock_rounded, color: Colors.white38, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stat Tile ────────────────────────────────────────
class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(value, style: AppText.displaySm.copyWith(color: color)),
            const SizedBox(height: 2),
            Text(label, style: AppText.label),
          ],
        ),
      ),
    );
  }
}

// ── Shared micro-widgets ─────────────────────────────

class _LevelBadge extends StatelessWidget {
  const _LevelBadge(this.label, {this.color, this.textColor});
  final String label;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color ?? Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppText.label.copyWith(
          color: textColor ?? AppColors.white,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppText.label.copyWith(color: AppColors.white),
      ),
    );
  }
}
