import 'package:admin_curator/Core/Services/auth_service.dart';
import 'package:admin_curator/Core/States/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState(isLoading: true)) {
    _initializeAuth();
  }

  void _initializeAuth() {
    _authService.authStateChanges.listen((user) {
      state = state.copyWith(user: user, isLoading: false);
    });
  }

  Future<bool> getUserDetails(String userId) async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final user = await _authService.getUserDetails(userId);
      if (user != null) {
        state = state.copyWith(user: user, isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to fetch data.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch data.',
      );
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final user = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );
      if (user != null) {
        state = state.copyWith(user: user, isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Sign-in failed.',
        );
        return false;
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _getErrorMessage(e),
      );
      return false;
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'The email address is already in use.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'home_decor_disabled':
        return 'Access restricted. Please contact support.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = AuthState();
  }
}
