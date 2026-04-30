import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/daily_challenge_firestore_service.dart';
import '../domain/models/daily_challenge.dart';
import 'firestore_provider.dart';

import '../../../../features/profile/application/user_profile_provider.dart';

final dailyChallengeFirestoreServiceProvider =
    Provider<DailyChallengeFirestoreService>((ref) {
      return DailyChallengeFirestoreService(ref.read(firestoreProvider));
    });

final dailyChallengeProvider = FutureProvider<DailyChallenge?>((ref) async {
  final profile = await ref.watch(userProfileProvider.future);

  if (profile == null || profile.createdAt == null) {
    return null;
  }

  final now = DateTime.now();
  final createdAt = profile.createdAt!;

  final signupDay = DateTime(createdAt.year, createdAt.month, createdAt.day);

  final today = DateTime(now.year, now.month, now.day);

  final dayNumber = today.difference(signupDay).inDays + 1;

  final service = ref.read(dailyChallengeFirestoreServiceProvider);
  return service.fetchChallengeForDay(dayNumber);
});
