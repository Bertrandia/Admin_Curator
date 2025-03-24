import 'package:admin_curator/Core/States/curator_profile_state.dart';
import 'package:admin_curator/Core/States/curator_task_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Models/comment.dart';
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

  void listenToComments(String taskId) {
    _TaskService.getCommentsStream(taskId).listen((comments) {
      state = state.copyWith(comments: comments);
    });
  }

  Future<bool> updateTaskVisiblity({
    required bool isTaskDisabled,
    required String taskId,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      await _TaskService.updateVisiblity(
        isTaskDisabled: isTaskDisabled,
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

  Future<bool> updateCurator({
    required String curatorID,
    required String taskId,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      await _TaskService.updateCurator(curatorID: curatorID, taskId: taskId);
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

  Future<bool> addCommentToTask({
    required String taskId,
    required Comment comment,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      await _TaskService.addCommentToTask(comment: comment, taskId: taskId);
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

  Future<bool> taskPriceAndTime({
    required double taskDurationByAdmin,
    required double taskPriceByAdmin,
    required String taskId,
    required isAdminApproved,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      await _TaskService.taskPriceAndTime(
        taskDurationByAdmin: taskDurationByAdmin,
        taskPriceByAdmin: taskPriceByAdmin,
        taskId: taskId,
        isAdminApproved: isAdminApproved,
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
      _TaskService.getTaskById(id: id)?.listen((task) {
        state = state.copyWith(selectedTask: task, isLoading: false);
      });
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to Accept: $e',
      );
    }
  }
}
