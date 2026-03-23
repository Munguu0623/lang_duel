import 'package:flutter/material.dart';
import 'package:voice_duel/core/theme/app_theme.dart';
import 'package:voice_duel/features/auth/widgets/parrot_mascot.dart';
import 'package:voice_duel/features/auth/widgets/auth_widgets.dart';

/// Forgot password screen — enter email to receive reset link.
///
/// Has two states:
/// 1. Email input form
/// 2. Success confirmation (email sent)
///
/// Navigation:
/// - Back arrow / "Буцах" → [onBack]
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  String? _error;
  bool _loading = false;
  bool _sent = false;

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
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final email = _emailCtrl.text.trim();

    if (email.isEmpty) {
      setState(() => _error = 'Имэйл хаяг оруулна уу');
      return;
    }
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
      setState(() => _error = 'Имэйл хаяг буруу байна');
      return;
    }

    setState(() {
      _error = null;
      _loading = true;
    });

    // TODO: Replace with real password reset call
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    setState(() {
      _loading = false;
      _sent = true;
    });
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
                            // ── Back button ──
                            GestureDetector(
                              onTap: widget.onBack,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.chevron_left_rounded,
                                    color: AppColors.primary,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Буцах',
                                    style: AppText.bodySm.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // ── Mascot ──
                            const Center(
                              child: ParrotMascot(size: 110, mood: ParrotMood.think),
                            ),
                            const SizedBox(height: 8),

                            if (!_sent) ..._buildForm() else ..._buildSuccess(),
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

  List<Widget> _buildForm() {
    return [
      // ── Title ──
      Center(
        child: Text('Нууц үг сэргээх', style: AppText.displayMd),
      ),
      const SizedBox(height: 8),
      Center(
        child: Text(
          'Бүртгэлтэй имэйл хаягаа оруулна уу.\nБид нууц үг сэргээх холбоос илгээнэ.',
          style: AppText.bodyMd.copyWith(color: AppColors.darkSoft, height: 1.6),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 24),

      // ── Email ──
      AuthInput(
        controller: _emailCtrl,
        label: 'Имэйл хаяг',
        placeholder: 'hello@example.com',
        icon: Icons.email_outlined,
        keyboardType: TextInputType.emailAddress,
        errorText: _error,
      ),

      const SizedBox(height: 8),

      // ── Submit button ──
      AuthButton(
        label: 'Холбоос илгээх',
        onTap: _handleSubmit,
        color: AppColors.accentOrange,
        loading: _loading,
      ),

      const SizedBox(height: 40),
    ];
  }

  List<Widget> _buildSuccess() {
    return [
      const SizedBox(height: 8),

      // ── Success icon ──
      Center(
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.secondary.withValues(alpha: 0.1),
          ),
          child: const Icon(
            Icons.check_circle_outline_rounded,
            size: 36,
            color: AppColors.secondary,
          ),
        ),
      ),
      const SizedBox(height: 16),

      // ── Title ──
      Center(
        child: Text(
          'Имэйл илгээгдлээ!',
          style: AppText.displaySm.copyWith(color: AppColors.secondary),
        ),
      ),
      const SizedBox(height: 8),

      // ── Description ──
      Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppText.bodyMd.copyWith(color: AppColors.darkSoft, height: 1.7),
            children: [
              TextSpan(
                text: _emailCtrl.text.trim(),
                style: AppText.bodyMd.copyWith(fontWeight: FontWeight.w800, color: AppColors.dark),
              ),
              const TextSpan(text: ' хаяг руу\nнууц үг сэргээх холбоос илгээлээ.\nИмэйлээ шалгана уу.'),
            ],
          ),
        ),
      ),
      const SizedBox(height: 24),

      // ── Back to login button ──
      AuthButton(
        label: 'Нэвтрэх хуудас руу буцах',
        onTap: widget.onBack,
        color: AppColors.primary,
      ),
      const SizedBox(height: 16),

      // ── Spam note ──
      Center(
        child: Text(
          'Имэйл ирээгүй бол спам хавтсаа шалгана уу.',
          style: AppText.bodySm.copyWith(fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ),

      const SizedBox(height: 40),
    ];
  }
}
