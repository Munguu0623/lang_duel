import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/theme/tokens.dart';
import '../../../features/auth/auth_flow_controller.dart';
import '../../../ui/widgets/primary_button.dart';
import '../../../ui/widgets/top_bar.dart';

class AvatarSelectScreen extends StatefulWidget {
  const AvatarSelectScreen({super.key});

  @override
  State<AvatarSelectScreen> createState() => _AvatarSelectScreenState();
}

class _AvatarSelectScreenState extends State<AvatarSelectScreen> {
  int? _selected;

  void _continue() {
    authFlowController.avatarId = _selected;
    Navigator.of(context).pushNamed(Routes.level);
  }

  void _skip() {
    authFlowController.avatarId = null;
    Navigator.of(context).pushNamed(Routes.level);
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
                title: 'Choose avatar',
                onBack: () => Navigator.of(context).pop(),
                actionIcon: Icons.skip_next_rounded,
                onAction: _skip,
              ),
              const SizedBox(height: SpacingTokens.xl),
              Text(
                'Pick a simple avatar for now. You can change it later.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: SpacingTokens.lg),
              Expanded(
                child: GridView.builder(
                  itemCount: 12,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: SpacingTokens.md,
                    crossAxisSpacing: SpacingTokens.md,
                  ),
                  itemBuilder: (context, index) {
                    final isSelected = _selected == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selected = index),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? c.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        padding:
                            const EdgeInsets.all(SpacingTokens.xs),
                        child: CircleAvatar(
                          backgroundColor: c.primaryLight,
                          child: Text(
                            String.fromCharCode(65 + index),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: c.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: SpacingTokens.lg),
              PrimaryButton(
                label: 'Continue',
                onPressed: _continue,
              ),
              const SizedBox(height: SpacingTokens.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
