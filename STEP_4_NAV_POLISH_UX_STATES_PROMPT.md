You are a senior Flutter UI/UX engineer.

Context:
We have an ENGLISH DUEL Flutter UI-only prototype.
We already implemented:
- design tokens + theme
- reusable widgets
- mock data
- duel state machine + duel flow screens (ModeSelect, Searching, Found, Live, Scoring, Result)
- AppShell with bottom navigation

Now implement FOUNDATION — STEP 4:
Navigation & AppShell polish + transitions + UX system states.

No backend. No audio. No external packages.

---

🎯 GOALS

1) Make navigation clean and scalable:
   - Centralized route names
   - Clear separation: AppShell tabs vs Duel Flow full-screen routes
   - Ability to deep link into duel flow later

2) Improve UX polish:
   - Smooth page transitions (subtle fade/slide)
   - Consistent app bars / top bars
   - SafeArea handling
   - Loading, empty, error UI states
   - Permission-denied placeholder UI (mic permission UI only, not real permission request)

3) Ensure performance:
   - avoid rebuild cascades
   - keep tab screens alive with IndexedStack
   - only duel flow routes push full-screen

---

✅ FILES TO CREATE / UPDATE

UPDATE:
lib/app/app_router.dart
lib/ui/shell/app_shell.dart

CREATE:
lib/app/routes.dart                (route names + helper methods)
lib/ui/widgets/top_bar.dart        (reusable top bar: back + title + optional action)
lib/ui/widgets/loading_overlay.dart (simple loading overlay widget)
lib/ui/widgets/error_state.dart    (generic error state)
lib/ui/widgets/permission_state.dart (mic permission missing UI)

OPTIONAL (if not existing):
lib/core/utils/page_transitions.dart (custom PageRouteBuilder helpers)

---

🔹 NAVIGATION SPEC

Routes:
- "/" -> AppShell
- "/duel/mode"
- "/duel/search"
- "/duel/found"
- "/duel/live"
- "/duel/scoring"
- "/duel/result"

Rule:
- Bottom tabs are inside AppShell only.
- Duel flow is full-screen push routes (so bottom nav is hidden in duel flow).
- Provide helper methods like:
  Routes.goToDuelMode(context)
  Routes.goToDuelLive(context)
  Routes.backToHomeRoot(context)

Implement router with:
- Navigator 1.0 (onGenerateRoute)
- Custom transitions using PageRouteBuilder

---

🔹 APP SHELL POLISH

- Use SafeArea properly (top and bottom)
- Bottom nav pinned with soft card style (already have component)
- Tab index state local
- Placeholders for:
  Home tab -> HomeScreen
  Duel tab -> shows "Start Duel" CTA card (navigates to /duel/mode)
  Rank tab -> placeholder list (empty state)
  Profile tab -> placeholder with stat pills + settings button (fake)

Add a global “snackbar helper” in AppShell for mock notifications (optional).

---

🔹 TOP BAR COMPONENT

TopBar must support:
- back button (optional)
- centered title
- optional right action icon button
- consistent height and spacing
- uses tokens and existing GhostIconButton

All duel screens should use TopBar for consistency.

---

🔹 UX STATES COMPONENTS

1) LoadingOverlay
- full screen dim + centered spinner + label text (optional)
- must be reusable

2) ErrorState
- icon + title + subtitle + primary action button
- style consistent with EmptyState

3) PermissionState (Mic)
- icon (mic_off)
- message: “Microphone permission required”
- action button: “Open settings” (mock, no actual open)

These are UI skeletons only.

---

🔹 FLOW POLISH REQUIREMENTS

- Searching screen: allow cancel → go back to mode screen
- Found screen: countdown transition uses smooth fade
- Live screen: transcript section is isolated with RepaintBoundary
- Result screen: has two actions: Rematch (go to /duel/search) and Back Home (pop to root)

Add tiny micro-interactions:
- buttons press scale (small)
- subtle AnimatedOpacity for transitions

Keep animations subtle, 150–200ms.

---

🔹 OUTPUT RULES

Return full code separated by file paths.
Do not explain outside code.
No extra packages.
Be clean, production-grade, scalable.