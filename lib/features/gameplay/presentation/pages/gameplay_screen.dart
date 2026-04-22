import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/command_sequence_provider.dart';
import '../../domain/models/command_type.dart';
import '../../domain/models/coordinate.dart';
import '../../domain/models/level_state.dart';
import '../widgets/command_block.dart';
import '../widgets/command_palette.dart';
import '../widgets/game_action_bar.dart';
import '../widgets/game_grid.dart';

class GameplayScreen extends ConsumerWidget {
  final LevelState level;

  const GameplayScreen({super.key, required this.level});

  Future<void> _showInsertCommandSheet(
    BuildContext context,
    WidgetRef ref,
    List<CommandType> availableCommands,
    int insertIndex,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.bg2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Insert Command',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Choose a command to add to the sequence.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: availableCommands.map((command) {
                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(commandSequenceProvider.notifier)
                          .insertCommand(index: insertIndex, command: command);
                      Navigator.of(context).pop();
                    },
                    child: CommandBlock(command: command),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final demoLevel = level.copyWith(
      startPosition: const Coordinate(row: 3, col: 2),
      targetPosition: const Coordinate(row: 2, col: 2),
      obstacles: const [],
    );

    final Coordinate auriPosition = const Coordinate(row: 3, col: 2);
    final sequence = ref.watch(commandSequenceProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Container(
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
                        demoLevel.title,
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
            const Text(
              'EXECUTION GRID · 3×3 TRAINING ZONE',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            GameGrid(level: demoLevel, auriPosition: auriPosition),
            const SizedBox(height: 20),
            CommandPalette(commands: demoLevel.availableCommands),
            const SizedBox(height: 16),
            DragTarget<CommandType>(
              onWillAcceptWithDetails: (details) => true,
              onAcceptWithDetails: (details) {
                ref
                    .read(commandSequenceProvider.notifier)
                    .addCommand(details.data);
              },
              builder: (context, candidateData, rejectedData) {
                final isHovering = candidateData.isNotEmpty;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isHovering
                        ? AppColors.cyan.withValues(alpha: 0.08)
                        : AppColors.bg3.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isHovering
                          ? AppColors.cyan.withValues(alpha: 0.55)
                          : AppColors.border2.withValues(alpha: 0.6),
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
                              ref
                                  .read(commandSequenceProvider.notifier)
                                  .clearSequence();
                            },
                            child: Text(
                              '✕ CLEAR',
                              style: TextStyle(
                                color: AppColors.textMuted.withValues(
                                  alpha: 0.75,
                                ),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
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
                          border: isHovering
                              ? Border.all(
                                  color: AppColors.cyan.withValues(alpha: 0.35),
                                )
                              : null,
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: sequence.length * 2 + 1,
                          itemBuilder: (context, index) {
                            // EVEN index = SLOT (+)
                            if (index.isEven) {
                              final insertIndex = index ~/ 2;

                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: DragTarget<CommandType>(
                                  onWillAcceptWithDetails: (details) => true,
                                  onAcceptWithDetails: (details) {
                                    ref
                                        .read(commandSequenceProvider.notifier)
                                        .insertCommand(
                                          index: insertIndex,
                                          command: details.data,
                                        );
                                  },
                                  builder:
                                      (context, candidateData, rejectedData) {
                                        final isHovering =
                                            candidateData.isNotEmpty;

                                        return AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 120,
                                          ),
                                          decoration: isHovering
                                              ? BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: AppColors.cyan,
                                                    width: 2,
                                                  ),
                                                )
                                              : null,
                                          child: CommandBlock(
                                            isSmall: true,
                                            isAddPlaceholder: true,
                                            onTap: () {
                                              _showInsertCommandSheet(
                                                context,
                                                ref,
                                                demoLevel.availableCommands,
                                                insertIndex,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                ),
                              );
                            }

                            // ODD index = COMMAND
                            final commandIndex = index ~/ 2;

                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: CommandBlock(
                                command: sequence[commandIndex],
                                isSmall: true,
                              ),
                            );
                          },
                        ),
                      ),
                      if (isHovering) ...[
                        const SizedBox(height: 10),
                        const Text(
                          'Drop command here',
                          style: TextStyle(
                            color: AppColors.cyan,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            const GameActionBar(),
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
                  const Text(
                    'Start small: drag command blocks into the sequence zone or tap the + button to insert them.',
                    style: TextStyle(
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
