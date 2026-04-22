import 'package:auri_app/features/gameplay/application/execution_engine.dart';
import 'package:auri_app/features/gameplay/domain/models/command_type.dart';
import 'package:auri_app/features/gameplay/domain/models/coordinate.dart';
import 'package:auri_app/features/gameplay/domain/models/direction.dart';
import 'package:auri_app/features/gameplay/domain/models/execution_status.dart';
import 'package:auri_app/features/gameplay/domain/models/level_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExecutionEngine', () {
    const engine = ExecutionEngine();

    const baseLevel = LevelState(
      id: 'level_1',
      title: 'Test Level',
      order: 1,
      isUnlockedByDefault: true,
      gridSize: 5,
      startPosition: Coordinate(row: 2, col: 2),
      startDirection: Direction.up,
      targetPosition: Coordinate(row: 0, col: 2),
      obstacles: [],
      availableCommands: [
        CommandType.moveForward,
        CommandType.turnLeft,
        CommandType.turnRight,
      ],
      rewardXp: 10,
      learningObjective: 'Test movement and turning.',
      optimalSolution: [CommandType.moveForward, CommandType.moveForward],
      reflectionPrompt: 'What happened?',
      firstFailureHint: 'Try moving forward.',
      repeatedFailureHint: 'Move up toward the goal.',
    );

    group('checkCollision', () {
      test(
        'returns false when next position is inside bounds and not obstacle',
        () {
          const nextPosition = Coordinate(row: 1, col: 2);

          final result = engine.checkCollision(
            level: baseLevel,
            nextPosition: nextPosition,
          );

          expect(result, false);
        },
      );

      test('returns true when next position is outside upper bound', () {
        const nextPosition = Coordinate(row: -1, col: 2);

        final result = engine.checkCollision(
          level: baseLevel,
          nextPosition: nextPosition,
        );

        expect(result, true);
      });

      test('returns true when next position is outside lower bound', () {
        const nextPosition = Coordinate(row: 5, col: 2);

        final result = engine.checkCollision(
          level: baseLevel,
          nextPosition: nextPosition,
        );

        expect(result, true);
      });

      test('returns true when next position is outside left bound', () {
        const nextPosition = Coordinate(row: 2, col: -1);

        final result = engine.checkCollision(
          level: baseLevel,
          nextPosition: nextPosition,
        );

        expect(result, true);
      });

      test('returns true when next position is outside right bound', () {
        const nextPosition = Coordinate(row: 2, col: 5);

        final result = engine.checkCollision(
          level: baseLevel,
          nextPosition: nextPosition,
        );

        expect(result, true);
      });

      test('returns true when next position is an obstacle', () {
        const levelWithObstacle = LevelState(
          id: 'level_2',
          title: 'Obstacle Level',
          order: 2,
          isUnlockedByDefault: false,
          gridSize: 5,
          startPosition: Coordinate(row: 2, col: 2),
          startDirection: Direction.up,
          targetPosition: Coordinate(row: 0, col: 2),
          obstacles: [Coordinate(row: 1, col: 2)],
          availableCommands: [
            CommandType.moveForward,
            CommandType.turnLeft,
            CommandType.turnRight,
          ],
          rewardXp: 10,
          learningObjective: 'Avoid obstacle.',
          optimalSolution: const [],
          reflectionPrompt: 'What blocked you?',
          firstFailureHint: 'There is an obstacle ahead.',
          repeatedFailureHint: 'Go around it.',
        );

        const nextPosition = Coordinate(row: 1, col: 2);

        final result = engine.checkCollision(
          level: levelWithObstacle,
          nextPosition: nextPosition,
        );

        expect(result, true);
      });
    });

    group('runSequence', () {
      test('moves forward correctly when facing up', () {
        final result = engine.runSequence(
          level: baseLevel,
          commands: const [CommandType.moveForward],
        );

        expect(result.currentPosition, const Coordinate(row: 1, col: 2));
        expect(result.direction, Direction.up);
        expect(result.status, ExecutionStatus.failure);
      });

      test('turnLeft changes direction correctly', () {
        final result = engine.runSequence(
          level: baseLevel,
          commands: const [CommandType.turnLeft],
        );

        expect(result.currentPosition, const Coordinate(row: 2, col: 2));
        expect(result.direction, Direction.left);
        expect(result.status, ExecutionStatus.failure);
      });

      test('turnRight changes direction correctly', () {
        final result = engine.runSequence(
          level: baseLevel,
          commands: const [CommandType.turnRight],
        );

        expect(result.currentPosition, const Coordinate(row: 2, col: 2));
        expect(result.direction, Direction.right);
        expect(result.status, ExecutionStatus.failure);
      });

      test('executes multiple commands in order', () {
        final result = engine.runSequence(
          level: baseLevel,
          commands: const [
            CommandType.turnRight,
            CommandType.moveForward,
            CommandType.moveForward,
          ],
        );

        expect(result.currentPosition, const Coordinate(row: 2, col: 4));
        expect(result.direction, Direction.right);
        expect(result.status, ExecutionStatus.failure);
      });

      test('returns success when target is reached', () {
        final result = engine.runSequence(
          level: baseLevel,
          commands: const [CommandType.moveForward, CommandType.moveForward],
        );

        expect(result.currentPosition, const Coordinate(row: 0, col: 2));
        expect(result.status, ExecutionStatus.success);
      });

      test('returns failure when collision happens with boundary', () {
        const boundaryLevel = LevelState(
          id: 'level_4',
          title: 'Boundary Collision',
          order: 4,
          isUnlockedByDefault: false,
          gridSize: 5,
          startPosition: Coordinate(row: 0, col: 2),
          startDirection: Direction.up,
          targetPosition: Coordinate(row: 4, col: 4),
          obstacles: [],
          availableCommands: [
            CommandType.moveForward,
            CommandType.turnLeft,
            CommandType.turnRight,
          ],
          rewardXp: 10,
          learningObjective: 'Boundary collision test.',
          optimalSolution: const [],
          reflectionPrompt: 'What happened at the edge?',
          firstFailureHint: 'You hit the boundary.',
          repeatedFailureHint: 'Do not move outside the grid.',
        );

        final result = engine.runSequence(
          level: boundaryLevel,
          commands: const [CommandType.moveForward],
        );

        expect(result.currentPosition, const Coordinate(row: 0, col: 2));
        expect(result.status, ExecutionStatus.failure);
      });

      test('returns failure when collision happens with obstacle', () {
        const levelWithObstacle = LevelState(
          id: 'level_3',
          title: 'Obstacle Collision',
          order: 3,
          isUnlockedByDefault: false,
          gridSize: 5,
          startPosition: Coordinate(row: 2, col: 2),
          startDirection: Direction.up,
          targetPosition: Coordinate(row: 0, col: 2),
          obstacles: [Coordinate(row: 1, col: 2)],
          availableCommands: [
            CommandType.moveForward,
            CommandType.turnLeft,
            CommandType.turnRight,
          ],
          rewardXp: 10,
          learningObjective: 'Obstacle collision test.',
          optimalSolution: const [],
          reflectionPrompt: 'What blocked you?',
          firstFailureHint: 'There is something ahead.',
          repeatedFailureHint: 'Try another route.',
        );

        final result = engine.runSequence(
          level: levelWithObstacle,
          commands: const [CommandType.moveForward],
        );

        expect(result.currentPosition, const Coordinate(row: 2, col: 2));
        expect(result.status, ExecutionStatus.failure);
      });

      test('keeps attemptCount from input', () {
        final result = engine.runSequence(
          level: baseLevel,
          commands: const [CommandType.turnLeft],
          attemptCount: 3,
        );

        expect(result.attemptCount, 3);
      });

      test('uses level startDirection by default', () {
        const rightFacingLevel = LevelState(
          id: 'level_right',
          title: 'Right Facing Level',
          order: 6,
          isUnlockedByDefault: false,
          gridSize: 5,
          startPosition: Coordinate(row: 2, col: 2),
          startDirection: Direction.right,
          targetPosition: Coordinate(row: 2, col: 3),
          obstacles: [],
          availableCommands: [
            CommandType.moveForward,
            CommandType.turnLeft,
            CommandType.turnRight,
          ],
          rewardXp: 10,
          learningObjective: 'Start direction test.',
          optimalSolution: [CommandType.moveForward],
          reflectionPrompt: 'Which way was Auri facing?',
          firstFailureHint: 'Auri starts facing right.',
          repeatedFailureHint: 'Move forward once.',
        );

        final result = engine.runSequence(
          level: rightFacingLevel,
          commands: const [CommandType.moveForward],
        );

        expect(result.currentPosition, const Coordinate(row: 2, col: 3));
        expect(result.direction, Direction.right);
        expect(result.status, ExecutionStatus.success);
      });

      test('unsupported future commands return failure', () {
        final result = engine.runSequence(
          level: baseLevel,
          commands: const [CommandType.loop],
        );

        expect(result.status, ExecutionStatus.failure);
      });
    });
  });
}
