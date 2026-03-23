// =============================================================================
// logging_interceptor.dart — Debug mode-д HTTP request/response log хийнэ
// =============================================================================
//
// Dio-ийн built-in `LogInterceptor`-г ашиглана эсвэл custom wrapper хийнэ.
// Зөвхөн `kDebugMode == true` үед ажиллах ёстой.
// dio_provider.dart дотор if (kDebugMode) { dio.interceptors.add(...) } хэлбэрээр нэмнэ.
//
// ШААРДЛАГАТАЙ IMPORT-УУД:
//   - package:dio/dio.dart
//   - package:flutter/foundation.dart (kDebugMode-ийн тулд)
//
// ТОХИРУУЛАХ ПАРАМЕТРҮҮД (LogInterceptor):
//   requestHeader  : true   — Authorization header зэргийг харна
//   requestBody    : true   — илгээж буй body харна
//   responseHeader : false  — response header ихэвчлэн хэрэггүй
//   responseBody   : true   — хариу body харна
//   error          : true   — алдааны дэлгэрэнгүй харна
//   logPrint       : debugPrint  — Flutter-ийн debugPrint ашиглана
//
// АНХААРУУЛГА:
//   - Production build-д Authorization header log хийгдэж болохгүй.
//     kDebugMode шалгалт заавал хийгдсэн байх ёстой.
//   - Том audio file upload хийхдээ requestBody log нь санах ой их эзэлнэ.
//     Тийм тохиолдолд requestBody: false болгох хэрэгтэй.
// =============================================================================
