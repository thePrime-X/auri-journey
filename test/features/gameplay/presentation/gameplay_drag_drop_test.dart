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
    id: 'drag_test_level',
    title: 'Drag Test Level',
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
    learningObjective: 'Test drag/drop.',
    optimalSolution: [CommandType.moveForward, CommandType.moveForward],
    reflectionPrompt: 'What happened?',
    firstFailureHint: 'Try moving forward.',
    repeatedFailureHint: 'Move forward twice.',
  );

  testWidgets('adding command fills first empty sequence slot', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: GameplayScreen(level: testLevel)),
      ),
    );

    await tester.pumpAndSettle();

    expect(container.read(commandSequenceProvider), [null, null, null]);

    container
        .read(commandSequenceProvider.notifier)
        .addCommand(CommandType.moveForward);

    await tester.pump();

    expect(container.read(commandSequenceProvider)[0], CommandType.moveForward);
    expect(container.read(commandSequenceProvider)[1], null);
    expect(container.read(commandSequenceProvider)[2], null);
  });

  testWidgets('clear resets sequence to three empty slots', (tester) async {
    final container = ProviderContainer();

    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: GameplayScreen(level: testLevel)),
      ),
    );

    await tester.pumpAndSettle();

    container
        .read(commandSequenceProvider.notifier)
        .fillSlot(index: 0, command: CommandType.moveForward);

    container.read(commandSequenceProvider.notifier).addEmptySlot();

    await tester.pump();

    final clearButton = find.text('✕ CLEAR');

    await tester.scrollUntilVisible(
      clearButton,
      300,
      scrollable: find.byType(Scrollable).first,
    );

    await tester.tap(clearButton);
    await tester.pump();

    final sequence = container.read(commandSequenceProvider);

    expect(sequence, [null, null, null]);
  });
}
