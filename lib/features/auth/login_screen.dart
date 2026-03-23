import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_duel/core/theme/app_theme.dart';
import 'package:voice_duel/core/router/app_router.dart';
import 'package:voice_duel/core/models/models.dart';
import 'package:voice_duel/core/providers/app_providers.dart';
import 'package:voice_duel/core/widgets/shared_widgets.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 🔐 Login Screen — Google auth + guest entry
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slide = Tween(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeOut),
    );
    _fade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeIn),
    );
    Future.delayed(const Duration(milliseconds: 100), () => _anim.forward());
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _loginAsGuest() {
    // Create a default guest user
    ref.read(currentUserProvider.notifier).login(
          const AppUser(
            id: 'guest_001',
            displayName: 'Player_MN',
            emoji: '😎',
            tier: TierLevel.silver,
            level: 7,
            xp: 1250,
            coins: 120,
            totalDuels: 24,
            wins: 18,
            streak: 5,
          ),
        );
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.lightBg, const Color(0xFFE8E4F8)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                const Spacer(),

                // ── Brand ──
                SlideTransition(
                  position: _slide,
                  child: FadeTransition(
                    opacity: _fade,
                    child: Column(
                      children: [
                        const Text('⚔️', style: TextStyle(fontSize: 64)),
                        const SizedBox(height: AppSpacing.md),
                        Text('VoiceDuel', style: AppText.displayLg),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Англи хэлээ тэмцээд сайжруул!',
                          style: AppText.bodyMd.copyWith(
                            color: AppColors.darkSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // ── Auth Buttons ──
                FadeTransition(
                  opacity: _fade,
                  child: Column(
                    children: [
                      // Google Sign-In
                      AppButton(
                        label: 'Google-ээр нэвтрэх',
                        onTap: _loginAsGuest, // TODO: replace with real Google auth
                        color: AppColors.dark,
                        fullWidth: true,
                        size: AppButtonSize.lg,
                        icon: const Icon(
                          Icons.g_mobiledata_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Guest Mode
                      AppButton(
                        label: 'Guest Mode — Шууд тоглох',
                        onTap: _loginAsGuest,
                        color: AppColors.primary,
                        fullWidth: true,
                        size: AppButtonSize.lg,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ── Terms ──
                Text(
                  'Нэвтрэснээр үйлчилгээний нөхцөлийг зөвшөөрнө',
                  style: AppText.bodySm.copyWith(fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
