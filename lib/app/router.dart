import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/gameplay/presentation/pages/gameplay_loader_screen.dart';
import '../features/auth/application/auth_state_provider.dart';
import '../features/auth/presentation/pages/loading_screen.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/signup_screen.dart';
import '../features/dashboard/presentation/pages/dashboard_screen.dart';
// import '../features/onboarding/application/onboarding_provider.dart';
import '../features/onboarding/presentation/pages/intro_one_screen.dart';
import '../features/onboarding/presentation/pages/intro_three_screen.dart';
import '../features/onboarding/presentation/pages/intro_two_screen.dart';
import '../features/dashboard/presentation/pages/profile_screen.dart';
import '../features/dashboard/presentation/pages/settings_screen.dart';
import '../core/services/local_preferences_provider.dart';
import '../features/dashboard/presentation/pages/edit_profile_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final onboardingCompletedAsync = ref.watch(hasCompletedOnboardingProvider);

  return GoRouter(
    initialLocation: '/loading',
    routes: <RouteBase>[
      GoRoute(
        path: '/intro-1',
        name: 'intro-1',
        builder: (BuildContext context, GoRouterState state) {
          return const IntroOneScreen();
        },
      ),
      GoRoute(
        path: '/intro-2',
        name: 'intro-2',
        builder: (BuildContext context, GoRouterState state) {
          return const IntroTwoScreen();
        },
      ),
      GoRoute(
        path: '/intro-3',
        name: 'intro-3',
        builder: (BuildContext context, GoRouterState state) {
          return const IntroThreeScreen();
        },
      ),
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
        path: '/loading',
        name: 'loading',
        builder: (BuildContext context, GoRouterState state) {
          return const LoadingScreen();
        },
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (BuildContext context, GoRouterState state) {
          return const DashboardScreen();
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileScreen();
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (BuildContext context, GoRouterState state) {
          return const SettingsScreen();
        },
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'edit-profile',
        builder: (BuildContext context, GoRouterState state) {
          return const EditProfileScreen();
        },
      ),
      GoRoute(
        path: '/gameplay',
        name: 'gameplay',
        builder: (BuildContext context, GoRouterState state) {
          return const GameplayLoaderScreen();
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final location = state.matchedLocation;
      final isAuthenticated = authState.isAuthenticated;
      final isLoadingRoute = location == '/loading';

      if (onboardingCompletedAsync.isLoading) {
        return location == '/loading' ? null : '/loading';
      }

      final onboardingCompleted = onboardingCompletedAsync.value ?? false;

      final isIntroRoute =
          location == '/intro-1' ||
          location == '/intro-2' ||
          location == '/intro-3';

      final isAuthRoute = location == '/login' || location == '/signup';

      final isDashboardRoute = location == '/dashboard';
      final isGameplayRoute = location == '/gameplay';

      if (!onboardingCompleted && !isIntroRoute) {
        return '/intro-1';
      }

      if (onboardingCompleted && isIntroRoute) {
        return isAuthenticated ? '/dashboard' : '/login';
      }

      if (!isAuthenticated && (isDashboardRoute || isGameplayRoute)) {
        return '/login';
      }

      if (isAuthenticated && isAuthRoute) {
        return '/dashboard';
      }

      if (isLoadingRoute && !onboardingCompletedAsync.isLoading) {
        if (!onboardingCompleted) {
          return '/intro-1';
        }

        return isAuthenticated ? '/dashboard' : '/login';
      }

      if (isLoadingRoute) {
        return null;
      }

      return null;
    },
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Route not found: ${state.uri}'))),
  );
});
