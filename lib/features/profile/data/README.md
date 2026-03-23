# profile/data — Хэрэглэгчийн профайлын өгөгдлийн давхарга

Одоогийн `profile_screen.dart` дахь hardcoded achievement жагсаалт, статистикийг
backend-аас авахад шилжинэ.

---

## datasources/

### profile_remote_datasource.dart
**Үүрэг:** Profile болон achievement endpoint-уудтай харилцана

Хийх зүйл:
- `getProfile()` → `GET /users/me`
  - Нэвтэрсэн хэрэглэгчийн бүрэн мэдээлэл
- `updateProfile(UpdateProfileDto body)` → `PATCH /users/me`
  - Нэр, emoji шинэчлэх
  - body: `{ displayName: String?, avatarEmoji: String? }`
- `getAchievements()` → `GET /users/me/achievements`
  - Амжилтуудын жагсаалт
- `getStats()` → `GET /users/me/stats`
  - Нийт дайралт, ялалт, streak, avg score гэх мэт

---

## models/

### achievement_dto.dart
`GET /users/me/achievements` хариуны shape:
- `id: String`
- `title: String`
- `titleMn: String`
- `description: String`
- `iconUrl: String?`
- `iconEmoji: String` (fallback)
- `earnedAt: DateTime?` (null = аваагүй байна)
- `isEarned: bool`

### user_stats_dto.dart
`GET /users/me/stats` хариуны shape:
- `totalDuels: int`
- `wins: int`
- `losses: int`
- `winRate: double`
- `currentStreak: int`
- `bestStreak: int`
- `averageScore: double`
- `totalXp: int`

---

## repositories/

### profile_repository_impl.dart
**Үүрэг:** Profile data flow удирдана

- `getProfile()` + `getAchievements()` + `getStats()`-г нэгтгэсэн `UserProfile` object буцаана
- Profile update хийсний дараа `currentUserProvider`-г refresh хийнэ
