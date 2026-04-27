import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class LevelsFirestoreService {
  final FirebaseFirestore _firestore;

  LevelsFirestoreService(this._firestore);

  Future<List<Map<String, dynamic>>> fetchLevels() async {
    final snapshot = await _firestore
        .collection('levels')
        .where('isPublished', isEqualTo: true) // ✅ REQUIRED
        .orderBy('order')
        .get();

    developer.log(
      'Loaded levels from Firestore: ${snapshot.docs.length}',
      name: 'Firestore',
    );

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
