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

  Stream<List<CuratorBill>> getCuratorBillsByTaskRef(DocumentReference taskRef) {
  return _firestore
      .collection('CuratorInvoice') // Replace with your actual Firestore collection name
      .where('taskRef', isEqualTo: taskRef)
      .snapshots()
      .map((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          return []; // Return an empty list if no documents exist
        }
        return querySnapshot.docs.map((doc) {
          return CuratorBill.fromFirestore(doc);
        }).toList();
      });
}
}
