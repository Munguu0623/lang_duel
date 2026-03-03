You are a senior Flutter UI systems engineer.

We are implementing FOUNDATION — STEP 2
for the standalone app: ENGLISH DUEL

STEP 1 already created:
- tokens.dart
- duel_theme.dart
- app_shell.dart

Now STEP 2 must create a reusable UI component kit.
No feature screens yet.
No duel flow yet.

---

🎯 GOAL

Create a clean, premium, soft-rounded component library
based on our design system tokens.

Style direction:
- Background #F6F7FB
- White cards
- Soft shadows
- Rounded radius (16–28)
- Primary accent #6E6AF6
- Minimal, modern, competitive feel
- No gradients, no dark mode

---

✅ REQUIRED FILES (Create exactly these)

lib/ui/widgets/
  soft_card.dart
  soft_chip.dart
  duel_avatar.dart
  ghost_icon_button.dart
  primary_button.dart
  section_header.dart
  stat_pill.dart
  empty_state.dart

lib/ui/widgets/demo/
  components_demo_screen.dart

---

🔹 COMPONENT SPECS

1) SoftCard
- uses ElevationTokens shadow
- uses RadiusTokens for shape
- supports:
  - child
  - padding
  - onTap
  - optional leading icon slot
- zero elevation Card widgets are OK, but prefer Container + BoxDecoration for full control.

2) SoftChip (pill)
- label
- selected
- onTap
- AnimatedContainer 160–200ms
- uses ColorTokens for selected bg and text

3) DuelAvatar
- size
- optional image provider
- fallback pastel bg when no image
- optional badge widget overlay bottom-right
- optional ring/border for “premium” state

4) GhostIconButton
- 44x44
- rounded square
- subtle bg
- ripple
- icon + optional onTap

5) PrimaryButton
- full width by default
- size variants: sm / md / lg
- states: enabled / disabled / loading
- loading shows spinner and disables tap
- uses tokens only
- no external packages

6) SectionHeader
- title
- optional action text button (e.g. "View more")
- aligns nicely in a row

7) StatPill
- small pill used for showing: rank, win rate, streak, badge
- supports:
  - icon
  - label
  - background variant (neutral / primarySoft / successSoft)
- uses tokens

8) EmptyState
- icon
- title
- subtitle
- action button optional
- clean spacing
- good for “No matches yet”

---

🔹 DEMO SCREEN (very important)

Create components_demo_screen.dart that visually showcases all components.
Put it as the first tab placeholder in AppShell temporarily
so we can preview components quickly.

The demo screen must:
- show SoftCard examples
- show chips in selected/unselected states
- show avatar variations
- show buttons (enabled/disabled/loading)
- show empty state

No external data.

---

🔹 PERFORMANCE RULES

- const constructors whenever possible
- keep build methods small
- avoid rebuild cascades
- use SizedBox and Padding efficiently
- no magic numbers (use SpacingTokens / RadiusTokens)

---

🔹 OUTPUT FORMAT

Return full file contents separated by file paths:

// lib/ui/widgets/soft_card.dart
// ...

Do not add any explanation outside code.
Be production-ready.