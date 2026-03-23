import 'package:flutter/material.dart';
import 'package:voice_duel/core/theme/app_theme.dart';
import 'package:voice_duel/core/data/stages.dart';

/// Bottom sheet that slides up when a stage node is tapped.
///
/// Shows stage details: emoji, title, topic prompt, star rules,
/// and the "START DUEL" / "BOSS BATTLE" button.
class StageDetailSheet extends StatelessWidget {
  const StageDetailSheet({
    super.key,
    required this.stage,
    required this.stars,
    required this.onPlay,
  });

  final Stage stage;
  final int stars;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final boss = stage.isBoss;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.light,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),

          // Emoji circle
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: boss
                    ? [AppColors.gold, AppColors.accentOrange]
                    : [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.info.withOpacity(0.1),
                      ],
              ),
              border: boss
                  ? Border.all(color: AppColors.gold, width: 3)
                  : null,
              boxShadow: boss
                  ? [
                      BoxShadow(
                        color: AppColors.gold.withOpacity(0.4),
                        blurRadius: 16,
                      )
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(stage.emoji, style: const TextStyle(fontSize: 30)),
          ),

          if (boss) ...[
            const SizedBox(height: 4),
            const Text('👑', style: TextStyle(fontSize: 18)),
          ],

          const SizedBox(height: 8),

          // Title
          Text(
            'Stage ${stage.id}: ${stage.title}',
            style: AppText.displaySm.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  Icons.star_rounded,
                  size: 24,
                  color: i < stars ? AppColors.gold : AppColors.light,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: boss
                  ? AppColors.gold.withOpacity(0.12)
                  : AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              stage.typeLabel,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: boss ? AppColors.accentOrange : AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Prompt preview
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.lightBg,
              borderRadius: BorderRadius.circular(14),
              border: Border(
                left: BorderSide(
                  color: boss ? AppColors.gold : AppColors.primary,
                  width: 4,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📝 Topic:',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkSoft,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '"${stage.prompt}"',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: AppColors.dark,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Star rules
          Row(
            children: [
              _StarRule(
                starNum: 1,
                title: 'Дуусгах',
                desc: 'Ялагдсан ч OK',
                earned: stars >= 1,
              ),
              const SizedBox(width: 6),
              _StarRule(
                starNum: 2,
                title: 'Ялах',
                desc: 'Bot-г ялах',
                earned: stars >= 2,
              ),
              const SizedBox(width: 6),
              _StarRule(
                starNum: 3,
                title: 'Төгс',
                desc: '85+ оноо',
                earned: stars >= 3,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Play button
          GestureDetector(
            onTap: onPlay,
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: boss
                      ? [AppColors.gold, AppColors.accentOrange]
                      : [AppColors.accentOrange, AppColors.danger],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (boss ? AppColors.gold : AppColors.accentOrange)
                        .withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // 3D bottom shadow
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0x25000000),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      boss ? '⚔️ BOSS BATTLE!' : '🎙️ START DUEL',
                      style: const TextStyle(
                        fontFamily: 'Lilita One',
                        fontSize: 17,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRule extends StatelessWidget {
  const _StarRule({
    required this.starNum,
    required this.title,
    required this.desc,
    required this.earned,
  });

  final int starNum;
  final String title;
  final String desc;
  final bool earned;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.accent.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              Icons.star_rounded,
              size: 18,
              color: earned ? AppColors.gold : AppColors.light,
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.dark,
              ),
            ),
            Text(
              desc,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: AppColors.darkSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows the stage detail bottom sheet.
void showStageDetail(
  BuildContext context, {
  required Stage stage,
  required int stars,
  required VoidCallback onPlay,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => StageDetailSheet(
      stage: stage,
      stars: stars,
      onPlay: () {
        Navigator.pop(context);
        onPlay();
      },
    ),
  );
}
