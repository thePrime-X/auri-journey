import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/models/daily_challenge.dart';

class DailyChallengeFirestoreService {
  final FirebaseFirestore _firestore;

  DailyChallengeFirestoreService(this._firestore);

  Future<DailyChallenge?> fetchChallengeForDay(int dayNumber) async {
    final snapshot = await _firestore
        .collection('dailyChallenges')
        .where('dayNumber', isEqualTo: dayNumber)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final doc = snapshot.docs.first;

    return DailyChallenge.fromFirestore(id: doc.id, data: doc.data());
  }
}
