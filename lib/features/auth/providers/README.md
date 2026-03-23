# auth/providers — Нэвтрэлтийн Riverpod state management

Энэ folder нь auth feature-ийн бүх Riverpod provider-уудыг агуулна.
Одоогийн `app_providers.dart` дахь `currentUserProvider`, `UserNotifier`-г энд шилжүүлнэ.

---

## auth_providers.dart
**Үүрэг:** Auth state-г удирдах provider-ууд

### authRepositoryProvider — Provider<AuthRepository>
- `AuthRepositoryImpl` instance үүсгэж буцаана
- `secureStorageServiceProvider`, `apiClientProvider`-г inject хийнэ

### authStateProvider — StreamProvider<User?>
- `FirebaseAuth.instance.authStateChanges()` stream-г сонсоно
- Firebase User null = нэвтрээгүй, not null = нэвтэрсэн
- `GoRouter.redirect` энэ provider-г ашиглан хандалт хянана

### currentUserProvider — AsyncNotifierProvider<UserNotifier, AppUser?>
- Backend-с хэрэглэгчийн бүрэн мэдээлэл авч хадгална
- `login()`, `logout()`, `updateProfile()` action-уудтай
- logout үед: Firebase signOut + SecureStorage.clearAll() + state null болгоно

### Хуучин app_providers.dart-аас шилжүүлэх зүйл:
- `currentUserProvider` → энд
- `UserNotifier` → энд (AsyncNotifierProvider болгон шинэчилнэ)
- Бусад provider-ууд өөрсдийн feature folder-т шилжинэ
