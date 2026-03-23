import 'package:flutter/material.dart';
import 'package:voice_duel/core/theme/app_theme.dart';
import 'package:voice_duel/core/data/stages.dart';
import 'package:voice_duel/features/map/widgets/map_decorations.dart';
import 'package:voice_duel/features/map/widgets/map_path_painter.dart';
import 'package:voice_duel/features/map/widgets/stage_node.dart';
import 'package:voice_duel/features/map/widgets/stage_detail_sheet.dart';

/// Candy Crush-style level map screen.
///
/// Displays all stages in a zigzag scrollable path with:
/// - Gradient background zones (sky → forest)
/// - Floating clouds, trees, sparkles
/// - Curved path lines connecting nodes
/// - Stage nodes with state-dependent styling
class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({
    super.key,
    required this.currentStage,
    required this.stageStars,
    required this.onPlayStage,
  });

  final int currentStage;

  /// Map of stageId → number of stars earned (0–3).
  final Map<int, int> stageStars;

  /// Called when user taps "START DUEL" on the detail sheet.
  final ValueChanged<Stage> onPlayStage;

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {
  final _scrollCtrl = ScrollController();
  final _stages = a1Stages;

  int get _totalStars =>
      widget.stageStars.values.fold(0, (a, b) => a + b);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToActive());
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToActive() {
    final index = widget.currentStage - 1;
    if (index < 0 || index >= _stages.length) return;
    final targetY = index * StagePositions.nodeSpacing - 150;
    _scrollCtrl.animateTo(
      targetY.clamp(0, _scrollCtrl.position.maxScrollExtent),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );
  }

  void _onStageTap(Stage stage) {
    showStageDetail(
      context,
      stage: stage,
      stars: widget.stageStars[stage.id] ?? 0,
      onPlay: () => widget.onPlayStage(stage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapHeight = _stages.length * StagePositions.nodeSpacing + 80.0;

    return Container(
      color: const Color(0xFF1A1A2E),
      child: Column(
        children: [
          // ── Header ──
          _MapHeader(
            currentStage: widget.currentStage,
            totalStages: _stages.length,
            totalStars: _totalStars,
            maxStars: _stages.length * 3,
          ),

          // ── Scrollable Map ──
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollCtrl,
              padding: EdgeInsets.zero,
              child: SizedBox(
                height: mapHeight,
                child: LayoutBuilder(builder: (context, constraints) {
                  final w = constraints.maxWidth;

                  return Stack(
                    children: [
                      // ── Background gradient zones ──
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: mapHeight * 0.5,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF74B9FF),
                                Color(0xFFA29BFE),
                                Color(0xFF81ECEC),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: mapHeight * 0.5,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF81ECEC),
                                Color(0xFF55EFC4),
                                Color(0xFF00B894),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // ── Decorative clouds ──
                      Positioned(left: w * 0.08, top: 50,  child: const CloudDecoration(size: 0.9, opacity: 0.55)),
                      Positioned(left: w * 0.65, top: 120, child: const CloudDecoration(size: 0.7, opacity: 0.35)),
                      Positioned(left: w * 0.03, top: 260, child: const CloudDecoration(size: 1.0, opacity: 0.45)),
                      Positioned(left: w * 0.72, top: 360, child: const CloudDecoration(size: 0.6, opacity: 0.30)),
                      Positioned(left: w * 0.12, top: 480, child: const CloudDecoration(size: 0.8, opacity: 0.25)),

                      // ── Trees & plants ──
                      Positioned(left: w * 0.06, top: 530, child: const TreeDecoration(type: 0)),
                      Positioned(left: w * 0.85, top: 580, child: const TreeDecoration(type: 1)),
                      Positioned(left: w * 0.10, top: 690, child: const TreeDecoration(type: 2)),
                      Positioned(left: w * 0.80, top: 740, child: const TreeDecoration(type: 0)),
                      Positioned(left: w * 0.04, top: 840, child: const TreeDecoration(type: 1)),
                      Positioned(left: w * 0.88, top: 890, child: const TreeDecoration(type: 2)),

                      // ── Sparkles near boss stages ──
                      Positioned(left: w * 0.35, top: 475, child: const SparkleDecoration()),
                      Positioned(left: w * 0.58, top: 500, child: const SparkleDecoration()),
                      Positioned(left: w * 0.36, top: 940, child: const SparkleDecoration()),
                      Positioned(left: w * 0.55, top: 960, child: const SparkleDecoration()),

                      // ── Ground at bottom ──
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                const Color(0xFF27AE60).withOpacity(0.3),
                              ],
                            ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(100),
                            ),
                          ),
                        ),
                      ),

                      // ── Connecting path lines ──
                      CustomPaint(
                        size: Size(w, mapHeight),
                        painter: MapPathPainter(
                          stageCount: _stages.length,
                          currentStage: widget.currentStage,
                          containerWidth: w,
                        ),
                      ),

                      // ── Stage nodes ──
                      for (int i = 0; i < _stages.length; i++)
                        Positioned(
                          top: i * StagePositions.nodeSpacing + 10,
                          left: StagePositions.xFraction(i) * w - 55,
                          width: 110,
                          child: StageNode(
                            stage: _stages[i],
                            currentStage: widget.currentStage,
                            stars: widget.stageStars[_stages[i].id] ?? 0,
                            onTap: () => _onStageTap(_stages[i]),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ───────────────────────────────────────────
class _MapHeader extends StatelessWidget {
  const _MapHeader({
    required this.currentStage,
    required this.totalStages,
    required this.totalStars,
    required this.maxStars,
  });

  final int currentStage;
  final int totalStages;
  final int totalStars;
  final int maxStars;

  @override
  Widget build(BuildContext context) {
    final done = (currentStage - 1).clamp(0, totalStages);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF4834D4)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 14,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'A1 — Beginner',
                    style: TextStyle(
                      fontFamily: 'Lilita One',
                      fontSize: 20,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$done/$totalStages дууссан',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Text('⭐ ', style: TextStyle(fontSize: 14)),
                    Text(
                      '$totalStars/$maxStars',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: done / totalStages,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor:
                  const AlwaysStoppedAnimation(AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}
