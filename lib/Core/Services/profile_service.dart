import 'package:admin_curator/Constants/firebase_collections.dart';
import 'package:admin_curator/Models/patron_model.dart';
import 'package:admin_curator/Models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  }) async {
    try {
      final docRef = _firestore
          .collection(FirebaseCollections.consultantCollection)
          .doc(curatorId);

      await docRef.update({'isVerified': isVerified, 'isRejected': isRejected});

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
}
