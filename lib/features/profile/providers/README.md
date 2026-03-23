# profile/providers — Профайлын Riverpod state management

---

## profile_providers.dart
**Үүрэг:** Profile болон achievement state удирдах provider-ууд

### profileRepositoryProvider — Provider<ProfileRepository>
- `ProfileRepositoryImpl` instance буцаана

### userProfileProvider — AsyncNotifierProvider<UserProfileNotifier, UserProfile?>
- Profile, achievement, stats нэгтгэсэн мэдээлэл ачаална
- `refresh()` action: pull-to-refresh дэмжинэ
- Loading: skeleton placeholder
- Error: retry button

### updateProfileProvider — AsyncNotifierProvider<UpdateProfileNotifier, void>
- `update(displayName, avatarEmoji)` action
- Амжилттай бол `userProfileProvider` болон `currentUserProvider` refresh хийнэ
- Loading үед save button disabled болно

### achievementsProvider — FutureProvider<List<Achievement>>
- Achievement жагсаалт тусдаа provider-т байвал дараа нь badge notification нэмэхэд хялбар болно
