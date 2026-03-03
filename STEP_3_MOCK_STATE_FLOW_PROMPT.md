You are a senior Flutter architect focusing on UI prototyping with clean state design.

We are building ENGLISH DUEL (standalone).
No backend. No real audio. No network.

We already have:
- tokens.dart + duel_theme.dart
- app_shell.dart with bottom tabs
- reusable widgets kit (SoftCard, SoftChip, PrimaryButton, etc.)

Now implement FOUNDATION — STEP 3:
Mock data layer + duel state machine + fake flow simulation.

---

🎯 GOAL

Enable a full UI-only duel flow simulation:

Home → Mode Select → Searching → Found → Countdown → Live → Scoring → Result → Rematch/Back

This must run purely on timers + mock data.

No API calls.

---

✅ CREATE THESE FILES

lib/mock/
  fake_models.dart
  fake_data.dart

lib/features/duel/
  duel_state.dart
  duel_controller.dart

lib/features/home/
  home_screen.dart

lib/features/duel/screens/
  mode_select_screen.dart
  searching_screen.dart
  opponent_found_screen.dart
  live_duel_screen.dart
  scoring_screen.dart
  result_screen.dart

lib/app/
  app_router.dart   (update routing to