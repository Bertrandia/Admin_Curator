import 'package:admin_curator/Models/task_model.dart';
import 'package:flutter/material.dart';

class TaskDataSource extends DataTableSource {
  final List<Task> _tasks;
  final BuildContext context;

  TaskDataSource(this._tasks, this.context);

  @override
  DataRow getRow(int index) {
    final task = _tasks[index];

    // Status color mapping
    final statusColors = {
      'Pending': const Color(0xFFBF4D28),
      'On Hold': const Color(0xFFF2A65A),
      'Completed': const Color(0xFF4CAF50),
    };

    final bool isOverdue = task.dueDate.isBefore(DateTime.now()) && task.status != 'Completed';

    return DataRow(
      cells: [
        // Title
        DataCell(
          Container(
            width: 120,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              task.title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),

        // Description
        DataCell(
          Container(
            width: 180,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              task.description,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ),
        ),

        // Status Chip
        DataCell(
          Container(
            width: 90,
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColors[task.status]?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                task.status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: statusColors[task.status] ?? Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),

        // Due Date
        DataCell(
          Container(
            width: 100,
            alignment: Alignment.center,
            child: Text(
             "DateFormat('dd/MM/yyyy').format(task.dueDate)",
              style: TextStyle(
                color: isOverdue ? Colors.red : Colors.black87,
              ),
            ),
          ),
        ),

        // Assigned To
        DataCell(
          Container(
            width: 130,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: const Color(0xFFF2A65A).withOpacity(0.3),
                  child: Text(
                    task.assignedTo.isNotEmpty ? task.assignedTo[0] : '?',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFBF4D28),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    task.assignedTo,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Actions
        DataCell(
          Container(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: Color(0xFFBF4D28)),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Edit',
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.grey),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        ),
      ],
      onSelectChanged: (selected) {
        if (selected != null && selected) {
          // Handle row selection - can navigate to detail page
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selected task: ${task.title}')),
          );
        }
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _tasks.length;

  @override
  int get selectedRowCount => 0;
}