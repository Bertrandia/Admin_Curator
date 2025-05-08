import 'package:admin_curator/Constants/app_colors.dart';
import 'package:admin_curator/Presentation/Dashboard/Widgets/custom_SearchableDD.dart';
import 'package:admin_curator/Presentation/Dashboard/Widgets/data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Constants/app_styles.dart';
import '../../Providers/providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskList = ref.watch(taskProvider);
    final selectedCurator = ref.watch(selectedCuratorProvider);
    final tasksNotifier = ref.watch(tasksNotifierProvider.notifier);
    final int pendingTasks =
        taskList.listOfTasks
            .where((task) => task.curatorTaskStatus == 'Pending')
            .length;
    final int completedTasks =
        taskList.listOfTasks
            .where((task) => task.curatorTaskStatus == 'Completed')
            .length;

    final int totalTasks = taskList.listOfTasks.length;
    final selectedChip = ref.watch(selectedChipProvider);
    final filteredTasks =
        taskList.listOfTasks.where((task) {
          final matchesStatus =
              selectedChip == "All" || task.curatorTaskStatus == selectedChip;
          final matchesCurator =
              selectedCurator == null ||
              task.taskAssignedToCurator == selectedCurator;
          return matchesStatus && matchesCurator;
        }).toList();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Task Dashboard',
                style: AppStyles.style20.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 23,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await tasksNotifier.downloadTasksCSV();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('CSV download started')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                ),
                child: Text(
                  'Tasks CSV',
                  style: AppStyles.style20.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Stats Cards Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatsCard(
                  title: 'Pending Tasks',
                  count: pendingTasks,
                  icon: Icons.pending_actions,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 16),
                _buildStatsCard(
                  title: 'Completed Tasks',
                  count: completedTasks,
                  icon: Icons.task_alt,
                  color: AppColors.primary,
                ),

                const SizedBox(width: 16),
                _buildStatsCard(
                  title: 'Verification Pending',
                  count:
                      taskList.listOfTasks
                          .where(
                            (task) =>
                                task.curatorTaskStatus == 'Under Verification',
                          )
                          .length,
                  icon: Icons.verified_user,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 16),
                _buildStatsCard(
                  title: 'Total Tasks',
                  count: totalTasks,
                  icon: Icons.list_alt,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // Task Filter Chips
          Wrap(
            spacing: 8,
            children:
                [
                  'All',
                  'Not Assigned',
                  'Pending',
                  'In Progress',
                  'Payment Due',
                  'Completed',
                  'Rejected',
                  'Under Verification',
                ].map((filter) {
                  return FilterChip(
                    label: Text(filter),
                    selected: selectedChip == filter,
                    selectedColor: const Color(0xFFF2A65A).withOpacity(0.3),
                    checkmarkColor: const Color(0xFFBF4D28),
                    backgroundColor: Colors.white,
                    labelStyle: AppStyles.style20.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 12,
                    ),
                    onSelected: (bool isSelected) {
                      if (isSelected) {
                        ref.read(selectedChipProvider.notifier).state = filter;
                      }
                    },
                  );
                }).toList(),
          ),

          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 250,

              // child: DropdownButton(
              //   dropdownColor: AppColors.white,

              //   borderRadius: BorderRadius.circular(20),
              //   isExpanded: false,
              //   value: selectedCurator,
              //   hint: Text('Select Curator'),
              //   items:
              //       profileState.profile.map((value) {
              //         return DropdownMenuItem(
              //           child: Text(value.fullName),
              //           value: value.id,
              //         );
              //       }).toList(),
              //   onChanged: (value) {
              //     ref.read(selectedCuratorProvider.notifier).state = value;
              //   },
              // ),
              child: SearchableDropdown(),

              // child: DropdownButton(
              //   dropdownColor: AppColors.white,
              //
              //   borderRadius: BorderRadius.circular(20),
              //   isExpanded: false,
              //   value: selectedCurator,
              //   hint: Text('Select Curator'),
              //   items:
              //       profileState.profile.map((value) {
              //         return DropdownMenuItem(
              //           child: Text(value.fullName),
              //           value: value.id,
              //         );
              //       }).toList(),
              //   onChanged: (value) {
              //     ref.read(selectedCuratorProvider.notifier).state = value;
              //   },
              // ),
            ),
          ),
          SizedBox(height: 20),

          // Task DataTable Card with styled container
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Theme(
                // Apply custom theme to DataTable
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.grey.withOpacity(0.1),
                  cardColor: Colors.white,
                  dataTableTheme: const DataTableThemeData(
                    headingTextStyle: TextStyle(
                      color: const Color(0xFFBF4D28),
                      fontWeight: FontWeight.bold,
                    ),
                    dataTextStyle: TextStyle(color: Colors.black87),
                  ),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: PaginatedDataTable(
                    headingRowColor: WidgetStateProperty.all(
                      const Color(0xFFFFE0CC),
                    ),
                    columnSpacing: 16,
                    horizontalMargin: 16,
                    rowsPerPage: 10,
                    showCheckboxColumn: false,
                    header: null, // No header, we have our own section title
                    columns: _createColumns(),
                    source: TaskDataSource(filteredTasks, context, ref),
                    dataRowMaxHeight: 51,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 30, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.style20.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  count.toString(),
                  style: AppStyles.style20.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(
        label: Text(
          'Task ID',
          style: AppStyles.style20.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontSize: 14,
          ),
        ),
      ),
      DataColumn(
        label: Container(
          width: 90,
          child: Text(
            'Task Subject',
            style: AppStyles.style20.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Patron Name',
          style: AppStyles.style20.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontSize: 14,
          ),
        ),
      ),
      DataColumn(
        label: Container(
          width: 80,
          child: Text(
            'LM Name',
            style: AppStyles.style20.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          width: 80,
          child: Text(
            'Assign Date',
            style: AppStyles.style20.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          width: 80,
          child: Text(
            'Due Date',
            style: AppStyles.style20.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          width: 80,
          child: Text(
            'Status',
            style: AppStyles.style20.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          width: 80,
          child: Text(
            'View Detail',
            style: AppStyles.style20.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
        ),
      ),
    ];
  }
}

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
//       DataColumn(label: Text('Description')),
//       DataColumn(label: Text('Status')),
//       DataColumn(label: Text('Due Date')),
//       DataColumn(label: Text('Assigned To')),
//       DataColumn(label: Text('Assigned To')),
//     ];
//   }
// }
