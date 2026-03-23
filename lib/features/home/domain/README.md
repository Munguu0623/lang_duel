# home/domain — Нүүр хуудасны бизнес логикийн давхарга

---

## topics_repository.dart
**Үүрэг:** Topic-уудын abstract interface

Тодорхойлох method-ууд:
- `Future<List<DuelTopic>> getTopics({String? level})` — topic жагсаалт авна
- `Future<DuelTopic> getTopicById(String id)` — тухайн topic-ийн дэлгэрэнгүй
