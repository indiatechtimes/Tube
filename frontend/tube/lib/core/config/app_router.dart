import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tube/features/auth/data/authSessions/auth_sessions_provider.dart';
import 'package:tube/features/auth/data/screens/registrationScreen.dart';
import 'package:tube/features/auth/data/screens/loginScreen.dart';
import 'package:tube/features/presentation/screens/homeScreen.dart';
import 'package:tube/features/presentation/widgets/productDetailsScreen.dart';
import 'package:tube/features/presentation/widgets/splashScreen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  late final GoRouter router;

  router = GoRouter(
    initialLocation: '/splash',

    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const Splashscreen(),
      ),

      GoRoute(
        path: '/register',
        builder: (context, state) => const Registrationscreen(),
      ),

      GoRoute(path: '/login', builder: (context, state) => const Loginscreen()),

      GoRoute(path: '/home', builder: (context, state) => Homescreen()),

      GoRoute(
        name: 'productDetails',
        path: '/product/:productId',
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;

          return Productdetailsscreen(productId: productId);
        },
      ),
    ],

    redirect: (context, state) {
      final authState = ref.read(authSessionsProvider);
      final location = state.matchedLocation;

      // session is still being checked
      if (authState.isLoading) {
        return location == '/splash' ? null : '/splash';
      }

      final isLoggedIn = authState.asData?.value ?? false;

      final isPublicRoute = location == '/login' || location == '/register';

      // a logged-out user cannnot access protected routes.

      if (!isLoggedIn && !isPublicRoute && location != '/splash') {
        return '/login';
      }

      //rosolve the splash sereen once the session checked finishes.
      if (location == '/splash') {
        return isLoggedIn ? '/home' : '/login';
      }

      // an authenticated user should not remain on login / register
      if (isLoggedIn && isPublicRoute) {
        return '/home';
      }

      // null means : do not redirected.
      return null;
    },
  );

  // re-evaluate redirected whenever the auth state change.
  ref.listen(authSessionsProvider, (previous, next) {
    router.refresh();
  });

  ref.onDispose(router.dispose);

  return router;
});
