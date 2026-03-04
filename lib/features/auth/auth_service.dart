import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/api_client.dart';
import 'data/auth_models.dart';
import 'data/auth_repository.dart';

// SharedPreferences түлхүүрүүд — энэ файлын дотор нуугдсан байна.
const _kTokenKey = 'auth_jwt_token';
const _kOnboardingKey = 'has_seen_onboarding';

/// Нэвтрэлтийн төлөвийн нэг эх сурвалж.
///
/// Хариуцлагууд:
///   • Апп дахин эхлэх бүрт JWT token-г диск дээр хадгалах / сэргээх.
///   • Сэргээсэн token-г GET /me дуудаж баталгаажуулах.
///   • [currentUser] болон [isLoggedIn]-г апп даяар нийлүүлэх.
///   • Онбординг харсан флагийг хадгалж, splash дэлгэц зөв чиглүүлэх.
///
/// Амьдралын мөчлөг:
/// ```dart
/// // SplashScreen.initState() дотор:
/// await authService.initialize();
/// // Дараа нь authService.isLoggedIn / hasSeenOnboarding уншиж чиглүүлнэ.
/// ```
///
/// Auth үйлдлүүд алдаа гарвал [ApiException] шидэнэ —
/// UI тал барьж, [ApiException.message]-г хэрэглэгчид харуулна.
class AuthService extends ChangeNotifier {
  AuthUser? _user;
  String? _token;
  bool _initialized = false;
  bool _hasSeenOnboarding = false;

  // ── Getter-үүд ────────────────────────────────────────────────────────────

  /// Одоо нэвтэрсэн хэрэглэгч, зочин / нэвтрээгүй бол `null`.
  AuthUser? get currentUser => _user;

  /// Дискэнд хадгалагдсан raw JWT мөр, гарсан бол `null`.
  String? get token => _token;

  /// [_user] болон [_token] хоёул байгаа бол true.
  bool get isLoggedIn => _user != null && _token != null;

  /// [initialize] дуусмагц (амжилттай эсвэл үгүй) true болно.
  /// Async init дуусахаас өмнө чиглүүлэхээс сэргийлэхэд ашиглана.
  bool get initialized => _initialized;

  /// Хэрэглэгч онбординг слайдыг ядаж нэг удаа дуусгасан бол true.
  bool get hasSeenOnboarding => _hasSeenOnboarding;

  // ── Амьдралын мөчлөг ─────────────────────────────────────────────────────

  /// Өмнөх сесс болон онбординг төлвийг сэргээнэ.  Нэг удаа, эрт дуудана.
  ///
  /// Алгоритм:
  ///   1. Дискнээс онбординг флагийг уншина.
  ///   2. Хадгалагдсан token байвал GET /me дуудаж баталгаажуулна.
  ///   3. Амжилттай → сесс сэргэнэ; алдаа → хуучин token-г арилгана.
  ///   4. [initialized] = true болж, listener-үүдэд мэдэгдэнэ.
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    // Token хүчинтэй эсэхээс үл хамааран флагуудыг сэргээнэ.
    _hasSeenOnboarding = prefs.getBool(_kOnboardingKey) ?? false;

    final savedToken = prefs.getString(_kTokenKey);

    if (savedToken != null) {
      try {
        // /me дуудаж баталгаажуулна — хэрэглэгчийн мэдээллийг шинэчилнэ.
        final repo = AuthRepository(ApiClient(bearerToken: savedToken));
        _user = await repo.getMe();
        _token = savedToken;
      } catch (_) {
        // Token хугацаа дууссан эсвэл сервер хүрэхгүй — чимээгүй арилгаж,
        // хэрэглэгч дахин нэвтрэх боломжтойгоор зочин болгоно.
        await prefs.remove(_kTokenKey);
      }
    }

    _initialized = true;
    notifyListeners();
  }

  // ── Auth үйлдлүүд ─────────────────────────────────────────────────────────

  /// [email] болон [password]-аар нэвтэрнэ.
  ///
  /// Амжилттай: token-г хадгалаад listener-үүдэд мэдэгдэнэ.
  /// Амжилтгүй: [ApiException]-г дахин шидэж UI харуулдаг болно.
  Future<AuthUser> login(String email, String password) async {
    final response =
        await AuthRepository(const ApiClient()).login(email, password);
    await _persist(response);
    return response.user;
  }

  /// Шинэ бүртгэл үүсгэнэ.
  ///
  /// Амжилттай: token-г хадгалаад listener-үүдэд мэдэгдэнэ.
  /// Амжилтгүй: [ApiException]-г дахин шидэж UI харуулдаг болно.
  Future<AuthUser> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await AuthRepository(const ApiClient())
        .register(email: email, password: password, name: name);
    await _persist(response);
    return response.user;
  }

  /// Локал сессийг цэвэрлэнэ.  Аль хэдийн гарсан үед аюулгүй дуудаж болно.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kTokenKey);
    _user = null;
    _token = null;
    notifyListeners();
  }

  /// "Хэрэглэгч онбординг харсан" флагийг дискэнд хадгална.
  Future<void> markOnboardingSeen() async {
    _hasSeenOnboarding = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingKey, true);
    // notifyListeners шаардлагагүй — splash дэлгэц энэ утгыг аль хэдийн авсан.
  }

  // ── Дотоод ────────────────────────────────────────────────────────────────

  /// Token-г дискэнд бичиж, санах ойн төлвийг шинэчилнэ.
  Future<void> _persist(AuthResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTokenKey, response.token);
    _token = response.token;
    _user = response.user;
    notifyListeners();
  }
}

/// Апп даяар нэг удаа үүсэх singleton.
///
/// Splash дэлгэцэнд [authService.initialize()]-г нэг удаа дуудсаны дараа
/// [authService.isLoggedIn] болон [authService.currentUser]-г уншина.
final authService = AuthService();
