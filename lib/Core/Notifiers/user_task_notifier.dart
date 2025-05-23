import 'package:admin_curator/Core/States/curator_task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Models/comment.dart';
import '../Services/task_service.dart';

class CuratorTaskNotifier extends StateNotifier<TaskState> {
  final TasksService _TaskService;

  CuratorTaskNotifier(this._TaskService)
    : super(TaskState(isLoading: true, listOfTasks: [])) {
    fetchTasks();
  }

  void getPaymentPendingTasks() async {
    _TaskService.getPaymentPendingTasks().listen((tasks) {
      state = state.copyWith(isLoading: false, listOfCompletedTasks: tasks);
    });
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
    required String reason,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      await _TaskService.updateVisiblity(
        isTaskDisabled: isTaskDisabled,
        taskId: taskId,
        reasonOfRejection: reason,
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

  Future<void> notifyAllCurators({
    required String title,
    required String body,
    required String action,
    Map<String, dynamic>? additionalData,
  }) async {
    state = state.copyWith(action: 'notificationUpdate', loading: true);
    await _TaskService.notifyAllCurators(
      title: title,
      body: body,
      action: action,
    );
    state = state.copyWith(action: 'notificationUpdate', loading: false);
  }

  Future<void> notifyUser({
    required String userId,
    required String title,
    required String body,
    required String action,
    Map<String, dynamic>? additionalData,
  }) async {
    state = state.copyWith(action: 'notificationUserUpdate', loading: true);
    await _TaskService.notifyUser(
      userId: userId,
      title: title,
      body: body,
      action: action,
    );
    state = state.copyWith(action: 'notificationUserUpdate', loading: false);
  }

  Future<bool> updateTaskBillStatus({
    required bool isTaskBillCreated,
    required String taskId,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      final taskModel = await _TaskService.updateTaskBillStatus(
        isTaskBillCreated: isTaskBillCreated,
        taskId: taskId,
      );
      state = state.copyWith(isLoading: false, selectedTask: taskModel);

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
      final taskModel = await _TaskService.updateCurator(
        curatorID: curatorID,
        taskId: taskId,
      );
      state = state.copyWith(isLoading: false, selectedTask: taskModel);

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to Accept: $e',
      );
      return false;
    }
  }

  void updateSelectedTaskPaymentStatus(bool status) {
    if (state.selectedTask != null) {
      state.selectedTask?.paymentDueCleared = true;
    }
  }

  Future<bool> updateTaskLifecycle({required DocumentReference taskRef}) async {
    try {
      state = state.copyWith(action: 'cycleUpdate', loading: true);
      final taskModel = await _TaskService.updateTaskLifecycle(
        taskRef: taskRef,
      );
      state = state.copyWith(
        action: 'cycleUpdate',
        loading: false,
        selectedTask: taskModel,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        action: 'cycleUpdate',
        loading: false,
        errorMessage: 'Failed to Accept: $e',
      );
      return false;
    }
  }

  Future<bool> removeCurator({required String taskId}) async {
    try {
      state = state.copyWith(isLoading: true);
      final taskModel = await _TaskService.removeCurator(taskId: taskId);
      state = state.copyWith(isLoading: false, selectedTask: taskModel);

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
      print('comment is addding');
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

  Future<bool> taskAdminReferenceUpdate({
    required String taskId,
    required List<String> files,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      await _TaskService.taskAdminReferenceUpdate(taskId: taskId, files: files);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save profile: $e',
      );
      return false;
    }
  }
}
