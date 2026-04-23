import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/current_level_provider.dart';
import '../../application/levels_provider.dart';
import 'gameplay_screen.dart';

class GameplayLoaderScreen extends ConsumerWidget {
  const GameplayLoaderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelsAsync = ref.watch(levelsProvider);
    final currentLevelIndex = ref.watch(currentLevelIndexProvider);

    return levelsAsync.when(
      data: (levels) {
        if (levels.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text('No levels found'),
            ),
          );
        }

        final safeIndex = currentLevelIndex.clamp(0, levels.length - 1);
        final level = levels[safeIndex];

        return GameplayScreen(level: level);
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}