import 'dart:math';

import 'fake_models.dart';

class FakeData {
  FakeData._();

  static final _random = Random();

  static const currentUser = DuelUser(
    id: 'user_0',
    name: 'Munkh',
    avatarUrl: '',
    rating: 1450,
    rank: 'Gold',
    winRate: 0.62,
    streak: 4,
    level: 'B2',
  );

  static const opponents = [
    DuelUser(id: 'u1', name: 'Alex Kim', avatarUrl: '', rating: 1380, rank: 'Silver'),
    DuelUser(id: 'u2', name: 'Sara Chen', avatarUrl: '', rating: 1520, rank: 'Gold'),
    DuelUser(id: 'u3', name: 'David Park', avatarUrl: '', rating: 1290, rank: 'Silver'),
    DuelUser(id: 'u4', name: 'Emma Liu', avatarUrl: '', rating: 1610, rank: 'Diamond'),
    DuelUser(id: 'u5', name: 'James Lee', avatarUrl: '', rating: 1440, rank: 'Gold'),
    DuelUser(id: 'u6', name: 'Mia Wang', avatarUrl: '', rating: 1350, rank: 'Silver'),
    DuelUser(id: 'u7', name: 'Noah Tanaka', avatarUrl: '', rating: 1480, rank: 'Gold'),
    DuelUser(id: 'u8', name: 'Olivia Sato', avatarUrl: '', rating: 1560, rank: 'Gold'),
    DuelUser(id: 'u9', name: 'Lucas Yamada', avatarUrl: '', rating: 1200, rank: 'Bronze'),
    DuelUser(id: 'u10', name: 'Sophia Nguyen', avatarUrl: '', rating: 1670, rank: 'Diamond'),
  ];

  static const prompts = [
    'Describe your ideal vacation destination and explain why.',
    'Debate: Is social media more harmful than helpful?',
    'Tell a story about an unexpected adventure.',
    'Explain the most important invention in human history.',
    'Convince me to try your favorite hobby.',
    'Describe a challenge you overcame and what you learned.',
    'Debate: Should AI replace teachers in schools?',
    'Explain how technology has changed communication.',
  ];

  static const fakeTranscriptLines = [
    'Well, I think the most important thing is...',
    'From my perspective, this topic is really interesting because...',
    'Let me explain my point of view on this...',
    'I strongly believe that we should consider...',
    'Another important aspect to mention is...',
    'In conclusion, I would say that...',
  ];

  static DuelUser getRandomOpponent() {
    return opponents[_random.nextInt(opponents.length)];
  }

  static String getRandomPrompt() {
    return prompts[_random.nextInt(prompts.length)];
  }

  static DuelResult generateFakeResult() {
    final userBreakdown = ScoreBreakdown(
      pronunciation: 15 + _random.nextInt(11),
      grammar: 15 + _random.nextInt(11),
      fluency: 15 + _random.nextInt(11),
      vocabulary: 15 + _random.nextInt(11),
    );
    final opponentBreakdown = ScoreBreakdown(
      pronunciation: 15 + _random.nextInt(11),
      grammar: 15 + _random.nextInt(11),
      fluency: 15 + _random.nextInt(11),
      vocabulary: 15 + _random.nextInt(11),
    );
    return DuelResult(
      userScore: userBreakdown.total,
      opponentScore: opponentBreakdown.total,
      isWin: userBreakdown.total >= opponentBreakdown.total,
      userBreakdown: userBreakdown,
      opponentBreakdown: opponentBreakdown,
    );
  }

  /// Full leaderboard including the current user.
  static List<LeaderboardEntry> get leaderboard {
    final all = [currentUser, ...opponents];
    final sorted = List<DuelUser>.from(all)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return [
      for (var i = 0; i < sorted.length; i++)
        LeaderboardEntry(
          user: sorted[i],
          rank: i + 1,
          wins: 20 + _random.nextInt(30),
          totalMatches: 40 + _random.nextInt(30),
        ),
    ];
  }

  // ─── Profile data ─────────────────────────────────────────────

  static const profileData = ProfileData(
    user: currentUser,
    totalMatches: 60,
    wins: 37,
    badges: [
      DuelBadge(id: 'b1', label: 'First Win', icon: '1'),
      DuelBadge(id: 'b2', label: '10 Streak', icon: '2'),
      DuelBadge(id: 'b3', label: 'Fluent', icon: '3'),
      DuelBadge(id: 'b4', label: 'Debater', icon: '4'),
      DuelBadge(id: 'b5', label: 'Grammar Pro', icon: '5'),
    ],
  );

  // ─── Home screen data ────────────────────────────────────────

  static const season = Season(
    tier: 'Silver',
    progress: 0.65,
    daysRemaining: 18,
  );

  static final recentMatches = [
    RecentMatch(
      opponent: opponents[1],
      didWin: true,
      yourScore: 78,
      theirScore: 65,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      rankChange: 3,
    ),
    RecentMatch(
      opponent: opponents[3],
      didWin: false,
      yourScore: 62,
      theirScore: 71,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      rankChange: -2,
    ),
    RecentMatch(
      opponent: opponents[0],
      didWin: true,
      yourScore: 81,
      theirScore: 74,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      rankChange: 5,
    ),
    RecentMatch(
      opponent: opponents[6],
      didWin: true,
      yourScore: 73,
      theirScore: 68,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
      rankChange: 1,
    ),
    RecentMatch(
      opponent: opponents[4],
      didWin: false,
      yourScore: 59,
      theirScore: 77,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      rankChange: -4,
    ),
  ];
}
