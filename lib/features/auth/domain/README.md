# auth/domain — Нэвтрэлтийн бизнес логикийн давхарга

Энэ folder нь implementation-аас хамааралгүй abstract interface-г тодорхойлно.
Providers болон UI нь энэ interface-г ашиглана — impl биш.

---

## auth_repository.dart
**Үүрэг:** Auth feature-ийн бүх үйлдлийн гэрээ (abstract interface)

Тодорхойлох method-ууд:
- `Future<AppUser> loginWithGoogle()` — нэвтрэх
- `Future<void> logout()` — гарах
- `Future<AppUser?> getCurrentUser()` — одоогийн хэрэглэгч (null = нэвтрээгүй)
- `Future<bool> hasValidSession()` — splash screen-д хурдан шалгах

Яагаад interface хэрэгтэй вэ?
- Тест бичихдээ mock implementation ашиглах боломжтой болно
- Implementation-г өөрчлөхөд (жишх: Firebase-г солих) UI код өөрчлөгдөхгүй
