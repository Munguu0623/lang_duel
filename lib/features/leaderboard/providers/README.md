# leaderboard/providers — Өрсөлдөөний жагсаалтын Riverpod state management

---

## leaderboard_providers.dart
**Үүрэг:** Leaderboard state provider-ууд

### leaderboardRepositoryProvider — Provider<LeaderboardRepository>
- `LeaderboardRepositoryImpl` instance буцаана

### selectedPeriodProvider — StateProvider<String>
- 'weekly' | 'alltime' сонголтыг хадгална
- Анхны утга: 'weekly'
- Tab солигдоход энэ provider шинэчлэгдэнэ

### leaderboardProvider — AsyncNotifierProvider.family<LeaderboardNotifier, List<LeaderboardEntry>, String>
- `period` параметрээр дуудна: `ref.watch(leaderboardProvider('weekly'))`
- Loading: shimmer skeleton харуулна (shimmer package аль хэдийн суулгасан)
- Error: retry button харуулна
- `refresh()` action нэмнэ

### myRankProvider — FutureProvider.family<int, String>
- Нэвтэрсэн хэрэглэгчийн байр эзлэлтийг leaderboard-ийн доод хэсэгт харуулна

### Хуучин app_providers.dart-аас шилжүүлэх зүйл:
- `leaderboardProvider` → энд (hardcoded list-г AsyncNotifierProvider болгон шинэчилнэ)
