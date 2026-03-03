import 'package:flutter/material.dart';

import '../core/theme/duel_theme.dart';
import 'app_router.dart';
import 'routes.dart';

class EnglishDuelApp extends StatelessWidget {
  const EnglishDuelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English Duel',
      debugShowCheckedModeBanner: false,
      theme: DuelTheme.light,
      darkTheme: DuelTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: Routes.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
