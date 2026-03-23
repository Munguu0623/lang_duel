import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_duel/core/models/models.dart';
import 'package:voice_duel/core/services/api_service.dart';
import 'package:voice_duel/core/services/audio_service.dart';
import 'package:voice_duel/core/constants/app_constants.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 🧠 Providers — single source of truth for app state
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// ── Services ─────────────────────────────────────────
final apiServiceProvider = Provider<ApiService>((_) => ApiService());
final audioServiceProvider = Provider<AudioService>((_) => AudioService());

// ── Auth / User ──────────────────────────────────────
final currentUserProvider = StateNotifierProvider<UserNotifier, AppUser?>(
  (ref) => UserNotifier(),
);

class UserNotifier extends StateNotifier<AppUser?> {
  UserNotifier() : super(null);

  void login(AppUser user) => state = user;
  void logout() => state = null;

  void addCoins(int amount) {
    if (state == null) return;
    state = state!.copyWith(coins: state!.coins + amount);
  }

  void addXp(int amount) {
    if (state == null) return;
    state = state!.copyWith(xp: state!.xp + amount);
  }

  void recordDuel({required bool won}) {
    if (state == null) return;
    state = state!.copyWith(
      totalDuels: state!.totalDuels + 1,
      wins: won ? state!.wins + 1 : state!.wins,
      streak: won ? state!.streak + 1 : 0,
      coins: state!.coins + (won ? GameConfig.coinsPerWin : GameConfig.coinsPerLoss),
      xp: state!.xp + (won ? GameConfig.xpPerWin : GameConfig.xpPerLoss),
    );
  }

  void setPremium(bool value) {
    if (state == null) return;
    state = state!.copyWith(isPremium: value);
  }
}

// ── Daily Duel Limit ─────────────────────────────────
final dailyDuelCountProvider = StateProvider<int>((_) => 0);

final canPlayDuelProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user?.isPremium == true) return true;
  final count = ref.watch(dailyDuelCountProvider);
  return count < GameConfig.freeDailyDuelLimit;
});

// ── Duel State ───────────────────────────────────────
enum DuelPhase { idle, matchmaking, ready, speaking, botTurn, transition, finished }

final duelPhaseProvider = StateProvider<DuelPhase>((_) => DuelPhase.idle);
final duelRoundProvider = StateProvider<int>((_) => 1);
final duelTimerProvider = StateProvider<int>((_) => DuelConfig.turnDuration);
final duelMessagesProvider = StateProvider<List<ChatMessage>>((_) => []);
final duelUserScoreProvider = StateProvider<int>((_) => 0);
final duelBotScoreProvider = StateProvider<int>((_) => 0);
final isRecordingProvider = StateProvider<bool>((_) => false);

// ── Duel Result ──────────────────────────────────────
final lastDuelResultProvider = StateProvider<DuelResult?>((_) => null);

// ── Topics ───────────────────────────────────────────
final topicsProvider = Provider<List<DuelTopic>>((_) => [
  const DuelTopic(
    id: '1',
    title: 'Өөрийгөө танилцуул',
    prompt: 'Tell me about yourself and your daily routine',
    cefrLevel: CefrLevel.a2,
    emoji: '🗣️',
  ),
  const DuelTopic(
    id: '2',
    title: 'Аялал',
    prompt: 'Describe your dream travel destination and why you want to go there',
    cefrLevel: CefrLevel.b1,
    emoji: '✈️',
  ),
  const DuelTopic(
    id: '3',
    title: 'Технологи',
    prompt: 'How has technology changed the way people communicate?',
    cefrLevel: CefrLevel.b2,
    emoji: '💻',
  ),
  const DuelTopic(
    id: '4',
    title: 'Цаг уурын өөрчлөлт',
    prompt: 'What can individuals do to reduce climate change?',
    cefrLevel: CefrLevel.c1,
    emoji: '🌍',
  ),
  const DuelTopic(
    id: '5',
    title: 'Хоол, Соёл',
    prompt: 'Tell me about your favorite food and its cultural significance',
    cefrLevel: CefrLevel.a2,
    emoji: '🍜',
  ),
  const DuelTopic(
    id: '6',
    title: 'Ажил мэргэжил',
    prompt: 'What is your ideal career and what steps are you taking to achieve it?',
    cefrLevel: CefrLevel.b1,
    emoji: '💼',
  ),
]);

// ── Selected Topic ───────────────────────────────────
final selectedTopicProvider = StateProvider<DuelTopic?>((ref) => null);

// ── Leaderboard ──────────────────────────────────────
final leaderboardProvider = Provider<List<LeaderboardEntry>>((_) => [
  const LeaderboardEntry(rank: 1, displayName: 'Bat_Bold', emoji: '🦅', score: 2850, tier: TierLevel.gold),
  const LeaderboardEntry(rank: 2, displayName: 'Saran_AI', emoji: '🌙', score: 2720, tier: TierLevel.gold),
  const LeaderboardEntry(rank: 3, displayName: 'Dulguun99', emoji: '🐺', score: 2580, tier: TierLevel.gold),
  const LeaderboardEntry(rank: 4, displayName: 'Nomin_Eng', emoji: '🌸', score: 2340, tier: TierLevel.silver),
  const LeaderboardEntry(rank: 5, displayName: 'Tulgaa_Pro', emoji: '⚡', score: 2180, tier: TierLevel.silver),
  const LeaderboardEntry(rank: 6, displayName: 'Anu_Speaker', emoji: '🎤', score: 2050, tier: TierLevel.silver),
  const LeaderboardEntry(rank: 7, displayName: 'Player_MN', emoji: '😎', score: 1920, tier: TierLevel.silver, isCurrentUser: true),
  const LeaderboardEntry(rank: 8, displayName: 'Munkh_99', emoji: '🔥', score: 1780, tier: TierLevel.bronze),
  const LeaderboardEntry(rank: 9, displayName: 'Zaya_Learner', emoji: '📚', score: 1650, tier: TierLevel.bronze),
  const LeaderboardEntry(rank: 10, displayName: 'Ochka_Dev', emoji: '💻', score: 1500, tier: TierLevel.bronze),
]);
