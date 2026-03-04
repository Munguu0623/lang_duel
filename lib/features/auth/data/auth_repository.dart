import '../../../core/network/api_client.dart';
import 'auth_models.dart';

/// Auth endpoint-уудын цэвэр өгөгдлийн давхарга.
///
/// Exception барьдаггүй — бүх [ApiException] дуудагч тал руу
/// ([AuthService] эсвэл шууд UI) дамжин гарна.
class AuthRepository {
  const AuthRepository(this._client);

  final ApiClient _client;

  // ── POST /auth/login ──────────────────────────────────────────────────────

  /// Одоо байгаа хэрэглэгчийг нэвтрүүлнэ.
  ///
  /// Имэйл / нууц үг буруу бол [serverCode] нь `"INVALID_CREDENTIALS"` байх
  /// [ApiException] шидэнэ.
  Future<AuthResponse> login(String email, String password) async {
    final data = await _client.post('/auth/login', {
      'email': email,
      'password': password,
    });
    return AuthResponse.fromJson(data);
  }

  // ── POST /auth/register ───────────────────────────────────────────────────

  /// Шинэ бүртгэл үүсгэж, нэн даруй token буцаана (имэйл баталгаажуулалтгүй).
  ///
  /// Давтагдсан имэйл бол [serverCode] нь `"EMAIL_EXISTS"` байх
  /// [ApiException] шидэнэ.
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final data = await _client.post('/auth/register', {
      'email': email,
      'password': password,
      'name': name,
    });
    return AuthResponse.fromJson(data);
  }

  // ── GET /me ───────────────────────────────────────────────────────────────

  /// Одоогийн token-ийг баталгаажуулж, шинэ хэрэглэгчийн мэдээлэл буцаана.
  ///
  /// [ApiClient]-г дуудахын өмнө bearer token-той үүсгэсэн байх ёстой.
  /// [AuthService.initialize] дэх сесс сэргээлтэд ашиглагдана.
  Future<AuthUser> getMe() async {
    final data = await _client.get('/me');
    return AuthUser.fromJson(data['user'] as Map<String, dynamic>);
  }
}
