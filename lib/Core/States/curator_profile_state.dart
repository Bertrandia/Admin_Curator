import 'package:admin_curator/Models/profile.dart';

class ProfileState {
  final List<CuratorModel> profile;
  final bool isLoading;
  final String errorMessage;
  final CuratorModel? singleProfile;

  ProfileState({
    required this.profile,
    this.isLoading = false,
    this.errorMessage = '',
    this.singleProfile,
  });

  ProfileState copyWith({
    List<CuratorModel>? profile,
    bool? isLoading,
    String? errorMessage,
    CuratorModel? singleProfile,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      singleProfile: singleProfile ?? this.singleProfile,
    );
  }
}
