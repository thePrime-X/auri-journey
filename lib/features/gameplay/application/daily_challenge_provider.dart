import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/daily_challenge_firestore_service.dart';
import '../domain/models/daily_challenge.dart';
import 'firestore_provider.dart';

final dailyChallengeFirestoreServiceProvider =
    Provider<DailyChallengeFirestoreService>((ref) {
      return DailyChallengeFirestoreService(ref.read(firestoreProvider));
    });

final dailyChallengeProvider = FutureProvider<DailyChallenge?>((ref) async {
  final service = ref.read(dailyChallengeFirestoreServiceProvider);
  return service.fetchTodayChallenge();
});
