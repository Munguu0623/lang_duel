import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';

/// Fullscreen loading overlay with optional label.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    this.label,
  });

  final String? label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AbsorbPointer(
      child: Container(
        color: Colors.black.withValues(alpha: 0.2),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(c.primary),
                ),
              ),
              if (label != null) ...[
                const SizedBox(height: SpacingTokens.md),
                Text(
                  label!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
