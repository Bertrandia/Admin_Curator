import 'package:cloud_firestore/cloud_firestore.dart';

class PatronModel {
  final String patronName;
  final String email1;
  final String clientCode;
  final String gender;
  final String assignedLM;
  final String maritalStatus;
  final String occupation;
  final DateTime? dob;
  final String email2;
  final String addressLine1;
  final String addressLine2;
  final String landmark;
  final String city;
  final String state;
  final String country;
  final String gadgetsAndTech;
  final String prefBrands;

  PatronModel({
    required this.patronName,
    required this.email1,
    required this.clientCode,
    required this.gender,
    required this.assignedLM,
    required this.maritalStatus,
    required this.occupation,
    this.dob,
    required this.email2,
    required this.addressLine1,
    required this.addressLine2,
    required this.landmark,
    required this.city,
    required this.state,
    required this.country,
    required this.gadgetsAndTech,
    required this.prefBrands,
  });

  // Convert Firestore document to Model
  factory PatronModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PatronModel(
      patronName: data['partonName'] ?? '',
      email1: data['email1'] ?? '',
      clientCode: data['clientCode'] ?? '',
      gender: data['gender'] ?? '',
      assignedLM: data['assignedLM'] ?? '',
      maritalStatus: data['maritalStatus'] ?? '',
      occupation: data['occupation'] ?? '',
      dob: data['dob'] != null ? (data['dob'] as Timestamp).toDate() : null,
      email2: data['email2'] ?? '',
      addressLine1: data['addressLine1'] ?? '',
      addressLine2: data['addressLine2'] ?? '',
      landmark: data['landmark'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      country: data['country'] ?? '',
      gadgetsAndTech: data['gadgetsndTech'] ?? '',
      prefBrands: data['prefBrands'] ?? '',
    );
  }

  // Convert Model to Firestore Document
  Map<String, dynamic> toFirestore() {
    return {
      "patronName": patronName,
      "email1": email1,
      "clientCode": clientCode,
      "gender": gender,
      "assignedLM": assignedLM,
      "maritalStatus": maritalStatus,
      "occupation": occupation,
      "dob": dob != null ? Timestamp.fromDate(dob!) : null,
      "email2": email2,
      "addressLine1": addressLine1,
      "addressLine2": addressLine2,
      "landmark": landmark,
      "city": city,
      "state": state,
      "country": country,
      "gadgetsndTech": gadgetsAndTech,
      "prefBrands": prefBrands,
    };
  }
}
