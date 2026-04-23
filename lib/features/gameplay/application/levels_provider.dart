import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/level_state.dart';
import '../domain/models/coordinate.dart';
import '../domain/models/command_type.dart';
import '../domain/models/direction.dart';
import '../application/firestore_provider.dart';

final levelsProvider = FutureProvider<List<LevelState>>((ref) async {
  try {
    final service = ref.read(levelsFirestoreServiceProvider);
    final firestoreData = await service.fetchLevels();

    return firestoreData
        .map<LevelState>((levelJson) => _parseLevel(levelJson))
        .toList();
  } catch (_) {
    final jsonString = await rootBundle.loadString('assets/data/levels.json');
    final List<dynamic> data = json.decode(jsonString);

    return data
        .map<LevelState>(
          (levelJson) => _parseLevel(levelJson as Map<String, dynamic>),
        )
        .toList();
  }
});

LevelState _parseLevel(Map<String, dynamic> levelJson) {
  final start = levelJson['startPosition'] as Map<String, dynamic>? ?? {};
  final target = levelJson['targetPosition'] as Map<String, dynamic>? ?? {};

  return LevelState(
    id: levelJson['id'] as String,
    title: levelJson['title'] as String,
    order: (levelJson['order'] as num).toInt(),
    isUnlockedByDefault: levelJson['isUnlockedByDefault'] as bool,
    gridSize: (levelJson['gridSize'] as num).toInt(),

    startPosition: Coordinate(
      row: (start['row'] as num).toInt(),
      col: (start['col'] as num).toInt(),
    ),

    startDirection: _parseDirection(levelJson['startDirection'] as String),

    targetPosition: Coordinate(
      row: (target['row'] as num).toInt(),
      col: (target['col'] as num).toInt(),
    ),

    obstacles: ((levelJson['obstacles'] ?? []) as List)
        .map(
          (o) => Coordinate(
            row: (o['row'] as num).toInt(),
            col: (o['col'] as num).toInt(),
          ),
        )
        .toList(),

    availableCommands: ((levelJson['availableCommands'] ?? []) as List)
        .map((c) => _parseCommand(c as String))
        .toList(),

    rewardXp: (levelJson['rewardXp'] as num).toInt(),

    learningObjective: levelJson['learningObjective'] as String,

    optimalSolution: ((levelJson['optimalSolution'] ?? []) as List)
        .map((c) => _parseCommand(c))
        .toList(),

    reflectionPrompt: levelJson['reflectionPrompt'] as String,

    firstFailureHint:
        levelJson['firstFailureHint']?.toString() ??
        levelJson['hints']?['first']?.toString() ??
        '',
    repeatedFailureHint:
        levelJson['repeatedFailureHint']?.toString() ??
        levelJson['hints']?['repeat']?.toString() ??
        '',
  );
}

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
