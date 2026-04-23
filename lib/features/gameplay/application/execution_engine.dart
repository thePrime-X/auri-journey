import '../domain/models/command_type.dart';
import '../domain/models/coordinate.dart';
import '../domain/models/direction.dart';
import '../domain/models/execution_state.dart';
import '../domain/models/execution_status.dart';
import '../domain/models/level_state.dart';

class ExecutionEngine {
  const ExecutionEngine();

  List<ExecutionState> buildExecutionTrace({
    required LevelState level,
    required List<CommandType> commands,
    int attemptCount = 0,
  }) {
    final List<ExecutionState> trace = [];

    ExecutionState state = ExecutionState.initial(
      startPosition: level.startPosition,
      direction: level.startDirection,
    ).copyWith(attemptCount: attemptCount);

    trace.add(state);

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
            state = state.copyWith(status: ExecutionStatus.failure);
            trace.add(state);
            return trace;
          }

          state = state.copyWith(currentPosition: nextPosition);
          trace.add(state);

          if (level.isTarget(state.currentPosition)) {
            state = state.copyWith(status: ExecutionStatus.success);
            trace.add(state);
            return trace;
          }
          break;

        case CommandType.turnLeft:
          state = state.copyWith(direction: state.direction.turnLeft);
          trace.add(state);
          break;

        case CommandType.turnRight:
          state = state.copyWith(direction: state.direction.turnRight);
          trace.add(state);
          break;

        case CommandType.ifPathClear:
        case CommandType.loop:
        case CommandType.loopUntil:
          state = state.copyWith(status: ExecutionStatus.failure);
          trace.add(state);
          return trace;
      }
    }

    if (level.isTarget(state.currentPosition)) {
      state = state.copyWith(status: ExecutionStatus.success);
    } else {
      state = state.copyWith(status: ExecutionStatus.failure);
    }

    trace.add(state);
    return trace;
  }

  ExecutionState runSequence({
    required LevelState level,
    required List<CommandType> commands,
    int attemptCount = 0,
  }) {
    final trace = buildExecutionTrace(
      level: level,
      commands: commands,
      attemptCount: attemptCount,
    );

    return trace.last;
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
