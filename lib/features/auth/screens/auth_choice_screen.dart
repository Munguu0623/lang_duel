import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../features/auth/auth_flow_controller.dart';
import '../../../features/auth/auth_service.dart';
import '../../../ui/widgets/cta_glow.dart';
import '../../../ui/widgets/primary_button.dart';

/// Login screen — email + password, wired to POST /auth/login.
class AuthChoiceScreen extends StatefulWidget {
  const AuthChoiceScreen({super.key});

  @override
  State<AuthChoiceScreen> createState() => _AuthChoiceScreenState();
}

class _AuthChoiceScreenState extends State<AuthChoiceScreen> {
  // "Username" → "Email": the backend uses email as the primary identifier.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  /// Basic gate: non-empty email + 6-char password.
  /// Deep email-format validation happens server-side.
  bool get _isValid =>
      _emailController.text.trim().contains('@') &&
      _passwordController.text.length >= 6;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_clearError);
    _passwordController.addListener(_clearError);
  }

  void _clearError() {
    if (_errorMessage != null) setState(() => _errorMessage = null);
    setState(() {}); // refresh button enabled state
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_isValid) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Call POST /auth/login → persist token → return AuthUser.
      final user = await authService.login(
        _emailController.text.trim().toLowerCase(),
        _passwordController.text,
      );

      // Sync display name into the lightweight UI flow controller.
      authFlowController.markAuthenticated(username: user.name);

      if (!mounted) return;
      // Replace the entire stack so Back doesn't return to the login screen.
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.root,
        (route) => false,
      );
    } on ApiException catch (e) {
      // Серверийн typed алдаа — _humanize()-аас ирсэн монгол мессеж.
      setState(() => _errorMessage = e.message);
    } catch (e, st) {
      // ApiException биш аливаа алдаа (SSL, cast, platform гэх мэт) —
      // debug console-д бичиж, хэрэглэгчид ерөнхий мессеж харуулна.
      debugPrint('[Login] Тодорхойгүй алдаа: $e\n$st');
      setState(() => _errorMessage = 'Холболтын алдаа гарлаа. Дахин оролдоно уу.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goToRegister() {
    Navigator.of(context).pushNamed(Routes.register);
  }

  void _continueAsGuest() {
    authFlowController
      ..isGuest = true
      ..username = null;
    Navigator.of(context).pushNamed(Routes.username);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.xl),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 56),

                  // Logo with blue+purple glow
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
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
                        Icons.bolt_rounded,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.xl),

                  // Heading
                  Center(
                    child: Text(
                      'Ready to duel?',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.sm),
                  Center(
                    child: Text(
                      'Sign in and dominate',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email field — backend uses email as the login identifier.
                  _InputField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    label: 'Email',
                    hint: 'Enter your email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _passwordFocus.requestFocus(),
                  ),
                  const SizedBox(height: SpacingTokens.base),

                  // Password field
                  _InputField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    label: 'Password',
                    hint: 'Enter your password',
                    icon: Icons.lock_outline_rounded,
                    obscure: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _login(),
                    suffixIcon: GestureDetector(
                      onTap: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: c.textTertiary,
                      ),
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.sm),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: c.primary,
                        ),
                      ),
                    ),
                  ),

                  // Error message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: SpacingTokens.base),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(SpacingTokens.md),
                      decoration: BoxDecoration(
                        color: c.danger.withValues(alpha: 0.08),
                        borderRadius: RadiusTokens.small,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline_rounded,
                              size: 18, color: c.danger),
                          const SizedBox(width: SpacingTokens.sm),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: c.danger,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: SpacingTokens.xl),

                  // Login button with CTA glow
                  CtaGlow(
                    child: PrimaryButton(
                      label: 'Sign in',
                      size: ButtonSize.lg,
                      onPressed: _isValid ? _login : null,
                      isLoading: _isLoading,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.xl),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: c.border, height: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: SpacingTokens.base),
                        child: Text(
                          'or',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: c.textTertiary,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: c.border, height: 1)),
                    ],
                  ),
                  const SizedBox(height: SpacingTokens.xl),

                  // Guest button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: _continueAsGuest,
                      icon: Icon(Icons.person_outline_rounded,
                          size: 18, color: c.textSecondary),
                      label: Text(
                        'Continue as guest',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: c.textPrimary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        shape: const StadiumBorder(),
                        side: BorderSide(color: c.border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Sign up link — accent purple
                  Center(
                    child: GestureDetector(
                      onTap: _goToRegister,
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: c.textSecondary,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: c.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.xxl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Themed text field with label, icon, and focus animation.
class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: c.textSecondary,
          ),
        ),
        const SizedBox(height: SpacingTokens.sm),
        Container(
          decoration: BoxDecoration(
            color: c.surfaceSecondary,
            borderRadius: RadiusTokens.medium,
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscure,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onSubmitted: onSubmitted,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: c.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: c.textTertiary,
              ),
              prefixIcon: Icon(icon, size: 20, color: c.textTertiary),
              suffixIcon: suffixIcon != null
                  ? Padding(
                      padding:
                          const EdgeInsets.only(right: SpacingTokens.md),
                      child: suffixIcon,
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(
                minHeight: 20,
                minWidth: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: RadiusTokens.medium,
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: RadiusTokens.medium,
                borderSide: BorderSide(color: c.primary, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.base,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
