// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:admin_curator/Constants/firebase_collections.dart';
import 'package:admin_curator/Models/patron_model.dart';
import 'package:admin_curator/Models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:download/download.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<CuratorModel>> getCuratorsWithProfilesStream() {
    return _firestore
        .collection(FirebaseCollections.consultantCollection)
        .where('isProfileCompleted', isEqualTo: true)
        .snapshots()
        .asyncMap((consultantsSnapshot) async {
          List<CuratorModel> curatorsList = [];

          for (var doc in consultantsSnapshot.docs) {
            final data = doc.data();
            if (data['isRejected'] == true) continue;
            String consultantId = doc.id;
            CuratorModel curator = CuratorModel.fromJson(doc.data());
            DocumentSnapshot profileSnapshot =
                await _firestore
                    .collection(FirebaseCollections.consultantCollection)
                    .doc(consultantId)
                    .collection(FirebaseCollections.profileCollection)
                    .doc(FirebaseCollections.userProfile)
                    .get();

            if (profileSnapshot.exists) {
              ProfileData profile = ProfileData.fromMap(
                profileSnapshot.data() as Map<String, dynamic>,
              );
              curator = curator.copyWith(profile: profile);
            }

            curatorsList.add(curator);
          }

          return curatorsList;
        });
  }

  Stream<List<CuratorModel>> getVerifiedCuratorsWithProfilesStream() {
    return _firestore
        .collection(FirebaseCollections.consultantCollection)
        .where('isProfileCompleted', isEqualTo: true)
        .where('isVerified', isEqualTo: true)
        .snapshots()
        .asyncMap((consultantsSnapshot) async {
          List<CuratorModel> curatorsList = [];

          for (var doc in consultantsSnapshot.docs) {
            final data = doc.data();
            if (data['isRejected'] == true) continue;
            String consultantId = doc.id;
            CuratorModel curator = CuratorModel.fromJson(doc.data());
            DocumentSnapshot profileSnapshot =
                await _firestore
                    .collection(FirebaseCollections.consultantCollection)
                    .doc(consultantId)
                    .collection(FirebaseCollections.profileCollection)
                    .doc(FirebaseCollections.userProfile)
                    .get();

            if (profileSnapshot.exists) {
              ProfileData profile = ProfileData.fromMap(
                profileSnapshot.data() as Map<String, dynamic>,
              );
              curator = curator.copyWith(profile: profile);
            }

            curatorsList.add(curator);
          }

          return curatorsList;
        });
  }

  Stream<List<CuratorModel>> getActiveCurators() {
    return _firestore
        .collection(FirebaseCollections.consultantCollection)
        .where('isProfileCompleted', isEqualTo: true)
        .where('isVerified', isEqualTo: true)
        .where('status', isEqualTo: true)
        .snapshots()
        .asyncMap((consultantsSnapshot) async {
          List<CuratorModel> curatorsList = [];

          for (var doc in consultantsSnapshot.docs) {
            final data = doc.data();
            if (data['isRejected'] == true) continue;
            String consultantId = doc.id;
            CuratorModel curator = CuratorModel.fromJson(doc.data());
            DocumentSnapshot profileSnapshot =
                await _firestore
                    .collection(FirebaseCollections.consultantCollection)
                    .doc(consultantId)
                    .collection(FirebaseCollections.profileCollection)
                    .doc(FirebaseCollections.userProfile)
                    .get();

            if (profileSnapshot.exists) {
              ProfileData profile = ProfileData.fromMap(
                profileSnapshot.data() as Map<String, dynamic>,
              );
              curator = curator.copyWith(profile: profile);
            }

            curatorsList.add(curator);
          }

          return curatorsList;
        });
  }

  Future<CuratorModel?> updateCuratorStatus(
    String curatorId, {
    required bool isVerified,
    required bool isRejected,
    String? rejectionReason,
    String? rejectedBy,
    DateTime? rejectedAt,
  }) async {
    try {
      final docRef = _firestore
          .collection(FirebaseCollections.consultantCollection)
          .doc(curatorId);

      await docRef.update({
        'isVerified': isVerified,
        'isRejected': isRejected,
        'reasonOfRejection': rejectionReason,
        'rejectedAt': rejectedAt,
        'rejectedBy': rejectedBy,
      });

      final updatedSnapshot = await docRef.get();
      if (updatedSnapshot.exists) {
        return CuratorModel.fromJson(
          updatedSnapshot.data() as Map<String, dynamic>,
        );
      }
    } catch (e) {
      print("Error updating curator status: $e");
    }
    return null;
  }

  Future<CuratorModel?> updateCuratorActiveDeactive({
    required bool status,
    required String curatorId,
  }) async {
    try {
      final docRef = _firestore
          .collection(FirebaseCollections.consultantCollection)
          .doc(curatorId);

      await docRef.update({'status': status});

      final updatedSnapshot = await docRef.get();
      if (updatedSnapshot.exists) {
        return CuratorModel.fromJson(
          updatedSnapshot.data() as Map<String, dynamic>,
        );
      }
    } catch (e) {
      print("Error updating curator status: $e");
    }
    return null;
  }

  Stream<CuratorModel?> getCuratorByReference(DocumentReference curatorRef) {
    return curatorRef.snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return CuratorModel.fromJson(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  Future<CuratorModel> getCuratorByRef(String doc) async {
    final curator =
        await _firestore
            .collection(FirebaseCollections.consultantCollection)
            .doc(doc)
            .collection(FirebaseCollections.profileCollection)
            .doc(FirebaseCollections.userProfile)
            .get();
    return CuratorModel.fromJson(curator as Map<String, dynamic>);
  }


Future<void> downloadCuratorProfiles(List<CuratorModel> curators) async {
  try {
    String fileContent = "ID,Full Name,Email,Status,Profile Completed,Verified,Created At,Updated At,addressLine, availabilitySlots,  contactNumber,  dateOfAvailability, departmentInterested,  dob, email,  gender,  nationality, pan, profileImage, selectedSkills, travelPreference,  workExperience, Bank Account name, Bank Account Number, Bank Account Type, Bank Name, Branch Name, IFDC Code";

    String formatCsvField(dynamic field) {
      if (field == null) return '""';
      String stringField = field.toString();
      if (field is DateTime) {
        stringField = DateFormat('dd/MM/yyyy').format(field);
      }
      return '"${stringField.replaceAll('"', '""')}"';
      
    }

    String formatWorkExp(List<WorkExp> workExp){
      if( workExp.isEmpty){return "''";}
      return '"${workExp.map((exp) => '${exp.organization}: (${exp.role})').join(";")}"';

    }
    for (var curator in curators) {
      fileContent +=
          "\n" +
          formatCsvField(curator.id) + "," +
          formatCsvField(curator.fullName) + "," +
          formatCsvField(curator.email) + "," +
          formatCsvField(curator.status ? 'Active' : 'Inactive') + "," +
          formatCsvField(curator.isProfileCompleted ? 'Yes' : 'No') + "," +
          formatCsvField(curator.isVerified ? 'Yes' : 'No') + "," +
          formatCsvField(curator.createdAt) + "," +
          formatCsvField(curator.updatedAt) + "," + 
          formatCsvField(curator.profile!.addressLine1)+formatCsvField(curator.profile!.addressLine1)+formatCsvField(curator.profile!.addressLine2)+formatCsvField(curator.profile!.district)+formatCsvField(curator.profile!.state)+formatCsvField(curator.profile!.pincode) + "," +
          formatCsvField(curator.profile!.availabilitySlots)+ ','+
          formatCsvField(curator.profile!.contactNumber)+ ','+
          formatCsvField(curator.profile!.dateOfAvailability)+ ','+
          formatCsvField(curator.profile!.departmentInterested)+ ','+
          formatCsvField(curator.profile!.dob)+ ','+
          formatCsvField(curator.profile!.email)+ ','+
          formatCsvField(curator.profile!.gender)+ ','+
          formatCsvField(curator.profile!.nationality)+ ','+
          formatCsvField(curator.profile!.pan)+ ','+
          formatCsvField(curator.profile!.profileImage)+ ','+
          formatCsvField(curator.profile!.selectedSkills)+ ','+
          formatCsvField(curator.profile!.travelPreference)+ ','+
          formatWorkExp(curator.profile!.workExperience)+ ',' +
          formatCsvField(curator.profile!.bankAccountDetails!.accountHolderName)+ ',' +
          formatCsvField(curator.profile!.bankAccountDetails!.accountNumber)+ ',' +
          formatCsvField(curator.profile!.bankAccountDetails!.accountType)+ ',' +
          formatCsvField(curator.profile!.bankAccountDetails!.bankName)+ ',' +
          formatCsvField(curator.profile!.bankAccountDetails!.branchName)+ ',' +
          formatCsvField(curator.profile!.bankAccountDetails!.ifscCode);
    }

    final fileName = "CuratorProfiles_${DateTime.now().toIso8601String()}.csv";
    var bytes = utf8.encode(fileContent);
    final stream = Stream.fromIterable(bytes);

    await download(stream, fileName);

    developer.log('CSV download completed successfully');
  } catch (e, stackTrace) {
    developer.log('Error in downloadCuratorProfiles: $e\n$stackTrace');
    rethrow;
  }
}

}
