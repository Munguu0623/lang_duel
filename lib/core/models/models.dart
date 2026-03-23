import 'package:equatable/equatable.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 📦 Data Models — immutable, equatable value objects
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// ── Tier / Rank ──────────────────────────────────────
enum TierLevel {
  bronze,
  silver,
  gold,
  diamond;

  String get label => switch (this) {
    TierLevel.bronze  => 'Bronze',
    TierLevel.silver  => 'Silver',
    TierLevel.gold    => 'Gold',
    TierLevel.diamond => 'Diamond',
  };

  String get emoji => switch (this) {
    TierLevel.bronze  => '🥉',
    TierLevel.silver  => '🥈',
    TierLevel.gold    => '🥇',
    TierLevel.diamond => '💎',
  };
}

// ── CEFR Level ───────────────────────────────────────
enum CefrLevel {
  a1, a2, b1, b2, c1;

  String get label => switch (this) {
    CefrLevel.a1 => 'A1',
    CefrLevel.a2 => 'A2',
    CefrLevel.b1 => 'B1',
    CefrLevel.b2 => 'B2',
    CefrLevel.c1 => 'C1',
  };
}

// ── User ─────────────────────────────────────────────
class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.displayName,
    this.emoji = '😎',
    this.tier = TierLevel.bronze,
    this.level = 1,
    this.xp = 0,
    this.coins = 0,
    this.totalDuels = 0,
    this.wins = 0,
    this.streak = 0,
    this.isPremium = false,
  });

  final String id;
  final String displayName;
  final String emoji;
  final TierLevel tier;
  final int level;
  final int xp;
  final int coins;
  final int totalDuels;
  final int wins;
  final int streak;
  final bool isPremium;

  double get winRate =>
      totalDuels == 0 ? 0 : (wins / totalDuels * 100);

  AppUser copyWith({
    String? displayName,
    String? emoji,
    TierLevel? tier,
    int? level,
    int? xp,
    int? coins,
    int? totalDuels,
    int? wins,
    int? streak,
    bool? isPremium,
  }) {
    return AppUser(
      id: id,
      displayName: displayName ?? this.displayName,
      emoji: emoji ?? this.emoji,
      tier: tier ?? this.tier,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      totalDuels: totalDuels ?? this.totalDuels,
      wins: wins ?? this.wins,
      streak: streak ?? this.streak,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  @override
  List<Object?> get props => [id];
}

// ── Topic ────────────────────────────────────────────
class DuelTopic extends Equatable {
  const DuelTopic({
    required this.id,
    required this.title,
    required this.prompt,
    required this.cefrLevel,
    required this.emoji,
  });

  final String id;
  final String title;
  final String prompt;     // The actual prompt shown during duel
  final CefrLevel cefrLevel;
  final String emoji;

  @override
  List<Object?> get props => [id];
}

// ── Score Breakdown ──────────────────────────────────
class ScoreBreakdown extends Equatable {
  const ScoreBreakdown({
    required this.grammar,
    required this.vocabulary,
    required this.fluency,
    required this.relevance,
  });

  final int grammar;    // out of 30
  final int vocabulary;  // out of 30
  final int fluency;     // out of 20
  final int relevance;   // out of 20

  int get total => grammar + vocabulary + fluency + relevance;

  @override
  List<Object?> get props => [grammar, vocabulary, fluency, relevance];
}

// ── Chat Message ─────────────────────────────────────
enum MessageSender { user, bot }

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
    this.audioUrl,
  });

  final MessageSender sender;
  final String text;
  final DateTime timestamp;
  final String? audioUrl;

  @override
  List<Object?> get props => [sender, text, timestamp];
}

// ── Duel Result ──────────────────────────────────────
class DuelResult extends Equatable {
  const DuelResult({
    required this.userScore,
    required this.botScore,
    required this.userBreakdown,
    required this.topic,
    required this.messages,
    this.aiAdvice,
  });

  final ScoreBreakdown userScore;
  final ScoreBreakdown botScore;
  final ScoreBreakdown userBreakdown;
  final DuelTopic topic;
  final List<ChatMessage> messages;
  final String? aiAdvice;

  bool get userWon => userScore.total > botScore.total;

  @override
  List<Object?> get props => [userScore, botScore, topic];
}

// ── Leaderboard Entry ────────────────────────────────
class LeaderboardEntry extends Equatable {
  const LeaderboardEntry({
    required this.rank,
    required this.displayName,
    required this.emoji,
    required this.score,
    required this.tier,
    this.isCurrentUser = false,
  });

  final int rank;
  final String displayName;
  final String emoji;
  final int score;
  final TierLevel tier;
  final bool isCurrentUser;

  @override
  List<Object?> get props => [rank, displayName];
}
