import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/theme/tokens.dart';
import '../../../features/auth/auth_flow_controller.dart';
import '../../../ui/widgets/cta_glow.dart';
import '../../../ui/widgets/primary_button.dart';
import '../../../ui/widgets/soft_chip.dart';
import '../../../ui/widgets/top_bar.dart';

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  final _levels = const ['A1', 'A2', 'B1', 'B2', 'C1'];
  int? _selectedIndex;

  void _continue() {
    final level = _selectedIndex != null ? _levels[_selectedIndex!] : null;
    authFlowController.level = level ?? 'B1';
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.root,
      (route) => false,
    );
  }

  void _skip() {
    authFlowController.level = null;
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.root,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBar(
                title: 'Select your level',
                onBack: () => Navigator.of(context).pop(),
                actionIcon: Icons.skip_next_rounded,
                onAction: _skip,
              ),
              const SizedBox(height: SpacingTokens.xl),
              Text(
                'Pick your rank to face worthy opponents.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: SpacingTokens.lg),
              Wrap(
                spacing: SpacingTokens.sm,
                runSpacing: SpacingTokens.sm,
                children: [
                  for (var i = 0; i < _levels.length; i++)
                    SoftChip(
                      label: _levels[i],
                      selected: _selectedIndex == i,
                      onTap: () => setState(() => _selectedIndex = i),
                    ),
                ],
              ),
              const SizedBox(height: SpacingTokens.xl),
              Text(
                'You\'ll be matched against opponents at your level. Prove yourself and climb the ranks.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              CtaGlow(
                child: PrimaryButton(
                  label: 'Continue',
                  onPressed: _continue,
                ),
              ),
              const SizedBox(height: SpacingTokens.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
