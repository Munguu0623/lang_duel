import 'dart:developer' as dev;
import 'dart:math';
import 'dart:typed_data';

import '../../../core/network/api_exception.dart';
import '../data/duel_models.dart';
import '../data/duel_repository.dart';

/// Аудио байтыг POST /duel/chat-аар илгээж transcript авна.
///
/// Сервер хүрэхгүй эсвэл алдаа гарвал mock текст буцааж дуэлийн
/// урсгал зогсохгүй байдлаар ажиллана.
class TranscriptionService {
  static final _random = Random();

  static const _mockLines = [
    'I think the most important aspect is communication.',
    'From my experience, this has been very challenging.',
    'Let me explain why I believe this is significant.',
    'I strongly feel that we need to consider multiple perspectives.',
    'This topic is fascinating because it affects everyone.',
    'In my opinion, the key factor here is consistency.',
    'I have personally seen the impact of this issue.',
    'To elaborate further, I would say it depends on context.',
  ];

  /// Аудио байтыг POST /duel/chat-аар илгээж [ChatMessageResult] авна.
  ///
  /// [audioBytes] — recorder-ийн буцаасан raw аудио байт.
  /// [mimeType]   — 'audio/m4a' (native) эсвэл 'audio/webm' (web).
  /// [matchId]    — одоогийн match ID.
  /// [durationMs] — бичлэгийн үргэлжлэл миллисекундээр.
  /// [repo]       — authenticated DuelRepository instance.
  ///
  /// Алдаанд mock transcript бүхий [ChatMessageResult] буцаана.
  Future<ChatMessageResult> sendMessage(
    Uint8List audioBytes, {
    required String mimeType,
    required String matchId,
    required int durationMs,
    required DuelRepository repo,
  }) async {
    try {
      return await repo.sendChatMessage(
        matchId: matchId,
        audioBytes: audioBytes,
        durationMs: durationMs,
        mimeType: mimeType,
      );
    } on ApiException catch (e) {
      dev.log('[TranscriptionService] API error ${e.statusCode} ${e.serverCode}: ${e.message}');
      return ChatMessageResult(transcript: _mockFallback(), seq: 0, durationMs: durationMs);
    } catch (e) {
      dev.log('[TranscriptionService] Unexpected error: $e');
      return ChatMessageResult(transcript: _mockFallback(), seq: 0, durationMs: durationMs);
    }
  }

  String _mockFallback() => _mockLines[_random.nextInt(_mockLines.length)];
}
