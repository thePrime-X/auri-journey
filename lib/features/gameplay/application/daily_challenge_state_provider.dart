import 'package:flutter_riverpod/legacy.dart';

final dailyChallengeLevelIdsProvider = StateProvider<List<String>>((ref) {
  return const [];
});

final currentDailyChallengeIndexProvider = StateProvider<int>((ref) {
  return 0;
});

final isDailyChallengeModeProvider = StateProvider<bool>((ref) {
  return false;
});

final completedDailyChallengeDateProvider = StateProvider<String?>((ref) {
  return null;
});
