import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/theme/tokens.dart';
import '../../../features/auth/auth_flow_controller.dart';
import '../../../ui/widgets/cta_glow.dart';
import '../../../ui/widgets/primary_button.dart';
import '../../../ui/widgets/top_bar.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    final text = _controller.text.trim();
    final isValid = text.length >= 3 && text.length <= 15;
    _isValid.value = isValid;
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onChanged)
      ..dispose();
    _isValid.dispose();
    super.dispose();
  }

  void _continue() {
    final username = _controller.text.trim();
    if (username.length < 3) return;
    authFlowController.username = username;
    Navigator.of(context).pushNamed(Routes.avatar);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBar(
                title: 'Choose username',
                onBack: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: SpacingTokens.xl),
              Text(
                'This is your arena name.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: SpacingTokens.lg),
              // Borderless container with surfaceSecondary bg
              Container(
                padding: const EdgeInsets.all(SpacingTokens.base),
                decoration: BoxDecoration(
                  color: c.surfaceSecondary,
                  borderRadius: RadiusTokens.card,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Username',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: SpacingTokens.sm),
                    TextField(
                      controller: _controller,
                      maxLength: 15,
                      autofocus: true,
                      decoration: const InputDecoration(
                        counterText: '',
                        hintText: 'Enter a unique name',
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ValueListenableBuilder<bool>(
                valueListenable: _isValid,
                builder: (context, isValid, _) {
                  return CtaGlow(
                    child: PrimaryButton(
                      label: 'Continue',
                      onPressed: isValid ? _continue : null,
                    ),
                  );
                },
              ),
              const SizedBox(height: SpacingTokens.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
