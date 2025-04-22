import 'package:admin_curator/Constants/firebase_collections.dart';
import 'package:admin_curator/Models/curatorBill_model.dart';
import 'package:admin_curator/Presentation/Widgets/create_bill_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Models/model_tasks.dart';
import 'create_bill_service_component.dart';

class CuratorBillService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CreateBill _createBill = CreateBill();
  // Stream<CuratorBill?> getCuratorBillByTaskRef(String taskRef) {
  //   return _firestore
  //       .collection('CuratorInvoice')
  //       .where('taskRef', isEqualTo: taskRef)
  //       .snapshots()
  //       .map((querySnapshot) {
  //         if (querySnapshot.docs.isNotEmpty) {
  //           return CuratorBill.fromFirestore(querySnapshot.docs.first);
  //         } else {
  //           return null;
  //         }
  //       });
  // }
  //  Stream<List<CuratorBill>> getCuratorBillsByTaskRef(String taskRef) {
  //   return _firestore
  //       .collection('CuratorInvoice') // Replace with your actual Firestore collection name
  //       .where('taskRef', isEqualTo: taskRef)
  //       .snapshots()
  //       .map((querySnapshot) {
  //         return querySnapshot.docs.map((doc) {
  //           return CuratorBill.fromFirestore(doc);
  //         }).toList();
  //       });
  // }

  Future<CuratorBill?> updateBill(
    bool isAdminApproved,
    DocumentReference billId,
    String status,
  ) async {
    WriteBatch batch = _firestore.batch();
    batch.update(billId, {
      'isAdminApproved': isAdminApproved,
      'status': status,
      'reasonOfRejection': "",
    });
    await batch.commit();
    DocumentSnapshot updatedTaskSnap = await billId.get();
    if (updatedTaskSnap.exists) {
      return CuratorBill.fromFirestore(updatedTaskSnap);
    }
    return null;
  }

  Future<CuratorBill?> updateRejectionBill(
    bool isAdminApproved,
    String rejectionReason,
    DocumentReference billId,
  ) async {
    WriteBatch batch = _firestore.batch();
    batch.update(billId, {
      'isAdminApproved': isAdminApproved,
      'reasonOfRejection': rejectionReason,
      'status': 'Rejected',
      'isTaskBillCreated': false,
    });
    await batch.commit();
    DocumentSnapshot updatedTaskSnap = await billId.get();
    if (updatedTaskSnap.exists) {
      return CuratorBill.fromFirestore(updatedTaskSnap);
    }
    return null;
  }

  Future<TaskModel?> updateTaskBillStatus(
    DocumentReference taskRef,
    bool taskBillStatus,
  ) async {
    WriteBatch batch = _firestore.batch();
    batch.update(taskRef, {'isTaskBillCreated': taskBillStatus});
    await batch.commit();
    DocumentSnapshot updatedTaskSnap = await taskRef.get();
    if (updatedTaskSnap.exists) {
      return TaskModel.fromFirestore(updatedTaskSnap);
    }
    return null;
  }

  Stream<List<CuratorBill>> getCuratorBillsByTaskRef(
    DocumentReference taskRef,
  ) {
    return _firestore
        .collection('CuratorInvoice')
        .where('taskRef', isEqualTo: taskRef)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) {
          if (querySnapshot.docs.isEmpty) {
            print('Document is empty');
            return [];
          }
          return querySnapshot.docs.map((doc) {
            return CuratorBill.fromFirestore(doc);
          }).toList();
        });
  }

  Future<CuratorBill> createCuratorBill(
    String fileName,
    String vendorName,
    String invoiceNumber,
    String invoiceDescription,
    String invoiceDate,
    String soldTo,
    double totalAmount,
    List<Map<String, dynamic>> items,
    DocumentReference taskRef,
    DocumentReference curatorRef,
    double taskHours,
    double taskPrices,
  ) async {
    try {
      final pdfURL = await _createBill.uploadPdfFile(
        fileName,
        vendorName,
        invoiceNumber,
        invoiceDate,
        soldTo,
        items,
      );
      final docRef = await FirebaseFirestore.instance
          .collection('CuratorInvoice')
          .add({
            'docUrl': pdfURL,
            'createdAt': Timestamp.now(),
            'taskRef': taskRef,
            'curatorRef': curatorRef,
            'invoiceDescription': invoiceDescription,
            'invoiceNumber': invoiceNumber,
            'invoiceSubmittedAt': Timestamp.now(),
            'invoiceSubmittedBy': curatorRef,
            'isAdminApproved': true,
            'isLMApproved': false,
            'totalAmount': totalAmount,
            'isAdditionalBillAdded': true,
            'taskHours': taskHours,
            'taskPrice': taskPrices,
          });

      final docSnap = await docRef.get();
      print(docSnap.data());
      return CuratorBill.fromFirestore(docSnap);
    } on FirebaseException catch (e) {
      print(e.toString());
      throw Exception(e.code);
    }
  }

  double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Future<CuratorBill?> getAdditionalBill({
    required DocumentReference taskRef,
  }) async {
    try {
      final document =
          await _firestore
              .collection('CuratorInvoice')
              .where('taskRef', isEqualTo: taskRef)
              .where('isAdditionalBillAdded', isEqualTo: true)
              .limit(1)
              .get();

      if (document.docs.isNotEmpty) {
        return CuratorBill.fromFirestore(document.docs.first);
      } else {
        print('No additional Bill Found');
        return null;
      }
    } catch (e) {
      print('Error fetching additional bill: $e');
      return null;
    }
  }

  Future<CuratorBill?> getTaskBill({
    required DocumentReference taskRef,
    required bool isTaskBillCreated,
  }) async {
    try {
      final document =
          await _firestore
              .collection('CuratorInvoice')
              .where('taskRef', isEqualTo: taskRef)
              .where('isTaskBillCreated', isEqualTo: isTaskBillCreated)
              .limit(1)
              .get();

      if (document.docs.isNotEmpty) {
        return CuratorBill.fromFirestore(document.docs.first);
      } else {
        print('No additional Bill Found');
        return null;
      }
    } catch (e) {
      print('Error fetching additional bill: $e');
      return null;
    }
  }

  Future<CuratorBill> createTaskBill(
    String fileName,
    String vendorName,
    String invoiceNumber,
    String invoiceDescription,
    String invoiceDate,
    String soldTo,
    double totalAmount,
    List<Map<String, dynamic>> items,
    DocumentReference taskRef,
    DocumentReference curatorRef,
  ) async {
    try {
      print(items);
      final pdfURL = await _createBill.uploadPdfFile(
        fileName,
        vendorName,
        invoiceNumber,
        invoiceDate,
        soldTo,
        items,
      );
      final docRef = await FirebaseFirestore.instance
          .collection('CuratorInvoice')
          .add({
            'docUrl': pdfURL,
            'createdAt': Timestamp.now(),
            'taskRef': taskRef,
            'curatorRef': curatorRef,
            'invoiceDescription': invoiceDescription,
            'invoiceNumber': invoiceNumber,
            'invoiceSubmittedAt': Timestamp.now(),
            'invoiceSubmittedBy': curatorRef,
            'isAdminApproved': true,
            'isLMApproved': false,
            'totalAmount': totalAmount,
            'isTaskBillCreated': true,
          });

      final docSnap = await docRef.get();
      print(docSnap.data());
      return CuratorBill.fromFirestore(docSnap);
    } on FirebaseException catch (e) {
      print(e.toString());
      throw Exception(e.code);
    }
  }

  //
  // Stream<CuratorBill?> getCuratorBillByTaskRef(DocumentReference taskRef) {
  //   return _firestore
  //       .collection('CuratorInvoice')
  //       .where('taskRef', isEqualTo: taskRef)
  //       .limit(1)
  //       .snapshots()
  //       .map((querySnapshot) {
  //     if (querySnapshot.docs.isEmpty) return null; // No document found
  //     return CuratorBill.fromFirestore(querySnapshot.docs.first);
  //   });
  // }
}
