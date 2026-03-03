import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/theme/tokens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _iconController;
  late final AnimationController _contentController;
  late final AnimationController _pulseController;

  late final Animation<double> _iconScale;
  late final Animation<double> _iconFade;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<double> _loaderFade;

  @override
  void initState() {
    super.initState();

    // Icon entrance: scale up + fade in
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _iconScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeOutBack),
    );
    _iconFade = CurvedAnimation(
      parent: _iconController,
      curve: Curves.easeOut,
    );

    // Content stagger: title -> subtitle -> loader
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );
    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.35, 0.7, curve: Curves.easeOut),
      ),
    );
    _loaderFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    // Subtle pulse on logo glow
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // Stagger: icon first, then content
    _iconController.forward().then((_) {
      _contentController.forward();
    });

    // Navigate after splash
    Timer(const Duration(milliseconds: 2100), () async {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(Routes.onboarding);
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    _contentController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo with blue-purple glow
            FadeTransition(
              opacity: _iconFade,
              child: ScaleTransition(
                scale: _iconScale,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final pulseValue = _pulseController.value;
                    return Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: c.primary.withValues(
                                alpha: 0.15 + pulseValue * 0.12),
                            blurRadius: 24 + pulseValue * 12,
                            spreadRadius: pulseValue * 4,
                          ),
                          BoxShadow(
                            color: c.accent.withValues(
                                alpha: 0.10 + pulseValue * 0.08),
                            blurRadius: 32 + pulseValue * 8,
                            spreadRadius: pulseValue * 2,
                            offset: const Offset(4, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icon/langduel_applogo.png',
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: SpacingTokens.xl),

            // Title
            FadeTransition(
              opacity: _titleFade,
              child: SlideTransition(
                position: _titleSlide,
                child: Text(
                  'LANG DUEL',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.0,
                    color: c.textPrimary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: SpacingTokens.sm),

            // Subtitle
            FadeTransition(
              opacity: _subtitleFade,
              child: Text(
                'AI-powered voice battles',
                style: TextStyles.bodyMedium.copyWith(
                  color: c.textSecondary,
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(height: SpacingTokens.xxl),

            // Loading indicator
            FadeTransition(
              opacity: _loaderFade,
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    c.primary.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
