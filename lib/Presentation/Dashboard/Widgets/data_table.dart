import 'package:admin_curator/Constants/app_colors.dart';
import 'package:admin_curator/Models/model_tasks.dart';
import 'package:admin_curator/Presentation/Dashboard/components/assignPricePopUp..dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../Models/task_model.dart';
import '../../../Providers/providers.dart';

class TaskDataSource extends DataTableSource {
  final List<TaskModel> tasks;
  final BuildContext context;
  final WidgetRef ref;

  TaskDataSource(this.tasks, this.context, this.ref);

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
                      print(task.taskRef);
                      // context.go('/tasks_details/${task.taskRef}');
                      // showModalBottomSheet(
                      //   context: context,
                      //   builder: (context) {
                      //     return AssignPriceBottomSheet(taskId: task.taskRef);
                      //   },
                      // );
                      showAssignPriceDialog(context, ref, task.taskRef);
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

  void showAssignPriceDialog(
    BuildContext context,
    WidgetRef ref,
    String taskId,
  ) {
    final taskNotifier = ref.read(taskProvider.notifier);
    final currencyFormat = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
      locale: 'hi_IN',
    );

    // ✅ Read initial values
    double taskHours = ref.read(taskHoursProvider);
    double taskPrice = ref.read(taskPriceProvider);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                "Assign Task Price & Time",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange.shade800,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔹 Task Completion Time Slider
                  Text(
                    'Task Hours: ${taskHours.toStringAsFixed(1)} hours',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Slider(
                    value: taskHours,
                    min: 0.5,
                    max: 8.0,
                    divisions: 15,
                    activeColor: Colors.deepOrange,
                    inactiveColor: Colors.deepOrange.shade100,
                    label: '${taskHours.toStringAsFixed(1)} hours',
                    onChanged: (value) {
                      setState(() => taskHours = value);
                    },
                  ),

                  SizedBox(height: 16),

                  // 🔹 Task Price Slider
                  Text(
                    'Task Price: ${currencyFormat.format(taskPrice)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Slider(
                    value: taskPrice,
                    min: 100.0,
                    max: 4000,
                    divisions: 39,
                    activeColor: Colors.deepOrange,
                    inactiveColor: Colors.deepOrange.shade100,
                    label: currencyFormat.format(taskPrice),
                    onChanged: (value) {
                      setState(() => taskPrice = value);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // ✅ Update Riverpod providers before saving
                    ref.read(taskHoursProvider.notifier).state = taskHours;
                    ref.read(taskPriceProvider.notifier).state = taskPrice;

                    await taskNotifier
                        .taskPriceAndTime(
                          taskDurationByAdmin: taskHours,
                          taskPriceByAdmin: taskPrice,
                          taskId: taskId,
                        )
                        .then((val) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Price & Time Updated!")),
                          );
                          Navigator.pop(context);
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ✅ Function to update task status (Firestore update logic needed)
  void _updateTaskStatus(TaskModel task, String newStatus) {
    print(
      "Updating ${task.taskID} to $newStatus",
    ); // Implement Firestore update here
  }
}
