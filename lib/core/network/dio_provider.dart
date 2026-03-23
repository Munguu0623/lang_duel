// =============================================================================
// dio_provider.dart — Dio instance + бүх interceptor-уудыг Riverpod Provider-р өгнө
// =============================================================================
//
// Энэ файл нь апп даяар ашиглагдах Dio HTTP client-ийг тохируулна.
// Riverpod `Provider<Dio>` болон `Provider<ApiClient>` хоёрыг export хийнэ.
//
// ШААРДЛАГАТАЙ IMPORT-УУД:
//   - package:dio/dio.dart
//   - package:flutter_riverpod/flutter_riverpod.dart
//   - core/network/api_client.dart
//   - core/network/auth_interceptor.dart
//   - core/network/refresh_interceptor.dart
//   - core/network/logging_interceptor.dart
//   - core/constants/app_constants.dart (ApiConfig.baseUrl авахын тулд)
//   - core/storage/secure_storage_service.dart
//
// ҮҮСГЭХ PROVIDER-УУД:
//
// 1. dioProvider — Provider<Dio>
//    Dio instance-ийг дараах тохиргоотой үүсгэнэ:
//    - BaseOptions:
//        baseUrl     : ApiConfig.baseUrl (app_constants.dart-аас)
//        connectTimeout: Duration(seconds: 15)
//        receiveTimeout: Duration(seconds: 30)
//        headers     : { 'Content-Type': 'application/json' }
//    - Interceptors дарааллаар нэмнэ (дараалал чухал):
//        1) AuthInterceptor     — request явахаасаа өмнө Bearer token нэмнэ
//        2) RefreshInterceptor  — 401 хариу ирвэл token refresh хийнэ
//        3) LoggingInterceptor  — зөвхөн debug mode-д ажиллана (kDebugMode шалгана)
//
// 2. apiClientProvider — Provider<ApiClient>
//    dioProvider-с Dio авч ApiClient(dio) үүсгэнэ.
//    Бусад файлууд энэ provider-г ашиглан API дуудлага хийнэ.
//
// ЖИШЭЭ ХЭРЭГЛЭЭ (datasource дотор):
//   final client = ref.watch(apiClientProvider);
//   final topics = await client.getTopics(null);
//
// АНХААРУУЛГА:
//   - Dio instance нь ref.watch-аар дахин үүсгэгдэж болохгүй тул
//     `keepAlive: true` эсвэл class-level singleton ашиглах хэрэгтэй.
//   - BaseUrl нь environment (dev/staging/prod) дагуу өөрчлөгдөх тул
//     ApiConfig дотор environment-aware логик нэмэх хэрэгтэй.
// =============================================================================
