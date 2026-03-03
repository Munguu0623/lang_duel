import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../duel_avatar.dart';
import '../empty_state.dart';
import '../ghost_icon_button.dart';
import '../primary_button.dart';
import '../section_header.dart';
import '../soft_card.dart';
import '../soft_chip.dart';
import '../stat_pill.dart';

/// Showcases every reusable component in one scrollable screen.
/// Placed temporarily as the first tab in AppShell for quick preview.
class ComponentsDemoScreen extends StatefulWidget {
  const ComponentsDemoScreen({super.key});

  @override
  State<ComponentsDemoScreen> createState() => _ComponentsDemoScreenState();
}

class _ComponentsDemoScreenState extends State<ComponentsDemoScreen> {
  int _selectedChip = 0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.base),
        children: [
          const SizedBox(height: SpacingTokens.base),
          Text('Component Kit', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: SpacingTokens.sm),
          Text('STEP 2 — UI Components', style: Theme.of(context).textTheme.bodyMedium),

          // ─── SoftCard ──────────────────────────────────────
          const SectionHeader(title: 'SoftCard'),
          const SoftCard(
            child: Text('Basic card with child'),
          ),
          const SizedBox(height: SpacingTokens.md),
          SoftCard(
            onTap: () {},
            child: const Text('Tappable card'),
          ),
          const SizedBox(height: SpacingTokens.md),
          SoftCard(
            leadingIcon: Icons.bolt_rounded,
            onTap: () {},
            child: const Text('Card with leading icon'),
          ),

          // ─── SoftChip ─────────────────────────────────────
          const SectionHeader(title: 'SoftChip'),
          Wrap(
            spacing: SpacingTokens.sm,
            children: [
              for (var i = 0; i < 4; i++)
                SoftChip(
                  label: ['All', 'Speaking', 'Debate', 'Quick'][i],
                  selected: _selectedChip == i,
                  onTap: () => setState(() => _selectedChip = i),
                ),
            ],
          ),

          // ─── DuelAvatar ───────────────────────────────────
          const SectionHeader(title: 'DuelAvatar'),
          Row(
            children: [
              const DuelAvatar(name: 'Alex', size: 48),
              const SizedBox(width: SpacingTokens.md),
              const DuelAvatar(name: 'Sara', size: 48, showRing: true),
              const SizedBox(width: SpacingTokens.md),
              DuelAvatar(
                name: 'David',
                size: 48,
                badge: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: c.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 10, color: Colors.white),
                ),
              ),
              const SizedBox(width: SpacingTokens.md),
              const DuelAvatar(name: 'Emma', size: 36),
              const SizedBox(width: SpacingTokens.md),
              const DuelAvatar(name: 'J', size: 28),
            ],
          ),

          // ─── GhostIconButton ──────────────────────────────
          const SectionHeader(title: 'GhostIconButton'),
          Row(
            children: [
              GhostIconButton(icon: Icons.notifications_none_rounded, onTap: () {}),
              const SizedBox(width: SpacingTokens.md),
              GhostIconButton(icon: Icons.arrow_back_rounded, onTap: () {}),
              const SizedBox(width: SpacingTokens.md),
              GhostIconButton(icon: Icons.settings_rounded, onTap: () {}),
              const SizedBox(width: SpacingTokens.md),
              const GhostIconButton(icon: Icons.more_horiz_rounded),
            ],
          ),

          // ─── PrimaryButton ────────────────────────────────
          const SectionHeader(title: 'PrimaryButton'),
          PrimaryButton(label: 'Start Duel', onPressed: () {}),
          const SizedBox(height: SpacingTokens.md),
          PrimaryButton(
            label: 'Loading...',
            onPressed: () {},
            isLoading: _isLoading,
          ),
          const SizedBox(height: SpacingTokens.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => setState(() => _isLoading = !_isLoading),
              child: Text(
                'Tap to toggle loading',
                style: TextStyle(fontSize: 13, color: c.primary),
              ),
            ),
          ),
          const SizedBox(height: SpacingTokens.md),
          const PrimaryButton(label: 'Disabled', onPressed: null),
          const SizedBox(height: SpacingTokens.md),
          Row(
            children: [
              PrimaryButton(label: 'SM', onPressed: () {}, expanded: false, size: ButtonSize.sm),
              const SizedBox(width: SpacingTokens.sm),
              PrimaryButton(label: 'MD', onPressed: () {}, expanded: false, size: ButtonSize.md),
              const SizedBox(width: SpacingTokens.sm),
              PrimaryButton(label: 'LG', onPressed: () {}, expanded: false, size: ButtonSize.lg),
            ],
          ),

          // ─── SectionHeader ────────────────────────────────
          SectionHeader(title: 'SectionHeader', actionText: 'View more', onAction: () {}),
          const SoftCard(child: Text('Content below the header')),

          // ─── StatPill ─────────────────────────────────────
          const SectionHeader(title: 'StatPill'),
          Wrap(
            spacing: SpacingTokens.sm,
            runSpacing: SpacingTokens.sm,
            children: const [
              StatPill(label: 'Gold', icon: Icons.workspace_premium_rounded),
              StatPill(
                label: '1450',
                icon: Icons.star_rounded,
                variant: StatPillVariant.primarySoft,
              ),
              StatPill(
                label: '70% Win',
                icon: Icons.trending_up_rounded,
                variant: StatPillVariant.successSoft,
              ),
              StatPill(label: '5 Streak', icon: Icons.local_fire_department_rounded),
            ],
          ),

          // ─── EmptyState ───────────────────────────────────
          const SectionHeader(title: 'EmptyState'),
          const SizedBox(
            height: 260,
            child: EmptyState(
              icon: Icons.sports_esports_rounded,
              title: 'No matches yet',
              subtitle: 'Start a duel to see your history here.',
              actionLabel: 'Start Duel',
            ),
          ),

          const SizedBox(height: SpacingTokens.xxl),
        ],
      ),
    );
  }
}
