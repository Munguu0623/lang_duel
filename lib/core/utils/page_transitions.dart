import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Centralized custom page transitions for the app.
abstract final class AppPageTransitions {
  /// Subtle fade + slight upward motion, used for most full-screen routes.
  static PageRoute<T> fadeUpwards<T>({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: DurationTokens.normal,
      reverseTransitionDuration: DurationTokens.normal,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
          reverseCurve: Curves.easeIn,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.03),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}

