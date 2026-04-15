import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> testWrite() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user found');
    }

    await _db.collection('users').doc(user.uid).set({
      'displayName': 'Anonymous Tester1',
      'createdAt': FieldValue.serverTimestamp(),
      'lastLoginAt': FieldValue.serverTimestamp(),
      'currentLevel': 'S1_L1',
      'totalXP': 0,
      'puzzlesCompleted': 0,
    }, SetOptions(merge: true));
  }
}