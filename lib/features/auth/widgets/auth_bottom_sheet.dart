import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../ui/widgets/primary_button.dart';
import '../auth_flow_controller.dart';

/// Why we're asking the user to sign in — shown as context in the sheet.
enum AuthReason {
  duel('Sign in to start dueling'),
  profile('Sign in to view your profile'),
  premium('Sign in to unlock premium features');

  const AuthReason(this.message);
  final String message;
}

/// Checks auth state. If already authenticated, returns `true` immediately.
/// Otherwise shows [AuthBottomSheet] and returns the result.
Future<bool> requireAuth(BuildContext context, {required AuthReason reason}) async {
  if (authFlowController.isAuthenticated) return true;

  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AuthBottomSheet(reason: reason),
  );

  return result == true;
}

enum _AuthMode { login, register }

class _AuthBottomSheet extends StatefulWidget {
  const _AuthBottomSheet({required this.reason});

  final AuthReason reason;

  @override
  State<_AuthBottomSheet> createState() => _AuthBottomSheetState();
}

class _AuthBottomSheetState extends State<_AuthBottomSheet>
    with TickerProviderStateMixin {
  _AuthMode _mode = _AuthMode.login;
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  // Success animation
  AnimationController? _successAnim;

  bool get _isLoginValid =>
      _usernameController.text.trim().length >= 3 &&
      _passwordController.text.length >= 6;

  bool get _isRegisterValid =>
      _isLoginValid &&
      _confirmController.text == _passwordController.text &&
      _confirmController.text.isNotEmpty;

  bool get _isValid =>
      _mode == _AuthMode.login ? _isLoginValid : _isRegisterValid;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onChanged);
    _passwordController.addListener(_onChanged);
    _confirmController.addListener(_onChanged);
  }

  void _onChanged() {
    if (_errorMessage != null) {
      setState(() => _errorMessage = null);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    _successAnim?.dispose();
    super.dispose();
  }

  void _switchMode() {
    setState(() {
      _mode =
          _mode == _AuthMode.login ? _AuthMode.register : _AuthMode.login;
      _errorMessage = null;
    });
  }

  Future<void> _submit() async {
    if (!_isValid) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    // Mock: accept any valid input
    authFlowController.markAuthenticated(
      username: _usernameController.text.trim(),
    );

    setState(() => _isLoading = false);

    // Play success animation then close
    _successAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _successAnim!.forward();

    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: c.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: _successAnim != null
              ? _buildSuccess(c)
              : _buildAuth(c, scrollController),
        );
      },
    );
  }

  // ─── Auth Form ──────────────────────────────────────────────

  Widget _buildAuth(AppColors c, ScrollController scrollController) {
    return Column(
      children: [
        // Handle bar + close button
        Padding(
          padding: const EdgeInsets.only(
            top: SpacingTokens.sm,
            left: SpacingTokens.base,
            right: SpacingTokens.base,
          ),
          child: Row(
            children: [
              const SizedBox(width: 40),
              Expanded(
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: c.border,
                      borderRadius: RadiusTokens.pill,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: c.surfaceSecondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: c.textSecondary,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.opaque,
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.xl,
              ),
              child: Column(
                children: [
                  const SizedBox(height: SpacingTokens.lg),

                  // Hero
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: c.primary,
                    ),
                    child: const Icon(
                      Icons.bolt_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.lg),

                  Text(
                    _mode == _AuthMode.login ? 'Welcome back' : 'Join the arena',
                    style: TextStyles.headlineLarge.copyWith(
                      color: c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.xs),
                  Text(
                    widget.reason.message,
                    style: TextStyles.bodyMedium.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.xxl),

                  // Username field
                  _AuthInputField(
                    controller: _usernameController,
                    focusNode: _usernameFocus,
                    label: 'Username',
                    hint: _mode == _AuthMode.login
                        ? 'Enter your username'
                        : 'Choose a unique name',
                    icon: Icons.person_outline_rounded,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _passwordFocus.requestFocus(),
                  ),
                  const SizedBox(height: SpacingTokens.base),

                  // Password field
                  _AuthInputField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    label: 'Password',
                    hint: _mode == _AuthMode.login
                        ? 'Enter your password'
                        : 'Create a password',
                    icon: Icons.lock_outline_rounded,
                    obscure: _obscurePassword,
                    textInputAction: _mode == _AuthMode.login
                        ? TextInputAction.done
                        : TextInputAction.next,
                    onSubmitted: (_) {
                      if (_mode == _AuthMode.login) {
                        _submit();
                      } else {
                        _confirmFocus.requestFocus();
                      }
                    },
                    suffixIcon: GestureDetector(
                      onTap: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: c.textTertiary,
                      ),
                    ),
                  ),

                  // Confirm password (register only)
                  if (_mode == _AuthMode.register) ...[
                    const SizedBox(height: SpacingTokens.base),
                    _AuthInputField(
                      controller: _confirmController,
                      focusNode: _confirmFocus,
                      label: 'Confirm password',
                      hint: 'Re-enter your password',
                      icon: Icons.lock_outline_rounded,
                      obscure: _obscureConfirm,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      suffixIcon: GestureDetector(
                        onTap: () => setState(
                          () => _obscureConfirm = !_obscureConfirm,
                        ),
                        child: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: c.textTertiary,
                        ),
                      ),
                    ),
                  ],

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

                  // Submit button
                  PrimaryButton(
                    label: _mode == _AuthMode.login ? 'Sign in' : 'Create account',
                    size: ButtonSize.lg,
                    onPressed: _isValid ? _submit : null,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: SpacingTokens.xl),

                  // Switch mode link
                  GestureDetector(
                    onTap: _switchMode,
                    child: RichText(
                      text: TextSpan(
                        text: _mode == _AuthMode.login
                            ? "Don't have an account? "
                            : 'Already have an account? ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: c.textSecondary,
                        ),
                        children: [
                          TextSpan(
                            text: _mode == _AuthMode.login
                                ? 'Sign up'
                                : 'Sign in',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: c.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.xxl),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Success ──────────────────────────────────────────────

  Widget _buildSuccess(AppColors c) {
    return AnimatedBuilder(
      animation: _successAnim!,
      builder: (context, _) {
        final value = Curves.elasticOut.transform(
          _successAnim!.value.clamp(0.0, 1.0),
        );
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: value,
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: c.primary,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 44,
                  ),
                ),
              ),
              const SizedBox(height: SpacingTokens.xl),
              Opacity(
                opacity: _successAnim!.value.clamp(0.0, 1.0),
                child: Text(
                  'Welcome,\n${_usernameController.text.trim()}!',
                  textAlign: TextAlign.center,
                  style: TextStyles.headlineLarge.copyWith(
                    color: c.textPrimary,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Input Field ────────────────────────────────────────────────

class _AuthInputField extends StatelessWidget {
  const _AuthInputField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffixIcon,
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
