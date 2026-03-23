# leaderboard/data — Өрсөлдөөний жагсаалтын өгөгдлийн давхарга

Одоогийн `leaderboard_screen.dart` дахь hardcoded 10 оролцогчийг backend-аас авахад шилжинэ.

---

## datasources/

### leaderboard_remote_datasource.dart
**Үүрэг:** Leaderboard API дуудлага

Хийх зүйл:
- `getLeaderboard(String period)` → `GET /leaderboard?period=weekly`
  - period утгууд: 'weekly' | 'alltime'
  - Response: `List<LeaderboardEntryDto>`
- `getMyRank(String period)` → `GET /leaderboard/me?period=weekly`
  - Нэвтэрсэн хэрэглэгчийн байр эзлэлт (top 100-д байхгүй бол тусад нь авна)

---

## models/

### leaderboard_entry_dto.dart
`GET /leaderboard` хариуны shape:
- `rank: int`
- `userId: String`
- `displayName: String`
- `avatarUrl: String?`
- `totalScore: int`
- `winRate: double` (0.0–1.0)
- `cefrLevel: String`
- `isCurrentUser: bool` (backend энэ талбарыг оруулж өгнө)

`LeaderboardEntry` domain model рүү хөрвүүлэх `toEntity()` method нэмнэ.

---

## repositories/

### leaderboard_repository_impl.dart
**Үүрэг:** Leaderboard data flow удирдана

- `getLeaderboard()` болон `getMyRank()` нэгтгэнэ
- Period (weekly/alltime) солигдоход дахин fetch хийнэ
- 5 минут cache хийж болно (leaderboard байнга өөрчлөгддөг тул богино хугацаа)
