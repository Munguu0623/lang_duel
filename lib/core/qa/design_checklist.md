## ENGLISH DUEL – Design System Checklist

### 1. Spacing Rules
- **Base grid**: 8pt.
- **Allowed vertical/horizontal spacing tokens**:
  - `SpacingTokens.sm` = 8
  - `SpacingTokens.md` = 12
  - `SpacingTokens.base` = 16
  - `SpacingTokens.lg` = 20
  - `SpacingTokens.xl` = 24
  - `SpacingTokens.xxl` = 32
- **Micro spacing**:
  - `SpacingTokens.xs` = 4 — only for tight content gaps (between label + meta, inside pills).
- **Screen padding**:
  - Default horizontal padding: `SpacingTokens.base` (16).
  - Vertical sections use `SpacingTokens.lg/xl` between blocks.

### 2. Typography Rules
- **Text styles (see `TextStyles` in `tokens.dart`)**:
  - Headline (primary titles / names): `headlineLarge`, `headlineMedium`.
  - Section titles: `titleLarge`, `titleMedium`.
  - Primary body text: `bodyLarge`.
  - Secondary / helper text: `bodyMedium` (uses `ColorTokens.textSecondary`).
  - Metadata / small labels: `caption`.
- **Usage guidelines**:
  - Do not hardcode font sizes; always use `TextStyles` or theme text styles.
  - Primary readable text must use `ColorTokens.textPrimary`.
  - Secondary / hint text should use `ColorTokens.textSecondary` only.

### 3. Radius Rules
- **Allowed radii (from `RadiusTokens`)**:
  - Small elements: `RadiusTokens.small` (12).
  - Medium containers: `RadiusTokens.medium` (16).
  - Cards: `RadiusTokens.card` (20).
  - Larger surfaces: `RadiusTokens.large` (24).
  - Pills / chips / bottom nav: `RadiusTokens.pill` (28) or `StadiumBorder`.
- **Rules**:
  - No ad-hoc `Radius.circular(...)` outside tokens.
  - Cards and skeleton cards must use `RadiusTokens.card`.
  - Tall bars / podium shapes should reuse `RadiusTokens.small` where possible.

### 4. Elevation & Shadow Rules
- **Elevation tokens** (see `ElevationTokens` in `tokens.dart`):
  - `soft` — default card elevation.
  - `elevated` — higher emphasis (bottom nav, pressed card state).
- **Rules**:
  - Cards and surfaces must use `ElevationTokens`; do not inline `BoxShadow` except for special controls (e.g. mic button glow).
  - Shadows should remain subtle (low opacity, large blur, small offset).

### 5. Motion Rules
- **Durations** (see `MotionDurations`):
  - Fast: 140ms (press-scale, small state changes).
  - Medium: 180ms (most transitions).
  - Slow: 240ms (entry of composed content, e.g. score breakdown).
  - Countdown tick: 220ms.
- **Curves** (see `MotionCurves`):
  - Standard: `easeOutCubic`.
  - Enter: `easeOut`.
  - Exit: `easeIn`.
- **Rules**:
  - No bounce / elastic curves.
  - Scale transforms must stay within 1.00 → 1.03.
  - Prefer `AnimatedSwitcher`, `AnimatedOpacity`, `AnimatedScale` over manual controllers for simple cases.

### 6. Components & Reuse
- **Always reuse**:
  - Cards: `SoftCard`.
  - Chips: `SoftChip`.
  - Primary actions: `PrimaryButton`.
  - Avatars: `DuelAvatar`.
  - Icon buttons: `GhostIconButton`.
  - Section headers: `SectionHeader`.
  - Status / stats: `StatPill`.
  - Empty states: `EmptyState`.
  - Top app bar in-flow: `TopBar`.
  - Skeletons: `SkeletonBox`, `SkeletonLine`, `SkeletonCard`.
  - Motion: `CountUpText`, `PressableScale`.
- Do **not** reimplement ad-hoc containers that duplicate these patterns.

### 7. Accessibility & Tap Targets
- **Tap targets**:
  - Icon buttons: at least 44×44 (use `GhostIconButton`).
  - Primary buttons: height ≥ 48 (`PrimaryButton` uses 44/48/56, prefer `md` for main actions).
  - List items: use `SoftCard` with at least `SpacingTokens.base` padding.
- **Contrast**:
  - Primary text: `ColorTokens.textPrimary` on `ColorTokens.surface` / `ColorTokens.background`.
  - Secondary text: `ColorTokens.textSecondary` only for non-critical information.
  - Avoid using `ColorTokens.surfaceGrey` as text color.

### 8. Performance Guidelines
- Use `const` constructors wherever possible for stateless UI.
- Keep heavy timers / state in dedicated controllers (`DuelController`, `ValueNotifier` + `ValueListenableBuilder`).
- Wrap frequently updating regions with `RepaintBoundary` (e.g. live transcript).
- Avoid nested scrollables and `shrinkWrap: true` lists when not necessary.
- Keep shadow animations minimal (small delta in blur/opacity only).

