import 'package:flutter/foundation.dart';

import 'command_type.dart';
import 'coordinate.dart';

@immutable
class LevelState {
  final String id;
  final String title;
  final int gridSize;
  final Coordinate startPosition;
  final Coordinate targetPosition;
  final List<Coordinate> obstacles;
  final List<CommandType> availableCommands;
  final int rewardXp;

  const LevelState({
    required this.id,
    required this.title,
    required this.gridSize,
    required this.startPosition,
    required this.targetPosition,
    required this.obstacles,
    required this.availableCommands,
    required this.rewardXp,
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
    int? gridSize,
    Coordinate? startPosition,
    Coordinate? targetPosition,
    List<Coordinate>? obstacles,
    List<CommandType>? availableCommands,
    int? rewardXp,
  }) {
    return LevelState(
      id: id ?? this.id,
      title: title ?? this.title,
      gridSize: gridSize ?? this.gridSize,
      startPosition: startPosition ?? this.startPosition,
      targetPosition: targetPosition ?? this.targetPosition,
      obstacles: obstacles ?? this.obstacles,
      availableCommands: availableCommands ?? this.availableCommands,
      rewardXp: rewardXp ?? this.rewardXp,
    );
  }

  @override
  String toString() {
    return 'LevelState('
        'id: $id, '
        'title: $title, '
        'gridSize: $gridSize, '
        'startPosition: $startPosition, '
        'targetPosition: $targetPosition, '
        'obstacles: $obstacles, '
        'availableCommands: $availableCommands, '
        'rewardXp: $rewardXp'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LevelState &&
        other.id == id &&
        other.title == title &&
        other.gridSize == gridSize &&
        other.startPosition == startPosition &&
        other.targetPosition == targetPosition &&
        listEquals(other.obstacles, obstacles) &&
        listEquals(other.availableCommands, availableCommands) &&
        other.rewardXp == rewardXp;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      gridSize,
      startPosition,
      targetPosition,
      Object.hashAll(obstacles),
      Object.hashAll(availableCommands),
      rewardXp,
    );
  }
}