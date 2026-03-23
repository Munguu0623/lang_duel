# profile/domain — Профайлын бизнес логик

---

## profile_repository.dart
**Үүрэг:** Profile feature-ийн abstract interface

Тодорхойлох method-ууд:
- `Future<UserProfile> getFullProfile()` — профайл + achievement + статистик нэгтгэсэн
- `Future<AppUser> updateProfile(String? displayName, String? avatarEmoji)` — шинэчлэнэ
- `Future<List<Achievement>> getAchievements()` — амжилтуудын жагсаалт

`Achievement` entity (domain model):
- `id: String`
- `title: String`
- `titleMn: String`
- `iconEmoji: String`
- `isEarned: bool`
- `earnedAt: DateTime?`
