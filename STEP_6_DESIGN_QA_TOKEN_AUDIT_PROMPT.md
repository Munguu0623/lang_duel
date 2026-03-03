You are a senior UI/UX QA engineer + Flutter design systems maintainer.

Context:
We have an ENGLISH DUEL Flutter UI prototype.
We already implemented:
- design tokens + theme
- reusable widgets kit
- duel flow screens
- navigation polish
- motion + skeleton + micro-interactions

Now implement FOUNDATION — STEP 6:
A professional design QA and consistency pass.

No backend.
No new features.
This step is about quality and system integrity.

---

🎯 GOALS

1) Visual consistency:
   - spacing, alignment, typography hierarchy
   - consistent paddings (8pt grid)
   - consistent corner radius usage
   - consistent shadows/elevation usage

2) Token enforcement:
   - remove remaining magic numbers where possible
   - replace with SpacingTokens / RadiusTokens / ElevationTokens / ColorTokens

3) Component audit:
   - ensure widgets are reusable and not duplicated across screens
   - refactor repeated patterns into widgets (TopBar, SectionHeader, StatPill, etc.)

4) Accessibility & readability:
   - ensure text contrast is readable
   - avoid light grey for primary text
   - tap target sizes at least 44x44

5) Performance audit:
   - const usage improvements
   - split large widgets
   - isolate rebuild-heavy parts
   - ensure no IntrinsicHeight/Width, no excessive shrinkWrap, no nested scroll traps

---

✅ TASKS TO PERFORM (must do all)

A) SPACING SYSTEM AUDIT
- Define allowed spacing values: 8, 12, 16, 20, 24, 32
- Scan UI screens and widgets:
  - Replace random paddings/margins with nearest token value
  - Ensure consistent screen padding (default 16)

B) TYPOGRAPHY HIERARCHY AUDIT
- Ensure usage is consistent:
  - headlineSmall for key titles
  - titleMedium for section headings
  - bodyMedium for normal text
  - caption/small style for metadata (date/time)
- Create missing text styles in tokens/theme if needed:
  - caption
  - mono score style (optional)

C) RADIUS AUDIT
- Ensure only token radii are used:
  - r12, r16, r20, r24, r28
- Cards should default to r20 (or r24 if already chosen)
- Pills/chips should use r28

D) ELEVATION/SHADOW AUDIT
- Ensure all cards use ElevationTokens (no custom BoxShadow scattered)
- Create 2 elevation levels max:
  - card
  - floating (nav / modal)
- Reduce heavy shadows if any (premium subtle only)

E) COMPONENT DEDUPLICATION
- Identify repeated UI patterns in screens and extract into widgets:
  - row with title + action -> SectionHeader
  - icon button container -> GhostIconButton
  - score row -> ScoreRow widget
  - breakdown list item -> ScoreBreakdownTile widget
- Ensure no screen re-implements the same container styles.

F) ACCESSIBILITY & TAP TARGETS
- Validate:
  - all icon buttons are 44x44
  - primary buttons min height 48
  - list item touch area is comfortable
- Ensure color contrast:
  - primary text not lighter than ColorTokens.text
  - subtitles use ColorTokens.textSub

G) PERFORMANCE PASS
- Add const constructors where possible
- Split big build methods into private widgets
- Add RepaintBoundary only where needed (live transcript)
- Avoid AnimatedContainer shadow animation if it causes jank (keep minimal)

---

✅ FILES TO CREATE/UPDATE

CREATE:
lib/core/qa/design_checklist.md
  - A checklist for future screens to follow:
    - spacing rules
    - typography rules
    - radius rules
    - elevation rules
    - motion rules

UPDATE (as needed):
- tokens.dart
- duel_theme.dart
- any widget files that violate tokens
- any screens with inconsistent spacing/alignment

---

🔹 OUTPUT FORMAT

1) Return updated code separated by file paths.
2) Return the new `design_checklist.md`.
3) No explanations outside of code/markdown.
4) Keep changes minimal but strict.
5) Ensure everything still compiles.

This step is about making the UI system future-proof.
Be strict like a design systems team.