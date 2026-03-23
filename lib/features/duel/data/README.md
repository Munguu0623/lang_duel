# duel/data — Дайралтын өгөгдлийн давхарга

Энэ folder нь matchmaking, дайралтын ээлж илгээх, AI дуудлага, дүн авах зэрэг
бүх backend/AI харилцааг агуулна.

---

## datasources/

### duel_remote_datasource.dart
**Үүрэг:** Backend-ийн duel endpoint-уудтай харилцана

Хийх зүйл:
- `findMatch(String cefrLevel, String topicId)` → `POST /duels/match`
  - Response: `DuelSessionDto` (sessionId, opponentType: bot|human, opponent info)
- `getDuelSession(String sessionId)` → `GET /duels/{id}`
  - Одоогийн session байдал авна
- `submitTurn(String sessionId, TurnSubmitRequestDto body)` → `POST /duels/{id}/turns`
  - Transcript + score илгээж, bot хариулт + bot score авна
- `getDuelResult(String sessionId)` → `GET /duels/{id}/result`
  - Бүх ээлж дууссаны дараа дуудна

---

### ai_datasource.dart
**Үүрэг:** AI endpoint-уудтай харилцана (backend proxy-р дамжуулна)

Хийх зүйл:
- `transcribeAudio(File audioFile)` → `POST /ai/transcribe`
  - FormData-р audio file илгээж, Whisper STT-р текст авна
  - Response: `{ transcript: String, confidence: double }`
- `scoreResponse(String transcript, String topic, String level)` → `POST /ai/score`
  - DeepSeek-р хэрэглэгчийн хариулт үнэлнэ
  - Response: `ScoreResponseDto` (pronunciation, grammar, vocabulary, fluency, total)
- `getBotReply(String topic, List<String> history)` → `POST /ai/bot-reply`
  - Bot-ийн дараагийн хариулт үүсгэнэ

**ЧУХАЛ:** Эдгээр дуудлага нь Flutter-аас шууд OpenAI/DeepSeek руу очихгүй.
Backend proxy ашигладаг учраас API key клиент кодод байхгүй.

---

## models/

### duel_session_dto.dart
`POST /duels/match` болон `GET /duels/{id}` хариуны shape:
- `sessionId: String`
- `opponentType: String` ('bot' | 'human')
- `opponent: OpponentDto` (id, displayName, cefrLevel, avatarUrl)
- `topic: TopicDto`
- `totalRounds: int`
- `status: String` ('waiting' | 'active' | 'finished')

### turn_result_dto.dart
`POST /duels/{id}/turns` хариуны shape:
- `roundNumber: int`
- `userScore: ScoreBreakdownDto`
- `botTranscript: String`
- `botScore: ScoreBreakdownDto`
- `roundWinner: String` ('user' | 'bot' | 'tie')

### stt_response_dto.dart
`POST /ai/transcribe` хариуны shape:
- `transcript: String`
- `confidence: double` (0.0–1.0)
- `language: String`

### score_response_dto.dart
`POST /ai/score` хариуны shape:
- `pronunciation: int`
- `grammar: int`
- `vocabulary: int`
- `fluency: int`
- `total: int`
- `feedback: String` (монгол хэл дэх тайлбар)

---

## repositories/

### duel_repository_impl.dart
**Үүрэг:** `domain/duel_repository.dart` interface-г хэрэгжүүлнэ

- `duel_remote_datasource` болон `ai_datasource`-г нэгтгэнэ
- Дайралтын ээлжийн бүрэн урсгалыг удирдана:
  1. Audio file авна
  2. ai_datasource-р transcribe хийнэ
  3. ai_datasource-р score хийнэ
  4. duel_remote_datasource-р turn submit хийнэ
  5. Нэгдсэн `TurnResult` domain object буцаана
