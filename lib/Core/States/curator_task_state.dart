import 'package:admin_curator/Models/curatorBill_model.dart';
import '../../Models/comment.dart';
import '../../Models/model_tasks.dart';

class TaskState {
  final List<TaskModel> listOfTasks;
  final TaskModel? selectedTask;
  final bool isLoading;
  final String errorMessage;
  final List<Comment> comments;
  final CuratorBill? bill;
  final CuratorBill? additionalBill;
  final CuratorBill? taskBill;
  final bool? isTaskBillCreated;
  final List<CuratorBill> curatorBills;
  final Map<String, bool> actionLoaders;
  final List<TaskModel> listOfCompletedTasks;
  TaskState({
    this.selectedTask,
    required this.listOfTasks,
    this.isLoading = false,
    this.errorMessage = '',
    this.comments = const [],
    this.taskBill,
    this.curatorBills = const [],
    this.additionalBill,
    this.bill,
    this.isTaskBillCreated = false,
    this.actionLoaders = const {},
    this.listOfCompletedTasks = const [],
  });

  TaskState copyWith({
    List<TaskModel>? tasks,
    bool? isLoading,
    String? errorMessage,
    TaskModel? selectedTask,
    List<Comment>? comments,
    CuratorBill? bill,
    List<CuratorBill>? curatorBills,
    CuratorBill? additionalBill,
    CuratorBill? taskBill,
    bool? isTaskBillCreated,
    String? action,
    bool? loading,
    List<TaskModel>? listOfCompletedTasks,
  }) {
    Map<String, bool> newMap = Map<String, bool>.from(actionLoaders);
    if (action != null && loading != null) {
      newMap[action] = loading;
    }
    return TaskState(
      listOfTasks: tasks ?? this.listOfTasks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedTask: selectedTask ?? this.selectedTask,
      comments: comments ?? this.comments,
      bill: bill ?? this.bill,
      additionalBill: additionalBill ?? this.additionalBill,
      curatorBills: curatorBills ?? this.curatorBills,
      taskBill: taskBill ?? this.taskBill,
      isTaskBillCreated: isTaskBillCreated ?? this.isTaskBillCreated,
      actionLoaders: {},
      listOfCompletedTasks: listOfCompletedTasks ?? this.listOfCompletedTasks,
    );
  }
}
