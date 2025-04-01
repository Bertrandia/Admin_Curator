import 'package:admin_curator/Constants/firebase_collections.dart';
import 'package:admin_curator/Models/curatorBill_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CuratorBillService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
  ) async {
    WriteBatch batch = _firestore.batch();
    batch.update(billId, {'isAdminApproved': isAdminApproved});
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
    });
    await batch.commit();
    DocumentSnapshot updatedTaskSnap = await billId.get();
    if (updatedTaskSnap.exists) {
      return CuratorBill.fromFirestore(updatedTaskSnap);
    }
    return null;
  }

  Stream<List<CuratorBill>> getCuratorBillsByTaskRef(
    DocumentReference taskRef,
  ) {
    return _firestore
        .collection(
          'CuratorInvoice',
        ) // Replace with your actual Firestore collection name
        .where('taskRef', isEqualTo: taskRef)
        .limit(1)
        .snapshots()
        .map((querySnapshot) {
          if (querySnapshot.docs.isEmpty) {
            print('Document is empty');
            return []; // Return an empty list if no documents exist
          }
          return querySnapshot.docs.map((doc) {
            return CuratorBill.fromFirestore(doc);
          }).toList();
        });
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
