import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/utils/app_logger.dart';

class LevelsFirestoreService {
  final FirebaseFirestore _firestore;

  LevelsFirestoreService(this._firestore);

  Future<List<Map<String, dynamic>>> fetchLevels() async {
    final snapshot = await _firestore
        .collection('levels')
        .where('isPublished', isEqualTo: true) // ✅ REQUIRED
        .orderBy('order')
        .get();
    AppLogger.success(
      'Loaded ${snapshot.docs.length} published levels',
      tag: 'Firestore',
    );

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
