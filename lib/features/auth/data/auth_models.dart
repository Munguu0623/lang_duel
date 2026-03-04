/// Backend-аас буцаж ирдэг нэвтэрсэн хэрэглэгчийн мэдээлэл.
///
/// `/auth/*` болон `/me` endpoint бүрийн `user` объекттай тохирно:
/// ```json
/// { "id": "uuid", "email": "…", "name": "…", "rank": 1000, "winStreak": 0 }
/// ```
class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
    required this.rank,
    required this.winStreak,
    this.avatar,
  });

  final String id;
  final String email;

  /// Бүртгэлийн үед хэрэглэгчийн сонгосон дэлгэцийн нэр.
  final String name;

  /// ELO-стиль рейтинг (1000-аас эхэлнэ).
  final int rank;

  final int winStreak;

  /// Аватарын түлхүүр — бүртгэлийн дараах урсгалд сонгох хүртэл null байна.
  final String? avatar;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String,
        rank: (json['rank'] as num).toInt(),
        winStreak: (json['winStreak'] as num).toInt(),
        avatar: json['avatar'] as String?,
      );
}

/// Нэвтрэх / бүртгэх endpoint-аас буцаж ирдэг JWT token + хэрэглэгч.
class AuthResponse {
  const AuthResponse({required this.token, required this.user});

  final String token;
  final AuthUser user;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        token: json['token'] as String,
        user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
      );
}
