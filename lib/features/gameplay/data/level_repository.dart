import '../domain/models/level_state.dart';
import 'level_mapper.dart';
import 'local_level_data_source.dart';

class LevelRepository {
  final LocalLevelDataSource localDataSource;

  const LevelRepository({required this.localDataSource});

  Future<List<LevelState>> getLocalLevels() async {
    final rawLevels = await localDataSource.loadLevelsJson();

    final levels = rawLevels.map(LevelMapper.fromJson).toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    return levels;
  }
}
