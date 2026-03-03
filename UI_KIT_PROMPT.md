You are a senior Flutter UI architect.

Build a clean, minimal, soft-rounded UI system inspired by modern education/productivity apps.

Design style requirements:

• Very clean layout
• Light background (#F6F7FB feel)
• White elevated cards
• Soft shadows (subtle, not heavy)
• Rounded corners (16–28 radius)
• Minimal color palette
• Primary accent: soft purple (#6E6AF6 range)
• Secondary accent: very light grey surfaces
• Typography: modern, geometric (Inter style)
• No harsh borders
• Very smooth, premium feeling

This is for a standalone app called “English Duel”.

---

PROJECT STRUCTURE:

Generate a modular Flutter UI kit with:

lib/ui/
    duel_theme.dart
    widgets/
        soft_card.dart
        soft_chip.dart
        duel_avatar.dart
        ghost_icon_button.dart
        duel_bottom_nav.dart
    screens/
        home_screen.dart
        progress_screen.dart

---

DESIGN SYSTEM REQUIREMENTS:

1. duel_theme.dart must contain:
   - Color constants
   - Border radius tokens
   - Spacing constants
   - Text theme
   - Soft shadow helper

2. soft_card widget:
   - White surface
   - Soft shadow
   - Rounded 20 radius
   - Optional onTap

3. soft_chip widget:
   - Pill shape
   - Selected/unselected state
   - Subtle background change
   - AnimatedContainer transition

4. duel_avatar:
   - Circular
   - Optional image
   - Optional badge overlay
   - Soft pastel background if no image

5. ghost_icon_button:
   - Rounded square 44x44
   - Light grey background
   - Centered icon

6. duel_bottom_nav:
   - Rounded container
   - Floating center FAB style
   - Active state highlight
   - Soft purple tint when active

---

HOME SCREEN LAYOUT:

Top:
• Notification icon
• Achievement text
• Avatar

Greeting:
• “Hello,”
• Username bold large

Horizontal filter chips

Upcoming section:
• Section title
• View more text button

Scrollable card list:
• Avatars row
• Date
• Title
• Subtitle
• Time row
• Circular arrow button

No heavy colors.
No gradients.
No dark mode.
Light mode only.

---

PROGRESS SCREEN LAYOUT:

Top row:
• Back button
• Centered title
• Settings icon

Horizontal calendar chips

Statistics card:
• Section label
• Title
• Arrow icon button
• Placeholder graph area (simple bars using Containers)

Use pure Flutter (no external chart libraries).

---

ANIMATION RULES:

• Use AnimatedContainer for state transitions
• Use 150–200ms duration
• No flashy effects

---

IMPORTANT:

• Code must be clean and production-ready
• No comments explaining basics
• No placeholder lorem ipsum
• Use proper file separation
• Do not put everything in one file
• Follow best Flutter architecture practices
• Avoid unnecessary rebuilds

Return full file contents for each file clearly separated with file paths.

Do not explain anything.
Only output code.