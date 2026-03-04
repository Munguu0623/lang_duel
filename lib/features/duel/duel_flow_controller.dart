import 'package:flutter/foundation.dart';

import '../../mock/fake_models.dart';
import 'duel_state.dart';

/// ValueNotifier ашиглан дуэлийн урсгалын шилжилтийг удирдана.
/// UI-ын төлвийн машин — реал API өгөгдөл болон цагийн хэрэгслийн дагуу ажиллана.
class DuelController extends ValueNotifier<DuelState> {
  DuelController() : super(DuelState());

  void startSearching(int duration) {
    value = DuelState(
      status: DuelStatus.searching,
      durationSeconds: duration,
      remainingSeconds: duration,
    );
  }

  /// Серверийн жинхэнэ [prompt]-тай [DuelStatus.found] руу шилжинэ.
  ///
  /// [opponent] — дуудагч тал [DuelOpponent.toDuelUser()]-ээр хөрвүүлсэн байна.
  /// [prompt]   — [MatchedTicket.prompt]-аас шууд ирнэ; хуурамч өгөгдөл байхгүй.
  void opponentFound(DuelUser opponent, {required String prompt}) {
    value = value.copyWith(
      status: DuelStatus.found,
      opponent: opponent,
      prompt: prompt,
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

