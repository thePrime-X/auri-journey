import '../domain/models/command_type.dart';
import '../domain/models/coordinate.dart';
import '../domain/models/level_state.dart';

const sampleLevel = LevelState(
  id: 'level_1',
  title: 'First Step',
  gridSize: 5,
  startPosition: Coordinate(row: 4, col: 2),
  targetPosition: Coordinate(row: 2, col: 2),
  obstacles: [],
  availableCommands: [
    CommandType.moveForward,
    CommandType.turnLeft,
    CommandType.turnRight,
  ],
  rewardXp: 10,
);
