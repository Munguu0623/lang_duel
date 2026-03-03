You are a senior Flutter architect.

We are implementing STEP 1 of the FOUNDATION phase
for a competitive mobile app called:

ENGLISH DUEL

This step focuses ONLY on:

• Project architecture
• Design token system
• Global theme
• App bootstrap
• Performance-safe patterns

No feature screens yet.
No duel logic.
No mock data yet.

---

🎯 OBJECTIVE

Create a scalable, production-grade Flutter foundation layer.

The app must:

• Be modular
• Be performance-safe
• Avoid over-engineering
• Be ready for future real-time features

---

🔹 CREATE THIS STRUCTURE

lib/
  main.dart
  app/
    app.dart
    app_router.dart
  core/
    theme/
      tokens.dart
      duel_theme.dart
  ui/
    shell/
      app_shell.dart
  features/
  mock/

Do NOT create feature screens yet.
Only architecture and theme system.

---

🔹 DESIGN SYSTEM REQUIREMENTS

Based on this visual direction:

• Background: #F6F7FB
• Surface: White
• Primary accent: #6E6AF6
• Soft shadows only
• Rounded UI
• Premium minimal feel

Create:

1) ColorTokens class
2) SpacingTokens class
3) RadiusTokens class
4) ElevationTokens class
5) TextStyles class

No magic numbers inside widgets.
All values must come from tokens.

---

🔹 duel_theme.dart

Must:

• Use Material 3
• Define ColorScheme properly
• Apply text theme
• Define scaffold background
• Define default card theme
• Define button theme
• Define chip theme
• Define page transitions theme

Keep it clean and scalable.

---

🔹 APP BOOTSTRAP

main.dart:
• runApp(MyApp())
• No global state

app.dart:
• MaterialApp
• Apply duel_theme
• Use app_router

app_router.dart:
• Basic router using Navigator
• Placeholder route to AppShell

---

🔹 APP SHELL

Create:

• Scaffold
• BottomNavigationBar (Home, Duel, Rank, Profile)
• IndexedStack for tab preservation
• Placeholder containers for each tab

Make sure:

• No unnecessary rebuilds
• Bottom navigation state is local
• Use const constructors where possible

---

🔹 PERFORMANCE DISCIPLINE

Enforce:

• const where possible
• small widgets
• no heavy layout widgets
• no IntrinsicHeight
• no nested scroll traps
• clear separation of UI and future business logic

Add short comments explaining performance reasoning where appropriate.

---

🔹 OUTPUT FORMAT

Return full file contents.
Separate clearly by file path:

// lib/main.dart
// lib/app/app.dart
// etc.

Do not explain anything outside code.
Do not merge files.
Be production-ready.
Be clean.
Be strict.