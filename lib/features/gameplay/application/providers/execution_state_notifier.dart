import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/command_type.dart';
import '../../domain/models/coordinate.dart';
import '../../domain/models/direction.dart';
import '../../domain/models/execution_state.dart';
import '../../domain/models/execution_status.dart';
import 'gameplay_providers.dart';

class ExecutionStateNotifier extends Notifier<ExecutionState> {
  @override
  ExecutionState build() {
    final level = ref.watch(levelStateProvider);

    return ExecutionState.initial(
      startPosition: level.startPosition,
    );
  }

  void resetFromLevel() {
    final level = ref.read(levelStateProvider);

    state = ExecutionState.initial(
      startPosition: level.startPosition,
    );
  }

  void addCommand(CommandType command) {
    state = state.copyWith(
      commandQueue: [...state.commandQueue, command],
    );
  }

  void removeCommandAt(int index) {
    if (index < 0 || index >= state.commandQueue.length) return;

    final updatedQueue = [...state.commandQueue]..removeAt(index);

    state = state.copyWith(
      commandQueue: updatedQueue,
    );
  }

  void clearCommands() {
    state = state.copyWith(
      commandQueue: [],
      currentStepIndex: 0,
      status: ExecutionStatus.idle,
    );
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
    state = state.copyWith(
      attemptCount: state.attemptCount + 1,
    );
  }
}