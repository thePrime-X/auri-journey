import 'package:flutter/foundation.dart';

import 'coordinate.dart';
import 'direction.dart';
import 'execution_status.dart';

@immutable
class ExecutionState {
  final Coordinate currentPosition;
  final Direction direction;
  final ExecutionStatus status;
  final int currentStepIndex;
  final int attemptCount;

  const ExecutionState({
    required this.currentPosition,
    required this.direction,
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
      status: ExecutionStatus.idle,
      currentStepIndex: 0,
      attemptCount: 0,
    );
  }

  bool get isIdle => status == ExecutionStatus.idle;
  bool get isRunning => status == ExecutionStatus.running;
  bool get isSuccess => status == ExecutionStatus.success;
  bool get isFailure => status == ExecutionStatus.failure;

  ExecutionState copyWith({
    Coordinate? currentPosition,
    Direction? direction,
    ExecutionStatus? status,
    int? currentStepIndex,
    int? attemptCount,
  }) {
    return ExecutionState(
      currentPosition: currentPosition ?? this.currentPosition,
      direction: direction ?? this.direction,
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
        other.status == status &&
        other.currentStepIndex == currentStepIndex &&
        other.attemptCount == attemptCount;
  }

  @override
  int get hashCode {
    return Object.hash(
      currentPosition,
      direction,
      status,
      currentStepIndex,
      attemptCount,
    );
  }
}
