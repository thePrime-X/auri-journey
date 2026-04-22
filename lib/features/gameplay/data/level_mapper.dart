import '../domain/models/command_type.dart';
import '../domain/models/coordinate.dart';
import '../domain/models/direction.dart';
import '../domain/models/level_state.dart';

class LevelMapper {
  static LevelState fromJson(Map<String, dynamic> json) {
    return LevelState(
      id: json['id'] as String,
      title: json['title'] as String,
      order: json['order'] as int,
      isUnlockedByDefault: json['isUnlockedByDefault'] as bool,
      gridSize: json['gridSize'] as int,
      startPosition: _coordinateFromJson(
        json['startPosition'] as Map<String, dynamic>,
      ),
      startDirection: _directionFromString(json['startDirection'] as String),
      targetPosition: _coordinateFromJson(
        json['targetPosition'] as Map<String, dynamic>,
      ),
      obstacles: ((json['obstacles'] as List<dynamic>?) ?? [])
          .map((item) => _coordinateFromJson(item as Map<String, dynamic>))
          .toList(),
      availableCommands: (json['availableCommands'] as List<dynamic>)
          .map((item) => _commandFromString(item as String))
          .toList(),
      rewardXp: json['rewardXp'] as int,
      learningObjective: json['learningObjective'] as String,
      optimalSolution: (json['optimalSolution'] as List<dynamic>)
          .map((item) => _commandFromString(item as String))
          .toList(),
      reflectionPrompt: json['reflectionPrompt'] as String,
      firstFailureHint:
          (json['hints'] as Map<String, dynamic>)['first'] as String,
      repeatedFailureHint:
          (json['hints'] as Map<String, dynamic>)['repeat'] as String,
    );
  }

  static Coordinate _coordinateFromJson(Map<String, dynamic> json) {
    return Coordinate(row: json['row'] as int, col: json['col'] as int);
  }

  static Direction _directionFromString(String value) {
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
        throw Exception('Invalid direction: $value');
    }
  }

  static CommandType _commandFromString(String value) {
    switch (value) {
      case 'MOVE_FORWARD':
        return CommandType.moveForward;
      case 'TURN_LEFT':
        return CommandType.turnLeft;
      case 'TURN_RIGHT':
        return CommandType.turnRight;
      case 'IF_PATH_CLEAR':
        return CommandType.ifPathClear;
      case 'LOOP':
        return CommandType.loop;
      case 'LOOP_UNTIL':
        return CommandType.loopUntil;
      default:
        throw Exception('Invalid command: $value');
    }
  }
}
