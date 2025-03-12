import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  String description;
  String status; // e.g., "Pending", "Completed", "On Hold"
  DateTime dueDate;
  String assignedTo;
  String priority; // 1 = High, 2 = Medium, 3 = Low
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.dueDate,
    required this.assignedTo,
    required this.priority,
    required this.createdAt,
  });

  // Convert Task object to JSON (for Firestore or API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'dueDate': dueDate.toIso8601String(),
      'assignedTo': assignedTo,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Convert JSON to Task object (for fetching from Firestore or API)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['taskID'] ?? '',
      title: json['taskSubject'] ?? 'Subject',
      description: json['taskDescription'] ?? 'Descirption',
      status: json['curatorTaskStatus'] ?? 'status',
      dueDate:
          json['taskDueDate'] is Timestamp
              ? (json['taskDueDate'] as Timestamp).toDate()
              : DateTime.now(),
      assignedTo: json['taskAssignedToCurator'] ?? 'defefef',
      priority: json['priority'] ?? 'Low',
      createdAt:
          json['createdAt'] is Timestamp
              ? (json['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
    );
  }
}

List<Task> taskList = [
  Task(
    id: 'task_001',
    title: 'Design Login Page',
    description: 'Create the UI for the login screen using Flutter.',
    status: 'Pending',
    dueDate: DateTime.now().add(Duration(days: 3)), // 3 days from now
    assignedTo: 'Alice Johnson',
    priority: 'Medium', // High Priority
    createdAt: DateTime.now(),
  ),
  Task(
    id: 'task_002',
    title: 'Integrate Firestore',
    description: 'Setup Firestore and create a database structure for tasks.',
    status: 'Completed',
    dueDate: DateTime.now().subtract(Duration(days: 1)), // 1 day ago
    assignedTo: 'Bob Smith',
    priority: 'Medium', // Medium Priority
    createdAt: DateTime.now().subtract(Duration(days: 7)),
  ),
  Task(
    id: 'task_003',
    title: 'Implement ChoiceChips',
    description: 'Add filter options for tasks using ChoiceChips in Flutter.',
    status: 'On Hold',
    dueDate: DateTime.now().add(Duration(days: 5)), // 5 days from now
    assignedTo: 'Charlie Adams',
    priority: 'Medium', // Low Priority
    createdAt: DateTime.now().subtract(Duration(days: 2)),
  ),
  Task(
    id: 'task_004',
    title: 'Fix Login Bug',
    description: 'Resolve authentication issue causing login failures.',
    status: 'Pending',
    dueDate: DateTime.now().add(Duration(days: 2)), // 2 days from now
    assignedTo: 'David Williams',
    priority: 'Medium', // High Priority
    createdAt: DateTime.now().subtract(Duration(days: 3)),
  ),
  // Task(
  //   id: 'task_005',
  //   title: 'Add Graphs to Dashboard',
  //   description: 'Implement pie charts and bar graphs using fl_chart.',
  //   status: 'Completed',
  //   dueDate: DateTime.now().subtract(Duration(days: 4)), // 4 days ago
  //   assignedTo: 'Eve Carter',
  //   priority: 2, // Medium Priority
  //   createdAt: DateTime.now().subtract(Duration(days: 10)),
  // ),
  // Task(
  //   id: 'task_005',
  //   title: 'Add Graphs to Dashboard',
  //   description: 'Implement pie charts and bar graphs using fl_chart.',
  //   status: 'Completed',
  //   dueDate: DateTime.now().subtract(Duration(days: 4)), // 4 days ago
  //   assignedTo: 'Eve Carter',
  //   priority: 2, // Medium Priority
  //   createdAt: DateTime.now().subtract(Duration(days: 10)),
  // ),
  // Task(
  //   id: 'task_005',
  //   title: 'Add Graphs to Dashboard',
  //   description: 'Implement pie charts and bar graphs using fl_chart.',
  //   status: 'Completed',
  //   dueDate: DateTime.now().subtract(Duration(days: 4)), // 4 days ago
  //   assignedTo: 'Eve Carter',
  //   priority: 2, // Medium Priority
  //   createdAt: DateTime.now().subtract(Duration(days: 10)),
  // ),
  // Task(
  //   id: 'task_005',
  //   title: 'Add Graphs to Dashboard',
  //   description: 'Implement pie charts and bar graphs using fl_chart.',
  //   status: 'Completed',
  //   dueDate: DateTime.now().subtract(Duration(days: 4)), // 4 days ago
  //   assignedTo: 'Eve Carter',
  //   priority: 2, // Medium Priority
  //   createdAt: DateTime.now().subtract(Duration(days: 10)),
  // ),
  // Task(
  //   id: 'task_005',
  //   title: 'Add Graphs to Dashboard',
  //   description: 'Implement pie charts and bar graphs using fl_chart.',
  //   status: 'Completed',
  //   dueDate: DateTime.now().subtract(Duration(days: 4)), // 4 days ago
  //   assignedTo: 'Eve Carter',
  //   priority: 2, // Medium Priority
  //   createdAt: DateTime.now().subtract(Duration(days: 10)),
  // ),
  // Task(
  //   id: 'task_005',
  //   title: 'Add Graphs to Dashboard',
  //   description: 'Implement pie charts and bar graphs using fl_chart.',
  //   status: 'Completed',
  //   dueDate: DateTime.now().subtract(Duration(days: 4)), // 4 days ago
  //   assignedTo: 'Eve Carter',
  //   priority: 2, // Medium Priority
  //   createdAt: DateTime.now().subtract(Duration(days: 10)),
  // ),
  // Task(
  //   id: 'task_005',
  //   title: 'Add Graphs to Dashboard',
  //   description: 'Implement pie charts and bar graphs using fl_chart.',
  //   status: 'Completed',
  //   dueDate: DateTime.now().subtract(Duration(days: 4)), // 4 days ago
  //   assignedTo: 'Eve Carter',
  //   priority: 2, // Medium Priority
  //   createdAt: DateTime.now().subtract(Duration(days: 10)),
  // ),
  // Task(
  //   id: 'task_005',
  //   title: 'Add Graphs to Dashboard',
  //   description: 'Implement pie charts and bar graphs using fl_chart.',
  //   status: 'Completed',
  //   dueDate: DateTime.now().subtract(Duration(days: 4)), // 4 days ago
  //   assignedTo: 'Eve Carter',
  //   priority: 2, // Medium Priority
  //   createdAt: DateTime.now().subtract(Duration(days: 10)),
  // ),
  // Task(
  //   id: 'task_005',
  //   title: 'Add Graphs to Dashboard',
  //   description: 'Implement pie charts and bar graphs using fl_chart.',
  //   status: 'Completed',
  //   dueDate: DateTime.now().subtract(Duration(days: 4)), // 4 days ago
  //   assignedTo: 'Eve Carter',
  //   priority: 2, // Medium Priority
  //   createdAt: DateTime.now().subtract(Duration(days: 10)),
  // ),
  // Task(
  //   id: 'task_005',
  //   title: 'Add Graphs to Dashboard',
  //   description: 'Implement pie charts and bar graphs using fl_chart.',
  //   status: 'Completed',
  //   dueDate: DateTime.now().subtract(Duration(days: 4)), // 4 days ago
  //   assignedTo: 'Eve Carter',
  //   priority: 2, // Medium Priority
  //   createdAt: DateTime.now().subtract(Duration(days: 10)),
  // ),
  // Task(
  //   id: 'task_005',
  //   title: 'Add Graphs to Dashboard',
  //   description: 'Implement pie charts and bar graphs using fl_chart.',
  //   status: 'Completed',
  //   dueDate: DateTime.now().subtract(Duration(days: 4)), // 4 days ago
  //   assignedTo: 'Eve Carter',
  //   priority: 2, // Medium Priority
  //   createdAt: DateTime.now().subtract(Duration(days: 10)),
  // ),
  // Task(
  //   id: 'task_005',
  //   title: 'Add Graphs to Dashboard',
  //   description: 'Implement pie charts and bar graphs using fl_chart.',
  //   status: 'Completed',
  //   dueDate: DateTime.now().subtract(Duration(days: 4)), // 4 days ago
  //   assignedTo: 'Eve Carter',
  //   priority: 2, // Medium Priority
  //   createdAt: DateTime.now().subtract(Duration(days: 10)),
  // ),
  // Task(
  //   id: 'task_005',
  //   title: 'Add Graphs to Dashboard',
  //   description: 'Implement pie charts and bar graphs using fl_chart.',
  //   status: 'Completed',
  //   dueDate: DateTime.now().subtract(Duration(days: 4)), // 4 days ago
  //   assignedTo: 'Eve Carter',
  //   priority: 2, // Medium Priority
  //   createdAt: DateTime.now().subtract(Duration(days: 10)),
  // ),
  // Task(
  //   id: 'task_005',
  //   title: 'Add Graphs to Dashboard',
  //   description: 'Implement pie charts and bar graphs using fl_chart.',
  //   status: 'Completed',
  //   dueDate: DateTime.now().subtract(Duration(days: 4)), // 4 days ago
  //   assignedTo: 'Eve Carter',
  //   priority: 2, // Medium Priority
  //   createdAt: DateTime.now().subtract(Duration(days: 10)),
  // ),
  // Task(
  //   id: 'task_005',
  //   title: 'Add Graphs to Dashboard',
  //   description: 'Implement pie charts and bar graphs using fl_chart.',
  //   status: 'Completed',
  //   dueDate: DateTime.now().subtract(Duration(days: 4)), // 4 days ago
  //   assignedTo: 'Eve Carter',
  //   priority: 2, // Medium Priority
  //   createdAt: DateTime.now().subtract(Duration(days: 10)),
  // ),
  // Task(
  //   id: 'task_005',
  //   title: 'Add Graphs to Dashboard',
  //   description: 'Implement pie charts and bar graphs using fl_chart.',
  //   status: 'Completed',
  //   dueDate: DateTime.now().subtract(Duration(days: 4)), // 4 days ago
  //   assignedTo: 'Eve Carter',
  //   priority: 2, // Medium Priority
  //   createdAt: DateTime.now().subtract(Duration(days: 10)),
  // ),
  // Task(
  //   id: 'task_005',
  //   title: 'Add Graphs to Dashboard',
  //   description: 'Implement pie charts and bar graphs using fl_chart.',
  //   status: 'Completed',
  //   dueDate: DateTime.now().subtract(Duration(days: 4)), // 4 days ago
  //   assignedTo: 'Eve Carter',
  //   priority: 2, // Medium Priority
  //   createdAt: DateTime.now().subtract(Duration(days: 10)),
  // ),
  // Task(
  //   id: 'task_005',
  //   title: 'Add Graphs to Dashboard',
  //   description: 'Implement pie charts and bar graphs using fl_chart.',
  //   status: 'Completed',
  //   dueDate: DateTime.now().subtract(Duration(days: 4)), // 4 days ago
  //   assignedTo: 'Eve Carter',
  //   priority: 2, // Medium Priority
  //   createdAt: DateTime.now().subtract(Duration(days: 10)),
  // ),
];
