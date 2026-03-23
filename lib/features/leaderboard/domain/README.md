# leaderboard/domain — Өрсөлдөөний жагсаалтын бизнес логик

---

## leaderboard_repository.dart
**Үүрэг:** Leaderboard-ийн abstract interface

Тодорхойлох method-ууд:
- `Future<List<LeaderboardEntry>> getLeaderboard(String period)` — жагсаалт авна
- `Future<int> getMyRank(String period)` — өөрийн байр эзлэлт
