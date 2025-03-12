import 'package:admin_curator/Models/model_tasks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Models/task_model.dart';

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  TaskNotifier() : super([]) {
    fetchTasks(); // Fetch tasks on initialization
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔥 Fetch tasks where selectedHomeCuratorDepartment is not empty
  Future<void> fetchTasks() async {
    try {
      final snapshot =
          await _firestore
              .collection('createTaskCollection')
              .where('selectedHomeCuratorDepartment', isNotEqualTo: "")
              .get();
      print(snapshot);

      // Convert Firestore documents to List<Task>
      state = snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error fetching tasks: $e");
    }
  }

  // ✅ Refresh tasks manually if needed
  Future<void> refreshTasks() async {
    await fetchTasks();
  }
}

// 🔥 StateNotifierProvider for Task Management
final taskProvider = StateNotifierProvider<TaskNotifier, List<TaskModel>>((
  ref,
) {
  return TaskNotifier();
});
