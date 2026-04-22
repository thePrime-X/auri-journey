import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/level_repository.dart';
import '../data/local_level_data_source.dart';
import '../domain/models/level_state.dart';

final localLevelDataSourceProvider = Provider<LocalLevelDataSource>((ref) {
  return const LocalLevelDataSource();
});

final levelRepositoryProvider = Provider<LevelRepository>((ref) {
  return LevelRepository(
    localDataSource: ref.read(localLevelDataSourceProvider),
  );
});

final levelsProvider = FutureProvider<List<LevelState>>((ref) async {
  final repository = ref.read(levelRepositoryProvider);
  return repository.getLocalLevels();
});
