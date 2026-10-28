//import 'dart:io';

//import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';
import 'package:tube/core/config/api_config.dart';
import 'package:tube/core/storage/secure_token_storage.dart';
import 'package:tube/features/auth/data/models/authSession.model.dart';
import 'package:tube/features/auth/data/models/loginUser.model.dart';
import 'package:tube/features/auth/data/repositories/auth_repository.dart';

final secureTokenStorageProvider = Provider<SecureTokenStorage>((ref) {
  return SecureTokenStorage();
});

final authRopositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(authHttpClientProvider);

  return AuthRepository(baseUrl: ApiConfig.baseUrl, client: client);
});

final authHttpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);

  return client;
});

final authSessionsProvider = AsyncNotifierProvider<AuthSessionsNotifier, AuthSession?>(
  AuthSessionsNotifier.new,
);

class AuthSessionsNotifier extends AsyncNotifier<AuthSession?> {
  late SecureTokenStorage _storage;
  late AuthRepository _authRepository;

  @override
  Future<AuthSession?> build() async {
    _storage = ref.read(secureTokenStorageProvider);
    _authRepository = ref.read(authRopositoryProvider);

    final refreshToken = await _storage.readRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    try {
      final tokens = await _authRepository.refreshTokens(refreshToken);

      // save the rotated token before continuing.
      await _storage.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );

      final userJson = await _authRepository.getCurrentUser(tokens.accessToken);

      return AuthSession.fromJson(userJson, accessToken: tokens.accessToken);
    } on AuthApiException catch (error) {
      if (error.statusCode == 401 || error.statusCode == 403) {
        await _storage.clearTokens();
        return null;
      }

      rethrow;
    }
  }

  Future<void> logIn(LoginUser user) async {
    if (user.accessToken.isEmpty || user.refreshToken.isEmpty) {
      throw Exception("Login response is missing tokens");
    }

    await _storage.saveTokens(
      accessToken: user.accessToken,
      refreshToken: user.refreshToken,
    );

    state = AsyncData(AuthSession.fromLoginUser(user));
  }

  Future<void> logout() async {
    final session = state.asData?.value;

    try {
      if (session != null && session.accessToken.isNotEmpty) {
        await _authRepository.logout(session.accessToken);
      }
    } finally {
      await _storage.clearTokens();
      state = const AsyncData(null);
    }
  }
}
