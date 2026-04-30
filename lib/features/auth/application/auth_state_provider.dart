import 'package:auri_app/features/auth/data/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

@immutable
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    required this.isAuthenticated,
    required this.isLoading,
    this.errorMessage,
  });

  const AuthState.initial()
    : isAuthenticated = false,
      isLoading = false,
      errorMessage = null;

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

class AuthStateNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    final currentUser = FirebaseAuth.instance.currentUser;

    return AuthState(
      isAuthenticated: currentUser != null,
      isLoading: false,
      errorMessage: null,
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await ref
          .read(authRepositoryProvider)
          .login(email: email, password: password);

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        errorMessage: null,
      );
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        errorMessage: _mapFirebaseAuthError(e),
      );
    } catch (_) {
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        errorMessage: 'Unexpected error occurred.',
      );
    }
  }

  Future<void> signup({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await ref
          .read(authRepositoryProvider)
          .signup(email: email, password: password);

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        errorMessage: null,
      );
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        errorMessage: _mapFirebaseAuthError(e),
      );
    } catch (_) {
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        errorMessage: 'Unexpected error occurred.',
      );
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState.initial();
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}

final authStateProvider = NotifierProvider<AuthStateNotifier, AuthState>(
  AuthStateNotifier.new,
);
