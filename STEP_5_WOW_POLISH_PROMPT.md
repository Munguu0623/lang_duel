You are a senior Flutter motion designer + performance UI engineer.

Context:
We have an ENGLISH DUEL UI-only prototype:
- tokens + theme
- reusable widgets
- duel flow screens
- navigation polished (Step 4)
Now implement FOUNDATION — STEP 5:
Add “wow factor” polish without making it flashy.

No backend.
No real audio.
No external packages.

---

🎯 GOALS

1) Add a professional motion system:
   - consistent durations, curves, transitions
   - subtle, premium animations
   - zero “cartoon” effects

2) Improve perceived performance:
   - skeleton loaders (pure Flutter)
   - shimmer-like effect (no packages) OR simple pulsing skeleton
   - smooth loading states

3) Add micro-interactions:
   - press scale on buttons/cards
   - subtle elevation change
   - AnimatedSwitcher / AnimatedOpacity for state changes
   - score number count-up animation (result screen)

4) Add haptics (optional but recommended):
   - light impact on key actions (start duel, countdown tick, win)
   - use Flutter built-in HapticFeedback only

5) Enforce render performance:
   - isolate frequently updating areas with RepaintBoundary
   - avoid rebuilding whole screens
   - keep animations cheap

---

✅ CREATE / UPDATE FILES

CREATE:
lib/core/motion/motion.dart
  - durations constants (fast/med/slow)
  - curves constants
  - helpers: fade/scale/slide transitions
  - a simple CountUpText widget (for score animation)

lib/ui/widgets/pressable_scale.dart
  - reusable wrapper that adds press-scale and tap feedback
  - supports onTap + child
  - uses GestureDetector + AnimatedScale

lib/ui/widgets/skeleton.dart
  - SkeletonBox, SkeletonLine, SkeletonCard
  - pulsing animation using AnimationController + FadeTransition
  - no shimmer package

lib/ui/widgets/haptics.dart
  - small helper functions: lightTap(), success(), warning()
  - uses HapticFeedback.selectionClick / lightImpact / mediumImpact

UPDATE (apply polish):
lib/ui/widgets/primary_button.dart
  - integrate PressableScale
  - better loading state
  - subtle disabled style

lib/ui/widgets/soft_card.dart
  - integrate PressableScale
  - optional hover/pressed elevation change (AnimatedContainer shadow intensity)

UPDATE duel screens:
- searching_screen.dart: replace loading with Skeleton + pulsing indicator
- scoring_screen.dart: show SkeletonCard placeholders + “AI scoring…” label
- result_screen.dart:
   - add CountUpText for total score
   - breakdown rows appear with AnimatedSwitcher
   - win/lose header fades in

- live_duel_screen.dart:
   - transcript area uses RepaintBoundary
   - transcript updates only that widget (split widget)
   - add mic button press animation (scale + glow via AnimatedContainer)

OPTIONAL UPDATE:
- opponent_found_screen.dart:
   - countdown number transitions with AnimatedSwitcher (scale/fade)
   - haptic tick each second (light)

---

🔹 MOTION SPEC (must follow)

Durations:
- fast: 140ms
- med: 180ms
- slow: 240ms
- countdown tick: 220ms

Curves:
- standard: Curves.easeOutCubic
- enter: Curves.easeOut
- exit: Curves.easeIn

Rules:
- No bounce curves
- No elastic
- Keep transforms minimal (scale 1.00 → 1.03 max)

---

🔹 SKELETON SPEC

Skeleton must:
- use neutral grey blocks (#E9EBF2 range)
- pulsing opacity 0.55 ↔ 0.85
- rounded corners from tokens
- reusable in any screen

Use skeletons in:
- searching
- scoring
- leaderboard placeholder (if exists)

---

🔹 SCORE COUNT-UP

CountUpText:
- animates from 0 to target
- duration depends on value but capped at 600ms
- integer display
- uses TextStyle passed in

---

🔹 HAPTICS RULES

- Light haptic on primary button tap
- Countdown tick: selectionClick
- Win: mediumImpact
- Avoid haptics on every small UI change

All haptics should be centralized in haptics.dart helpers.

---

🔹 PERFORMANCE RULES

- Avoid rebuilding entire scaffold
- Keep timers and notifiers scoped
- Use ValueListenableBuilder for small parts
- Wrap frequently updating areas with RepaintBoundary
- Don’t animate shadows too heavy (keep subtle)

---

🔹 OUTPUT RULES

Return code separated by file paths.
No explanations outside code.
No extra dependencies.
Everything must compile.
Keep it premium and subtle.