import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/current_level_provider.dart';
import '../../application/levels_provider.dart';
import 'gameplay_screen.dart';
import '../../application/daily_challenge_state_provider.dart';

class GameplayLoaderScreen extends ConsumerWidget {
  const GameplayLoaderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelsAsync = ref.watch(levelsProvider);
    final currentLevelIndex = ref.watch(currentLevelIndexProvider);

    final isDailyMode = ref.watch(isDailyChallengeModeProvider);
    final dailyLevelIds = ref.watch(dailyChallengeLevelIdsProvider);
    final currentDailyIndex = ref.watch(currentDailyChallengeIndexProvider);

    return levelsAsync.when(
      data: (levels) {
        if (levels.isEmpty) {
          return const Scaffold(body: Center(child: Text('No levels found')));
        }

        if (isDailyMode && dailyLevelIds.isNotEmpty) {
          final safeDailyIndex = currentDailyIndex.clamp(
            0,
            dailyLevelIds.length - 1,
          );
          final dailyLevelId = dailyLevelIds[safeDailyIndex];

          final dailyLevel = levels
              .where((level) => level.id == dailyLevelId)
              .cast()
              .firstOrNull;

          if (dailyLevel == null) {
            return const Scaffold(
              body: Center(child: Text('Daily challenge level not found')),
            );
          }

          return GameplayScreen(level: dailyLevel);
        }

        final mainLevels = levels
            .where((level) => level.id.startsWith('level_'))
            .toList();

        if (mainLevels.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('No main missions found')),
          );
        }

        final safeIndex = currentLevelIndex.clamp(0, mainLevels.length - 1);
        final level = mainLevels[safeIndex];

        return GameplayScreen(level: level);
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }
}
