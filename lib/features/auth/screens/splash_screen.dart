import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/theme/tokens.dart';
import '../auth_flow_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _contentController;
  late final AnimationController _pulseController;
  late final AnimationController _streakController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _loaderFade;

  @override
  void initState() {
    super.initState();

    // Logo entrance — scale up + fade
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoFade = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    );

    // Content stagger: title → loader
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _loaderFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    // Pulsing glow behind logo
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    // Diagonal streak shimmer
    _streakController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    // Sequence: logo → content → navigate
    _logoController.forward().then((_) => _contentController.forward());
    Timer(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      // Skip onboarding if already seen — go straight to the app.
      final destination = authFlowController.hasSeenOnboarding
          ? Routes.root
          : Routes.onboarding;
      Navigator.of(context).pushReplacementNamed(destination);
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _contentController.dispose();
    _pulseController.dispose();
    _streakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primary,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _pulseController,
          _streakController,
        ]),
        builder: (context, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Diagonal streaks background
              CustomPaint(
                painter: _StreakPainter(
                  progress: _streakController.value,
                ),
              ),

              // Center content
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo with pulse glow
                    FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withValues(
                                  alpha: 0.10 + _pulseController.value * 0.12,
                                ),
                                blurRadius:
                                    40 + _pulseController.value * 24,
                                spreadRadius:
                                    4 + _pulseController.value * 8,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/icon/white.png',
                            width: 220,
                            height: 220,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // LANGDUEL title
                    FadeTransition(
                      opacity: _titleFade,
                      child: SlideTransition(
                        position: _titleSlide,
                        child: const Text(
                          'LANGDUEL',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    FadeTransition(
                      opacity: _titleFade,
                      child: SlideTransition(
                        position: _titleSlide,
                        child: Text(
                          'AI · LANGUAGE · DUEL',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2.5,
                            color: Colors.white.withValues(alpha: 0.65),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom loader
              Positioned(
                bottom: 56,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _loaderFade,
                  child: Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withValues(alpha: 0.55),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Diagonal light streak painter — mimics the flash.png background effect.
class _StreakPainter extends CustomPainter {
  _StreakPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Static subtle streaks
    const streaks = [
      (start: Offset(0.15, 0.0), end: Offset(0.75, 1.0), alpha: 0.06),
      (start: Offset(0.35, 0.0), end: Offset(0.95, 1.0), alpha: 0.05),
      (start: Offset(0.55, 0.0), end: Offset(1.15, 1.0), alpha: 0.04),
      (start: Offset(-0.1, 0.0), end: Offset(0.50, 1.0), alpha: 0.05),
      (start: Offset(0.70, 0.0), end: Offset(1.30, 1.0), alpha: 0.03),
    ];

    for (final s in streaks) {
      paint.color = Colors.white.withValues(alpha: s.alpha);
      canvas.drawLine(
        Offset(s.start.dx * size.width, s.start.dy * size.height),
        Offset(s.end.dx * size.width, s.end.dy * size.height),
        paint,
      );
    }

    // Moving shimmer streak
    final shimmerX = -0.3 + progress * 1.6;
    final shimmerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.04),
          Colors.white.withValues(alpha: 0.07),
          Colors.white.withValues(alpha: 0.04),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path()
      ..moveTo(shimmerX * size.width, 0)
      ..lineTo((shimmerX + 0.6) * size.width, size.height);

    canvas.drawPath(path, shimmerPaint);

    // Subtle radial glow at center
    final centerPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.06),
          Colors.transparent,
        ],
        stops: const [0.0, 1.0],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height * 0.42),
          radius: size.width * 0.6,
        ),
      );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      centerPaint,
    );

    // Top-left subtle arc highlight
    final arcPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.07),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.1, size.height * 0.05),
          radius: size.width * 0.5,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.05),
      size.width * 0.5,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_StreakPainter old) => old.progress != progress;
}

// ignore: unused_element
double _clamp(double value) => math.max(0, math.min(1, value));
