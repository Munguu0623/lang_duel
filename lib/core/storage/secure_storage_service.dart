// =============================================================================
// secure_storage_service.dart — flutter_secure_storage wrapper
// =============================================================================
//
// Access token, refresh token болон бусад нууц мэдээллийг
// төхөөрөмжийн аюулгүй хадгалалтад (Keychain/Keystore) хадгалах, унших үүрэгтэй.
// StorageKeys constant-ууд `core/constants/app_constants.dart`-д аль хэдийн
// тодорхойлогдсон — тэнд байгааг ашиглана, давтаж тодорхойлохгүй.
//
// ШААРДЛАГАТАЙ IMPORT-УУД:
//   - package:flutter_secure_storage/flutter_secure_storage.dart
//   - core/constants/app_constants.dart (StorageKeys-ийн тулд)
//
// CLASS БҮТЭЦ: class SecureStorageService
//
// CONSTRUCTOR:
//   SecureStorageService({FlutterSecureStorage? storage})
//   → Dependency injection-д зориулан storage параметрийг nullable болгоно.
//     Null бол const FlutterSecureStorage() ашиглана.
//     Тест дээр mock instance дамжуулах боломжтой болно.
//
// METHOD-УУД:
//
//   Future<void> saveTokens({
//     required String accessToken,
//     required String refreshToken,
//   })
//   → StorageKeys.accessToken болон StorageKeys.refreshToken key-р хадгална
//   → Хоёуланг нь нэг дор хадгалах ёстой (хагас хадгалагдах эрсдэлгүй байхын тулд)
//
//   Future<String?> getAccessToken()
//   → StorageKeys.accessToken key-р унших. Байхгүй бол null буцаана.
//
//   Future<String?> getRefreshToken()
//   → StorageKeys.refreshToken key-р унших. Байхгүй бол null буцаана.
//
//   Future<void> saveUserId(String userId)
//   → StorageKeys.userId key-р хадгална (splash screen auth check-д ашиглана)
//
//   Future<String?> getUserId()
//   → StorageKeys.userId key-р унших
//
//   Future<void> clearAll()
//   → Бүх хадгалсан утгуудыг устгана (logout үед дуудна)
//   → storage.deleteAll() ашиглана
//
//   Future<bool> hasValidSession()
//   → getAccessToken() != null эсэхийг шалгана
//   → Splash screen дээр нэвтэрсэн эсэхийг хурдан шалгахад ашиглана
//
// RIVERPOD PROVIDER:
//   Энэ class-г `dio_provider.dart` болон `auth_providers.dart`-д ашиглахын тулд
//   `secureStorageServiceProvider` нэртэй Provider<SecureStorageService> үүсгэнэ.
//   final secureStorageServiceProvider = Provider((ref) => SecureStorageService())
//
// АНХААРУУЛГА:
//   - iOS-д Keychain, Android-д EncryptedSharedPreferences ашиглана.
//   - Android дээр `android:allowBackup="false"` тохируулаагүй бол
//     backup-д token орж болзошгүй — AndroidManifest.xml шалгана уу.
// =============================================================================
