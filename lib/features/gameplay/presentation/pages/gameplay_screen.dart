import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/current_level_provider.dart';
import '../../application/levels_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/command_sequence_provider.dart';
import '../../application/execution_engine_provider.dart';
import '../../application/gameplay_providers.dart';
import '../../domain/models/command_type.dart';
import '../../domain/models/coordinate.dart';
import '../../domain/models/execution_status.dart';
import '../../domain/models/level_state.dart';
import '../widgets/command_block.dart';
import '../widgets/command_palette.dart';
import '../widgets/game_action_bar.dart';
import '../widgets/game_grid.dart';

class GameplayScreen extends ConsumerStatefulWidget {
  final LevelState level;

  const GameplayScreen({super.key, required this.level});

  @override
  ConsumerState<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends ConsumerState<GameplayScreen> {
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(executionStateProvider.notifier).resetFromLevel(widget.level);
      ref.read(commandSequenceProvider.notifier).clearSequence();
    });
  }

  @override
  void didUpdateWidget(covariant GameplayScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.level.id != widget.level.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(executionStateProvider.notifier).resetFromLevel(widget.level);
        ref.read(commandSequenceProvider.notifier).clearSequence();
      });
    }
  }

Future<void> _showSuccessDialog() async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.bg2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Text(
              '✅',
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Level Complete',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Auri reached the goal.\n\n+${widget.level.rewardXp} XP earned',
          style: const TextStyle(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cyan,
              foregroundColor: Colors.black,
            ),
            child: const Text(
              'Next Level',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> _showAllLevelsCompletedDialog() async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.bg2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Text(
              '🎉',
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'All Levels Completed',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          'Congratulations! You completed all available levels.\n\nYou can replay the final level as many times as you want.',
          style: TextStyle(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cyan,
              foregroundColor: Colors.black,
            ),
            child: const Text(
              'Replay Level 5',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      );
    },
  );
}

  Future<void> _showFailureDialog({required String hint}) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.bg2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Text('⚠️', style: TextStyle(fontSize: 22)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Mission Failed',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            hint,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _runSequenceAnimated() async {
    if (_isAnimating) return;

    final sequence = ref.read(commandSequenceProvider);
    final commands = sequence.whereType<CommandType>().toList();

    if (commands.isEmpty) return;

    setState(() {
      _isAnimating = true;
    });

    final executionNotifier = ref.read(executionStateProvider.notifier);
    final currentExecution = ref.read(executionStateProvider);
    final engine = ref.read(executionEngineProvider);

    executionNotifier.resetFromLevel(widget.level);
    executionNotifier.incrementAttemptCount();

    final nextAttemptCount = currentExecution.attemptCount + 1;

    final trace = engine.buildExecutionTrace(
      level: widget.level,
      commands: commands,
      attemptCount: nextAttemptCount,
    );

    for (final step in trace) {
      executionNotifier.applyExecutionState(step);
      await Future.delayed(const Duration(milliseconds: 350));
    }

    final finalState = trace.last;

    if (mounted) {
      setState(() {
        _isAnimating = false;
      });
    }

    if (!mounted) return;

    if (finalState.status == ExecutionStatus.success) {
      final levels = await ref.read(levelsProvider.future);
      final currentIndex = ref.read(currentLevelIndexProvider);
      final isLastLevel = currentIndex >= levels.length - 1;

      if (isLastLevel) {
        await _showAllLevelsCompletedDialog();

        ref.read(currentLevelIndexProvider.notifier).state = levels.length - 1;
        ref.read(executionStateProvider.notifier).resetFromLevel(widget.level);
        ref.read(commandSequenceProvider.notifier).clearSequence();
      } else {
        await _showSuccessDialog();

        ref.read(currentLevelIndexProvider.notifier).state = currentIndex + 1;
      }
    } else if (finalState.status == ExecutionStatus.failure) {
      final hint = nextAttemptCount <= 1
          ? widget.level.firstFailureHint
          : widget.level.repeatedFailureHint;

      ref.read(executionStateProvider.notifier).resetFromLevel(widget.level);

      await _showFailureDialog(hint: hint);
    }
  }

  void _exitToDashboard() {
    if (_isAnimating) return;
    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final executionState = ref.watch(executionStateProvider);
    final Coordinate auriPosition = executionState.currentPosition;
    final auriDirection = executionState.direction;
    final sequence = ref.watch(commandSequenceProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: _exitToDashboard,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.bg3,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SECTOR 1',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.level.title,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.bolt, color: AppColors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '2,289',
                      style: TextStyle(
                        color: AppColors.amber,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'EXECUTION GRID · ${widget.level.gridSize}×${widget.level.gridSize}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 1,
              child: GameGrid(
                level: widget.level,
                auriPosition: auriPosition,
                auriDirection: auriDirection,
                showTrainingZone: false,
              ),
            ),
            const SizedBox(height: 20),
            CommandPalette(commands: widget.level.availableCommands),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.bg3.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.border2.withValues(alpha: 0.6),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Sequence',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_isAnimating) return;
                          ref
                              .read(commandSequenceProvider.notifier)
                              .clearSequence();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.red.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: AppColors.red.withValues(alpha: 0.30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.red.withValues(alpha: 0.18),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Text(
                            '✕ CLEAR',
                            style: TextStyle(
                              color: AppColors.red,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bg.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: SizedBox(
                      height: 52,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: sequence.length + 1,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          if (index < sequence.length) {
                            final item = sequence[index];

                            if (item == null) {
                              return DragTarget<Object>(
                                onWillAcceptWithDetails: (details) =>
                                    !_isAnimating,
                                onAcceptWithDetails: (details) {
                                  final data = details.data;

                                  if (data is _DraggedCommandData) {
                                    ref
                                        .read(commandSequenceProvider.notifier)
                                        .moveCommandToEmptySlot(
                                          fromIndex: data.sequenceIndex,
                                          toIndex: index,
                                        );
                                  } else if (data is CommandType) {
                                    ref
                                        .read(commandSequenceProvider.notifier)
                                        .fillSlot(index: index, command: data);
                                  }
                                },
                                builder:
                                    (context, candidateData, rejectedData) {
                                      final isHovering =
                                          candidateData.isNotEmpty;

                                      return AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 120,
                                        ),
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: isHovering
                                              ? AppColors.cyan.withValues(
                                                  alpha: 0.10,
                                                )
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: isHovering
                                                ? AppColors.cyan
                                                : AppColors.textMuted
                                                      .withValues(alpha: 0.22),
                                            width: isHovering ? 2 : 1,
                                          ),
                                        ),
                                      );
                                    },
                              );
                            }

                            return LongPressDraggable<_DraggedCommandData>(
                              data: _DraggedCommandData(
                                command: item,
                                sequenceIndex: index,
                              ),
                              maxSimultaneousDrags: _isAnimating ? 0 : 1,
                              feedback: Material(
                                color: Colors.transparent,
                                child: Opacity(
                                  opacity: 0.95,
                                  child: CommandBlock(
                                    command: item,
                                    isSmall: true,
                                  ),
                                ),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.35,
                                child: CommandBlock(
                                  command: item,
                                  isSmall: true,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (_isAnimating) return;
                                  ref
                                      .read(commandSequenceProvider.notifier)
                                      .removeCommandAt(index);
                                },
                                child: CommandBlock(
                                  command: item,
                                  isSmall: true,
                                ),
                              ),
                            );
                          }

                          return CommandBlock(
                            isSmall: true,
                            isAddPlaceholder: true,
                            onTap: () {
                              if (_isAnimating) return;
                              ref
                                  .read(commandSequenceProvider.notifier)
                                  .addEmptySlot();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            GameActionBar(
              onRun: _runSequenceAnimated,
              onExit: _exitToDashboard,
              isBusy: _isAnimating,
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.bg3,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.cyan.withValues(alpha: 0.35),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'ECHO SAYS',
                          style: TextStyle(
                            color: AppColors.cyan,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.cyan.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lightbulb,
                              color: AppColors.amber,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Hints',
                              style: TextStyle(
                                color: AppColors.cyan,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Goal: guide Auri from ${widget.level.startPosition.row},${widget.level.startPosition.col} to ${widget.level.targetPosition.row},${widget.level.targetPosition.col}.',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DraggedCommandData {
  final CommandType command;
  final int sequenceIndex;

  const _DraggedCommandData({
    required this.command,
    required this.sequenceIndex,
  });
}
