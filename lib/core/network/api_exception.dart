/// Backend 4xx/5xx буцаах эсвэл сүлжээний алдаа гарах үед шидэгдэнэ.
///
/// [statusCode] — HTTP-ийн бус алдаа (timeout, холболтгүй) үед 0 байна.
/// [serverCode] — серверийн машинд ойлгогдохуйц код (`"EMAIL_EXISTS"` гэх мэт).
/// [message]    — UI-д шууд харуулж болох хэрэглэгчид зориулсан мессеж.
class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.serverCode,
    required this.message,
  });

  /// Серверийн буцааж өгсөн HTTP статус код; сүлжээний алдаанд 0 байна.
  final int statusCode;

  /// Серверийн алдааны код, жишээ нь `"INVALID_CREDENTIALS"`, `"EMAIL_EXISTS"`.
  final String serverCode;

  /// Хэрэглэгчид харуулах мессеж — Snackbar эсвэл алдааны widget-т аюулгүй.
  final String message;

  @override
  String toString() => 'ApiException[$statusCode/$serverCode]: $message';
}
