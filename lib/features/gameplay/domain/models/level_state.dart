import 'package:flutter/foundation.dart';

import 'command_type.dart';
import 'coordinate.dart';
import 'direction.dart';

@immutable
class LevelState {
  final String id;
  final String title;
  final int order;
  final bool isUnlockedByDefault;
  final int gridSize;
  final Coordinate startPosition;
  final Direction startDirection;
  final Coordinate targetPosition;
  final List<Coordinate> obstacles;
  final List<CommandType> availableCommands;
  final int rewardXp;
  final String learningObjective;
  final List<CommandType> optimalSolution;
  final String reflectionPrompt;
  final String firstFailureHint;
  final String repeatedFailureHint;

  const LevelState({
    required this.id,
    required this.title,
    required this.order,
    required this.isUnlockedByDefault,
    required this.gridSize,
    required this.startPosition,
    required this.startDirection,
    required this.targetPosition,
    required this.obstacles,
    required this.availableCommands,
    required this.rewardXp,
    required this.learningObjective,
    required this.optimalSolution,
    required this.reflectionPrompt,
    required this.firstFailureHint,
    required this.repeatedFailureHint,
  });

  bool isWithinBounds(Coordinate coordinate) {
    return coordinate.row >= 0 &&
        coordinate.row < gridSize &&
        coordinate.col >= 0 &&
        coordinate.col < gridSize;
  }

  bool isObstacle(Coordinate coordinate) {
    return obstacles.contains(coordinate);
  }

  bool isTarget(Coordinate coordinate) {
    return coordinate == targetPosition;
  }

  LevelState copyWith({
    String? id,
    String? title,
    int? order,
    bool? isUnlockedByDefault,
    int? gridSize,
    Coordinate? startPosition,
    Direction? startDirection,
    Coordinate? targetPosition,
    List<Coordinate>? obstacles,
    List<CommandType>? availableCommands,
    int? rewardXp,
    String? learningObjective,
    List<CommandType>? optimalSolution,
    String? reflectionPrompt,
    String? firstFailureHint,
    String? repeatedFailureHint,
  }) {
    return LevelState(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
      isUnlockedByDefault: isUnlockedByDefault ?? this.isUnlockedByDefault,
      gridSize: gridSize ?? this.gridSize,
      startPosition: startPosition ?? this.startPosition,
      startDirection: startDirection ?? this.startDirection,
      targetPosition: targetPosition ?? this.targetPosition,
      obstacles: obstacles ?? this.obstacles,
      availableCommands: availableCommands ?? this.availableCommands,
      rewardXp: rewardXp ?? this.rewardXp,
      learningObjective: learningObjective ?? this.learningObjective,
      optimalSolution: optimalSolution ?? this.optimalSolution,
      reflectionPrompt: reflectionPrompt ?? this.reflectionPrompt,
      firstFailureHint: firstFailureHint ?? this.firstFailureHint,
      repeatedFailureHint: repeatedFailureHint ?? this.repeatedFailureHint,
    );
  }
}
