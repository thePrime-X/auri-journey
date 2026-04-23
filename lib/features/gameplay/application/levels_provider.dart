import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/level_state.dart';
import '../domain/models/coordinate.dart';
import '../domain/models/command_type.dart';
import '../domain/models/direction.dart';

final levelsProvider = FutureProvider<List<LevelState>>((ref) async {
  final jsonString = await rootBundle.loadString('assets/data/levels.json');

  final List<dynamic> data = json.decode(jsonString);

  return data.map((levelJson) {
    return LevelState(
      id: levelJson['id'],
      title: levelJson['title'],
      order: levelJson['order'],
      isUnlockedByDefault: levelJson['isUnlockedByDefault'],
      gridSize: levelJson['gridSize'],
      startPosition: Coordinate(
        row: levelJson['startPosition']['row'],
        col: levelJson['startPosition']['col'],
      ),
      startDirection: _parseDirection(levelJson['startDirection']),
      targetPosition: Coordinate(
        row: levelJson['targetPosition']['row'],
        col: levelJson['targetPosition']['col'],
      ),
      obstacles: (levelJson['obstacles'] as List)
          .map((o) => Coordinate(row: o['row'], col: o['col']))
          .toList(),
      availableCommands: (levelJson['availableCommands'] as List)
          .map((c) => _parseCommand(c))
          .toList(),
      rewardXp: levelJson['rewardXp'],
      learningObjective: levelJson['learningObjective'],
      optimalSolution: (levelJson['optimalSolution'] as List)
          .map((c) => _parseCommand(c))
          .toList(),
      reflectionPrompt: levelJson['reflectionPrompt'],
      firstFailureHint: levelJson['hints']?['first']?.toString() ?? '',
      repeatedFailureHint: levelJson['hints']?['repeat']?.toString() ?? '',
    );
  }).toList();
});

Direction _parseDirection(String value) {
  switch (value) {
    case 'UP':
      return Direction.up;
    case 'RIGHT':
      return Direction.right;
    case 'DOWN':
      return Direction.down;
    case 'LEFT':
      return Direction.left;
    default:
      return Direction.up;
  }
}

CommandType _parseCommand(String value) {
  switch (value) {
    case 'MOVE_FORWARD':
      return CommandType.moveForward;
    case 'TURN_LEFT':
      return CommandType.turnLeft;
    case 'TURN_RIGHT':
      return CommandType.turnRight;
    default:
      return CommandType.moveForward;
  }
}
