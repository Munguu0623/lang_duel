# duel/providers — Дайралтын Riverpod state management

Одоогийн `app_providers.dart` дахь duel-тай холбоотой бүх provider-г энд шилжүүлнэ.

---

## duel_providers.dart
**Үүрэг:** Дайралтын state удирдах provider-ууд

### duelRepositoryProvider — Provider<DuelRepository>
- `DuelRepositoryImpl` instance буцаана
- `apiClientProvider` inject хийнэ

### matchmakingProvider — AsyncNotifierProvider<MatchmakingNotifier, DuelSession?>
- `startMatch()` дуудаж matchmaking эхлүүлнэ
- Loading state: "Өрсөлдөгч хайж байна..."
- Амжилттай бол duel session state-г тохируулна
- Timeout (20 сек): backend өөрөө bot оноодог, апп хүлээнэ

### duelSessionProvider — StateNotifierProvider<DuelSessionNotifier, DuelSessionState>
`DuelSessionState` агуулах зүйл:
- `sessionId: String?`
- `currentRound: int`
- `phase: DuelPhase` (waiting | recording | processing | botTurn | finished)
- `userTurns: List<TurnResult>`
- `botTurns: List<TurnResult>`
- `userTotalScore: int`
- `botTotalScore: int`

Action method-ууд:
- `submitTurn(File audioFile)` — recording дуусаад дуудна
- `nextRound()` — дараагийн ээлжид шилжинэ
- `endDuel()` — бүх ээлж дуусаад дуудна

### duelResultProvider — FutureProvider.family<DuelResult, String>
- sessionId параметраар `getDuelResult(sessionId)` дуудна
- `result_screen.dart`-д ашиглана

### Хуучин app_providers.dart-аас шилжүүлэх зүйл:
- `duelPhaseProvider` → duelSessionProvider-т нэгтгэнэ
- `duelRoundProvider` → duelSessionProvider-т нэгтгэнэ
- `dailyDuelCountProvider` → энд үлдэнэ эсвэл profile_providers-т шилжинэ
