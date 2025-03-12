import 'package:admin_curator/Core/States/curator_profile_state.dart';
import 'package:admin_curator/Core/States/curator_task_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Models/model_tasks.dart';
import '../Services/task_service.dart';

class CuratorTaskNotifier extends StateNotifier<TaskState> {
  final TasksService _TaskService;

  CuratorTaskNotifier(this._TaskService)
    : super(TaskState(isLoading: true, listOfTasks: [])) {
    fetchTasks();
  }

  void fetchTasks() async {
    _TaskService.getTasksWithCuratorsStream().listen((tasks) {
      state = state.copyWith(isLoading: false, tasks: tasks);
    });
  }

  Future<bool> taskPriceAndTime({
    required double taskDurationByAdmin,
    required double taskPriceByAdmin,
    required String taskId,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      await _TaskService.taskPriceAndTime(
        taskDurationByAdmin: taskDurationByAdmin,
        taskPriceByAdmin: taskPriceByAdmin,
        taskId: taskId,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to Accept: $e',
      );
      return false;
    }
  }

  Future<void> getTaskById({required String id}) async {
    try {
      state = state.copyWith(isLoading: true);
      TaskModel? fetchedTask = await _TaskService.getTaskById(id: id);
      if (fetchedTask != null) {
        state = state.copyWith(isLoading: false, selectedTask: fetchedTask);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Task not found",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to Accept: $e',
      );
    }
  }
}
