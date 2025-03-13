import 'dart:convert';

import 'package:admin_curator/Constants/app_colors.dart';
import 'package:admin_curator/Models/model_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../Providers/providers.dart';

class TaskDataSource extends DataTableSource {
  final List<TaskModel> tasks;
  final BuildContext context;
  final WidgetRef ref;

  TaskDataSource(this.tasks, this.context, this.ref);

  @override
  DataRow getRow(int index) {
    //  print('NO Data for Patron : ${tasks[0].patronName}');
    final task = tasks[index];

    return DataRow(
      cells: [
        // 🔹 Title
        DataCell(
          Container(
            width: 150,
            child: Text(task.taskID, style: TextStyle(fontSize: 12)),
          ),
        ),

        // 🔹 Status
        DataCell(
          Container(
            width: 180,
            padding: EdgeInsets.symmetric(vertical: 4),
            // decoration: BoxDecoration(
            //   color: _getStatusColor(task.curatorTaskStatus).withOpacity(0.1),
            //   borderRadius: BorderRadius.circular(16),
            // ),
            child: Text(
              task.taskSubject,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ),

        // 🔹 Assigned To
        DataCell(Text(task.patronName, style: TextStyle(fontSize: 12))),

        // 🔹 Due Date
        DataCell(
          Container(
            width: 100,
            child: Text(task.assignedLMName, style: TextStyle(fontSize: 12)),
          ),
        ),
        DataCell(
          Container(
            width: 60,
            child: Text(
              style: TextStyle(fontSize: 12),
              DateFormat('dd/MM/yy').format(task.taskAssignDate.toDate()),
            ),
          ),
        ),
        // 🔹 Actions (Approve/Reject)
        DataCell(
          Container(
            width: 60,
            child: Text(
              style: TextStyle(fontSize: 12),
              DateFormat('dd/MM/yy').format(task.taskDueDate.toDate()),
            ),
          ),
        ),
        DataCell(
          Text(
            style: TextStyle(
              fontSize: 12,
              color: _getStatusColor(task.curatorTaskStatus),
            ),
            task.curatorTaskStatus,
          ),
        ),
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
                      //
                      // showModalBottomSheet(
                      //   context: context,
                      //   builder: (context) {
                      //     return AssignPriceBottomSheet(taskId: task.taskRef);
                      //   },
                      // );
                      showAssignPriceDialog(
                        context,
                        ref,
                        task.taskRef,
                        task.taskSubject,
                        task.taskDescription,
                        task.assignedTimeSlot ?? 'No Time Slot Available',
                        task.locationMode ?? 'Not Available',
                      );
                    },
                    child: Text('Assign Price'),
                  )
                  : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary.withOpacity(.8),
                      foregroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      //  context.go('/tasks_details/${task.taskRef}');

                      context.go('/crm_tasks', extra: task);
                    },
                    child: Text(
                      'View Detail',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
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
    String taskSubject,
    String taskDescription,
    String timeSlot,
    String taskMode,
  ) {
    final taskNotifier = ref.read(taskProvider.notifier);
    final currencyFormat = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
      locale: 'hi_IN',
    );

    double taskHours = ref.read(taskHoursProvider);
    double taskPrice = ref.read(taskPriceProvider);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              child: Container(
                color: Colors.white70,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Task Details',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Subject:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      taskSubject,
                      style: TextStyle(fontSize: 16, color: AppColors.primary),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      taskDescription,
                      style: TextStyle(fontSize: 16, color: AppColors.primary),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Time Slot:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      timeSlot,
                      style: TextStyle(fontSize: 16, color: AppColors.primary),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Time Mode:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      taskMode,
                      style: TextStyle(fontSize: 16, color: AppColors.primary),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Task Hours: ${taskHours.toStringAsFixed(1)} hours',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Slider(
                      value: taskHours,
                      min: 0.0,
                      max: 8.0,
                      divisions: 16,
                      activeColor: AppColors.primary,
                      inactiveColor: Colors.deepOrange.shade100,
                      label: '${taskHours.toStringAsFixed(1)} hours',
                      onChanged: (value) {
                        setState(() => taskHours = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Task Price: ${currencyFormat.format(taskPrice)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Slider(
                      value: taskPrice,
                      min: 0,
                      max: 4000,
                      divisions: 40,
                      activeColor: AppColors.primary,
                      inactiveColor: Colors.deepOrange.shade100,
                      label: currencyFormat.format(taskPrice),
                      onChanged: (value) {
                        setState(() => taskPrice = value);
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            ref.read(taskHoursProvider.notifier).state =
                                taskHours;
                            ref.read(taskPriceProvider.notifier).state =
                                taskPrice;
                            await taskNotifier
                                .taskPriceAndTime(
                                  taskDurationByAdmin: taskHours,
                                  taskPriceByAdmin: taskPrice,
                                  taskId: taskId,
                                )
                                .then((val) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Price & Time Updated!"),
                                    ),
                                  );
                                  Navigator.pop(context);
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
