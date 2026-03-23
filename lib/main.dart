import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_duel/core/theme/app_theme.dart';
import 'package:voice_duel/core/router/app_router.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 🚀 VoiceDuel — AI-powered English voice duel game
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
// Architecture: Feature-first + Riverpod
//
// lib/
// ├── core/
// │   ├── constants/    → app-wide config values
// │   ├── models/       → immutable data classes
// │   ├── providers/    → Riverpod state management
// │   ├── router/       → GoRouter navigation
// │   ├── services/     → API, audio, storage
// │   ├── theme/        → colors, typography, spacing
// │   └── widgets/      → reusable UI components
// └── features/
//     ├── auth/         → login / signup
//     ├── duel/         → matchmaking, battle, result
//     ├── home/         → main hub
//     ├── leaderboard/  → rankings
//     ├── payment/      → subscription plans
//     ├── profile/      → user stats & achievements
//     └── shell/        → bottom nav wrapper
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode (mobile game UX)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Transparent status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    const ProviderScope(
      child: VoiceDuelApp(),
    ),
  );
}

class VoiceDuelApp extends StatelessWidget {
  const VoiceDuelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VoiceDuel',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: appRouter,
    );
  }
}
