import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressFirestoreService {
  final FirebaseFirestore _firestore;

  ProgressFirestoreService(this._firestore);

  Future<void> saveLevelCompletion({
    required String uid,
    required String levelId,
    required int movesUsed,
    required int hintsUsed,
  }) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc(levelId)
        .set({
          'levelId': levelId,
          'status': 'completed',
          'movesUsed': movesUsed,
          'hintsUsed': hintsUsed,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }
}
