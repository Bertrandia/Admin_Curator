import 'package:admin_curator/Models/comment.dart';
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

  Future<bool> addCommentToTask({
    required String taskId,
    required Comment comment,
  }) async {
    try {
      state = state.copyWith(
        isLoading: true,
      );
      await _tasksService.addCommentToTask(
        comment: comment,
        taskId: taskId,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: 'Failed to Accept: $e');
      return false;
    }
  }
}
