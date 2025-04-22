// import 'package:go_router/go_router.dart';
//
// import '../../Models/model_tasks.dart';
//
// class TaskModelCodec extends GoRouterStateCodec<TaskModel> {
//   @override
//   TaskModel decode(Object? extra) {
//     if (extra is Map<String, dynamic>) {
//       return TaskModel.fromJson(extra);
//     }
//     throw Exception('Invalid extra passed for TaskModel');
//   }
//
//   @override
//   Object? encode(TaskModel task) {
//     return task.toJson(); // assuming TaskModel has toJson()
//   }
// }
