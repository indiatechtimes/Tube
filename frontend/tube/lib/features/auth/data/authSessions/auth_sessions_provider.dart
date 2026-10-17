import 'package:riverpod/riverpod.dart';

class AuthSessionsNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {


    
    // learning placeholder

    // later , restore the saved session/token here.

    return false;
  }

  void markLoggedIn() {
    state = const AsyncData(true);
  }

  void logout() {
    state = const AsyncData(false);
  }
}

final authSessionsProvider = AsyncNotifierProvider<AuthSessionsNotifier, bool>(
  AuthSessionsNotifier.new,
);
