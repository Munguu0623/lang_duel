// =============================================================================
// auth_interceptor.dart — Dio Interceptor: бүх request-д Bearer token нэмнэ
// =============================================================================
//
// Dio-ийн `Interceptor` class-г extends хийнэ.
// `onRequest` method-г override хийж, access token-ийг header-т оруулна.
//
// ШААРДЛАГАТАЙ IMPORT-УУД:
//   - package:dio/dio.dart
//   - core/storage/secure_storage_service.dart
//
// CLASS БҮТЭЦ: AuthInterceptor extends Interceptor
//
// CONSTRUCTOR:
//   AuthInterceptor(SecureStorageService storage)
//   → storage параметраар secure storage авна
//
// OVERRIDE ХИЙХ METHOD:
//
//   onRequest(RequestOptions options, RequestInterceptorHandler handler):
//     1. SecureStorageService.getAccessToken() дуудна (await)
//     2. Token null биш бол:
//          options.headers['Authorization'] = 'Bearer $token'
//     3. handler.next(options) дуудан request-г үргэлжлүүлнэ
//
// ОНЦЛОГ:
//   - Token байхгүй бол header нэмэхгүй, request-г блоклохгүй
//     (нэвтрэхгүй хандах боломжтой endpoint-уудын тулд)
//   - Token хэзээ expire болж байгааг ЭНД шалгахгүй —
//     энэ нь refresh_interceptor.dart-ийн үүрэг (401 хариу ирсний дараа)
// =============================================================================
