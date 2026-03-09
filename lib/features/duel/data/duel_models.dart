import '../../../mock/fake_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DuelResultResponse — GET /duel/result/:matchId хариу
//
// Сервер гурван төлвийн аль нэгийг буцаана:
//   waiting_submit   → хэрэглэгчийн submission ирэхгүй байна
//   waiting_opponent → хэрэглэгч илгээсэн, өрсөлдөгчийг хүлээж байна
//   done             → хоёул илгээсэн, оноо бодогдсон
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// TranscribeResult — POST /duel/transcribe хариу
// ─────────────────────────────────────────────────────────────────────────────

/// POST /duel/transcribe хариу — transcript + optional bot reply.
///
/// BOT match дугаарт [botReply] орно (GPT-4o-mini үүсгэсэн текст + үргэлжлэл).
/// Human vs human дугаарт [botReply] null байна.
class TranscribeResult {
  const TranscribeResult({
    required this.transcript,
    this.botReply,
  });

  final String transcript;

  /// BOT match-д орох GPT-4o-mini-ийн үүсгэсэн хариу.
  final BotReply? botReply;
}

/// Bot-ын GPT-4o-mini хариу — текст + тооцоолсон үргэлжлэл.
class BotReply {
  const BotReply({required this.text, required this.durationMs});

  final String text;

  /// Текстийн урт дээр суурилсан тооцоолсон ярих хугацаа (миллисекунд).
  final int durationMs;

  factory BotReply.fromJson(Map<String, dynamic> json) => BotReply(
        text: json['text'] as String,
        durationMs: (json['durationMs'] as num).toInt(),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
/// Серверийн GET /duel/result/:matchId хариуг төлөв бүрт задалсан sealed class.
sealed class DuelResultResponse {
  const DuelResultResponse();

  factory DuelResultResponse.fromJson(Map<String, dynamic> json) {
    return switch (json['status'] as String) {
      'waiting_submit' => const WaitingSubmitResult(),
      'waiting_opponent' => const WaitingOpponentResult(),
      'done' => DuelDoneResult.fromJson(json),
      final s => throw FormatException('Тодорхойгүй result төлөв: $s'),
    };
  }
}

/// Хэрэглэгчийн аудио submission ирээгүй байна — хүлээнэ.
class WaitingSubmitResult extends DuelResultResponse {
  const WaitingSubmitResult();
}

/// Хэрэглэгч илгээсэн, өрсөлдөгчийг хүлээж байна.
class WaitingOpponentResult extends DuelResultResponse {
  const WaitingOpponentResult();
}

/// Оноо бодогдсон — эцсийн үр дүн.
class DuelDoneResult extends DuelResultResponse {
  const DuelDoneResult({
    required this.matchId,
    required this.winnerUserId,
    required this.youUserId,
    required this.youScores,
    required this.opponentScores,
    required this.rankDelta,
  });

  final String matchId;
  final String? winnerUserId; // null → зургаан зурааны үед
  final String youUserId;
  final DuelScores youScores;
  final DuelScores opponentScores;
  final int rankDelta;

  factory DuelDoneResult.fromJson(Map<String, dynamic> json) {
    final you = json['you'] as Map<String, dynamic>;
    final opp = json['opponent'] as Map<String, dynamic>;
    return DuelDoneResult(
      matchId: json['matchId'] as String,
      winnerUserId: json['winnerUserId'] as String?,
      youUserId: you['userId'] as String,
      youScores: DuelScores.fromJson(you['scores'] as Map<String, dynamic>),
      opponentScores:
          DuelScores.fromJson(opp['scores'] as Map<String, dynamic>),
      rankDelta: (json['rankDelta'] as num).toInt(),
    );
  }

  /// UI-д хэрэглэх [DuelResult] болгон хөрвүүлнэ.
  DuelResult toDuelResult() => DuelResult(
        userScore: youScores.overall,
        opponentScore: opponentScores.overall,
        isWin: winnerUserId == youUserId,
        userBreakdown: youScores.toScoreBreakdown(),
        opponentBreakdown: opponentScores.toScoreBreakdown(),
      );
}

/// Серверийн scores объект (fluency, grammar, pronunciation, confidence, overall).
class DuelScores {
  const DuelScores({
    required this.fluency,
    required this.grammar,
    required this.pronunciation,
    required this.confidence,
    required this.overall,
  });

  final int fluency;
  final int grammar;
  final int pronunciation;
  final int confidence; // vocabulary слот болгон ашиглана
  final int overall;

  factory DuelScores.fromJson(Map<String, dynamic> json) => DuelScores(
        fluency: _toInt(json['fluency']),
        grammar: _toInt(json['grammar']),
        pronunciation: _toInt(json['pronunciation']),
        confidence: _toInt(json['confidence']),
        overall: _toInt(json['overall']),
      );

  /// [ScoreBreakdown] руу хөрвүүлнэ — confidence → vocabulary слот.
  ScoreBreakdown toScoreBreakdown() => ScoreBreakdown(
        pronunciation: pronunciation,
        grammar: grammar,
        fluency: fluency,
        vocabulary: confidence,
      );

  static int _toInt(dynamic v) => v == null ? 0 : (v as num).toInt();
}

// ─────────────────────────────────────────────────────────────────────────────
// ChatMessageResult — POST /duel/chat хариу
// ─────────────────────────────────────────────────────────────────────────────

/// POST /duel/chat хариу — transcript + seq + optional bot reply.
class ChatMessageResult {
  const ChatMessageResult({
    required this.transcript,
    required this.seq,
    required this.durationMs,
    this.botReply,
  });

  final String transcript;
  final int seq;
  final int durationMs;

  /// BOT match-д орох GPT-4o-mini-ийн хариу (text + seq + durationMs).
  final BotChatReply? botReply;
}

/// Bot-ын /duel/chat хариу — seq дагана (хэд хэдэн message-д тохируулах).
class BotChatReply {
  const BotChatReply({
    required this.text,
    required this.seq,
    required this.durationMs,
  });

  final String text;
  final int seq;
  final int durationMs;

  factory BotChatReply.fromJson(Map<String, dynamic> json) => BotChatReply(
        text: json['text'] as String,
        seq: (json['seq'] as num).toInt(),
        durationMs: (json['durationMs'] as num).toInt(),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// RemoteChatMessage — GET /duel/messages/:matchId хариуны нэг элемент
// ─────────────────────────────────────────────────────────────────────────────

/// Серверээс ирсэн нэг chat мессеж — polling-д ашиглана.
class RemoteChatMessage {
  const RemoteChatMessage({
    required this.seq,
    required this.userId,
    required this.transcript,
  });

  final int seq;
  final String userId;
  final String transcript;

  factory RemoteChatMessage.fromJson(Map<String, dynamic> json) =>
      RemoteChatMessage(
        seq: (json['seq'] as num).toInt(),
        userId: json['userId'] as String,
        transcript: json['transcript'] as String,
      );
}

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
          etaSec: (json['etaSec'] as num?)?.toInt() ?? 10,
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
