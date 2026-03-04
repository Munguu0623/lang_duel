import '../../../mock/fake_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Sealed TicketResult
//
// matchmaking.ts дахь серверийн TicketState union-тай тохирно:
//   waiting  → { status, ticketId, etaSec }
//   matched  → { status, ticketId, matchId, prompt, opponent }
//
// Хэрэглэх жишээ:
//   final result = await duelRepo.join(cefrLevel: 'B1');
//   switch (result) {
//     case WaitingTicket()  => polling эхлүүлнэ;
//     case MatchedTicket()  => өрсөлдөгч олдсон дэлгэц рүү явна;
//   }
// ─────────────────────────────────────────────────────────────────────────────

sealed class TicketResult {
  const TicketResult({required this.ticketId});

  final String ticketId;

  factory TicketResult.fromJson(Map<String, dynamic> json) {
    return switch (json['status'] as String) {
      'waiting' => WaitingTicket(
          ticketId: json['ticketId'] as String,
          etaSec: (json['etaSec'] as num).toInt(),
        ),
      'matched' => MatchedTicket(
          ticketId: json['ticketId'] as String,
          matchId: json['matchId'] as String,
          prompt: json['prompt'] as String,
          opponent: DuelOpponent.fromJson(
            json['opponent'] as Map<String, dynamic>,
          ),
        ),
      final unknown =>
        throw FormatException('Тодорхойгүй ticket төлөв: $unknown'),
    };
  }
}

/// Дараалалд орсон боловч өрсөлдөгч олдоогүй байна.
/// [WaitingTicket] авсны дараа [GET /duel/ticket/:ticketId]-г 2 секунд тутамд poll хийнэ.
/// 10 секундийн дараа сервер автоматаар bot тогтооно.
class WaitingTicket extends TicketResult {
  const WaitingTicket({required super.ticketId, required this.etaSec});

  /// Сервер bot тогтоох хүртэл үлдсэн тооцоолсон секунд.
  final int etaSec;
}

/// Өрсөлдөгч (хүн эсвэл bot) олдсон.  Дуэль эхлэхэд бэлэн.
class MatchedTicket extends TicketResult {
  const MatchedTicket({
    required super.ticketId,
    required this.matchId,
    required this.prompt,
    required this.opponent,
  });

  /// [POST /duel/submit] болон үр дүн харахад ашиглах тогтвортой match ID.
  final String matchId;

  /// Энэ дуэлийн AI-ын сонгосон ярих даалгавар.
  final String prompt;

  final DuelOpponent opponent;
}

// ─────────────────────────────────────────────────────────────────────────────
// DuelOpponent — серверийн OpponentInfo хэлбэртэй тохирно
// ─────────────────────────────────────────────────────────────────────────────

/// [MatchedTicket] дотор сервераас ирдэг өрсөлдөгчийн мэдээлэл.
class DuelOpponent {
  const DuelOpponent({
    required this.id,
    required this.name,
    required this.type,
    this.avatar,
  });

  final String id;
  final String name;

  /// `"HUMAN"` эсвэл `"BOT"`.
  final String type;

  /// Аватарын түлхүүр — MVP-д сервер `null` илгээнэ.
  final String? avatar;

  bool get isBot => type == 'BOT';

  factory DuelOpponent.fromJson(Map<String, dynamic> json) => DuelOpponent(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        avatar: json['avatar'] as String?,
      );

  /// [DuelController] болон бүх дуэль дэлгэцэд хэрэглэгдэх UI моделд хөрвүүлнэ.
  /// Апп-ын бусад хэсэг API давхаргыг мэдэхгүйгээр ажиллана.
  DuelUser toDuelUser() => DuelUser(
        id: id,
        name: name,
        avatarUrl: avatar ?? '',
        rating: 0, // join хариунд рейтинг ирдэггүй
        rank: type == 'BOT' ? 'BOT' : '—',
        level: 'B1',
      );
}
