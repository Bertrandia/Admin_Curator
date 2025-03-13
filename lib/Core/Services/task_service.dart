import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Constants/firebase_collections.dart';
import '../../Models/model_tasks.dart';

class TasksService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<TaskModel>> getTasksWithCuratorsStream() {
    return _firestore
        .collection(FirebaseCollections.createTaskCollection)
        .where('selectedHomeCuratorDepartment', isNull: false)
        .orderBy('taskAssignDate', descending: true)
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs.map((doc) {
            return TaskModel.fromFirestore(doc);
          }).toList();
        });
  }

  Future<TaskModel?> taskPriceAndTime({
    required String taskId,
    required double taskDurationByAdmin,
    required double taskPriceByAdmin,
  }) async {
    DocumentReference taskRef = _firestore
        .collection(FirebaseCollections.createTaskCollection)
        .doc(taskId);
    WriteBatch batch = _firestore.batch();
    batch.update(taskRef, {
      'taskPriceByAdmin': taskPriceByAdmin,
      'taskDurationByAdmin': taskDurationByAdmin,
    });
    await batch.commit();
    DocumentSnapshot updatedTaskSnap = await taskRef.get();
    if (updatedTaskSnap.exists) {
      return TaskModel.fromFirestore(updatedTaskSnap);
    }
    return null;
  }

  Future<TaskModel?> getTaskById({required String id}) async {
    final taskRef =
        await _firestore
            .collection(FirebaseCollections.createTaskCollection)
            .doc(id)
            .get();
    if (taskRef.exists) {
      return TaskModel.fromFirestore(taskRef);
    } else {
      return null;
    }
  }
}
