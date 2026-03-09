import 'dart:typed_data';

import '../../../core/network/api_client.dart';
import 'duel_models.dart';

/// Дуэльтэй холбоотой endpoint-уудын цэвэр өгөгдлийн давхарга.
///
/// Нэвтрэлт шаардсан [ApiClient]-тай үүсгэнэ — дуэлийн бүх endpoint
/// хүчинтэй JWT (`Authorization: Bearer <token>`) шаарддаг.
///
/// Сүлжээ эсвэл серверийн алдаанд [ApiException] шидэнэ;
/// яаж харуулахыг дуудагч тал шийдэнэ.
class DuelRepository {
  const DuelRepository(this._client);

  final ApiClient _client;

  // ── POST /duel/join ───────────────────────────────────────────────────────

  /// Matchmaking дараалалд орно.
  ///
  /// Нэн даруй буцаана:
  ///   • [WaitingTicket] — одоохондоо тохирол байхгүй; [pollTicket]-г ~2 секунд тутамд дуудна.
  ///   • [MatchedTicket] — шууд тохирол (ховор); дуэлийг шууд эхлүүлнэ.
  ///
  /// Хэрэглэгч аль хэдийн хүлээж байгаа бол (жишээ нь crash-ийн дараа)
  /// [serverCode] нь `"ALREADY_IN_QUEUE"` байх [ApiException] шидэнэ.
  Future<TicketResult> join({
    required String cefrLevel,
    int entryFee = 0,
  }) async {
    final data = await _client.post('/duel/join', {
      'cefrLevel': cefrLevel,
      'entryFee': entryFee,
    });
    return TicketResult.fromJson(data);
  }

  // ── GET /duel/ticket/:ticketId ────────────────────────────────────────────

  /// Одоо байгаа ticket-ийн төлвийг шалгана.
  ///
  /// [join]-аас [WaitingTicket] авсны дараа 2 секунд тутамд дуудна.
  /// Сервер дараах тохиолдолд [MatchedTicket] болгон шилжүүлнэ:
  ///   • Хүн өрсөлдөгч мөн дараалалд орох, эсвэл
  ///   • 10 секунд өнгөрч сервер автоматаар bot тогтоох.
  Future<TicketResult> pollTicket(String ticketId) async {
    final data = await _client.get('/duel/ticket/$ticketId');
    return TicketResult.fromJson(data);
  }

  // ── POST /duel/transcribe ─────────────────────────────────────────────────

  /// Аудио файлыг серверт илгээж, Whisper API-аар транскрипт хийлгэнэ.
  ///
  /// [matchId]   — одоогийн дуэлийн ID.
  /// [filePath]  — төхөөрөмж дэх аудио файлын замнал (.m4a).
  /// [durationMs] — бичлэгийн үргэлжлэл миллисекундээр.
  ///
  /// Хариу: [TranscribeResult] — transcript + BOT match дугаарт GPT reply.
  /// Алдаанд [ApiException] шидэнэ.
  Future<TranscribeResult> transcribe({
    required String matchId,
    required Uint8List audioBytes,
    required int durationMs,
    String mimeType = 'audio/m4a',
  }) async {
    final data = await _client.postMultipart(
      '/duel/transcribe',
      fields: {
        'matchId': matchId,
        'durationMs': durationMs.toString(),
      },
      fileField: 'audio',
      fileBytes: audioBytes,
      filename: mimeType.contains('webm') ? 'audio.webm' : 'audio.m4a',
      mimeType: mimeType,
    );
    final botReplyJson = data['botReply'] as Map<String, dynamic>?;
    return TranscribeResult(
      transcript: (data['transcript'] as String?) ?? '',
      botReply: botReplyJson != null ? BotReply.fromJson(botReplyJson) : null,
    );
  }

  // ── POST /duel/chat ───────────────────────────────────────────────────────

  /// Дуэлийн явцад нэг voice message илгээнэ.
  ///
  /// [matchId]   — одоогийн дуэлийн ID.
  /// [filePath]  — локал аудио файлын замнал (.m4a).
  /// [durationMs] — бичлэгийн үргэлжлэл миллисекундээр.
  ///
  /// Хариу: [ChatMessageResult] — transcript + seq + BOT match-д bot reply.
  /// Алдаанд [ApiException] шидэнэ.
  Future<ChatMessageResult> sendChatMessage({
    required String matchId,
    required Uint8List audioBytes,
    required int durationMs,
    String mimeType = 'audio/m4a',
  }) async {
    final data = await _client.postMultipart(
      '/duel/chat',
      fields: {
        'matchId': matchId,
        'durationMs': durationMs.toString(),
      },
      fileField: 'audio',
      fileBytes: audioBytes,
      filename: mimeType.contains('webm') ? 'audio.webm' : 'audio.m4a',
      mimeType: mimeType,
    );
    final botJson = data['botReply'] as Map<String, dynamic>?;
    return ChatMessageResult(
      transcript: (data['transcript'] as String?) ?? '',
      seq: (data['seq'] as num?)?.toInt() ?? 0,
      durationMs: (data['durationMs'] as num?)?.toInt() ?? 5000,
      botReply: botJson != null ? BotChatReply.fromJson(botJson) : null,
    );
  }

  // ── GET /duel/messages/:matchId ───────────────────────────────────────────

  /// [after] курсорын дараах шинэ мессежүүдийг татна.
  ///
  /// Human vs human дуэлд 2 секунд тутамд дуудаж өрсөлдөгчийн
  /// мессежийг шинэчилнэ.  Буцаасан жагсаалтаас хамгийн сүүлийн
  /// seq-г шинэ cursor болгон хадгална.
  Future<List<RemoteChatMessage>> pollMessages(
    String matchId, {
    int after = 0,
  }) async {
    final data = await _client.get('/duel/messages/$matchId?after=$after');
    final list = data['messages'] as List<dynamic>? ?? [];
    return list
        .map((e) => RemoteChatMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── GET /duel/result/:matchId ─────────────────────────────────────────────

  /// Match-ийн одоогийн үр дүнг шалгана.
  ///
  /// Буцаах утгууд:
  ///   • [WaitingSubmitResult]   — submission ирэхгүй байна
  ///   • [WaitingOpponentResult] — өрсөлдөгчийг хүлээж байна
  ///   • [DuelDoneResult]        — оноо бодогдсон, харуулахад бэлэн
  Future<DuelResultResponse> pollResult(String matchId) async {
    final data = await _client.get('/duel/result/$matchId');
    return DuelResultResponse.fromJson(data);
  }
}
