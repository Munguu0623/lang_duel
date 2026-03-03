You are a senior Flutter architect and UI systems engineer.

We are building a standalone mobile app called:

ENGLISH DUEL

This is a competitive AI-powered voice battle app.
For now, we are building ONLY the UI prototype.
No backend. No real audio. No network.

Your task:
Build the professional FOUNDATION layer of the Flutter project.

This must be production-grade and scalable.
Clean architecture.
High performance.
Modular.
No over-engineering.

---

🎯 PHASE 0 GOAL:

Create:

1) Project folder structure
2) Global theme system (design tokens)
3) Core reusable UI components
4) App shell layout
5) Navigation base
6) Performance-ready patterns
7) Mock data layer
8) Duel state machine skeleton (UI-only)

---

🔹 REQUIREMENTS

App style:
• Light mode only
• Background: #F6F7FB
• Surface: White
• Primary accent: soft purple (#6E6AF6 family)
• Soft shadows
• Rounded corners (16–28 radius)
• Minimal, premium, competitive feel
• No gradients
• No dark mode yet

---

🔹 FOLDER STRUCTURE (must follow)

lib/
  main.dart
  app/
    app.dart
    app_router.dart
  core/
    theme/
      duel_theme.dart
      tokens.dart
    utils/
    constants/
  ui/
    widgets/
      soft_card.dart
      soft_chip.dart
      duel_avatar.dart
      ghost_icon_button.dart
      primary_button.dart
    shell/
      app_shell.dart
  features/
    duel/
      duel_state.dart
    home/
      home_screen.dart
  mock/
    fake_models.dart
    fake_data.dart

Explain briefly what each folder is responsible for.

---

🔹 DESIGN SYSTEM

Create a professional design token system:

• Colors class
• Spacing class
• Radius class
• Text styles
• Elevation / shadow system

Do NOT hardcode magic numbers inside widgets.
All values must come from tokens.

---

🔹 PERFORMANCE RULES (must implement)

• Use const constructors wherever possible
• Split widgets properly (avoid giant build methods)
• No unnecessary rebuilds
• No global mutable state
• Use ValueNotifier for temporary duel state
• Avoid nested scroll performance traps
• Use ListView.builder when needed

Include comments in code explaining performance decisions.

---

🔹 APP SHELL

Create:

• Scaffold wrapper
• Bottom navigation (Home, Duel, Rank, Profile)
• IndexedStack for tab state preservation
• Clean separation between shell and feature screens

---

🔹 DUEL STATE MACHINE (UI only)

Create a simple enum:

idle
searching
found
countdown
live
scoring
result

Create DuelState model with:
• status
• timer
• transcript (mock)
• score (mock)

Use ValueNotifier<DuelState>.

No backend logic.
Only structure.

---

🔹 MOCK LAYER

Create fake:
• User model
• Opponent model
• Prompt model
• Match result model

Provide example fake data.

---

🔹 OUTPUT FORMAT

• Return code separated clearly by file paths.
• Do not merge everything in one file.
• Do not give explanations outside of code.
• Follow clean naming.
• Make it scalable for future backend integration.
• Avoid unnecessary packages.

---

This is a FOUNDATION phase.
We are preparing for:
• Real-time voice battle
• AI scoring
• Leaderboards
• Wallet
• Production scaling

Act like you are preparing a startup MVP for scale.