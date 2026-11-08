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

final authSessionsProvider =
    AsyncNotifierProvider<AuthSessionsNotifier, AuthSession?>(
      AuthSessionsNotifier.new,
    );

class AuthSessionsNotifier extends AsyncNotifier<AuthSession?> {
  late SecureTokenStorage _storage;
  late AuthRepository _authRepository;

  @override
  Future<AuthSession?> build() async {
    try {
      print('STEP 1: Auth build started');

      _storage = ref.read(secureTokenStorageProvider);
      _authRepository = ref.read(authRopositoryProvider);

      print('STEP 2: Dependencies initialized');

      final refreshToken = await _storage.readRefreshToken();

      print(
        'STEP 3: Refresh token exists = '
        '${refreshToken != null && refreshToken.isNotEmpty}',
      );

      if (refreshToken == null || refreshToken.isEmpty) {
        print('STEP 4: No refresh token found');
        return null;
      }

      print('STEP 5: Calling refresh API');

      final tokens = await _authRepository.refreshTokens(refreshToken);

      print('STEP 6: Refresh API successful');

      await _storage.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );

      print('STEP 7: New tokens saved');

      final userJson = await _authRepository.getCurrentUser(tokens.accessToken);

      print('STEP 8: Current user fetched');

      final session = AuthSession.fromJson(
        userJson,
        accessToken: tokens.accessToken,
      );

      print('STEP 9: Session restored successfully');

      return session;
    } catch (error, stackTrace) {
      print('AUTH RESTORATION FAILED: $error');
      print(stackTrace);

      rethrow;
    }
  }

  Future<void> logIn(LoginUser user) async {
    print('login= $user');
    print('login= ${user.accessToken}');
    print('login = ${user.refreshToken}');
    if (user.accessToken.isEmpty || user.refreshToken.isEmpty) {
      throw Exception("Login response is missing tokens");
    }

    await _storage.saveTokens(
      accessToken: user.accessToken,
      refreshToken: user.refreshToken,
    );

    print("user , accessToken and refreshToken is saved");

    state = AsyncData(AuthSession.fromLoginUser(user));

    print("state is changed to asyncData");
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
