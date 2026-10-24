
import 'package:tube/features/auth/data/models/loginUser.model.dart';

class AuthSession {
  final String id;
  final String userName;
  final String email;
  final String fullName;
  final String avatar;
  final String accessToken;

  const AuthSession({
    required this.id,
    required this.userName,
    required this.email,
    required this.fullName,
    required this.avatar,
    required this.accessToken,
  });

  factory AuthSession.fromLoginUser(LoginUser user) {
    return AuthSession(
      id: user.id,
      userName: user.userName,
      email: user.email,
      fullName: user.fullName,
      avatar: user.avatar,
      accessToken: user.accessToken,
    );
  }

  factory AuthSession.fromJson(
    Map<String, dynamic> json, {
    required String accessToken,
  }) {
    return AuthSession(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      userName: (json['userName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      fullName: (json['fullName'] ?? '').toString(),
      avatar: (json['avatar'] ?? '').toString(),
      accessToken: (json['accessToken'] ?? '').toString(),
    );
  }
}
