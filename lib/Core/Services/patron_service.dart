import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Models/patron_model.dart';

class PatronService {
  Future<PatronModel> getPatronModel(DocumentReference ref) async {
    DocumentSnapshot patronRef = await ref.get();
    return PatronModel.fromFirestore(patronRef);
  }
}
