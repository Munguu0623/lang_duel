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
}
