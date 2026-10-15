
























// import 'dart:io';
// import 'dart:async';

// import 'package:riverpod/legacy.dart';
// import 'package:riverpod/riverpod.dart';
// import 'package:tube/features/auth/data/models/registeredUser.model.dart';
// import 'package:tube/features/auth/data/repositories/auth_repository.dart';

// final AuthRepositoryProvider = StateProvider<AuthRepository>((ref) {
//   return AuthRepository();
// });

// class RegisterNotifier extends AsyncNotifier<RegisteredUser?> {
//   @override
//   FutureOr<RegisteredUser?> build() async {
//     return null;
//   }

//   Future<void> register({
//     required String fullName,
//     required String email,
//     required String userName,
//     required String password,
//     required File avatar,
//     File? coverImage,
//   }) async {
//     if (state.isLoading) {
//       return;
//     }

//     state = const AsyncLoading<RegisteredUser?>();
    

//     state = const AsyncLoading();
//     state = await AsyncValue.guard(() {
//       final repository = ref.read(AuthRepositoryProvider);
//       return repository.register(
//         fullName: fullName,
//         email: email,
//         userName: userName,
//         password: password,
//         avatar: avatar,
//         coverImage: coverImage,
//       );
//     });
//   }

//   void reset() {
//     state = const AsyncData(null);
//   }
// }

// final RegisterNotifierProvider =
//     AsyncNotifierProvider<RegisterNotifier, RegisteredUser?>(
//       RegisterNotifier.new,
//     );
// import 'dart:io';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:tube/features/auth/data/models/registeredUser.model.dart';
// import 'package:tube/features/auth/data/repositories/auth_repository.dart';

// final authRepositoryProvider = Provider<AuthRepository>((ref) {
//   return AuthRepository();
// });

// class RegisterNotifier extends Notifier<AsyncValue<RegisteredUser?>> {
//   @override
//   AsyncValue<RegisteredUser?> build() {
//     return const AsyncData(null);
//   }

//   Future<void> register({
//     required String fullName,
//     required String email,
//     required String userName,
//     required String password,
//     required File avatar,
//     File? coverImage,
//   }) async {
//     // Prevent duplicate registration requests.
//     if (state.isLoading) return;

//     state = const AsyncLoading<RegisteredUser?>();

//     state = await AsyncValue.guard(() async {
//       final repository = ref.read(authRepositoryProvider);

//       return await repository.register(
//         fullName: fullName,
//         email: email,
//         userName: userName,
//         password: password,
//         avatar: avatar,
//         coverImage: coverImage,
//       );
//     });
//   }

//   void reset() {
//     state = const AsyncData<RegisteredUser?>(null);
//   }
// }

// final registerNotifierProvider =
//     NotifierProvider<RegisterNotifier, AsyncValue<RegisteredUser?>>(
//       RegisterNotifier.new,
//     );
