import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class AuthStateNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState.initial();

  void setAuthenticated(bool value) {
    state = state.copyWith(
      isAuthenticated: value,
      isLoading: false,
      errorMessage: null,
    );
  }

  void logout() {
    state = const AuthState.initial();
  }
}

final authStateProvider = NotifierProvider<AuthStateNotifier, AuthState>(
  AuthStateNotifier.new,
);
