// =============================================================================
// refresh_interceptor.dart — 401 хариу ирвэл token refresh хийж request давтана
// =============================================================================
//
// Dio-ийн `QueuedInterceptorsWrapper` ашиглана.
// QueuedInterceptorsWrapper нь олон зэрэг request 401 авах үед
// зөвхөн нэг удаа refresh хийгдэхийг баталгаажуулна (race condition эвдэнэ).
//
// ШААРДЛАГАТАЙ IMPORT-УУД:
//   - package:dio/dio.dart
//   - core/storage/secure_storage_service.dart
//   - core/constants/app_constants.dart (refresh endpoint URL-ийн тулд)
//
// CLASS БҮТЭЦ: RefreshInterceptor extends QueuedInterceptorsWrapper
//
// CONSTRUCTOR:
//   RefreshInterceptor({
//     required Dio dio,                         ← шинэ Dio instance (interceptor-гүй)
//     required SecureStorageService storage,
//     required VoidCallback onLogout,           ← refresh fail бол нэвтрэх хуудас руу
//   })
//   АНХААРУУЛГА: dio параметр нь dioProvider-ийн Dio биш, тусдаа шинэ instance байна.
//   Учир нь interceptor дотор interceptor-тай Dio ашиглавал давтагдах тойрог үүснэ.
//
// OVERRIDE ХИЙХ METHOD:
//
//   onError(DioException err, ErrorInterceptorHandler handler):
//     1. err.response?.statusCode == 401 эсэхийг шалгана
//     2. 401 биш бол: handler.next(err) — энгийн алдаа шиг дамжуулна
//     3. 401 бол:
//        a. SecureStorageService.getRefreshToken() авна
//        b. refreshToken null бол → onLogout() дуудаж, handler.reject() хийнэ
//        c. POST /auth/refresh { refreshToken } дуудна (interceptor-гүй Dio-р)
//        d. Амжилттай бол:
//           - Шинэ accessToken-г SecureStorageService-д хадгална
//           - Анхны request-г шинэ token-тэй давтана:
//               err.requestOptions.headers['Authorization'] = 'Bearer $newToken'
//               final retryResponse = await dio.fetch(err.requestOptions)
//               handler.resolve(retryResponse)
//        e. Refresh мөн fail болвол:
//           - SecureStorageService.clearAll() дуудна
//           - onLogout() дуудна (GoRouter login руу redirect хийнэ)
//           - handler.reject(err)
//
// ЧУХАЛ:
//   - Энэ interceptor нь dio_provider.dart дотор AuthInterceptor-ийн ДАРАА нэмэгдэнэ.
//   - onLogout callback нь Riverpod-ийн auth provider-г invalidate хийх эсвэл
//     ProviderContainer-аар дамжуулан state цэвэрлэх боломжтой.
// =============================================================================
