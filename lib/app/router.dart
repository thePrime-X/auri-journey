import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/application/auth_state_provider.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/signup_screen.dart';
import '../features/dashboard/presentation/pages/dashboard_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (BuildContext context, GoRouterState state) {
          return const SignupScreen();
        },
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (BuildContext context, GoRouterState state) {
          return const DashboardScreen();
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = authState.isAuthenticated;
      final location = state.matchedLocation;

      final isAuthPage = location == '/login' || location == '/signup';
      final isDashboardPage = location == '/dashboard';

      if (!isAuthenticated && isDashboardPage) {
        return '/login';
      }

      if (isAuthenticated && isAuthPage) {
        return '/dashboard';
      }

      return null;
    },
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Route not found: ${state.uri}'))),
  );
});
