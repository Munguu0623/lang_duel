import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Суурь URL — --dart-define=API_BASE_URL=... ашиглан build цагт өөрчилнө
//
//   Android эмулятор  → хост машины localhost = 10.0.2.2
//   iOS симулятор     → localhost шууд ажиллана
//   Бодит төхөөрөмж   → машины LAN IP хаяг (жишээ: 192.168.1.x:8787)
//   Продакшн          → https://english-duel-backend.<sub>.workers.dev
//
// Жишээ (Android эмулятор):
//   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8787
// ─────────────────────────────────────────────────────────────────────────────
const String _kBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:8787',
);

/// Бүх хүсэлтэд хэрэглэгдэх timeout хугацаа.
const _kTimeout = Duration(seconds: 20);

/// [package:http]-г ороосон нимгэн HTTP client.
///
/// [bearerToken] дамжуулбал бүх хүсэлтэд `Authorization: Bearer` header
/// автоматаар орно.  Алдаа гарвал [ApiException] шидэж — дуудагч тал
/// raw [http.Response] объекттой ажиллах шаардлагагүй.
///
/// ```dart
/// // Нэвтрэх шаардлагагүй хүсэлт
/// final client = ApiClient();
/// final data = await client.post('/auth/login', {'email': e, 'password': p});
///
/// // Нэвтэрсэн хэрэглэгчийн хүсэлт
/// final authed = ApiClient(bearerToken: token);
/// final me = await authed.get('/me');
/// ```
class ApiClient {
  const ApiClient({this.bearerToken});

  final String? bearerToken;

  // ── Нийтийн методууд ──────────────────────────────────────────────────────

  Future<Map<String, dynamic>> get(String path) => _send('GET', path, null);

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) =>
      _send('POST', path, body);

  // ── Дотоод ────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> _send(
    String method,
    String path,
    Map<String, dynamic>? body,
  ) async {
    final uri = Uri.parse('$_kBaseUrl$path');

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // Client үүсгэхдээ token өгсөн бол header-т нэмнэ.
      if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
    };

    late http.Response response;

    try {
      final request = http.Request(method, uri)..headers.addAll(headers);
      if (body != null) request.body = jsonEncode(body);

      final streamed = await request.send().timeout(_kTimeout);
      response = await http.Response.fromStream(streamed);
    } on TimeoutException {
      throw const ApiException(
        statusCode: 0,
        serverCode: 'TIMEOUT',
        message: 'Хүсэлт хэтэрхий удаан байна. Холболтоо шалгана уу.',
      );
    } on SocketException {
      throw const ApiException(
        statusCode: 0,
        serverCode: 'NO_CONNECTION',
        message: 'Серверт холбогдож чадсангүй. Интернэт холболтоо шалгана уу.',
      );
    } on http.ClientException {
      throw const ApiException(
        statusCode: 0,
        serverCode: 'NO_CONNECTION',
        message: 'Серверт холбогдож чадсангүй. Интернэт холболтоо шалгана уу.',
      );
    }

    return _decode(response);
  }

  /// JSON задлаад 4xx / 5xx үед [ApiException] шидэнэ.
  Map<String, dynamic> _decode(http.Response response) {
    late Map<String, dynamic> data;
    try {
      data =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException(
        statusCode: response.statusCode,
        serverCode: 'PARSE_ERROR',
        message: 'Серверийн хариу буруу форматтай байна (${response.statusCode}).',
      );
    }

    if (response.statusCode >= 400) {
      final code = data['error'] as String? ?? 'UNKNOWN_ERROR';
      throw ApiException(
        statusCode: response.statusCode,
        serverCode: code,
        message: _humanize(code),
      );
    }

    return data;
  }

  /// Серверийн алдааны кодыг хэрэглэгчид ойлгомжтой мессеж болгон хөрвүүлнэ.
  static String _humanize(String code) => switch (code) {
        'EMAIL_EXISTS' => 'Энэ имэйл аль хэдийн бүртгэгдсэн байна.',
        'INVALID_EMAIL' => 'Зөв имэйл хаяг оруулна уу.',
        'INVALID_CREDENTIALS' => 'Имэйл эсвэл нууц үг буруу байна.',
        'UNAUTHORIZED' => 'Хугацаа дууссан. Дахин нэвтэрнэ үү.',
        'NOT_FOUND' => 'Хэрэглэгч олдсонгүй.',
        _ => 'Алдаа гарлаа. Дахин оролдоно уу.',
      };
}
