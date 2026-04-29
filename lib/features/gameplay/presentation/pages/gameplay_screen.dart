import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/firestore_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/command_sequence_provider.dart';
import '../../application/current_level_provider.dart';
import '../../application/execution_engine_provider.dart';
import '../../application/gameplay_providers.dart';
import '../../application/levels_provider.dart';
import '../../domain/models/command_type.dart';
import '../../domain/models/coordinate.dart';
import '../../domain/models/execution_status.dart';
import '../../domain/models/level_state.dart';
import '../widgets/command_block.dart';
import '../widgets/command_palette.dart';
import '../widgets/game_action_bar.dart';
import '../widgets/game_grid.dart';
import 'mission_complete_screen.dart';
import '../../application/hint_analyzer.dart';
import '../../../../core/services/offline_progress_queue_provider.dart';
import '../../../../features/profile/application/user_profile_provider.dart';

class GameplayScreen extends ConsumerStatefulWidget {
  final LevelState level;

  const GameplayScreen({super.key, required this.level});

  @override
  ConsumerState<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends ConsumerState<GameplayScreen> {
  bool _isAnimating = false;
  String? _latestEchoHint;
  bool _latestHintIsRepeated = false;
  int _hintsUsed = 0;
  bool _usedExactHint = false;
  late DateTime _levelStartedAt;

  @override
  void initState() {
    super.initState();

    _levelStartedAt = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetLevelState();
    });
  }

  String _echoMessage() {
    final executionState = ref.read(executionStateProvider);

    if (executionState.status == ExecutionStatus.running || _isAnimating) {
      return 'Executing command sequence...';
    }

    return _latestEchoHint ?? widget.level.learningObjective;
  }

  @override
  void didUpdateWidget(covariant GameplayScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.level.id != widget.level.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _resetLevelState();
      });
    }
  }

  void _resetLevelState() {
    ref
        .read(executionStateProvider.notifier)
        .resetFromLevel(widget.level, preserveAttemptCount: false);
    ref.read(commandSequenceProvider.notifier).clearSequence();

    setState(() {
      _latestEchoHint = null;
      _latestHintIsRepeated = false;
      _hintsUsed = 0;
      _usedExactHint = false;
    });
  }

  Future<void> _showPauseDialog() async {
    if (_isAnimating) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.bg3,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.border2.withValues(alpha: 0.9),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.45),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'PAUSED',
                  style: TextStyle(
                    color: AppColors.cyan,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cyan,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      '▶ Resume',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _resetLevelState();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.border2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      '↻ Restart Level',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go('/settings');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.border2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      '⚙ Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go('/dashboard');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.red,
                      side: BorderSide(
                        color: AppColors.red.withValues(alpha: 0.65),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      '✕ Abandon Mission',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showFailureDialog({
    required String hint,
    required bool isRepeatedFailure,
  }) async {
    if (mounted) {
      setState(() {
        _hintsUsed += 1;
      });
    }

    bool isExactHintUnlocked = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                decoration: BoxDecoration(
                  color: AppColors.bg3,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.cyan.withValues(alpha: 0.65),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cyan.withValues(alpha: 0.18),
                      blurRadius: 24,
                      offset: const Offset(0, -8),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.45),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.cyan.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.lightbulb,
                                color: AppColors.amber,
                                size: 15,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'ECHO TERMINAL',
                              style: TextStyle(
                                color: AppColors.cyan,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(
                              Icons.close_rounded,
                              color: AppColors.textMuted.withValues(alpha: 0.8),
                              size: 20,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: AppColors.cyan.withValues(alpha: 0.055),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.cyan.withValues(alpha: 0.32),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isRepeatedFailure
                                  ? 'HINT 2 · ECHO SUGGESTION'
                                  : 'HINT 1 · GENERAL',
                              style: TextStyle(
                                color: AppColors.cyan,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.9,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              hint,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 11,
                                height: 1.55,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isExactHintUnlocked
                              ? AppColors.amber.withValues(alpha: 0.055)
                              : Colors.white.withValues(alpha: 0.015),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isExactHintUnlocked
                                ? AppColors.amber.withValues(alpha: 0.38)
                                : AppColors.border2.withValues(alpha: 0.75),
                          ),
                        ),
                        child: isExactHintUnlocked
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'HINT 2 · EXACT SEQUENCE',
                                    style: TextStyle(
                                      color: AppColors.amber,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.9,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: widget.level.optimalSolution
                                        .map(_buildExactHintCommandChip)
                                        .toList(),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Icon(
                                    Icons.lock_rounded,
                                    color: AppColors.amber.withValues(
                                      alpha: 0.9,
                                    ),
                                    size: 18,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'HINT 2 · EXACT SEQUENCE',
                                    style: TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.9,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        isExactHintUnlocked = true;
                                      });

                                      setState(() {
                                        _usedExactHint = true;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.amber.withValues(
                                          alpha: 0.08,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        border: Border.all(
                                          color: AppColors.amber.withValues(
                                            alpha: 0.45,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Unlock for 10 XP',
                                        style: TextStyle(
                                          color: AppColors.amber,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showFailureOverlay({
    required String hint,
    required bool isRepeatedFailure,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.bg3,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.red.withValues(alpha: 0.55)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.red.withValues(alpha: 0.18),
                  blurRadius: 26,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.45),
                  blurRadius: 30,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.red.withValues(alpha: 0.08),
                    border: Border.all(
                      color: AppColors.red.withValues(alpha: 0.45),
                    ),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.red,
                    size: 42,
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'MISSION FAILED',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Auri could not reach the target.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Exo2',
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ref
                          .read(executionStateProvider.notifier)
                          .resetFromLevel(widget.level);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      '↻ Try Again',
                      style: TextStyle(
                        fontFamily: 'Exo2',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();

                      await Future<void>.delayed(
                        const Duration(milliseconds: 180),
                      );

                      if (!mounted) return;

                      await _showFailureDialog(
                        hint: hint,
                        isRepeatedFailure: isRepeatedFailure,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.amber,
                      side: BorderSide(
                        color: AppColors.amber.withValues(alpha: 0.55),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      '💡 Open Hint',
                      style: TextStyle(
                        fontFamily: 'Exo2',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExactHintCommandChip(CommandType command) {
    final label = _hintCommandLabel(command);
    final color = _hintCommandColor(command);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  String _hintCommandLabel(CommandType command) {
    switch (command) {
      case CommandType.moveForward:
        return '↑ Forward';
      case CommandType.turnLeft:
        return '↰ Left';
      case CommandType.turnRight:
        return '↱ Right';
      case CommandType.ifPathClear:
        return '◇ If Clear';
      case CommandType.loop:
        return '↻ Loop';
      case CommandType.loopUntil:
        return '⟳ Loop Until';
    }
  }

  Color _hintCommandColor(CommandType command) {
    switch (command) {
      case CommandType.moveForward:
        return AppColors.cyan;
      case CommandType.turnLeft:
        return AppColors.purple;
      case CommandType.turnRight:
        return AppColors.amber;
      case CommandType.ifPathClear:
        return AppColors.green;
      case CommandType.loop:
        return AppColors.red;
      case CommandType.loopUntil:
        return AppColors.textMuted;
    }
  }

  Future<void> _showReflectionModal() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.bg3,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cyan.withValues(alpha: 0.4)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'PAUSE & THINK',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  widget.level.reflectionPrompt,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Exo2',
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cyan,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontFamily: 'Exo2',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _runSequenceAnimated() async {
    if (_isAnimating) return;

    final sequence = ref.read(commandSequenceProvider);
    final commands = sequence.whereType<CommandType>().toList();

    if (commands.isEmpty) return;

    final runStartedAt = DateTime.now();

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
      await Future.delayed(const Duration(milliseconds: 500));
    }

    final finalState = trace.last;
    final timeTaken = DateTime.now().difference(runStartedAt);

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
      final commands = sequence.whereType<CommandType>().toList();

      final sessionTime = DateTime.now().difference(_levelStartedAt).inSeconds;

      final nextLevelId = isLastLevel
          ? widget.level.id
          : levels[currentIndex + 1].id;

      final uid = FirebaseAuth.instance.currentUser?.uid;

      final previousProfile = await ref.read(userProfileProvider.future);
      final previousTotalXp = previousProfile?.totalXP ?? 0;
      final alreadyCompleted =
          previousProfile?.completedLevelIds.contains(widget.level.id) ?? false;

      final earnedXpForDisplay = alreadyCompleted ? 0 : widget.level.rewardXp;
      final totalXpForDisplay = previousTotalXp + earnedXpForDisplay;

      if (uid != null) {
        final queue = ref.read(offlineProgressQueueServiceProvider);

        await ref
            .read(progressFirestoreServiceProvider)
            .saveMissionCompletionWithFallback(
              uid: uid,
              level: widget.level,
              nextLevelId: nextLevelId,
              movesUsed: commands.length,
              hintsUsed: _hintsUsed,
              playTimeSeconds: sessionTime,
              usedExactHint: _usedExactHint,
              queue: queue,
            );
      }

      final updatedProfile = await ref.read(userProfileProvider.future);

      if (uid != null && updatedProfile != null) {
        if (updatedProfile.achievements['firstMission'] == true) {
          await _showAchievementUnlockedPopup('firstMission');
        }
      }

      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return MissionCompleteScreen(
              level: widget.level,
              isLastLevel: isLastLevel,
              timeTaken: timeTaken,
              stepsUsed: commands.length,
              optimalSteps: widget.level.optimalSolution.length,
              earnedXp: earnedXpForDisplay,
              totalXp: totalXpForDisplay,

              onNextMission: () {
                if (isLastLevel) {
                  Navigator.of(context).pop();

                  ref.read(currentLevelIndexProvider.notifier).state =
                      levels.length - 1;

                  ref
                      .read(executionStateProvider.notifier)
                      .resetFromLevel(widget.level);

                  ref.read(commandSequenceProvider.notifier).clearSequence();

                  _levelStartedAt = DateTime.now();
                  return;
                }

                Navigator.of(context).pop();

                ref.read(currentLevelIndexProvider.notifier).state =
                    currentIndex + 1;

                _levelStartedAt = DateTime.now();
              },
              onReplayLevel: () {
                Navigator.of(context).pop();

                ref
                    .read(executionStateProvider.notifier)
                    .resetFromLevel(widget.level);

                ref.read(commandSequenceProvider.notifier).clearSequence();

                _levelStartedAt = DateTime.now();
              },
            );
          },
        ),
      );
    } else if (finalState.status == ExecutionStatus.failure) {
      final hintAnalyzer = const HintAnalyzer();

      final analysis = hintAnalyzer.analyze(
        userCommands: commands,
        optimalSolution: widget.level.optimalSolution,
      );

      final analyzerHint = hintAnalyzer.messageFor(analysis);

      final hint = nextAttemptCount <= 1
          ? widget.level.firstFailureHint
          : analysis.type == HintErrorType.correct
          ? widget.level.repeatedFailureHint
          : analyzerHint;

      final isRepeatedFailure = nextAttemptCount > 1;

      ref.read(executionStateProvider.notifier).resetFromLevel(widget.level);

      setState(() {
        _latestEchoHint = hint;
        _latestHintIsRepeated = isRepeatedFailure;
      });

      if (nextAttemptCount == 2) {
        await _showReflectionModal();
        return;
      }

      await _showFailureOverlay(
        hint: hint,
        isRepeatedFailure: isRepeatedFailure,
      );
    }
  }

  bool _isCommandHighlighted({
    required int sequenceIndex,
    required List<CommandType?> sequence,
  }) {
    final executionState = ref.read(executionStateProvider);

    if (executionState.status != ExecutionStatus.running) {
      return false;
    }

    final item = sequence[sequenceIndex];

    if (item == null) {
      return false;
    }

    final commandOrderIndex =
        sequence.take(sequenceIndex + 1).whereType<CommandType>().length - 1;

    return commandOrderIndex == executionState.currentStepIndex;
  }

  String _achievementTitle(String key) {
    switch (key) {
      case 'firstMission':
        return 'First Mission';
      case 'earned100Xp':
        return '100 XP';
      case 'perfectSolution':
        return 'Perfect Run';
      case 'threeDayStreak':
        return '3 Day Streak';
      case 'noHintWin':
        return 'No Hint Win';
      case 'fiveMissions':
        return 'Explorer';
      default:
        return 'Achievement';
    }
  }

  IconData _achievementIcon(String key) {
    switch (key) {
      case 'firstMission':
        return Icons.emoji_events_rounded;
      case 'earned100Xp':
        return Icons.bolt_rounded;
      case 'perfectSolution':
        return Icons.check_circle_rounded;
      case 'threeDayStreak':
        return Icons.local_fire_department_rounded;
      case 'noHintWin':
        return Icons.visibility_off_rounded;
      case 'fiveMissions':
        return Icons.explore_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  Future<void> _showAchievementUnlockedPopup(String achievementKey) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(28),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.85, end: 1),
            duration: const Duration(milliseconds: 360),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.bg3,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.amber.withValues(alpha: 0.55),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.amber.withValues(alpha: 0.24),
                    blurRadius: 26,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'ACHIEVEMENT UNLOCKED',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      color: AppColors.amber,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.amber.withValues(alpha: 0.12),
                      border: Border.all(color: AppColors.amber, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.amber.withValues(alpha: 0.30),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      _achievementIcon(achievementKey),
                      color: AppColors.amber,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _achievementTitle(achievementKey),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your progress has been recorded.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Nice!',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final executionState = ref.watch(executionStateProvider);
    final Coordinate auriPosition = executionState.currentPosition;
    final auriDirection = executionState.direction;
    final sequence = ref.watch(commandSequenceProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: _showPauseDialog,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.bolt,
                          color: AppColors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        profileAsync.when(
                          loading: () => const Text(
                            '...',
                            style: TextStyle(
                              color: AppColors.amber,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          error: (error, stackTrace) => const Text(
                            '0',
                            style: TextStyle(
                              color: AppColors.amber,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          data: (profile) {
                            final xp = profile?.totalXP ?? 0;

                            return Text(
                              xp.toString(),
                              style: const TextStyle(
                                color: AppColors.amber,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _showPauseDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bg3,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.pause_rounded,
                              color: AppColors.textSecondary,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Pause',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
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

                            final isHighlighted = _isCommandHighlighted(
                              sequenceIndex: index,
                              sequence: sequence,
                            );

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
                                    isHighlighted: isHighlighted,
                                  ),
                                ),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.35,
                                child: CommandBlock(
                                  command: item,
                                  isSmall: true,
                                  isHighlighted: isHighlighted,
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
                                  isHighlighted: isHighlighted,
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
              onExit: _showPauseDialog,
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
                      GestureDetector(
                        onTap: () {
                          final hint =
                              _latestEchoHint ?? widget.level.firstFailureHint;

                          _showFailureDialog(
                            hint: hint,
                            isRepeatedFailure: _latestHintIsRepeated,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cyan.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.amber.withValues(alpha: 0.35),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ],
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _echoMessage(),
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
