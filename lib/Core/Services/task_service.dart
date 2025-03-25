import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Constants/firebase_collections.dart';
import '../../Models/comment.dart';
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

  Stream<List<Comment>> getCommentsStream(String taskId) {
    return _firestore
        .collection(FirebaseCollections.createTaskCollection)
        .doc(taskId)
        .collection('commentsThread')
        .orderBy('timeStamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Comment.fromJson(doc)).toList();
        });
  }


  Future<TaskModel?> taskPriceAndTime({
    required String taskId,
    required double taskDurationByAdmin,
    required double taskPriceByAdmin,
    required bool isAdminApproved,
  }) async {
    DocumentReference taskRef = _firestore
        .collection(FirebaseCollections.createTaskCollection)
        .doc(taskId);
    WriteBatch batch = _firestore.batch();
    batch.update(taskRef, {
      'taskPriceByAdmin': taskPriceByAdmin,
      'taskDurationByAdmin': taskDurationByAdmin,
      'isAdminApproved': isAdminApproved,

    });
    await batch.commit();
    DocumentSnapshot updatedTaskSnap = await taskRef.get();
    if (updatedTaskSnap.exists) {
      return TaskModel.fromFirestore(updatedTaskSnap);
    }
    return null;
  }

  Future<TaskModel?> updateCurator({
    required String taskId,

    required String curatorID,
  }) async {
    DocumentReference taskRef = _firestore
        .collection(FirebaseCollections.createTaskCollection)
        .doc(taskId);
    WriteBatch batch = _firestore.batch();
    batch.update(taskRef, {
      'taskAssignedToCurator': curatorID,
      'curatorTaskStatus': 'Pending',
      'isTaskAssignedToCurator': true,
      'taskAcceptedTimeByCurator': Timestamp.now(),

    });
    await batch.commit();
    DocumentSnapshot updatedTaskSnap = await taskRef.get();
    if (updatedTaskSnap.exists) {
      return TaskModel.fromFirestore(updatedTaskSnap);
    }
    return null;
  }


  Future<TaskModel?> updateCurator({
    required String taskId,

    required String curatorID,
  }) async {
    DocumentReference taskRef = _firestore
        .collection(FirebaseCollections.createTaskCollection)
        .doc(taskId);
    WriteBatch batch = _firestore.batch();
    batch.update(taskRef, {
      'taskAssignedToCurator': curatorID,
      'curatorTaskStatus': 'Pending',
      'isTaskAssignedToCurator': true,
      'taskAcceptedTimeByCurator': Timestamp.now(),
    });
    await batch.commit();
    DocumentSnapshot updatedTaskSnap = await taskRef.get();
    if (updatedTaskSnap.exists) {
      return TaskModel.fromFirestore(updatedTaskSnap);
    }
    return null;
  }


  Future<void> addCommentToTask({
    required String taskId,
    required Comment comment,
  }) async {
    DocumentReference commentRef =
        _firestore
            .collection(FirebaseCollections.createTaskCollection)
            .doc(taskId)
            .collection('commentsThread')
            .doc();

    WriteBatch batch = _firestore.batch();
    batch.set(commentRef, comment.toJson());

    await batch.commit();
  }

  Future<TaskModel?> updateVisiblity({
    required bool isTaskDisabled,
    required String taskId,
  }) async {
    DocumentReference taskRef = _firestore
        .collection(FirebaseCollections.createTaskCollection)
        .doc(taskId);
    WriteBatch batch = _firestore.batch();
    batch.update(taskRef, {'isTaskDisabled': isTaskDisabled});
    await batch.commit();
    DocumentSnapshot updatedTaskSnap = await taskRef.get();
    if (updatedTaskSnap.exists) {
      return TaskModel.fromFirestore(updatedTaskSnap);
    }
    return null;
  }

  Stream<TaskModel>? getTaskById({required String id}) {
    return _firestore
        .collection(FirebaseCollections.createTaskCollection)
        .doc(id)
        .snapshots()
        .map((snapshots) {
          return TaskModel.fromFirestore(snapshots);
        });
    // if (taskRef.exists) {
    //   return TaskModel.fromFirestore(taskRef);
    // } else {
    //   return null;
    // }
  }
}
