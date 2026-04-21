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
      gridSize: 5,
      startPosition: Coordinate(row: 2, col: 2),
      targetPosition: Coordinate(row: 0, col: 2),
      obstacles: [],
      availableCommands: [
        CommandType.moveForward,
        CommandType.turnLeft,
        CommandType.turnRight,
      ],
      rewardXp: 10,
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
          gridSize: 5,
          startPosition: Coordinate(row: 2, col: 2),
          targetPosition: Coordinate(row: 0, col: 2),
          obstacles: [Coordinate(row: 1, col: 2)],
          availableCommands: [
            CommandType.moveForward,
            CommandType.turnLeft,
            CommandType.turnRight,
          ],
          rewardXp: 10,
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
          gridSize: 5,
          startPosition: Coordinate(row: 0, col: 2),
          targetPosition: Coordinate(row: 4, col: 4),
          obstacles: [],
          availableCommands: [
            CommandType.moveForward,
            CommandType.turnLeft,
            CommandType.turnRight,
          ],
          rewardXp: 10,
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
          gridSize: 5,
          startPosition: Coordinate(row: 2, col: 2),
          targetPosition: Coordinate(row: 0, col: 2),
          obstacles: [Coordinate(row: 1, col: 2)],
          availableCommands: [
            CommandType.moveForward,
            CommandType.turnLeft,
            CommandType.turnRight,
          ],
          rewardXp: 10,
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

      test('stores command queue correctly', () {
        const commands = [CommandType.moveForward, CommandType.turnLeft];

        final result = engine.runSequence(level: baseLevel, commands: commands);

        expect(result.commandQueue, commands);
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
