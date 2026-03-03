import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/motion/motion.dart';
import '../../../core/theme/tokens.dart';
import '../../../mock/fake_data.dart';
import '../../../mock/fake_models.dart';
import '../../../ui/widgets/duel_avatar.dart';
import '../../../ui/widgets/haptics.dart';
import '../../../ui/widgets/top_bar.dart';

class OpponentFoundScreen extends StatefulWidget {
  const OpponentFoundScreen({
    super.key,
    required this.opponent,
    required this.onCountdownDone,
  });

  final DuelUser opponent;
  final VoidCallback onCountdownDone;

  @override
  State<OpponentFoundScreen> createState() => _OpponentFoundScreenState();
}

class _OpponentFoundScreenState extends State<OpponentFoundScreen>
    with SingleTickerProviderStateMixin {
  int _count = 3;
  Timer? _timer;
  late final AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: MotionDurations.countdownTick,
      lowerBound: 0.5,
      upperBound: 1.0,
    );
    _scaleController.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_count <= 1) {
        timer.cancel();
        widget.onCountdownDone();
      } else {
        setState(() => _count--);
        _scaleController.forward(from: 0.5);
        Haptics.tick();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final user = FakeData.currentUser;

    return SafeArea(
      child: Column(
        children: [
          const TopBar(
            title: 'Opponent found',
          ),
          const Spacer(flex: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PlayerColumn(name: user.name, rating: user.rating),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.xl),
                child: Text(
                  'VS',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: c.accent,
                  ),
                ),
              ),
              _PlayerColumn(
                name: widget.opponent.name,
                rating: widget.opponent.rating,
              ),
            ],
          ),
          const SizedBox(height: SpacingTokens.xxl),
          // Countdown with radial glow
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.8,
                    colors: [
                      c.primary.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: DurationTokens.normal,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: _scaleController, child: child),
                  );
                },
                child: Text(
                  _count > 0 ? '$_count' : 'GO!',
                  key: ValueKey(_count),
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w800,
                    color: _count > 0 ? c.primary : c.success,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

class _PlayerColumn extends StatelessWidget {
  const _PlayerColumn({required this.name, required this.rating});

  final String name;
  final int rating;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DuelAvatar(name: name, size: 72),
        const SizedBox(height: SpacingTokens.sm),
        Text(name, style: Theme.of(context).textTheme.titleMedium),
        Text('$rating', style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
