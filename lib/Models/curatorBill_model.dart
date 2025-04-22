import 'package:cloud_firestore/cloud_firestore.dart';

class CuratorBill {
  DocumentReference? billDocRef;
  DocumentReference? curatorRef;
  String docUrl;
  String invoiceDescription;
  String invoiceNumber;
  Timestamp invoiceSubmittedAt;
  DocumentReference invoiceSubmittedBy;
  bool isAdminApproved;
  bool isLMApproved;
  String reasonOfRejection;
  String status;
  DocumentReference? taskRef;
  int totalAmount;
  bool? isAdditionalBillAdded;
  double taskHours;
  double taskPrice;
  bool? isTaskBillCreated;

  CuratorBill({
    this.billDocRef,
    this.curatorRef,
    required this.docUrl,
    required this.invoiceDescription,
    required this.invoiceNumber,
    required this.invoiceSubmittedAt,
    required this.invoiceSubmittedBy,
    this.isAdminApproved = false,
    this.isLMApproved = false,
    this.reasonOfRejection = "",
    required this.status,
    required this.taskRef,
    required this.totalAmount,
    this.isAdditionalBillAdded = false,
    required this.taskHours,
    required this.taskPrice,
    this.isTaskBillCreated,
  });

  // Convert Firestore DocumentSnapshot to CuratorBill
  factory CuratorBill.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return CuratorBill(
      billDocRef: doc.reference,
      curatorRef:
          data['curatorRef'] != null
              ? data['curatorRef'] as DocumentReference
              : null,
      docUrl: data['docUrl'] ?? '',
      invoiceDescription: data['invoiceDescription'] ?? '',
      invoiceNumber: data['invoiceNumber'] ?? '',
      invoiceSubmittedAt: data['invoiceSubmittedAt'] ?? Timestamp.now(),
      invoiceSubmittedBy: data['invoiceSubmittedBy'],
      isAdminApproved: data['isAdminApproved'] ?? false,
      isLMApproved: data['isLMApproved'] ?? false,
      reasonOfRejection: data['reasonOfRejection'] ?? '',
      status: data['status'] ?? 'Pending',
      taskRef:
          data['taskRef'] != null ? data['taskRef'] as DocumentReference : null,
      totalAmount: (data['totalAmount'] ?? 0).toInt(),
      isAdditionalBillAdded: data['isAdditionalBillAdded'] ?? false,
      taskHours: _parseDouble(data['taskHours']),
      taskPrice: _parseDouble(data['taskPrice']),
      isTaskBillCreated: data['isTaskBillCreated'] ?? false,
    );
  }

  // Convert CuratorBill to Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'curatorRef': curatorRef,
      'docUrl': docUrl,
      'invoiceDescription': invoiceDescription,
      'invoiceNumber': invoiceNumber,
      'invoiceSubmittedAt': invoiceSubmittedAt,
      'invoiceSubmittedBy': invoiceSubmittedBy,
      'isAdminApproved': isAdminApproved,
      'isLMApproved': isLMApproved,
      'reasonOfRejection': reasonOfRejection,
      'status': status,
      'taskRef': taskRef,
      'totalAmount': totalAmount,
      'isAdditionalBillAdded': isAdditionalBillAdded,
      'taskHours': taskHours.toDouble(),
      'taskPrice': taskPrice.toDouble(),
      'isTaskBillCreated': isTaskBillCreated,
    };
  }
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
