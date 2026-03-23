import 'package:flutter/material.dart';
import 'package:voice_duel/core/theme/app_theme.dart';
import 'package:voice_duel/features/auth/widgets/parrot_mascot.dart';
import 'package:voice_duel/features/auth/widgets/auth_widgets.dart';

/// Register screen — create new account with email + password.
///
/// Navigation:
/// - "Нэвтрэх" → [onLogin]
/// - Successful registration → [onRegisterSuccess]
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.onLogin,
    required this.onRegisterSuccess,
  });

  final VoidCallback onLogin;
  final VoidCallback onRegisterSuccess;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _errors = <String, String>{};
  bool _loading = false;
  bool _agreed = false;
  String _password = '';

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
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool _validate() {
    _errors.clear();
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pw = _passwordCtrl.text;
    final confirm = _confirmCtrl.text;

    if (name.isEmpty) _errors['name'] = 'Нэрээ оруулна уу';
    if (email.isEmpty) {
      _errors['email'] = 'Имэйл хаяг оруулна уу';
    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
      _errors['email'] = 'Имэйл хаяг буруу байна';
    }
    if (pw.isEmpty) {
      _errors['password'] = 'Нууц үг оруулна уу';
    } else if (pw.length < 6) {
      _errors['password'] = 'Хамгийн багадаа 6 тэмдэгт';
    }
    if (pw != confirm) _errors['confirm'] = 'Нууц үг таарахгүй байна';
    if (!_agreed) _errors['agreed'] = 'Үйлчилгээний нөхцөл зөвшөөрнө үү';

    setState(() {});
    return _errors.isEmpty;
  }

  Future<void> _handleRegister() async {
    if (!_validate()) return;
    setState(() => _loading = true);

    // TODO: Replace with real registration call
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    setState(() => _loading = false);
    widget.onRegisterSuccess();
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
                              child: ParrotMascot(size: 100, mood: ParrotMood.wink),
                            ),

                            // ── Title ──
                            const SizedBox(height: 4),
                            Center(
                              child: Text('Бүртгүүлэх', style: AppText.displayMd),
                            ),
                            const SizedBox(height: 4),
                            Center(
                              child: Text(
                                'Шинэ аккаунт үүсгээд duel эхлүүл!',
                                style: AppText.bodyMd.copyWith(color: AppColors.darkSoft),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // ── Name ──
                            AuthInput(
                              controller: _nameCtrl,
                              label: 'Нэр',
                              placeholder: 'Таны нэр',
                              icon: Icons.person_outline_rounded,
                              errorText: _errors['name'],
                            ),

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
                              placeholder: '6+ тэмдэгт',
                              icon: Icons.lock_outline_rounded,
                              isPassword: true,
                              errorText: _errors['password'],
                              onChanged: (v) => setState(() => _password = v),
                            ),

                            // ── Password strength ──
                            PasswordStrength(password: _password),

                            // ── Confirm password ──
                            AuthInput(
                              controller: _confirmCtrl,
                              label: 'Нууц үг давтах',
                              placeholder: 'Нууц үг давтана уу',
                              icon: Icons.lock_outline_rounded,
                              isPassword: true,
                              errorText: _errors['confirm'],
                            ),

                            // ── Terms checkbox ──
                            _TermsCheckbox(
                              agreed: _agreed,
                              hasError: _errors.containsKey('agreed'),
                              onToggle: () => setState(() => _agreed = !_agreed),
                            ),

                            const SizedBox(height: 16),

                            // ── Register button ──
                            AuthButton(
                              label: 'Бүртгүүлэх',
                              onTap: _handleRegister,
                              color: AppColors.secondary,
                              loading: _loading,
                            ),

                            const SizedBox(height: 24),

                            // ── Login link ──
                            Center(
                              child: GestureDetector(
                                onTap: widget.onLogin,
                                child: RichText(
                                  text: TextSpan(
                                    style: AppText.bodyMd.copyWith(color: AppColors.darkSoft),
                                    children: [
                                      const TextSpan(text: 'Бүртгэлтэй юу? '),
                                      TextSpan(text: 'Нэвтрэх', style: AppText.link),
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

/// Terms & conditions checkbox row.
class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({
    required this.agreed,
    required this.hasError,
    required this.onToggle,
  });

  final bool agreed;
  final bool hasError;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: agreed ? AppColors.primary : AppColors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: hasError
                    ? AppColors.danger
                    : agreed
                        ? AppColors.primary
                        : AppColors.light,
                width: 2.5,
              ),
            ),
            child: agreed
                ? const Icon(Icons.check_rounded, size: 14, color: AppColors.white)
                : null,
          ),
          const SizedBox(width: 8),

          // Text
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppText.bodySm.copyWith(
                  color: hasError ? AppColors.danger : AppColors.darkSoft,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: 'Үйлчилгээний нөхцөл',
                    style: AppText.bodySm.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(text: ' болон '),
                  TextSpan(
                    text: 'Нууцлалын бодлого',
                    style: AppText.bodySm.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(text: '-г зөвшөөрч байна'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
