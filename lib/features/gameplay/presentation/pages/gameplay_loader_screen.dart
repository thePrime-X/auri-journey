import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/levels_provider.dart';
import 'gameplay_screen.dart';

class GameplayLoaderScreen extends ConsumerWidget {
  const GameplayLoaderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelsAsync = ref.watch(levelsProvider);

    return levelsAsync.when(
      data: (levels) {
        if (levels.isEmpty) {
          return const Scaffold(
            backgroundColor: AppColors.bg,
            body: Center(
              child: Text(
                'No levels found.',
                style: TextStyle(color: AppColors.textPrimary),
              ),
            ),
          );
        }

        return GameplayScreen(level: levels.first);
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(child: CircularProgressIndicator(color: AppColors.cyan)),
      ),
      error: (error, stackTrace) => Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Failed to load levels:\n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.red),
            ),
          ),
        ),
      ),
    );
  }
}
