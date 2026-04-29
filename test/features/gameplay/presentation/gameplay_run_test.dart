import 'package:auri_app/features/gameplay/application/command_sequence_provider.dart';
import 'package:auri_app/features/gameplay/application/gameplay_providers.dart';
import 'package:auri_app/features/gameplay/domain/models/command_type.dart';
import 'package:auri_app/features/gameplay/domain/models/coordinate.dart';
import 'package:auri_app/features/gameplay/domain/models/direction.dart';
import 'package:auri_app/features/gameplay/domain/models/execution_status.dart';
import 'package:auri_app/features/gameplay/domain/models/level_state.dart';
import 'package:auri_app/features/gameplay/presentation/pages/gameplay_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auri_app/features/profile/application/user_profile_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
  });

  const testLevel = LevelState(
    id: 'test_level',
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
    learningObjective: 'Test movement.',
    optimalSolution: [CommandType.moveForward, CommandType.moveForward],
    reflectionPrompt: 'What happened?',
    firstFailureHint: 'Try moving forward.',
    repeatedFailureHint: 'Move forward twice.',
  );

  testWidgets('RUN executes command sequence and reaches success', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        userProfileProvider.overrideWith((ref) {
          return Stream.value(null);
        }),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: GameplayScreen(level: testLevel)),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    container
        .read(commandSequenceProvider.notifier)
        .fillSlot(index: 0, command: CommandType.moveForward);

    container
        .read(commandSequenceProvider.notifier)
        .fillSlot(index: 1, command: CommandType.moveForward);

    await tester.pump();

    final runButton = find.text('▶ RUN');

    await tester.scrollUntilVisible(
      runButton,
      300,
      scrollable: find.byType(Scrollable).first,
    );

    await tester.tap(runButton);

    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 400));
    }

    final executionState = container.read(executionStateProvider);

    expect(executionState.currentPosition, const Coordinate(row: 0, col: 2));
    expect(executionState.status, ExecutionStatus.success);
  });
}
