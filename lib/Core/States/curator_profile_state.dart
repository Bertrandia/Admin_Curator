import 'package:admin_curator/Models/profile.dart';

class ProfileState {
  final List<CuratorModel> profile;
  final bool isLoading;
  final String errorMessage;
  final CuratorModel? singleProfile;
  final List<CuratorModel>? verifiedProfiles;

  ProfileState({
    required this.profile,
    this.isLoading = false,
    this.errorMessage = '',
    this.singleProfile,
    this.verifiedProfiles,
  });

  ProfileState copyWith({
    List<CuratorModel>? profile,
    bool? isLoading,
    String? errorMessage,
    CuratorModel? singleProfile,
    List<CuratorModel>? verifiedProfiles,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      singleProfile: singleProfile ?? this.singleProfile,
      verifiedProfiles: verifiedProfiles ?? this.verifiedProfiles,
    );
  }
}
