import 'dart:async';
import 'package:admin_curator/Core/Services/profile_service.dart';
import 'package:admin_curator/Core/States/curator_profile_state.dart';
import 'package:admin_curator/Models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileService _profileService;

  ProfileNotifier(this._profileService)
    : super(ProfileState(isLoading: true, profile: [])) {
    fetchCurators();
  }

  void fetchCurators() async {
    _profileService.getCuratorsWithProfilesStream().listen((profiles) {
      state = state.copyWith(isLoading: false, profile: profiles);
    });
  }

  Future<bool> updateVerificationStatus({
    required String consultantId,
    required bool isVerified,
    required bool isRejected,
    String? rejectionReason,
    String? rejectedBy,
    DateTime? rejectedAt,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final user = await _profileService.updateCuratorStatus(
        consultantId,
        isRejected: isRejected,
        isVerified: isVerified,
        rejectionReason: rejectionReason,
        rejectedBy: rejectedBy,
        rejectedAt: rejectedAt,
      );
      if (user != null) {
        state = state.copyWith(isLoading: false, errorMessage: '');
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to change status',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to change status',
      );
      return false;
    }
  }

  void getCuratorByReference(DocumentReference ref) {
    _profileService.getCuratorByReference(ref).listen((curator) {
      state = state.copyWith(singleProfile: curator);
      print(state.singleProfile);
    });
  }

  void getCuratorById(String doc) async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final user = await _profileService.getCuratorByRef(doc);
      print('user is : $user');
      if (user != null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: '',
          singleProfile: user,
        );
      }
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: 'Failed');
    }
  }
}
