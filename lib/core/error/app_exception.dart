// =============================================================================
// app_exception.dart — Апп дахь бүх алдааны төрлийг sealed class-аар тодорхойлно
// =============================================================================
//
// Sealed class ашиглаж бүх боломжит алдааны нөхцлийг нэг дор тодорхойлно.
// UI layer нь `switch` ашиглан бүх тохиолдлыг заавал боловсруулна.
//
// ШААРДЛАГАТАЙ IMPORT-УУД:
//   - package:equatable/equatable.dart (шаардлагатай бол)
//
// SEALED CLASS БҮТЭЦ:
//
//   sealed class AppException implements Exception {
//     final String userMessage;  ← Монгол хэл дэх хэрэглэгчид харуулах мессеж
//     final String? debugMessage; ← Developer-т зориулсан дэлгэрэнгүй (nullable)
//   }
//
// ДЭД КЛАССУУД:
//
//   class NetworkException extends AppException
//     → Интернэт холболт байхгүй үед
//     userMessage: 'Интернэт холболт шалгана уу'
//
//   class UnauthorizedException extends AppException
//     → 401 статус: token дууссан эсвэл буруу
//     userMessage: 'Дахин нэвтэрнэ үү'
//     → Энэ алдаа ирвэл login хуудас руу redirect хийнэ
//
//   class ForbiddenException extends AppException
//     → 403 статус: Premium эрх шаардлагатай эсвэл хандах эрхгүй
//     userMessage: 'Энэ функц Premium хэрэглэгчдэд зориулагдсан'
//
//   class NotFoundException extends AppException
//     → 404 статус: хайсан мэдээлэл олдсонгүй
//     userMessage: 'Мэдээлэл олдсонгүй'
//
//   class ServerException extends AppException
//     → 5xx статус: backend алдаатай байна
//     userMessage: 'Серверт алдаа гарлаа. Түр хүлээгээд дахин оролдоно уу'
//
//   class TimeoutException extends AppException
//     → Холболт эсвэл хариу хүлээх хугацаа дууссан
//     userMessage: 'Холболт удаан байна. Дахин оролдоно уу'
//
//   class ValidationException extends AppException
//     → 422 статус: request body буруу (field validation алдаа)
//     final Map<String, List<String>> errors; ← field-ийн алдааны жагсаалт
//     userMessage: 'Оруулсан мэдээлэл буруу байна'
//
//   class UnknownException extends AppException
//     → Дээрхид хамрагдаагүй бусад бүх алдаа
//     userMessage: 'Тодорхойгүй алдаа гарлаа. Дахин оролдоно уу'
//
// SWITCH PATTERN ХЭРЭГЛЭЭ (UI-д):
//   switch (exception) {
//     case NetworkException()     => 'Интернэт холболт шалгана уу',
//     case UnauthorizedException() => router.go('/login'),
//     case ForbiddenException()   => router.go('/payment'),
//     case ServerException()      => showRetryButton(),
//     ...
//   }
// =============================================================================
