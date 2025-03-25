import 'package:admin_curator/Models/curatorBill_model.dart';
import 'package:admin_curator/Models/profile.dart';

import '../../Models/comment.dart';
import '../../Models/model_tasks.dart';

class TaskState {
  final List<TaskModel> listOfTasks;
  final TaskModel? selectedTask;
  final bool isLoading;
  final String errorMessage;
  final List<Comment> comments;

  final List<CuratorBill> curatorBills;


  TaskState({
    this.selectedTask,
    required this.listOfTasks,
    this.isLoading = false,
    this.errorMessage = '',
    this.comments = const [],

    this.curatorBills = const [],

  });

  TaskState copyWith({
    List<TaskModel>? tasks,
    bool? isLoading,
    String? errorMessage,
    TaskModel? selectedTask,
    List<Comment>? comments,

    List<CuratorBill>? curatorBills,

  }) {
    return TaskState(
      listOfTasks: tasks ?? this.listOfTasks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedTask: selectedTask ?? this.selectedTask,
      comments: comments ?? this.comments,

      curatorBills: curatorBills ?? this.curatorBills,

    );
  }
}
