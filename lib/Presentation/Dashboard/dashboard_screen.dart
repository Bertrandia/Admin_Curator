import 'package:admin_curator/Constants/app_colors.dart';
import 'package:admin_curator/Models/task_model.dart';
import 'package:admin_curator/Presentation/Dashboard/Widgets/data_table.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedChip = 'Pending';
  List<Task> _taskList = [];

  @override
  void initState() {
    super.initState();
    _filterTasks();
  }

  void _filterTasks() {
    setState(() {
      _taskList =
          taskList.where((task) => task.status == selectedChip).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          const Text(
            'Task Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFBF4D28),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Monitor and manage all your organization tasks',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 24),

          // Stats Cards Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatsCard(
                  title: 'Pending Tasks',
                  count:
                      taskList.where((task) => task.status == 'Pending').length,
                  icon: Icons.pending_actions,
                  color: const Color(0xFFBF4D28),
                ),
                const SizedBox(width: 16),
                _buildStatsCard(
                  title: 'Completed Tasks',
                  count:
                      taskList
                          .where((task) => task.status == 'Completed')
                          .length,
                  icon: Icons.task_alt,
                  color: const Color(0xFF4CAF50),
                ),
                const SizedBox(width: 16),
                _buildStatsCard(
                  title: 'Verification Pending',
                  count:
                      taskList.where((task) => task.status == 'On Hold').length,
                  icon: Icons.verified_user,
                  color: const Color(0xFFF2A65A),
                ),
                const SizedBox(width: 16),
                _buildStatsCard(
                  title: 'Total Tasks',
                  count: taskList.length,
                  icon: Icons.list_alt,
                  color: const Color(0xFF673AB7),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Task Management',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFBF4D28),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search tasks by title, assignee...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),

          const SizedBox(height: 16),

          // Task Filter Chips
          Wrap(
            spacing: 8,
            children:
                ['Pending', 'On Hold', 'Completed'].map((filter) {
                  return FilterChip(
                    label: Text(filter),
                    selected: selectedChip == filter,
                    selectedColor: const Color(0xFFF2A65A).withOpacity(0.3),
                    checkmarkColor: const Color(0xFFBF4D28),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color:
                          selectedChip == filter
                              ? const Color(0xFFBF4D28)
                              : Colors.black87,
                    ),
                    onSelected: (bool isSelected) {
                      if (isSelected) {
                        setState(() {
                          selectedChip = filter;
                          _filterTasks();
                        });
                      }
                    },
                  );
                }).toList(),
          ),

          const SizedBox(height: 16),

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
                    rowsPerPage: 5,
                    showCheckboxColumn: false,
                    header: null, // No header, we have our own section title
                    columns: _createColumns(),
                    source: TaskDataSource(_taskList, context),
                    dataRowMinHeight: 64,
                    dataRowMaxHeight: 64,
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
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
        label: Container(
          width: 120,
          child: Text(
            'Title',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFBF4D28),
            ),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          width: 180,
          child: Text(
            'Description',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFBF4D28),
            ),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          width: 90,
          child: Text(
            'Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFBF4D28),
            ),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          width: 100,
          child: Text(
            'Due Date',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFBF4D28),
            ),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          width: 130,
          child: Text(
            'Assigned To',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFBF4D28),
            ),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          width: 80,
          child: Text(
            'Actions',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFBF4D28),
            ),
          ),
        ),
      ),
    ];
  }
}
