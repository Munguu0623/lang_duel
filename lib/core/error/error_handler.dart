// =============================================================================
// error_handler.dart — DioException-г AppException-болгон хөрвүүлнэ
// =============================================================================
//
// Datasource layer дахь try-catch блок бүрт ашиглагдах utility class.
// DioException, SocketException, FormatException зэрэг raw алдааг
// апп-д ойлгомжтой AppException болгоно.
//
// ШААРДЛАГАТАЙ IMPORT-УУД:
//   - package:dio/dio.dart
//   - dart:io (SocketException-ийн тулд)
//   - core/error/app_exception.dart
//
// CLASS БҮТЭЦ: abstract final class ErrorHandler (instantiate хийх шаардлагагүй)
//
// СТАТИК METHOD:
//
//   static AppException handle(Object error, [StackTrace? stackTrace]) {
//     → Дараах тохиолдлуудыг шалгана:
//
//     ТОХИОЛДОЛ 1 — DioException:
//       type == DioExceptionType.connectionError
//       эсвэл type == DioExceptionType.unknown && error нь SocketException
//         → NetworkException() буцаана
//
//       type == DioExceptionType.connectionTimeout
//       эсвэл type == DioExceptionType.receiveTimeout
//         → TimeoutException() буцаана
//
//       response?.statusCode == 401  → UnauthorizedException()
//       response?.statusCode == 403  → ForbiddenException()
//       response?.statusCode == 404  → NotFoundException()
//       response?.statusCode == 422  → ValidationException(errors: ...)
//       response?.statusCode >= 500  → ServerException(debugMessage: body)
//       бусад                        → UnknownException()
//
//     ТОХИОЛДОЛ 2 — AppException (аль хэдийн боловсруулагдсан):
//       → Хэвээр нь буцаана (дахин хөрвүүлэхгүй)
//
//     ТОХИОЛДОЛ 3 — Бусад бүх алдаа:
//       → UnknownException(debugMessage: error.toString())
//   }
//
// DATASOURCE ДОТОР ХЭРЭГЛЭХ ЗАГВАР:
//   try {
//     return await apiClient.getTopics(null);
//   } catch (e, st) {
//     throw ErrorHandler.handle(e, st);
//   }
//
// АНХААРУУЛГА:
//   - ValidationException-д response body-г parse хийж
//     field-ийн алдааг Map<String, List<String>> болгон хадгалах хэрэгтэй.
//   - StackTrace-г Crashlytics эсвэл Sentry-д илгээх логик энд нэмж болно.
// =============================================================================
