/// Application-wide constants.
///
/// Centralised so nothing is hard-coded in feature code.
library;

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 🔧 Constants — API URLs, game rules, limits
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

abstract final class ApiConfig {
  static const baseUrl = 'https://api.voiceduel.app/v1';
  static const openAiBaseUrl = 'https://api.openai.com/v1';
  static const deepSeekBaseUrl = 'https://api.deepseek.com/v1';

  static const connectionTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 30);
}

abstract final class DuelConfig {
  /// Maximum seconds to wait for a PvP opponent.
  static const matchmakingTimeout = Duration(seconds: 20);

  /// Seconds each player gets per turn.
  static const turnDuration = 20;

  /// Number of rounds in a single duel.
  static const roundCount = 3;

  /// Maximum score per duel (sum of all categories).
  static const maxScore = 100;
}

abstract final class GameConfig {
  /// Free users get this many duels per day.
  static const freeDailyDuelLimit = 3;

  /// Coins awarded per win / loss.
  static const coinsPerWin = 15;
  static const coinsPerLoss = 5;

  /// XP awarded per win / loss.
  static const xpPerWin = 25;
  static const xpPerLoss = 10;
}

abstract final class StorageKeys {
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
  static const userId = 'user_id';
  static const isPremium = 'is_premium';
  static const dailyDuelCount = 'daily_duel_count';
  static const lastDuelDate = 'last_duel_date';
  static const coins = 'coins';
  static const xp = 'xp';
}
