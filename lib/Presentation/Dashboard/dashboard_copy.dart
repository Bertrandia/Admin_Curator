// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../Core/Notifiers/task_notifier.dart';
// import '../../Models/task_model.dart';
// import 'Widgets/data_table.dart';
//
// class DashboardScreenLayout extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final tasks = ref.watch(taskProvider);
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Task Dashboard',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFFBF4D28),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Monitor and manage all your organization tasks',
//               style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//             ),
//             const SizedBox(height: 24),
//
//             // 🔄 Refresh Button
//             ElevatedButton(
//               onPressed: () => ref.read(taskProvider.notifier).refreshTasks(),
//               child: Text("Refresh Tasks"),
//             ),
//
//             const SizedBox(height: 16),
//
//             // 🔥 Task Table
//             Expanded(
//               child:
//                   tasks.isEmpty
//                       ? Center(child: Text("No tasks available"))
//                       : TaskDataTable(tasks: tasks),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class TaskDataTable extends StatelessWidget {
//   final List<Task> tasks;
//
//   const TaskDataTable({required this.tasks, Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return PaginatedDataTable(
//       columns: _createColumns(),
//       source: TaskDataSource(tasks, context),
//       rowsPerPage: 5,
//     );
//   }
//
//   List<DataColumn> _createColumns() {
//     return [
//       DataColumn(label: Text('Title')),
//       DataColumn(label: Text('Status')),
//       DataColumn(label: Text('Assigned To')),
//       DataColumn(label: Text('Due Date')),
//     ];
//   }
// }
//
// class TaskDataSource extends DataTableSource {
//   final List<Task> tasks;
//   final BuildContext context;
//
//   TaskDataSource(this.tasks, this.context);
//
//   @override
//   DataRow getRow(int index) {
//     final task = tasks[index];
//
//     return DataRow(
//       cells: [
//         DataCell(Text(task.title)),
//         DataCell(Text(task.status)),
//         DataCell(Text(task.assignedTo)),
//         DataCell(Text(task.dueDate.toIso8601String())),
//       ],
//     );
//   }
//
//   @override
//   int get rowCount => tasks.length;
//   @override
//   bool get isRowCountApproximate => false;
//   @override
//   int get selectedRowCount => 0;
// }
