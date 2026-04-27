import 'package:auri_app/features/gameplay/application/hint_analyzer.dart';
import 'package:auri_app/features/gameplay/domain/models/command_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const analyzer = HintAnalyzer();

  const optimal = [
    CommandType.moveForward,
    CommandType.turnRight,
    CommandType.moveForward,
  ];

  group('HintAnalyzer', () {
    test('detects empty sequence', () {
      final result = analyzer.analyze(
        userCommands: const [],
        optimalSolution: optimal,
      );

      expect(result.type, HintErrorType.emptySequence);
      expect(result.incorrectIndex, null);
    });

    test('detects too short sequence', () {
      final result = analyzer.analyze(
        userCommands: const [CommandType.moveForward, CommandType.turnRight],
        optimalSolution: optimal,
      );

      expect(result.type, HintErrorType.tooShort);
      expect(result.incorrectIndex, null);
    });

    test('detects too long sequence', () {
      final result = analyzer.analyze(
        userCommands: const [
          CommandType.moveForward,
          CommandType.turnRight,
          CommandType.moveForward,
          CommandType.turnLeft,
        ],
        optimalSolution: optimal,
      );

      expect(result.type, HintErrorType.tooLong);
      expect(result.incorrectIndex, 3);
    });

    test('detects wrong command and index', () {
      final result = analyzer.analyze(
        userCommands: const [
          CommandType.moveForward,
          CommandType.turnLeft,
          CommandType.moveForward,
        ],
        optimalSolution: optimal,
      );

      expect(result.type, HintErrorType.wrongCommand);
      expect(result.incorrectIndex, 1);
    });

    test('detects correct sequence', () {
      final result = analyzer.analyze(
        userCommands: optimal,
        optimalSolution: optimal,
      );

      expect(result.type, HintErrorType.correct);
      expect(result.incorrectIndex, null);
    });
  });
}
