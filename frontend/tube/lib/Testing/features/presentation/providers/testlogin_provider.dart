import 'package:riverpod/riverpod.dart';
import 'package:tube/Testing/core/config/test_api_config.dart';
import 'package:tube/Testing/features/data/models/testLoginUser.model.dart';
import 'package:tube/Testing/features/data/repository/testlogin_repository.dart';


final testLoginRepositoryProvider = Provider<TestloginRepository>((ref) {
  return TestloginRepository(testbaseUrl: TestApiConfig.testbaseUrl);
});

class TestLoginNotifier extends AsyncNotifier<Testloginuser> {
  @override
  Future<Testloginuser?> build() async {
    return null;
  }

  Future<void> testloginUser({
    required String userName,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(testLoginRepositoryProvider);

      final user = await repository.login(
        userName: userName,
        email: email,
        password: password,
      );

      state = AsyncData(user);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
    
  }
}
