import 'package:admin_curator/Providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../Constants/app_colors.dart';
import '../../Constants/app_styles.dart';

class PendingDashboard extends ConsumerStatefulWidget {
  const PendingDashboard({super.key});

  @override
  ConsumerState<PendingDashboard> createState() => _PendingDashboardState();
}

class _PendingDashboardState extends ConsumerState<PendingDashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      ref.read(taskProvider.notifier).getPaymentPendingTasks();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskProvider);
    return Scaffold(
      backgroundColor: AppColors.white,
      body:
          taskState.isLoading == true
              ? Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Payments Dashboard', style: AppStyles.heading),
                      ],
                    ),

                    Text(
                      'All Pending Payments of completed tasks are mentioned below',
                      style: AppStyles.subHeading,
                    ),
                    const SizedBox(height: 32),
                    // Table Header
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: Row(
                        children: [
                          _TableHeader('Task ID', flex: 2),
                          _TableHeader('Task Subject', flex: 3),
                          _TableHeader('Patron Name', flex: 2),
                          _TableHeader('LM Name', flex: 2),
                          _TableHeader('Assign Date', flex: 2),
                          _TableHeader('Due Date', flex: 2),
                          _TableHeader('Status', flex: 2),
                          _TableHeader('', flex: 2),
                        ],
                      ),
                    ),

                    // Table Rows (Sample Data)
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final task = taskState.listOfCompletedTasks[index];
                          return _TaskRow(
                            taskId: task.taskID,
                            subject: task.taskSubject,
                            patron: task.patronName,
                            lm: task.assignedLMName,
                            assignDate: DateFormat(
                              'dd/MM/yy',
                            ).format(task.taskAssignDate.toDate()),
                            dueDate: DateFormat(
                              'dd/MM/yy',
                            ).format(task.taskDueDate.toDate()),
                            status: task.curatorTaskStatus,
                            actionLabel: 'View Detail',
                            actionColor: AppColors.primary,
                            onPressed: () {
                              context.push('/crm_tasks', extra: task);
                            },
                          );
                        },
                        itemCount: taskState.listOfCompletedTasks.length,
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

// Table Header Widget
class _TableHeader extends StatelessWidget {
  final String label;
  final int flex;

  const _TableHeader(this.label, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: flex, child: Text(label, style: AppStyles.style18));
  }
}

// Task Row Widget
class _TaskRow extends StatelessWidget {
  final String taskId,
      subject,
      patron,
      lm,
      assignDate,
      dueDate,
      status,
      actionLabel;
  final Color actionColor;
  final VoidCallback onPressed;

  const _TaskRow({
    required this.taskId,
    required this.subject,
    required this.patron,
    required this.lm,
    required this.assignDate,
    required this.dueDate,
    required this.status,
    required this.actionLabel,
    required this.actionColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(taskId, style: AppStyles.text14)),
          SizedBox(width: 4),
          Expanded(flex: 3, child: Text(subject, style: AppStyles.text14)),
          Expanded(flex: 2, child: Text(patron, style: AppStyles.text14)),
          Expanded(flex: 2, child: Text(lm, style: AppStyles.text14)),
          Expanded(flex: 2, child: Text(assignDate, style: AppStyles.text14)),
          Expanded(flex: 2, child: Text(dueDate, style: AppStyles.text14)),
          Expanded(
            flex: 2,
            child: Text(
              status,
              style: AppStyles.text14.copyWith(
                color:
                    status == 'Completed'
                        ? Colors.green
                        : status == 'Pending'
                        ? Colors.orange
                        : AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: actionColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onPressed,
              child: Text(
                actionLabel,
                style: AppStyles.buttonText.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
