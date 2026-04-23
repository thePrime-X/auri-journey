import 'package:cloud_firestore/cloud_firestore.dart';

class LevelsFirestoreService {
  final FirebaseFirestore _firestore;

  LevelsFirestoreService(this._firestore);

  Future<List<Map<String, dynamic>>> fetchLevels() async {
    final snapshot = await _firestore
        .collection('levels')
        .orderBy('order')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
