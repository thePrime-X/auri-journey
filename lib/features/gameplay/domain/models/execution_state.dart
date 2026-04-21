import 'package:flutter/foundation.dart';

import 'command_type.dart';
import 'coordinate.dart';
import 'direction.dart';
import 'execution_status.dart';

@immutable
class ExecutionState {
  final Coordinate currentPosition;
  final Direction direction;
  final List<CommandType> commandQueue;
  final ExecutionStatus status;
  final int currentStepIndex;
  final int attemptCount;

  const ExecutionState({
    required this.currentPosition,
    required this.direction,
    required this.commandQueue,
    required this.status,
    required this.currentStepIndex,
    required this.attemptCount,
  });

  factory ExecutionState.initial({
    required Coordinate startPosition,
    Direction direction = Direction.up,
  }) {
    return ExecutionState(
      currentPosition: startPosition,
      direction: direction,
      commandQueue: const [],
      status: ExecutionStatus.idle,
      currentStepIndex: 0,
      attemptCount: 0,
    );
  }

  factory ExecutionState.fromCommandQueue({
    required Coordinate startPosition,
    Direction direction = Direction.up,
    required List<CommandType> commandQueue,
    int attemptCount = 0,
  }) {
    return ExecutionState(
      currentPosition: startPosition,
      direction: direction,
      commandQueue: List.unmodifiable(commandQueue),
      status: ExecutionStatus.running,
      currentStepIndex: 0,
      attemptCount: attemptCount,
    );
  }

  bool get isIdle => status == ExecutionStatus.idle;
  bool get isRunning => status == ExecutionStatus.running;
  bool get isSuccess => status == ExecutionStatus.success;
  bool get isFailure => status == ExecutionStatus.failure;

  CommandType? get currentCommand {
    if (currentStepIndex < 0 || currentStepIndex >= commandQueue.length) {
      return null;
    }
    return commandQueue[currentStepIndex];
  }

  ExecutionState copyWith({
    Coordinate? currentPosition,
    Direction? direction,
    List<CommandType>? commandQueue,
    ExecutionStatus? status,
    int? currentStepIndex,
    int? attemptCount,
  }) {
    return ExecutionState(
      currentPosition: currentPosition ?? this.currentPosition,
      direction: direction ?? this.direction,
      commandQueue: commandQueue ?? this.commandQueue,
      status: status ?? this.status,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      attemptCount: attemptCount ?? this.attemptCount,
    );
  }

  @override
  String toString() {
    return 'ExecutionState('
        'currentPosition: $currentPosition, '
        'direction: $direction, '
        'commandQueue: $commandQueue, '
        'status: $status, '
        'currentStepIndex: $currentStepIndex, '
        'attemptCount: $attemptCount'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExecutionState &&
        other.currentPosition == currentPosition &&
        other.direction == direction &&
        listEquals(other.commandQueue, commandQueue) &&
        other.status == status &&
        other.currentStepIndex == currentStepIndex &&
        other.attemptCount == attemptCount;
  }

  @override
  int get hashCode {
    return Object.hash(
      currentPosition,
      direction,
      Object.hashAll(commandQueue),
      status,
      currentStepIndex,
      attemptCount,
    );
  }
}
