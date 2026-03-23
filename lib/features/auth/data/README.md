# auth/data — Нэвтрэлтийн өгөгдлийн давхарга

Энэ folder нь auth feature-ийн бүх API дуудлага, token хадгалалт, DTO-уудыг агуулна.
UI болон state management нь энэ folder-г шууд биш, domain/ дахь repository interface-аар дамжуулан ашиглана.

---

## datasources/

### auth_remote_datasource.dart
**Үүрэг:** Firebase + backend-тай харилцах

Хийх зүйл:
- `loginWithGoogle(String firebaseIdToken)` → `POST /auth/google` дуудна
  - Google Sign-In SDK-аас Firebase idToken авна
  - Backend-д илгээж `AuthResponseDto` (accessToken + refreshToken + user) авна
- `refreshToken(String refreshToken)` → `POST /auth/refresh` дуудна
- `logout()` → `DELETE /auth/logout` дуудна (backend дээр refresh token устгана)

Бүх try-catch блок нь `ErrorHandler.handle(e, st)` ашиглана.

---

### auth_local_datasource.dart
**Үүрэг:** Token-уудыг аюулгүй хадгалах, унших

Хийх зүйл:
- `saveTokens(accessToken, refreshToken)` → SecureStorageService-д хадгална
- `getAccessToken()` → унших
- `getRefreshToken()` → унших
- `clearTokens()` → logout үед устгана
- `hasStoredSession()` → splash screen-д нэвтэрсэн эсэх шалгана

---

## models/

### auth_response_dto.dart
**Үүрэг:** `POST /auth/google` болон `POST /auth/refresh`-ийн JSON хариуг map хийнэ

Талбарууд:
- `accessToken: String`
- `refreshToken: String`
- `expiresIn: int` (секундээр)
- `user: UserDto`

`@JsonSerializable()` annotation заавал хэрэгтэй.
`dart run build_runner build` ажиллуулсны дараа `.g.dart` файл үүснэ.

---

### user_dto.dart
**Үүрэг:** Backend-с ирэх хэрэглэгчийн мэдээллийн JSON shape

Талбарууд:
- `id: String`
- `displayName: String`
- `email: String?`
- `avatarUrl: String?`
- `cefrLevel: String` (A1–C1)
- `isPremium: bool`
- `totalScore: int`

`AppUser` domain model рүү хөрвүүлэх `toEntity()` method нэмнэ.

---

## repositories/

### auth_repository_impl.dart
**Үүрэг:** `domain/auth_repository.dart` interface-г хэрэгжүүлнэ

- Remote болон local datasource-уудыг нэгтгэнэ
- `loginWithGoogle()`: remote дуудаж token авч, local-д хадгална, AppUser буцаана
- `logout()`: remote дуудаж, local token цэвэрлэнэ
- `getCurrentUser()`: local-с token шалгаж, remote-с user мэдээлэл авна
