import 'package:admin_curator/Core/Notifiers/auth_notifier.dart';
import 'package:admin_curator/Core/Notifiers/profile_notifier.dart';
import 'package:admin_curator/Core/Services/auth_service.dart';
import 'package:admin_curator/Core/Services/profile_service.dart';
import 'package:admin_curator/Core/Services/task_service.dart';
import 'package:admin_curator/Core/States/auth_state.dart';
import 'package:admin_curator/Core/States/curator_profile_state.dart';
import 'package:admin_curator/Core/States/curator_task_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Core/Notifiers/user_task_notifier.dart';

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(AuthService());
});

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(ProfileService()),
);

final taskProvider = StateNotifierProvider<CuratorTaskNotifier, TaskState>(
  (ref) => CuratorTaskNotifier(TasksService()),
);

final selectedChipProvider = StateProvider<String>((ref) => 'Pending');
