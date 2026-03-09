import '../../mock/fake_models.dart';

/// Duel lifecycle states — linear progression.
enum DuelStatus {
  idle,
  searching,
  found,
  countdown,
  live,
  scoring,
  result,
}

/// Immutable snapshot of a single duel session.
/// Using copyWith ensures state transitions are predictable and
/// ValueNotifier correctly detects changes (new object reference).
class DuelState {
  DuelState({
    this.status = DuelStatus.idle,
    this.opponent,
    this.prompt,
    this.matchId,
    this.durationSeconds = 60,
    this.remainingSeconds = 60,
    this.transcript = const [],
    this.result,
  });

  final DuelStatus status;
  final DuelUser? opponent;
  final String? prompt;

  /// [MatchedTicket.matchId] — transcribe болон result polling-д ашиглана.
  final String? matchId;

  final int durationSeconds;
  final int remainingSeconds;
  final List<String> transcript;
  final DuelResult? result;

  DuelState copyWith({
    DuelStatus? status,
    DuelUser? opponent,
    String? prompt,
    String? matchId,
    int? durationSeconds,
    int? remainingSeconds,
    List<String>? transcript,
    DuelResult? result,
  }) {
    return DuelState(
      status: status ?? this.status,
      opponent: opponent ?? this.opponent,
      prompt: prompt ?? this.prompt,
      matchId: matchId ?? this.matchId,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      transcript: transcript ?? this.transcript,
      result: result ?? this.result,
    );
  }
}

/// Duel controller is defined in `duel_controller.dart` to keep state model
/// and control logic separated.
