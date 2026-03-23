# home/providers — Нүүр хуудасны Riverpod state management

---

## home_providers.dart
**Үүрэг:** Topic жагсаалтын state provider-ууд

### topicsRepositoryProvider — Provider<TopicsRepository>
- `TopicsRepositoryImpl` instance буцаана

### topicsProvider — AsyncNotifierProvider<TopicsNotifier, List<DuelTopic>>
- App нээгдэхэд автоматаар topic жагсаалт ачаална
- loading / error / data гурван төлөв удирдана
- `refresh()` action: pull-to-refresh хийхэд дуудна

### filteredTopicsProvider — Provider.family<List<DuelTopic>, String?>
- `topicsProvider`-с авч level-ээр шүүнэ
- `home_screen.dart` дахь CEFR level tab-уудад зориулна

### selectedTopicProvider — StateProvider<DuelTopic?>
- Хэрэглэгч сонгосон topic-г хадгална
- Matchmaking эхлэхэд энэ provider-с topic id авна

### Хуучин app_providers.dart-аас шилжүүлэх зүйл:
- `topicsProvider` → энд (hardcode-г API call болгон шинэчилнэ)
- `selectedTopicProvider` → энд
