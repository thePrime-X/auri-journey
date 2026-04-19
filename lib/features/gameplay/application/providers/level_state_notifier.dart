import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/command_type.dart';
import '../../domain/models/coordinate.dart';
import '../../domain/models/level_state.dart';

class LevelStateNotifier extends Notifier<LevelState> {
  @override
  LevelState build() {
    return const LevelState(
      id: 'S1_L1',
      title: 'Restore the Path',
      gridSize: 5,
      startPosition: Coordinate(row: 2, col: 1),
      targetPosition: Coordinate(row: 2, col: 4),
      obstacles: [Coordinate(row: 1, col: 3), Coordinate(row: 3, col: 3)],
      availableCommands: [
        CommandType.moveForward,
        CommandType.turnLeft,
        CommandType.turnRight,
      ],
      rewardXp: 50,
    );
  }

  void setLevel(LevelState level) {
    state = level;
  }
}
