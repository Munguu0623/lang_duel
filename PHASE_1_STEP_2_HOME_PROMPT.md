You are a senior Flutter product UI engineer.

We are building ENGLISH DUEL (standalone competitive voice battle app).

PHASE 1 — STEP 2:
Implement the HOME experience (UI-only, mock data).
Entry Flow (Step 1) already routes to AppShell home tab.

No backend, no network.
Use mock data from lib/mock/.

Use existing:
- tokens.dart, duel_theme.dart
- widgets kit (SoftCard, StatPill, SectionHeader, PrimaryButton, etc.)
- motion system (fade/slide, pressable scale)
- app shell with bottom tabs

---

🎯 GOALS

1) Home must instantly explain the product:
   - "Start Duel" is the primary CTA
   - show skill/rank snapshot
   - show recent matches (mock)
   - show season progress (mock)

2) UX must be premium and minimal:
   - whitespace
   - consistent tokens
   - 8pt spacing grid
   - no clutter

3) Performance:
   - ListView.builder for recent matches
   - const usage
   - split widgets
   - no heavy layouts

---

✅ CREATE/UPDATE FILES

CREATE:
lib/features/home/
  home_screen.dart
  widgets/
    home_header.dart
    quick_stats_row.dart
    start_duel_card.dart
    recent_match_tile.dart
    season_progress_card.dart

UPDATE:
lib/ui/shell/app_shell.dart
  - Home tab points to HomeScreen
  - Duel tab can show a simple CTA too (optional)
lib/app/app_router.dart
  - add route to Duel Mode screen: "/duel/mode" (even if not built yet, keep as placeholder)

If mock files don't exist yet:
CREATE minimal:
lib/mock/fake_models.dart
lib/mock/fake_data.dart

---

🔹 HOME SCREEN LAYOUT SPEC

Top area (Header):
- Greeting: "Hello,"
- Username (from mock user / flow controller)
- Right side: avatar circle
- Left: notification ghost icon button (opens placeholder notifications modal/snackbar)

Quick stats row (StatPill):
- Rank (e.g. #128)
- Win rate (e.g. 62%)
- Streak (e.g. 4)
- Level (e.g. B1)

Primary CTA:
- StartDuelCard:
  - big SoftCard
  - title: "Start a Duel"
  - subtitle: "60 seconds. AI judges."
  - primary button inside: "Quick Duel"
  - onTap navigates to "/duel/mode"

Season Progress:
- SeasonProgressCard:
  - shows current tier badge (Silver)
  - progress bar (fake)
  - "Season ends in X days" (mock)

Recent Matches section:
- SectionHeader: "Recent matches" + "View more"
- List of 5 matches (ListView.builder)
- Each tile:
  - opponent avatar
  - result chip (Win/Lose)
  - score (you vs them)
  - time ago (2h ago)
  - tap → placeholder match detail (snackbar ok)

Empty state:
- if no matches show EmptyState component with CTA "Start first duel"

---

🔹 DATA SPEC (mock)

User:
- username
- avatarId
- level
- rank
- winRate
- streak
Season:
- tier
- progress (0..1)
RecentMatch:
- opponentName, opponentAvatarId
- didWin bool
- yourScore, theirScore
- createdAt

Provide fake_data.dart returning stable fake objects.

---

🔹 ANIMATION / MICRO-INTERACTION

- StartDuelCard press scale
- Result chip subtle fade-in
- Home sections load with AnimatedOpacity (optional)
All durations 140–200ms.

---

🔹 OUTPUT FORMAT

Return full file contents separated by file paths.

No explanations outside code.
No extra packages.
Production-ready, clean, token-based.