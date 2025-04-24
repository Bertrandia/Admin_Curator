import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
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

  Future<void> notifyUser({
    required String userId,
    required String title,
    required String body,
    required String action,
    Map<String, dynamic>? additionalData,
  }) async {
    final functions = FirebaseFunctions.instance;

    try {
      final HttpsCallable callable = functions.httpsCallable(
        'sendNotificationToUser',
      );
      final result = await callable.call({
        "userId": userId,
        "title": title,
        "body": body,
        "action": action,
        "additionalData": additionalData,
      });

      debugPrint("Notification sent to user $userId: ${result.data}");
    } catch (e) {
      debugPrint("Error sending notification to user $userId: $e");
      // Optionally update state with errorMessage if needed
    }
  }

  Future<void> notifyAllCurators({
    required String title,
    required String body,
    required String action,
    Map<String, dynamic>? additionalData,
  }) async {
    final functions = FirebaseFunctions.instance;

    try {
      final HttpsCallable callable = functions.httpsCallable(
        'sendNotificationToAllCurators',
      );
      final result = await callable.call({
        "title": title,
        "body": body,
        "action": action,
        "additionalData": additionalData ?? {},
      });

      debugPrint("Notification sent: ${result.data}");
    } catch (e) {
      debugPrint("Error sending notification: $e");
      rethrow;
    }
  }

  Future<TaskModel?> updateTaskLifecycle({
    required DocumentReference taskRef,
  }) async {
    WriteBatch batch = _firestore.batch();
    batch.update(taskRef, {
      'curatorTaskStatus': 'Completed',
      'paymentDueClearedTimeByAdmin': Timestamp.now(),
      'paymentDueCleared': true,
    });
    await batch.commit();
    DocumentSnapshot updatedTaskSnap = await taskRef.get();
    if (updatedTaskSnap.exists) {
      return TaskModel.fromFirestore(updatedTaskSnap);
    }
    return null;
  }

  Future<TaskModel?> removeCurator({required String taskId}) async {
    DocumentReference taskRef = _firestore
        .collection(FirebaseCollections.createTaskCollection)
        .doc(taskId);
    WriteBatch batch = _firestore.batch();
    batch.update(taskRef, {
      'taskAssignedToCurator': null,
      'isTaskAssignedToCurator': false,
    });
    await batch.commit();
    DocumentSnapshot updatedTaskSnap = await taskRef.get();
    if (updatedTaskSnap.exists) {
      return TaskModel.fromFirestore(updatedTaskSnap);
    }
    return null;
  }
  // Future<TaskModel?> updateCurator({
  //   required String taskId,
  //
  //   required String curatorID,
  // }) async {
  //   DocumentReference taskRef = _firestore
  //       .collection(FirebaseCollections.createTaskCollection)
  //       .doc(taskId);
  //   WriteBatch batch = _firestore.batch();
  //   batch.update(taskRef, {
  //     'taskAssignedToCurator': curatorID,
  //     'curatorTaskStatus': 'Pending',
  //     'isTaskAssignedToCurator': true,
  //     'taskAcceptedTimeByCurator': Timestamp.now(),
  //   });
  //   await batch.commit();
  //   DocumentSnapshot updatedTaskSnap = await taskRef.get();
  //   if (updatedTaskSnap.exists) {
  //     return TaskModel.fromFirestore(updatedTaskSnap);
  //   }
  //   return null;
  // }

  Future<void> addCommentToTask({
    required String taskId,
    required Comment comment,
  }) async {
    try {
      DocumentReference commentRef =
          _firestore
              .collection(FirebaseCollections.createTaskCollection)
              .doc(taskId)
              .collection('commentsThread')
              .doc();

      WriteBatch batch = _firestore.batch();
      batch.set(commentRef, comment.toJson());

      await batch.commit();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<TaskModel?> updateVisiblity({
    required bool isTaskDisabled,
    required String taskId,
    required String reasonOfRejection,
  }) async {
    try {
      DocumentReference taskRef = _firestore
          .collection(FirebaseCollections.createTaskCollection)
          .doc(taskId);

      WriteBatch batch = _firestore.batch();
      batch.update(taskRef, {
        'isTaskDisabled': isTaskDisabled,
        'taskDisablingReason': reasonOfRejection,
      });

      await batch.commit();

      DocumentSnapshot updatedTaskSnap = await taskRef.get();
      if (updatedTaskSnap.exists) {
        return TaskModel.fromFirestore(updatedTaskSnap);
      }
      return null;
    } catch (e, stackTrace) {
      debugPrint('Error updating task visibility: $e');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  Future<TaskModel?> updateTaskBillStatus({
    required bool isTaskBillCreated,
    required String taskId,
  }) async {
    try {
      DocumentReference taskRef = _firestore
          .collection(FirebaseCollections.createTaskCollection)
          .doc(taskId);

      WriteBatch batch = _firestore.batch();
      batch.update(taskRef, {'isTaskBillCreated': isTaskBillCreated});

      await batch.commit();

      DocumentSnapshot updatedTaskSnap = await taskRef.get();
      if (updatedTaskSnap.exists) {
        return TaskModel.fromFirestore(updatedTaskSnap);
      }
      return null;
    } catch (e, stackTrace) {
      debugPrint('Error updating task visibility: $e');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
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

  Future<void> taskAdminReferenceUpdate({
    required String taskId,
    required List<String> files,
  }) async {
    DocumentReference taskRef = _firestore
        .collection(FirebaseCollections.createTaskCollection)
        .doc(taskId);
    WriteBatch batch = _firestore.batch();
    batch.update(taskRef, {
      'referenceFileByAdmin': files,
      'updatedAdminAt': Timestamp.now(),
    });
    await batch.commit();
  }

}
