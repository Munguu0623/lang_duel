class DuelUser {
  const DuelUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.rating,
    required this.rank,
    this.winRate = 0.0,
    this.streak = 0,
    this.level = 'B1',
  });

  final String id;
  final String name;
  final String avatarUrl;
  final int rating;
  final String rank;
  final double winRate;
  final int streak;
  final String level;
}

class DuelMatch {
  const DuelMatch({
    required this.opponent,
    required this.prompt,
    this.durationSeconds = 60,
  });

  final DuelUser opponent;
  final String prompt;
  final int durationSeconds;
}

class ScoreBreakdown {
  const ScoreBreakdown({
    required this.pronunciation,
    required this.grammar,
    required this.fluency,
    required this.vocabulary,
  });

  final int pronunciation;
  final int grammar;
  final int fluency;
  final int vocabulary;

  int get total => pronunciation + grammar + fluency + vocabulary;
}

class DuelResult {
  const DuelResult({
    required this.userScore,
    required this.opponentScore,
    required this.isWin,
    required this.userBreakdown,
    required this.opponentBreakdown,
  });

  final int userScore;
  final int opponentScore;
  final bool isWin;
  final ScoreBreakdown userBreakdown;
  final ScoreBreakdown opponentBreakdown;
}

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.user,
    required this.rank,
    required this.wins,
    required this.totalMatches,
  });

  final DuelUser user;
  final int rank;
  final int wins;
  final int totalMatches;
}

/// A single recent match for the home feed.
class RecentMatch {
  const RecentMatch({
    required this.opponent,
    required this.didWin,
    required this.yourScore,
    required this.theirScore,
    required this.createdAt,
  });

  final DuelUser opponent;
  final bool didWin;
  final int yourScore;
  final int theirScore;
  final DateTime createdAt;
}

/// Badge earned by user (mock).
class DuelBadge {
  const DuelBadge({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final String icon;
}

/// Profile data snapshot for the profile screen.
class ProfileData {
  const ProfileData({
    required this.user,
    required this.totalMatches,
    required this.wins,
    required this.badges,
  });

  final DuelUser user;
  final int totalMatches;
  final int wins;
  final List<DuelBadge> badges;

  int get losses => totalMatches - wins;
}

/// Season progress snapshot.
class Season {
  const Season({
    required this.tier,
    required this.progress,
    required this.daysRemaining,
  });

  final String tier;

  /// 0.0 to 1.0
  final double progress;
  final int daysRemaining;
}
