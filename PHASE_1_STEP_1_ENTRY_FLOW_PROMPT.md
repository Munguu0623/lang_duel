You are a senior Flutter UX architect.

We are building ENGLISH DUEL — a competitive AI-powered voice battle app.

This is PHASE 1 — STEP 1:
Implement the full Entry Flow UI (no backend yet).

This must feel premium, fast, minimal, competitive.
No childish visuals.
No over-animation.

Use existing:
- tokens.dart
- duel_theme.dart
- reusable widgets
- motion system

No external packages.
No backend.
Use fake data only.

---

🎯 GOAL

Build this complete flow:

Splash
  ↓
Version Check (mock delay)
  ↓
Onboarding (max 3 slides)
  ↓
Auth Choice
  ↓
Username Setup
  ↓
Avatar Select
  ↓
Level Select
  ↓
Home

After Level Select → navigate into AppShell (Home tab active).

---

🔹 UX RULES

• Entire flow must take < 30 seconds
• Skip buttons available where appropriate
• No long forms
• One primary CTA per screen
• Smooth 180ms transitions
• Use fade + slight slide transitions only

---

🔹 CREATE THESE FILES

lib/features/auth/screens/
  splash_screen.dart
  onboarding_screen.dart
  auth_choice_screen.dart
  username_screen.dart
  avatar_select_screen.dart
  level_select_screen.dart

lib/features/auth/
  auth_flow_controller.dart

Update:
lib/app/app_router.dart

---

🔹 SCREEN SPECS

1) SplashScreen
- Center logo (text logo is fine)
- Subtle fade in
- After 1.5 sec → Version check (fake Future.delayed)
- Navigate to Onboarding

2) OnboardingScreen
- 3 pages max
- Horizontal PageView
- Each page:
   • Title
   • Subtitle
   • Minimal illustration placeholder
- Bottom:
   • Dot indicators
   • PrimaryButton "Continue"
   • "Skip" text button top-right
- Last page → AuthChoice

3) AuthChoiceScreen
- Title: "Enter the Arena"
- Subtitle short
- Buttons:
   • Continue with Apple
   • Continue with Google
   • Continue as Guest (small text)
- Buttons simulate success → Username screen

4) UsernameScreen
- TextField (single field)
- Character limit 15
- Validation: min 3 chars
- PrimaryButton disabled until valid
- Continue → AvatarSelect

5) AvatarSelectScreen
- Grid of 12 avatar placeholders
- Selected state highlight ring
- PrimaryButton continue
- Skip allowed
- Continue → LevelSelect

6) LevelSelectScreen
- Chips for A1, A2, B1, B2, C1
- Brief explanation
- PrimaryButton continue
- Skip allowed
- Continue → pushReplacement to AppShell (Home)

---

🔹 STATE MANAGEMENT

Use a simple AuthFlowController with:
- username
- avatarId
- level
- isGuest

Use ValueNotifier or ChangeNotifier (no Riverpod yet).

Do not store anything permanently.
Mock only.

---

🔹 NAVIGATION RULES

Use centralized route names.
Auth flow routes separate from AppShell routes.

When flow completes:
Navigator.pushReplacementNamed(context, "/")

---

🔹 PERFORMANCE RULES

• const everywhere possible
• split widgets
• avoid rebuilding entire page on text change
• use ValueListenableBuilder for validation
• PageView should not rebuild full screen unnecessarily

---

🔹 OUTPUT FORMAT

Return full file contents separated by file paths:

// lib/features/auth/screens/splash_screen.dart
// ...

No explanation.
Production-ready.
Clean structure.
Scalable for future real auth integration.