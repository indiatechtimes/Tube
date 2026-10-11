import 'dart:io';
import 'dart:async';

import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tube/features/auth/data/models/registeredUser.model.dart';
import 'package:tube/features/auth/data/repositories/auth_repository.dart';

final AuthRepositoryProvider = StateProvider<AuthRepository>((ref) {
  return AuthRepository();
});

class RegisterNotifier extends AsyncNotifier<RegisteredUser?> {
  @override
  FutureOr<RegisteredUser?> build() async {
    return null;
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String userName,
    required String password,
    required File avatar,
    File? coverImage,
  }) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncLoading<RegisteredUser?>();
    

    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      final repository = ref.read(AuthRepositoryProvider);
      return repository.register(
        fullName: fullName,
        email: email,
        userName: userName,
        password: password,
        avatar: avatar,
        coverImage: coverImage,
      );
    });
  }

  void reset() {
    state = const AsyncData(null);
  }
}

final RegisterNotifierProvider =
    AsyncNotifierProvider<RegisterNotifier, RegisteredUser?>(
      RegisterNotifier.new,
    );
