import 'package:flutter/material.dart';
import 'package:voice_duel/core/theme/app_theme.dart';
import 'package:voice_duel/core/data/stages.dart';

/// Game hub screen — shows A1 progress, next stage CTA, and completed stages.
///
/// Navigation:
/// - "Дараагийн үе" card → [onGoToMap]
class GameHubScreen extends StatelessWidget {
  const GameHubScreen({
    super.key,
    required this.currentStage,
    required this.stageStars,
    required this.coins,
    required this.streak,
    required this.onGoToMap,
  });

  final int currentStage;
  final Map<int, int> stageStars;
  final int coins;
  final int streak;
  final VoidCallback onGoToMap;

  int get _totalStars => stageStars.values.fold(0, (a, b) => a + b);
  int get _completedCount => (currentStage - 1).clamp(0, a1Stages.length);

  @override
  Widget build(BuildContext context) {
    final nextStage = currentStage <= a1Stages.length
        ? a1Stages[currentStage - 1]
        : null;

    return Container(
      color: AppColors.lightBg,
      child: Column(
        children: [
          // ── Header ──
          _GameHubHeader(
            currentStage: currentStage,
            coins: coins,
            streak: streak,
          ),

          // ── Content ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                // ── Next Stage CTA ──
                if (nextStage != null)
                  _NextStageCta(stage: nextStage, onTap: onGoToMap),

                const SizedBox(height: AppSpacing.base),

                // ── A1 Progress Card ──
                _ProgressCard(
                  completed: _completedCount,
                  total: a1Stages.length,
                  totalStars: _totalStars,
                ),

                const SizedBox(height: AppSpacing.base),

                // ── Completed Stages ──
                Text('🏅 Давсан үе', style: AppText.headingMd),
                const SizedBox(height: AppSpacing.sm),

                if (_completedCount == 0)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Center(
                      child: Text(
                        'Анхны duel тоглоорой! 🎙️',
                        style: AppText.bodyMd.copyWith(
                          color: AppColors.darkSoft,
                        ),
                      ),
                    ),
                  )
                else
                  ...a1Stages
                      .where((s) => s.id < currentStage)
                      .toList()
                      .reversed
                      .map((st) => _CompletedStageTile(
                            stage: st,
                            stars: stageStars[st.id] ?? 0,
                          )),

                const SizedBox(height: AppSpacing.base),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ──────────────────────────────────────────
class _GameHubHeader extends StatelessWidget {
  const _GameHubHeader({
    required this.currentStage,
    required this.coins,
    required this.streak,
  });

  final int currentStage;
  final int coins;
  final int streak;

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
        top: MediaQuery.of(context).padding.top + 8,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: AppSpacing.lg,
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent,
              border: Border.all(color: Colors.white, width: 3),
            ),
            alignment: Alignment.center,
            child: const Text('😎', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Name + Level
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Player_MN',
                  style: AppText.headingSm.copyWith(color: AppColors.white),
                ),
                Text(
                  'A1 · Stage $currentStage/${a1Stages.length}',
                  style: AppText.bodySm.copyWith(
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),

          _HeaderChip(icon: '🔥', value: '$streak'),
          const SizedBox(width: AppSpacing.sm),
          _HeaderChip(icon: '🪙', value: '$coins'),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 3),
          Text(
            value,
            style: AppText.headingSm.copyWith(
              color: AppColors.white,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Next Stage CTA ───────────────────────────────────
class _NextStageCta extends StatelessWidget {
  const _NextStageCta({required this.stage, required this.onTap});
  final Stage stage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: stage.isBoss
                ? [AppColors.gold, AppColors.accentOrange]
                : [AppColors.accentOrange, AppColors.danger],
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentOrange.withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Row(
              children: [
                Text(stage.emoji, style: const TextStyle(fontSize: 34)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ДАРААГИЙН ҮЕ',
                        style: AppText.label.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        'Stage ${stage.id}: ${stage.title}',
                        style: AppText.displaySm.copyWith(
                          color: AppColors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        stage.isBoss
                            ? '⚔️ Boss Battle!'
                            : 'Дарж duel эхлүүл →',
                        style: AppText.bodySm.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
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

// ── A1 Progress Card ─────────────────────────────────
class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.completed,
    required this.total,
    required this.totalStars,
  });

  final int completed;
  final int total;
  final int totalStars;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('📊 A1 Ахиц', style: AppText.headingMd),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 12,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Явц',
                    style: AppText.headingSm.copyWith(fontSize: 12),
                  ),
                  Text(
                    '$completed/$total',
                    style: AppText.headingSm.copyWith(
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: LinearProgressIndicator(
                  value: completed / total,
                  minHeight: 8,
                  backgroundColor: AppColors.light,
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(icon: '⭐', value: '$totalStars', label: 'Нийт од'),
                  _StatItem(icon: '✅', value: '$completed', label: 'Давсан'),
                  _StatItem(
                    icon: '📌',
                    value: '${total - completed}',
                    label: 'Үлдсэн',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });
  final String icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$icon $value',
          style: AppText.displaySm.copyWith(fontSize: 18),
        ),
        Text(label, style: AppText.label),
      ],
    );
  }
}

// ── Completed Stage Tile ─────────────────────────────
class _CompletedStageTile extends StatelessWidget {
  const _CompletedStageTile({required this.stage, required this.stars});
  final Stage stage;
  final int stars;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(stage.emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Stage ${stage.id}: ${stage.title}',
              style: AppText.bodySm.copyWith(
                color: AppColors.dark,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              3,
              (i) => Icon(
                Icons.star_rounded,
                size: 14,
                color: i < stars ? AppColors.gold : AppColors.light,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
