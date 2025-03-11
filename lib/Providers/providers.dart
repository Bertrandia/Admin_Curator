import 'package:admin_curator/Core/Notifiers/auth_notifier.dart';
import 'package:admin_curator/Core/Notifiers/profile_notifier.dart';
import 'package:admin_curator/Core/Services/auth_service.dart';
import 'package:admin_curator/Core/Services/profile_service.dart';
import 'package:admin_curator/Core/States/auth_state.dart';
import 'package:admin_curator/Core/States/curator_profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(AuthService());
});

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(ProfileService()),
);
