import '../domain/models/command_type.dart';
import '../domain/models/coordinate.dart';
import '../domain/models/direction.dart';
import '../domain/models/execution_state.dart';
import '../domain/models/execution_status.dart';
import '../domain/models/level_state.dart';

class ExecutionEngine {
  const ExecutionEngine();

  ExecutionState runSequence({
    required LevelState level,
    required List<CommandType> commands,
    Direction startDirection = Direction.up,
    int attemptCount = 0,
  }) {
    ExecutionState state = ExecutionState.fromCommandQueue(
      startPosition: level.startPosition,
      direction: startDirection,
      commandQueue: commands,
      attemptCount: attemptCount,
    );

    for (int i = 0; i < commands.length; i++) {
      final command = commands[i];

      state = state.copyWith(
        currentStepIndex: i,
        status: ExecutionStatus.running,
      );

      switch (command) {
        case CommandType.moveForward:
          final nextPosition = _getNextForwardPosition(
            currentPosition: state.currentPosition,
            direction: state.direction,
          );

          final hasCollision = checkCollision(
            level: level,
            nextPosition: nextPosition,
          );

          if (hasCollision) {
            return state.copyWith(status: ExecutionStatus.failure);
          }

          state = state.copyWith(currentPosition: nextPosition);

          if (level.isTarget(state.currentPosition)) {
            return state.copyWith(status: ExecutionStatus.success);
          }
          break;

        case CommandType.turnLeft:
          state = state.copyWith(direction: state.direction.turnLeft);
          break;

        case CommandType.turnRight:
          state = state.copyWith(direction: state.direction.turnRight);
          break;

        case CommandType.ifPathClear:
        case CommandType.loop:
        case CommandType.loopUntil:
          return state.copyWith(status: ExecutionStatus.failure);
      }
    }

    if (level.isTarget(state.currentPosition)) {
      return state.copyWith(status: ExecutionStatus.success);
    }

    return state.copyWith(status: ExecutionStatus.failure);
  }

  bool checkCollision({
    required LevelState level,
    required Coordinate nextPosition,
  }) {
    if (!level.isWithinBounds(nextPosition)) {
      return true;
    }

    if (level.isObstacle(nextPosition)) {
      return true;
    }

    return false;
  }

  Coordinate _getNextForwardPosition({
    required Coordinate currentPosition,
    required Direction direction,
  }) {
    switch (direction) {
      case Direction.up:
        return currentPosition.translate(rowOffset: -1);
      case Direction.right:
        return currentPosition.translate(colOffset: 1);
      case Direction.down:
        return currentPosition.translate(rowOffset: 1);
      case Direction.left:
        return currentPosition.translate(colOffset: -1);
    }
  }
}
