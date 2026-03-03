import 'package:flutter/material.dart';

import 'error_state.dart';

/// Mic permission missing placeholder (UI-only, no real permission handling).
class PermissionState extends StatelessWidget {
  const PermissionState({super.key, this.onOpenSettings});

  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return ErrorState(
      icon: Icons.mic_off_rounded,
      title: 'Microphone permission required',
      subtitle:
          'To start an English Duel, please enable microphone access in your system settings.',
      actionLabel: 'Open settings',
      onAction: onOpenSettings,
    );
  }
}

