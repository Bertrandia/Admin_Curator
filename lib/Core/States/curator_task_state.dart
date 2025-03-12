import 'package:admin_curator/Models/profile.dart';

import '../../Models/model_tasks.dart';

class TaskState {
  final List<TaskModel> listOfTasks;
  final TaskModel? selectedTask;
  final bool isLoading;
  final String errorMessage;

  TaskState({
    this.selectedTask,
    required this.listOfTasks,
    this.isLoading = false,
    this.errorMessage = '',
  });

  TaskState copyWith({
    List<TaskModel>? tasks,
    bool? isLoading,
    String? errorMessage,
    TaskModel? selectedTask,
  }) {
    return TaskState(
      listOfTasks: tasks ?? this.listOfTasks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedTask: selectedTask ?? this.selectedTask,
    );
  }
}
