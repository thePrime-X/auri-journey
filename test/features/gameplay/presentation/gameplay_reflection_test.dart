import 'package:auri_app/features/gameplay/application/command_sequence_provider.dart';
import 'package:auri_app/features/gameplay/domain/models/command_type.dart';
import 'package:auri_app/features/gameplay/domain/models/coordinate.dart';
import 'package:auri_app/features/gameplay/domain/models/direction.dart';
import 'package:auri_app/features/gameplay/domain/models/level_state.dart';
import 'package:auri_app/features/gameplay/presentation/pages/gameplay_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testLevel = LevelState(
    id: 'reflection_test_level',
    title: 'Reflection Test Level',
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
    learningObjective: 'Test reflection.',
    optimalSolution: [CommandType.moveForward, CommandType.moveForward],
    reflectionPrompt: 'What happened when Auri moved the wrong way?',
    firstFailureHint: 'Try moving toward the goal.',
    repeatedFailureHint: 'Move forward twice.',
  );

  testWidgets(
    'second failed attempt shows reflection modal before hint overlay',
    (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: GameplayScreen(level: testLevel)),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      container
          .read(commandSequenceProvider.notifier)
          .fillSlot(index: 0, command: CommandType.turnLeft);

      await tester.pump();

      final runButton = find.text('▶ RUN');

      await tester.scrollUntilVisible(
        runButton,
        300,
        scrollable: find.byType(Scrollable).first,
      );

      await tester.tap(runButton);

      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 600));
      }

      expect(find.text('MISSION FAILED'), findsOneWidget);
      expect(find.text('PAUSE & THINK'), findsNothing);

      await tester.tap(find.text('↻ Try Again'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      container
          .read(commandSequenceProvider.notifier)
          .fillSlot(index: 0, command: CommandType.turnLeft);

      await tester.pump();

      await tester.scrollUntilVisible(
        runButton,
        300,
        scrollable: find.byType(Scrollable).first,
      );

      await tester.tap(runButton);

      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 600));
      }

      expect(find.text('PAUSE & THINK'), findsOneWidget);
      expect(
        find.text('What happened when Auri moved the wrong way?'),
        findsOneWidget,
      );

      expect(find.text('MISSION FAILED'), findsNothing);
    },
  );
}
