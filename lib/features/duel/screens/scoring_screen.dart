import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../mock/fake_data.dart';
import '../../../mock/fake_models.dart';
import '../../../ui/widgets/skeleton.dart';
import '../../../ui/widgets/top_bar.dart';

class ScoringScreen extends StatefulWidget {
  const ScoringScreen({
    super.key,
    required this.onDone,
  });

  final ValueChanged<DuelResult> onDone;

  @override
  State<ScoringScreen> createState() => _ScoringScreenState();
}

class _ScoringScreenState extends State<ScoringScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _dotController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _timer = Timer(const Duration(seconds: 2), () {
      widget.onDone(FakeData.generateFakeResult());
    });
  }

  @override
  void dispose() {
    _dotController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // Dot colors: primary, accent, accentCyan
    final dotColors = [c.primary, c.accent, c.accentCyan];

    return SafeArea(
      child: Column(
        children: [
          const TopBar(title: 'Scoring'),
          const Spacer(),
          // Icon — gradient circle + glow
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.primary,
              boxShadow: [
                BoxShadow(
                  color: c.primary.withValues(alpha: 0.30),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 36,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: SpacingTokens.xl),
          Text(
            'AI is judging...',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: SpacingTokens.md),
          AnimatedBuilder(
            animation: _dotController,
            builder: (context, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  final delay = i * 0.2;
                  final value =
                      ((_dotController.value - delay) % 1.0).clamp(0.0, 1.0);
                  final opacity = (value < 0.5)
                      ? (value * 2).clamp(0.2, 1.0)
                      : ((1.0 - value) * 2).clamp(0.2, 1.0);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: dotColors[i],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            'Analyzing pronunciation, grammar, fluency...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: SpacingTokens.xl),
          const Padding(
            padding:
                EdgeInsets.symmetric(horizontal: SpacingTokens.base),
            child: SkeletonCard(),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
