import 'package:admin_curator/Core/Notifiers/auth_notifier.dart';
import 'package:admin_curator/Core/Notifiers/curatorBill_notifier.dart';
import 'package:admin_curator/Core/Notifiers/profile_notifier.dart';
import 'package:admin_curator/Core/Notifiers/task_notifier.dart';
import 'package:admin_curator/Core/Services/auth_service.dart';
import 'package:admin_curator/Core/Services/curatorBill_service.dart';
import 'package:admin_curator/Core/Services/profile_service.dart';
import 'package:admin_curator/Core/Services/task_service.dart';
import 'package:admin_curator/Core/States/auth_state.dart';
import 'package:admin_curator/Core/States/curator_profile_state.dart';
import 'package:admin_curator/Core/States/curator_task_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Core/Notifiers/patron_Notifier.dart';
import '../Core/Notifiers/user_task_notifier.dart';
import '../Core/States/patron_state.dart';
import '../Core/services/patron_service.dart';

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

final tasksServiceProvider = Provider<TasksService>((ref) {
  return TasksService();
});

final tasksNotifierProvider = StateNotifierProvider<TasksNotifier, TaskState>((
  ref,
) {
  final tasksService = ref.watch(tasksServiceProvider);
  return TasksNotifier(tasksService);
});


final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});

final selectedChipProvider = StateProvider<String>((ref) => 'All');
final selectedChoicCuratorChipProvider = StateProvider<String>(
  (ref) => 'Active',
);
// final selectedCuratorChipProvider = StateProvider<bool>((ref) => true);

final taskHoursProvider = StateProvider<double>((ref) => 0); // Default 2 hours
final taskPriceProvider = StateProvider<double>((ref) => 0.0); // Default ₹500

final patronProvider = StateNotifierProvider<PatronNotifier, PatronState>(
  (ref) => PatronNotifier(PatronService()),
);
final selectedCuratorProvider = StateProvider<String?>((ref) => null);

final curatorBillProvider =
    StateNotifierProvider<CuratorBillNotifier, TaskState>(
      (ref) => CuratorBillNotifier(CuratorBillService()),
    );
