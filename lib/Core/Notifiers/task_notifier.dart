import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Services/task_service.dart';
import '../States/curator_task_state.dart';

class TasksNotifier extends StateNotifier<TaskState> {
  final TasksService _tasksService;

  TasksNotifier(this._tasksService)
    : super(TaskState(isLoading: true, listOfTasks: [])) {
    fetchTasks();
  }

  void fetchTasks() async {
    _tasksService.getTasksWithCuratorsStream().listen((tasks) {
      state = state.copyWith(isLoading: false, tasks: tasks);
    });
  }
}
