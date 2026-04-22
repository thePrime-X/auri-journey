import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/coordinate.dart';
import '../../domain/models/direction.dart';
import '../../domain/models/execution_state.dart';
import '../../domain/models/execution_status.dart';
import '../../domain/models/level_state.dart';

class ExecutionStateNotifier extends Notifier<ExecutionState> {
  @override
  ExecutionState build() {
    return ExecutionState.initial(
      startPosition: const Coordinate(row: 0, col: 0),
    );
  }

  void resetFromLevel(LevelState level) {
    state = ExecutionState.initial(
      startPosition: level.startPosition,
      direction: level.startDirection,
    );
  }

  void applyExecutionState(ExecutionState newState) {
    state = newState;
  }

  void updatePosition(Coordinate position) {
    state = state.copyWith(currentPosition: position);
  }

  void updateDirection(Direction direction) {
    state = state.copyWith(direction: direction);
  }

  void updateStatus(ExecutionStatus status) {
    state = state.copyWith(status: status);
  }

  void setStepIndex(int index) {
    state = state.copyWith(currentStepIndex: index);
  }

  void incrementAttemptCount() {
    state = state.copyWith(attemptCount: state.attemptCount + 1);
  }
}
