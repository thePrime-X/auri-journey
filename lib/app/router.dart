import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/application/auth_state_provider.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/signup_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authStateProvider.notifier);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isAuthenticated = authState.isAuthenticated;
      final location = state.matchedLocation;

      final isPublicRoute = location == '/login' || location == '/signup';

      if (!isAuthenticated && !isPublicRoute) {
        return '/login';
      }

      if (isAuthenticated && isPublicRoute) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
});
