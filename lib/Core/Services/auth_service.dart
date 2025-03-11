import 'package:admin_curator/Constants/firebase_collections.dart';
import 'package:admin_curator/Models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((User? user) async {
      if (user == null) return null;
      final doc =
          await _firestore
              .collection(FirebaseCollections.user)
              .doc(user.uid)
              .get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    });
  }

  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        final user = await getUserDetails(userCredential.user!.uid);
        print("******************");
        print(user.toString());
        print("*****************");
        if (user != null && user.isHomeDecorEnabled) {
          return user;
        } else {
          await _auth.signOut();
          throw FirebaseAuthException(
            code: 'home_decor_disabled',
            message: 'Access restricted. Please contact support.',
          );
        }
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserModel?> getUserDetails(String userId) async {
    try {
      final doc =
          await _firestore
              .collection(FirebaseCollections.user)
              .doc(userId)
              .get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
