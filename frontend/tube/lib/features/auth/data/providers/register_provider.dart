import 'package:riverpod/legacy.dart';
import 'package:tube/features/auth/data/repositories/auth_repository.dart';

final AuthRepositoryProvider = StateProvider<AuthRepository>((ref) {
  return AuthRepository();
});

