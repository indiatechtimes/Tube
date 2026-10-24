//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';



// Ye class kya solve karti hai?
// - Login success hone par tokens save honge.
// - App restart par tokens read ho sakenge.
// - Refresh ke baad purane tokens naye tokens se replace honge.
// - Logout par dono tokens delete honge.






import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage {
  SecureTokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;// _storage is my obect of FlutterSecureStorage

  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    if (accessToken.isEmpty || refreshToken.isEmpty) {
      throw Exception('cannot save empty authentication tokens');
    }

    await _storage.write(key: _accessTokenKey, value: accessToken);

    await _storage.write(key: _refreshTokenKey, value: refreshToken);

    
  }


  Future<String?> readAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> readRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  
}
