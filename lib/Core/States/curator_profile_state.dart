import 'package:admin_curator/Models/profile.dart';

class ProfileState {
  final List<CuratorModel> profile;
  final bool isLoading;
  final String errorMessage;

  ProfileState({
    required this.profile,
    this.isLoading = false,
    this.errorMessage = '',
  });

  ProfileState copyWith({
    List<CuratorModel>? profile,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
