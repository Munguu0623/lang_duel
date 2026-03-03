You are a senior Flutter product UI engineer and game UX designer.

We are building ENGLISH DUEL — a competitive AI-powered voice battle app.

PHASE 1 — STEP 3:
Implement the full Duel Flow UI (mock only).

No backend.
No real audio.
No network.
Use fake timers and mock state only.

Use existing:
- design tokens
- theme
- reusable widgets
- motion system
- home screen
- app shell
- router
- mock data

---

🎯 GOAL

Create a smooth, premium duel experience:

ModeSelect
  ↓
Searching
  ↓
OpponentFound
  ↓
Countdown
  ↓
LiveDuel
  ↓
Scoring
  ↓
Result
  ↓
Rematch / Back Home

All transitions must feel intentional and fast.

---

✅ CREATE THESE FILES

lib/features/duel/screens/
  mode_select_screen.dart
  searching_screen.dart
  opponent_found_screen.dart
  live_duel_screen.dart
  scoring_screen.dart
  result_screen.dart

lib/features/duel/
  duel_state.dart
  duel_flow_controller.dart

UPDATE:
lib/app/app_router.dart

---

🔹 DUEL STATE MACHINE

enum DuelStatus:
idle
searching
found
countdown
live
scoring
result

Create DuelState model:
- status
- countdown (int)
- liveTimer (int)
- transcript (String)
- yourScore
- opponentScore
- didWin

Use DuelFlowController with ValueNotifier<DuelState>.

Use Timer to simulate:
- searching delay (3s)
- countdown (3..2..1)
- live timer (60s → but shorten to 10s for demo)
- scoring delay (2s)

---

🔹 SCREEN SPECIFICATIONS

1) ModeSelectScreen
- Title: "Choose your battle"
- Two SoftCard options:
   • Quick Duel (enabled)
   • Entry Duel (disabled visual)
- Tap Quick Duel → go to SearchingScreen

2) SearchingScreen
- Centered animation placeholder (pulse circle)
- Text: "Finding opponent..."
- Cancel button
- After 3 seconds auto → OpponentFound

3) OpponentFoundScreen
- Your avatar left
- Opponent avatar right
- VS text center
- Countdown label
- After 1 second auto → CountdownScreen (or merge with this)

4) Countdown (can be inside same screen)
- Large number (3,2,1)
- AnimatedSwitcher for number change
- Optional light haptic on tick

5) LiveDuelScreen
Layout:
Top:
- You vs Opponent row
- Timer centered
Middle:
- Prompt card (fake prompt text)
Bottom:
- Big circular mic button (mock)
- Transcript box below mic

Transcript simulation:
- every 1s append mock text words
- isolate transcript in separate widget + RepaintBoundary

After timer ends → auto go to Scoring

6) ScoringScreen
- SkeletonCard placeholders
- Label: "AI is scoring..."
- After 2s → ResultScreen

7) ResultScreen
- Large header: WIN or LOSE
- Score display (CountUpText)
- Breakdown rows:
   • Fluency
   • Grammar
   • Vocabulary
- Buttons:
   • Rematch (go to Searching)
   • Back Home (popUntil root)

Add subtle fade/slide animations.

---

🔹 VISUAL RULES

- Light mode only
- Purple accent used only for primary actions
- Result header color:
   Win → subtle emerald
   Lose → muted red
- No heavy shadows
- 8pt spacing grid
- Token-only styling

---

🔹 PERFORMANCE RULES

- Split widgets (no giant build methods)
- Use const where possible
- Use RepaintBoundary for transcript area
- Use ValueListenableBuilder for state updates
- Avoid rebuilding entire screen per second

---

🔹 ROUTING RULES

Routes:
"/duel/mode"
"/duel/search"
"/duel/live"
"/duel/result"

Flow should hide bottom nav during duel screens.

---

🔹 OUTPUT FORMAT

Return full file contents separated by file paths.
No explanations.
Production-ready.
Clean architecture.
Mock only.