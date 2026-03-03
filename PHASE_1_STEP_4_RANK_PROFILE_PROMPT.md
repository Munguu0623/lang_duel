You are a senior Flutter product UI engineer specializing in competitive systems.

We are building ENGLISH DUEL (competitive voice battle app).

PHASE 1 — STEP 4:
Implement Leaderboard + Profile UI layer (mock only).

No backend.
No real ranking engine.
Use mock data only.

Use existing:
- tokens + theme
- widgets kit
- motion system
- duel flow
- home screen
- router
- mock layer

---

🎯 GOALS

1) Build competitive prestige feel.
2) Make ranking visually strong but minimal.
3) Make profile feel like a skill identity.
4) Keep everything token-based and performance safe.

---

✅ CREATE THESE FILES

lib/features/leaderboard/
  leaderboard_screen.dart
  widgets/
    leaderboard_tile.dart
    top_three_header.dart

lib/features/profile/
  profile_screen.dart
  widgets/
    profile_header.dart
    stats_grid.dart
    match_history_tile.dart
    badge_row.dart

UPDATE:
lib/ui/shell/app_shell.dart
  - Rank tab → LeaderboardScreen
  - Profile tab → ProfileScreen

If needed:
lib/mock/fake_data.dart (extend mock ranking + profile data)

---

🔹 LEADERBOARD SCREEN SPEC

Top:
- Title: "Leaderboard"
- Toggle: Global / Weekly (SoftChip toggle)
- Current user rank highlighted card at top

Top 3 section:
- Special layout:
   1st center slightly bigger
   2nd left
   3rd right
- Subtle elevated SoftCard style
- Rank badge minimal

Below:
- ListView.builder ranking list
- Each row:
   - rank number
   - avatar
   - username
   - level (B1 etc)
   - win rate %
- Current user row highlighted (primarySoft bg)

No heavy colors.
Prestige minimalism.

---

🔹 PROFILE SCREEN SPEC

Top ProfileHeader:
- Large avatar
- Username
- Rank badge
- Level badge
- Win rate

StatsGrid:
- 2x2 grid:
   • Total Matches
   • Wins
   • Win Rate
   • Current Streak

BadgeRow:
- Horizontal scroll badges (mock)

Match History:
- SectionHeader "Match history"
- ListView.builder of 5 mock matches
- Each tile:
   - opponent
   - result
   - score
   - date

---

🔹 VISUAL RULES

- Use StatPill where possible
- Consistent 8pt spacing
- Rank highlight subtle
- No gradients
- No trophy emojis
- Clean esports prestige vibe

---

🔹 ANIMATION RULES

- Leaderboard list fade-in on load
- Top 3 slight scale entrance animation
- Profile stats grid subtle AnimatedOpacity
- No bounce effects

---

🔹 PERFORMANCE RULES

- Use const constructors
- Split widgets properly
- ListView.builder for lists
- Avoid rebuilding entire screen
- No shrinkWrap in large scrolls
- Avoid nested scroll traps

---

🔹 MOCK DATA REQUIRED

LeaderboardUser:
- rank
- username
- avatarId
- level
- winRate
- isCurrentUser

ProfileData:
- username
- avatarId
- level
- rank
- totalMatches
- wins
- streak
- badges list
- recentMatches list

Provide fake data in fake_data.dart.

---

🔹 OUTPUT FORMAT

Return full file contents separated by file paths.
No explanation.
Production-ready.
Token-only styling.
Mock only.