import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../mock/fake_data.dart';
import '../../../mock/fake_models.dart';
import '../../../ui/widgets/skeleton.dart';
import '../../../ui/widgets/top_bar.dart';

class SearchingScreen extends StatefulWidget {
  const SearchingScreen({
    super.key,
    required this.onCancel,
    required this.onFound,
  });

  final VoidCallback onCancel;
  final ValueChanged<DuelUser> onFound;

  @override
  State<SearchingScreen> createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Fake 3-second delay before "finding" an opponent.
    _searchTimer = Timer(const Duration(seconds: 3), () {
      widget.onFound(FakeData.getRandomOpponent());
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SafeArea(
      child: Column(
        children: [
          TopBar(
            title: 'Searching',
            onBack: widget.onCancel,
          ),
          const Spacer(flex: 2),
          SizedBox(
            width: 160,
            height: 160,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    for (var i = 0; i < 3; i++)
                      _PulseCircle(
                        progress: (_pulseController.value + i * 0.33) % 1.0,
                        useAccent: i.isOdd,
                      ),
                    // Center circle — gradient primary→accent + glow
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [c.primary, c.accent],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: c.primary.withValues(alpha: 0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: c.accent.withValues(alpha: 0.15),
                            blurRadius: 28,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: SpacingTokens.xl),
          Text(
            'Searching for a worthy opponent...',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            'This may take a few seconds',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: SpacingTokens.xl),
          const Padding(
            padding:
                EdgeInsets.symmetric(horizontal: SpacingTokens.base),
            child: SkeletonCard(),
          ),
          const Spacer(flex: 3),
          Padding(
            padding: const EdgeInsets.only(bottom: SpacingTokens.xxl),
            child: TextButton(
              onPressed: widget.onCancel,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.xxl,
                  vertical: SpacingTokens.md,
                ),
                shape: const StadiumBorder(),
                backgroundColor: c.surfaceSecondary,
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: c.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseCircle extends StatelessWidget {
  const _PulseCircle({required this.progress, this.useAccent = false});

  final double progress;
  final bool useAccent;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = useAccent ? c.accent : c.primary;
    return Opacity(
      opacity: (1.0 - progress).clamp(0.0, 0.3),
      child: Container(
        width: 64 + progress * 96,
        height: 64 + progress * 96,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
      ),
    );
  }
}
