import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../features/auth/auth_flow_controller.dart';
import '../../../features/auth/auth_service.dart';
import '../../../ui/widgets/cta_glow.dart';
import '../../../ui/widgets/primary_button.dart';
import '../../../ui/widgets/top_bar.dart';

/// Registration screen — email, display name, password, confirm password.
///
/// Calls POST /auth/register on submit.  On success the JWT is persisted by
/// [AuthService] and the user continues to avatar selection.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Field order mirrors the API: email → name → password → confirm.
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController(); // maps to API "name"
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _emailFocus = FocusNode();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _errorMessage;

  bool get _isValid =>
      _emailController.text.trim().contains('@') &&
      _usernameController.text.trim().length >= 3 &&
      _passwordController.text.length >= 6 &&
      _passwordController.text == _confirmController.text;

  String? get _passwordMismatch {
    if (_confirmController.text.isEmpty) return null;
    if (_passwordController.text == _confirmController.text) return null;
    return 'Passwords do not match';
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onChanged);
    _usernameController.addListener(_onChanged);
    _passwordController.addListener(_onChanged);
    _confirmController.addListener(_onChanged);
  }

  void _onChanged() {
    if (_errorMessage != null) setState(() => _errorMessage = null);
    setState(() {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _emailFocus.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_isValid) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Call POST /auth/register → persist token → return AuthUser.
      final user = await authService.register(
        email: _emailController.text.trim().toLowerCase(),
        password: _passwordController.text,
        name: _usernameController.text.trim(),
      );

      // Sync display name into the lightweight UI flow controller.
      authFlowController.markAuthenticated(username: user.name);

      if (!mounted) return;
      // Continue to avatar selection for new users.
      Navigator.of(context).pushNamed(Routes.avatar);
    } on ApiException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e, st) {
      debugPrint('[Register] Тодорхойгүй алдаа: $e\n$st');
      setState(() => _errorMessage = 'Холболтын алдаа гарлаа. Дахин оролдоно уу.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final mismatch = _passwordMismatch;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              TopBar(
                title: 'Create account',
                onBack: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: SpacingTokens.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: SpacingTokens.sm),
                      Center(
                        child: Text(
                          'Join the arena and start dueling',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: c.accent),
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.xxl),

                      // Email — used as the login identifier on the backend.
                      _InputField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        label: 'Email',
                        hint: 'Enter your email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => _usernameFocus.requestFocus(),
                      ),
                      const SizedBox(height: SpacingTokens.lg),

                      // Display name — shown to opponents (maps to API "name").
                      _InputField(
                        controller: _usernameController,
                        focusNode: _usernameFocus,
                        label: 'Username',
                        hint: 'Choose a display name',
                        icon: Icons.person_outline_rounded,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => _passwordFocus.requestFocus(),
                        helperText: 'At least 3 characters',
                      ),
                      const SizedBox(height: SpacingTokens.lg),

                      // Password
                      _InputField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        label: 'Password',
                        hint: 'Create a password',
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => _confirmFocus.requestFocus(),
                        helperText: 'At least 6 characters',
                        suffixIcon: GestureDetector(
                          onTap: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                          child: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: c.textTertiary,
                          ),
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.lg),

                      // Confirm password
                      _InputField(
                        controller: _confirmController,
                        focusNode: _confirmFocus,
                        label: 'Confirm password',
                        hint: 'Re-enter your password',
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscureConfirm,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _register(),
                        errorText: mismatch,
                        suffixIcon: GestureDetector(
                          onTap: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                          child: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: c.textTertiary,
                          ),
                        ),
                      ),

                      // Error message
                      if (_errorMessage != null) ...[
                        const SizedBox(height: SpacingTokens.lg),
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

                      const SizedBox(height: SpacingTokens.xxl),

                      // Register button with CTA glow
                      CtaGlow(
                        child: PrimaryButton(
                          label: 'Create account',
                          size: ButtonSize.lg,
                          onPressed: _isValid ? _register : null,
                          isLoading: _isLoading,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.xl),

                      // Terms
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: SpacingTokens.base),
                          child: Text(
                            'By creating an account, you agree to our Terms of Service and Privacy Policy.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: c.textTertiary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.xxl),

                      // Already have account — accent purple
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: c.textSecondary,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign in',
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
            ],
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
    this.helperText,
    this.errorText,
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
  final String? helperText;
  final String? errorText;

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
                borderSide: BorderSide(
                  color: errorText != null ? c.danger : c.primary,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.base,
                vertical: 14,
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: SpacingTokens.xs),
          Row(
            children: [
              Icon(Icons.error_outline, size: 14, color: c.danger),
              const SizedBox(width: SpacingTokens.xs),
              Text(
                errorText!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: c.danger,
                ),
              ),
            ],
          ),
        ] else if (helperText != null) ...[
          const SizedBox(height: SpacingTokens.xs),
          Text(
            helperText!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: c.textTertiary,
            ),
          ),
        ],
      ],
    );
  }
}
