import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_duel/core/models/models.dart';
import 'package:voice_duel/core/providers/app_providers.dart';
import 'package:voice_duel/core/theme/app_theme.dart';
import 'package:voice_duel/features/auth/widgets/parrot_mascot.dart';
import 'package:voice_duel/features/auth/widgets/auth_widgets.dart';

/// Login screen — email + password authentication.
///
/// Navigation:
/// - "Бүртгүүлэх" → [onRegister]
/// - "Нууц үг мартсан?" → [onForgotPassword]
/// - Successful login → [onLoginSuccess]
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({
    super.key,
    required this.onRegister,
    required this.onForgotPassword,
    required this.onLoginSuccess,
  });

  final VoidCallback onRegister;
  final VoidCallback onForgotPassword;
  final VoidCallback onLoginSuccess;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _errors = <String, String>{};
  bool _loading = false;

  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _slide = Tween(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 100), () => _anim.forward());
  }

  @override
  void dispose() {
    _anim.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  bool _validate() {
    _errors.clear();
    final email = _emailCtrl.text.trim();
    final pw = _passwordCtrl.text;

    if (email.isEmpty) {
      _errors['email'] = 'Имэйл хаяг оруулна уу';
    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
      _errors['email'] = 'Имэйл хаяг буруу байна';
    }
    if (pw.isEmpty) _errors['password'] = 'Нууц үг оруулна уу';

    setState(() {});
    return _errors.isEmpty;
  }

  Future<void> _handleLogin() async {
    if (!_validate()) return;
    setState(() => _loading = true);

    // TODO: Replace with real auth call
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    setState(() => _loading = false);

    // Set mock user until real auth is wired up
    ref.read(currentUserProvider.notifier).login(
      AppUser(
        id: 'user_001',
        displayName: _emailCtrl.text.split('@').first,
        emoji: '😎',
      ),
    );

    widget.onLoginSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: Stack(
          children: [
            const FloatingDecorations(),
            SafeArea(
              child: Column(
                children: [
                  const BrandHeader(),
                  Expanded(
                    child: SlideTransition(
                      position: _slide,
                      child: FadeTransition(
                        opacity: _fade,
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          children: [
                            // ── Mascot ──
                            const Center(
                              child: ParrotMascot(size: 120, mood: ParrotMood.happy),
                            ),

                            // ── Welcome text ──
                            const SizedBox(height: 4),
                            Center(
                              child: Text(
                                'LangDuel-д тавтай морил!',
                                style: AppText.displayLg,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Center(
                              child: Text(
                                'Англи хэлээ тэмцээд сайжруул',
                                style: AppText.bodyMd.copyWith(color: AppColors.darkSoft),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // ── Email ──
                            AuthInput(
                              controller: _emailCtrl,
                              label: 'Имэйл',
                              placeholder: 'hello@example.com',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              errorText: _errors['email'],
                            ),

                            // ── Password ──
                            AuthInput(
                              controller: _passwordCtrl,
                              label: 'Нууц үг',
                              placeholder: 'Нууц үг оруулна уу',
                              icon: Icons.lock_outline_rounded,
                              isPassword: true,
                              errorText: _errors['password'],
                            ),

                            // ── Forgot password ──
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: GestureDetector(
                                  onTap: widget.onForgotPassword,
                                  child: Text(
                                    'Нууц үг мартсан?',
                                    style: AppText.bodySm.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // ── Login button ──
                            AuthButton(
                              label: 'Нэвтрэх',
                              onTap: _handleLogin,
                              color: AppColors.primary,
                              loading: _loading,
                            ),

                            const SizedBox(height: 24),

                            // ── Register link ──
                            Center(
                              child: GestureDetector(
                                onTap: widget.onRegister,
                                child: RichText(
                                  text: TextSpan(
                                    style: AppText.bodyMd.copyWith(color: AppColors.darkSoft),
                                    children: [
                                      const TextSpan(text: 'Бүртгэлгүй юу? '),
                                      TextSpan(
                                        text: 'Бүртгүүлэх',
                                        style: AppText.link,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
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
