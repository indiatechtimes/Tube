import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:riverpod/src/framework.dart';
import 'package:tube/core/config/api_config.dart';
import 'package:tube/features/auth/data/authSessions/auth_sessions_provider.dart';
import 'package:tube/features/auth/data/models/loginUser.model.dart';
//import 'package:tube/features/auth/data/providers/auth_provider.dart';
import 'package:tube/features/auth/data/repositories/login_repository.dart';

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepository(baseUrl: ApiConfig.baseUrl);
});

class LoginNotifier extends AsyncNotifier<LoginUser?> {
  // @override
  // Future<LoginUser?> build() async => null;

  @override
  Future<LoginUser?> build() async => null;

  Future<void> loginUser({
    required String userName,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(loginRepositoryProvider);

      final user = await repository.login(
        userName: userName,
        email: email,
        password: password,
      );

      await ref.read(authSessionsProvider.notifier).logIn(user);
      return user;
    });
  }
}

final loginProvider = AsyncNotifierProvider<LoginNotifier, LoginUser?>(
  LoginNotifier.new,
);
