import 'package:admin_curator/Constants/app_colors.dart';
import 'package:admin_curator/Models/model_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../Constants/app_styles.dart';
import '../../Widgets/asssign_pric_component.dart';

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
            child: Text(
              task.taskID,
              style: AppStyles.style20.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 12,
              ),
            ),
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
              style: AppStyles.style20.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 11,
              ),
            ),
          ),
        ),

        // 🔹 Assigned To
        DataCell(
          Text(
            task.patronName,
            style: AppStyles.style20.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 12,
            ),
          ),
        ),

        // 🔹 Due Date
        DataCell(
          Container(
            width: 100,
            child: Text(
              task.assignedLMName,
              style: AppStyles.style20.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            width: 60,
            child: Text(
              style: AppStyles.style20.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 12,
              ),
              DateFormat('dd/MM/yy').format(task.taskAssignDate.toDate()),
            ),
          ),
        ),
        // 🔹 Actions (Approve/Reject)
        DataCell(
          Container(
            width: 60,
            child: Text(
              style: AppStyles.style20.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 12,
              ),
              DateFormat('dd/MM/yy').format(task.taskDueDate.toDate()),
            ),
          ),
        ),
        DataCell(
          Text(
            style: AppStyles.style20.copyWith(
              fontWeight: FontWeight.bold,
              color: _getStatusColor(task.curatorTaskStatus),
              fontSize: 12,
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
                  ? Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
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
                            task.taskPriceByAdmin,
                            task.taskDurationByAdmin,
                          );
                        },
                        child: Text(
                          'Assign Price',
                          style: AppStyles.style20.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert),
                        itemBuilder:
                            (BuildContext context) => [
                              PopupMenuItem(
                                value: "View",
                                child: Text("View"),
                                onTap: () {
                                  context.go('/crm_tasks', extra: task);
                                  // context.go(
                                  //   '/crm_tasks_github/${task.taskRef}',
                                  // );
                                },
                              ),
                              PopupMenuItem(
                                value: "Delete",
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                      ),
                    ],
                  )
                  : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      //  context.go('/tasks_details/${task.taskRef}');

                      context.go('/crm_tasks', extra: task);
                    },
                    child: Text(
                      'View Detail',
                      style: AppStyles.style20.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        fontSize: 18,
                      ),
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
    double taskPrice,
    double taskHours,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AssignPriceDialog(
            taskPrice: taskPrice,
            taskId: taskId,
            taskSubject: taskSubject,
            taskDescription: taskDescription,
            timeSlot: timeSlot,
            taskMode: taskMode,
            taskHours: taskHours,
          ),
    );
  }

  // ✅ Function to update task status (Firestore update logic needed)
  void _updateTaskStatus(TaskModel task, String newStatus) {
    print(
      "Updating ${task.taskID} to $newStatus",
    ); // Implement Firestore update here
  }
}
