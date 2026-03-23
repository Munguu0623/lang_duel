# duel/domain — Дайралтын бизнес логикийн давхарга

---

## duel_repository.dart
**Үүрэг:** Duel feature-ийн бүх үйлдлийн abstract interface

Тодорхойлох method-ууд:
- `Future<DuelSession> startMatch(String cefrLevel, String topicId)` — matchmaking
- `Future<TurnResult> submitVoiceTurn(String sessionId, File audioFile)` — ээлж илгээх
  - Дотроо transcribe → score → submit дарааллыг агуулна
- `Future<DuelResult> getDuelResult(String sessionId)` — эцсийн дүн
- `Future<DuelSession> getCurrentSession(String sessionId)` — session байдал

Domain entity-уудыг ашиглана (DTO биш):
- `DuelSession` — sessionId, opponent, topic, status
- `TurnResult` — userScore, botTranscript, botScore, roundWinner
- `DuelResult` — `core/models/models.dart` дахь `DuelResult` class-г ашиглах
