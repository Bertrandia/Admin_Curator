import 'package:admin_curator/Models/user_model.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String errorMessage;

  AuthState({this.user, this.isLoading = false, this.errorMessage = ''});

  AuthState copyWith({UserModel? user, bool? isLoading, String? errorMessage}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
