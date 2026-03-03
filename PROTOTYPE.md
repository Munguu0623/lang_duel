You are a senior Flutter UI prototyper.

Goal:
Create a UI-only prototype for a standalone app “English Duel”.
No API, no backend, no real audio.
Everything is mock data + fake timers.

Design style:
Clean, soft, rounded, premium.
Light background (#F6F7FB), white cards, subtle shadows, soft purple accent.

Required screens (exact user flow):
1) HomeScreen
2) ModeSelectScreen
3) SearchingScreen (animated searching + cancel)
4) OpponentFoundScreen (countdown 3..2..1)
5) LiveDuelScreen (timer 60s, big mic button, live transcript mock, opponent header)
6) ScoringScreen (loading animation, “AI is scoring…”)
7) ResultScreen (win/lose state + score breakdown + rematch button)

Optional:
LeaderboardScreen, ProfileScreen (simple placeholders)

Implementation rules:
- Pure Flutter UI (no audio)
- Use fake models and fake data in `lib/mock/`
- Use a simple app shell with bottom navigation (Home, Duel, Rank, Profile)
- Use `IndexedStack` to preserve state
- Use `ValueNotifier` to simulate duel state transitions
- Use `Timer` to simulate searching and countdown and duel time
- Keep widgets small and reusable (SoftCard, SoftChip, GhostIconButton, DuelAvatar)
- Return code separated by file paths
- Do not explain anything, only output code.

Folder structure:
lib/
  main.dart
  app_shell.dart
  mock/
    fake_data.dart
    models.dart
  ui/
    duel_theme.dart
    widgets/...
    screens/...