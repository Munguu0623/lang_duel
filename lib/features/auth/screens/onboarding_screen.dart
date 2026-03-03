import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/motion/motion.dart';
import '../../../core/theme/tokens.dart';
import '../../../ui/widgets/cta_glow.dart';
import '../../../ui/widgets/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    (
      'Battle in real-time',
      'Face opponents in live English voice battles.',
      Icons.sports_esports_rounded,
    ),
    (
      'AI judges every word',
      'Get instant feedback on pronunciation and fluency.',
      Icons.auto_awesome_rounded,
    ),
    (
      'Dominate the leaderboard',
      'Win duels, earn rating, and move up the ladder.',
      Icons.leaderboard_rounded,
    ),
  ];

  void _goNext() {
    if (_currentPage == _pages.length - 1) {
      Navigator.of(context).pushReplacementNamed(Routes.authChoice);
    } else {
      _pageController.nextPage(
        duration: MotionDurations.med,
        curve: MotionCurves.standard,
      );
    }
  }

  void _skip() {
    Navigator.of(context).pushReplacementNamed(Routes.authChoice);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SpacingTokens.base,
                SpacingTokens.base,
                SpacingTokens.base,
                0,
              ),
              child: Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: _skip,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: c.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final (title, subtitle, icon) = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SpacingTokens.base,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 96px gradient circle with glow
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: c.primary,
                            boxShadow: [
                              BoxShadow(
                                color: c.primary.withValues(alpha: 0.30),
                                blurRadius: 24,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(icon, size: 44, color: Colors.white),
                        ),
                        const SizedBox(height: SpacingTokens.xl),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: SpacingTokens.md),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.base,
                vertical: SpacingTokens.base,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: MotionDurations.fast,
                        margin: const EdgeInsets.symmetric(
                          horizontal: SpacingTokens.xs,
                        ),
                        width: isActive ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? c.primary : c.surfaceSecondary,
                          borderRadius: RadiusTokens.pill,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: SpacingTokens.lg),
                  CtaGlow(
                    child: PrimaryButton(
                      label: _currentPage == _pages.length - 1
                          ? 'Enter the arena'
                          : 'Continue',
                      onPressed: _goNext,
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
