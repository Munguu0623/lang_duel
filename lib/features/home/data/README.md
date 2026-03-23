# home/data — Нүүр хуудасны өгөгдлийн давхарга

Одоогийн `home_screen.dart` дахь hardcoded topic жагсаалтыг backend-аас авахад шилжинэ.

---

## datasources/

### topics_remote_datasource.dart
**Үүрэг:** Topic жагсаалтыг backend-аас авна

Хийх зүйл:
- `getTopics({String? level})` → `GET /topics?level=B1`
  - level параметр заавал биш (null бол бүх level-ийн topic ирнэ)
  - Response: `List<TopicDto>`

Caching стратеги:
- Topic-ууд байнга өөрчлөгддөггүй тул `shared_preferences`-д cache хийж болно
- Cache хугацаа: 1 цаг (app_constants.dart-д тогтооно)
- Cache байвал network дуудахгүй, байхгүй бол network-с авч cache-д хийнэ

---

## models/

### topic_dto.dart
`GET /topics` хариуны shape:
- `id: String`
- `title: String`
- `titleMn: String` (монгол орчуулга)
- `description: String`
- `level: String` (A1–C1)
- `imageUrl: String?`
- `isActive: bool`

`DuelTopic` domain model рүү хөрвүүлэх `toEntity()` method нэмнэ.
`core/models/models.dart` дахь `DuelTopic` class-г шинэчилж `imageUrl` нэмэх шаардлагатай.

---

## repositories/

### topics_repository_impl.dart
**Үүрэг:** Cache логик + remote datasource нэгтгэнэ

- Cache шалгана → байвал cached data буцаана
- Cache байхгүй / хуучирсан бол remote-с авч cache-д хийнэ
- Error үед cache байвал stale cache буцаана (offline тохиолдол)
