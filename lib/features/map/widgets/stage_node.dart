import 'package:flutter/material.dart';
import 'package:voice_duel/core/theme/app_theme.dart';
import 'package:voice_duel/core/data/stages.dart';

/// A single stage node on the level map.
///
/// Renders as a gradient circle with state-dependent styling:
/// - Completed: green with checkmark and stars
/// - Current: orange with pulse animation and "ТОГЛОХ" label
/// - Locked: gray with lock icon
/// - Boss: gold with crown on top
class StageNode extends StatefulWidget {
  const StageNode({
    super.key,
    required this.stage,
    required this.currentStage,
    required this.stars,
    required this.onTap,
  });

  final Stage stage;
  final int currentStage;
  final int stars;
  final VoidCallback onTap;

  @override
  State<StageNode> createState() => _StageNodeState();
}

class _StageNodeState extends State<StageNode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;

  bool get _done => widget.stage.id < widget.currentStage;
  bool get _active => widget.stage.id == widget.currentStage;
  bool get _locked => widget.stage.id > widget.currentStage;
  bool get _boss => widget.stage.isBoss;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    if (_active) _pulseCtrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  double get _size => _boss ? 70 : 58;

  List<Color> get _gradientColors => _locked
      ? [const Color(0xFF636E72), const Color(0xFFB2BEC3)]
      : _boss
          ? [AppColors.gold, AppColors.accentOrange]
          : _done
              ? [AppColors.secondary, AppColors.cyan]
              : [AppColors.accentOrange, AppColors.danger];

  Color get _borderColor => _locked
      ? const Color(0xFF4A4A5A)
      : _boss
          ? const Color(0xFFE67E22)
          : _done
              ? const Color(0xFF00997A)
              : const Color(0xFFC0392B);

  Color get _shadowColor => _locked
      ? Colors.transparent
      : _boss
          ? AppColors.gold.withOpacity(0.5)
          : _done
              ? AppColors.secondary.withOpacity(0.4)
              : AppColors.accentOrange.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _locked ? null : widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Crown for boss
          if (_boss && !_locked) ...[
            const Text('👑', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 2),
          ],

          // Main node with pulse
          SizedBox(
            width: _size + 24,
            height: _size + 24,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Pulse ring (active only)
                if (_active)
                  FadeTransition(
                    opacity: Tween(begin: 0.8, end: 0.2).animate(
                      CurvedAnimation(
                          parent: _pulseCtrl, curve: Curves.easeInOut),
                    ),
                    child: ScaleTransition(
                      scale: Tween(begin: 1.0, end: 1.15).animate(
                        CurvedAnimation(
                            parent: _pulseCtrl, curve: Curves.easeInOut),
                      ),
                      child: Container(
                        width: _size + 18,
                        height: _size + 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.accentOrange.withOpacity(0.6),
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Node circle
                Container(
                  width: _size,
                  height: _size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: _gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(color: _borderColor, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: _shadowColor,
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                      const BoxShadow(
                        color: Color(0x25000000),
                        blurRadius: 4,
                        offset: Offset(0, -2),
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Top highlight
                      if (!_locked)
                        Positioned(
                          top: 4,
                          child: Container(
                            width: _size * 0.55,
                            height: _size * 0.25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withOpacity(0.4),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),

                      // Icon / State
                      _locked
                          ? Icon(Icons.lock_rounded,
                              size: 20,
                              color: Colors.white.withOpacity(0.5))
                          : _done
                              ? const Icon(Icons.check_rounded,
                                  size: 22, color: Colors.white)
                              : Text(
                                  widget.stage.emoji,
                                  style: TextStyle(
                                    fontSize: _boss ? 26 : 22,
                                    shadows: const [
                                      Shadow(
                                        color: Color(0x40000000),
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                    ],
                  ),
                ),

                // Number badge
                Positioned(
                  top: _active ? 3 : 0,
                  right: _active ? 3 : 0,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _locked
                          ? const Color(0xFF4A4A5A)
                          : _boss
                              ? AppColors.gold
                              : AppColors.primary,
                      border: Border.all(color: Colors.white, width: 2.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x30000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${widget.stage.id}',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Title
          const SizedBox(height: 2),
          SizedBox(
            width: 90,
            child: Text(
              widget.stage.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: _locked ? Colors.white.withOpacity(0.3) : Colors.white,
                shadows: _locked
                    ? null
                    : const [
                        Shadow(
                          color: Color(0x50000000),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
              ),
            ),
          ),

          // Stars (completed only)
          if (_done) ...[
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final filled = i < widget.stars;
                return Icon(
                  Icons.star_rounded,
                  size: 14,
                  color: filled
                      ? AppColors.gold
                      : Colors.white.withOpacity(0.25),
                );
              }),
            ),
          ],

          // "ТОГЛОХ" badge (active only)
          if (_active) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
              child: Text(
                _boss ? '⚔️ BOSS' : '▶ ТОГЛОХ',
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
