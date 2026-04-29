import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/models/daily_challenge.dart';

class DailyChallengeFirestoreService {
  final FirebaseFirestore _firestore;

  DailyChallengeFirestoreService(this._firestore);

  Future<DailyChallenge?> fetchTodayChallenge() async {
    final todayKey = _todayKey();

    final snapshot = await _firestore
        .collection('dailyChallenges')
        .where('dateKey', isEqualTo: todayKey)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final doc = snapshot.docs.first;

    return DailyChallenge.fromFirestore(id: doc.id, data: doc.data());
  }

  String _todayKey() {
    final now = DateTime.now();

    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');

    return '${now.year}-$month-$day';
  }
}
