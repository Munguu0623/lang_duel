import 'package:flutter/foundation.dart';

import '../../mock/fake_data.dart';
import '../../mock/fake_models.dart';
import 'duel_state.dart';

/// Controls duel flow transitions via ValueNotifier.
/// UI-only state machine for the prototype — runs on mock data + timers.
class DuelController extends ValueNotifier<DuelState> {
  DuelController() : super(DuelState());

  void startSearching(int duration) {
    value = DuelState(
      status: DuelStatus.searching,
      durationSeconds: duration,
      remainingSeconds: duration,
    );
  }

  void opponentFound(DuelUser opponent) {
    value = value.copyWith(
      status: DuelStatus.found,
      opponent: opponent,
      prompt: FakeData.getRandomPrompt(),
    );
  }

  void startCountdown() {
    value = value.copyWith(status: DuelStatus.countdown);
  }

  void startDuel() {
    value = value.copyWith(status: DuelStatus.live);
  }

  void startScoring() {
    value = value.copyWith(status: DuelStatus.scoring);
  }

  void showResult(DuelResult result) {
    value = value.copyWith(status: DuelStatus.result, result: result);
  }

  void reset() {
    value = DuelState();
  }
}

