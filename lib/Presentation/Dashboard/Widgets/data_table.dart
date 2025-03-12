import 'package:admin_curator/Constants/app_colors.dart';
import 'package:admin_curator/Models/model_tasks.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../Models/task_model.dart';

class TaskDataSource extends DataTableSource {
  final List<TaskModel> tasks;
  final BuildContext context;

  TaskDataSource(this.tasks, this.context);

  @override
  DataRow getRow(int index) {
    final task = tasks[index];

    return DataRow(
      cells: [
        // 🔹 Title
        DataCell(Text(task.taskSubject)),

        // 🔹 Status
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(task.curatorTaskStatus).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              task.curatorTaskStatus,
              style: TextStyle(
                color: _getStatusColor(task.curatorTaskStatus),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        // 🔹 Assigned To
        DataCell(Text(task.assignedLMName)),

        // 🔹 Due Date
        DataCell(
          Text(DateFormat('dd/MM/yy').format(task.taskStartTime.toDate())),
        ),
        DataCell(
          Text(DateFormat('dd/MM/yy').format(task.taskDueDate.toDate())),
        ),
        // 🔹 Actions (Approve/Reject)
        DataCell(
          Row(
            children: [
              // IconButton(
              //   icon: const Icon(Icons.check_circle, color: Colors.green),
              //   onPressed: () {
              //     _updateTaskStatus(task, "Approved");
              //     context.go('/tasks_details/${task.taskRef}');
              //   },
              // ),
              // IconButton(
              //   icon: const Icon(Icons.cancel, color: Colors.red),
              //   onPressed: () => _updateTaskStatus(task, "Rejected"),
              // ),
              task.taskPriceByAdmin == 0
                  ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      context.go('/tasks_details/${task.taskRef}');
                    },
                    child: Text('Assign Price'),
                  )
                  : Text('₹ ${task.taskPriceByAdmin.toString()}'),
            ],
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => tasks.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;

  // 🔥 Helper method to get color for status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // ✅ Function to update task status (Firestore update logic needed)
  void _updateTaskStatus(TaskModel task, String newStatus) {
    print(
      "Updating ${task.taskID} to $newStatus",
    ); // Implement Firestore update here
  }
}
