import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/level_state.dart';

class MissionCompleteScreen extends StatelessWidget {
  final LevelState level;
  final bool isLastLevel;
  final Duration timeTaken;
  final int stepsUsed;
  final int optimalSteps;
  final VoidCallback onNextMission;
  final VoidCallback onReplayLevel;

  const MissionCompleteScreen({
    super.key,
    required this.level,
    required this.isLastLevel,
    required this.timeTaken,
    required this.stepsUsed,
    required this.optimalSteps,
    required this.onNextMission,
    required this.onReplayLevel,
  });

  String get formattedTime {
    final seconds = timeTaken.inSeconds;
    if (seconds < 60) return '${seconds}s';

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }

  String get efficiencyBadge {
    final extraSteps = stepsUsed - optimalSteps;
    if (extraSteps <= 0) return 'Optimal';
    return '+$extraSteps steps';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SECTOR 1 · MISSION ${level.order}',
                        style: const TextStyle(
                          fontFamily: 'Exo2',
                          color: AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        level.title,
                        style: const TextStyle(
                          fontFamily: 'Exo2',
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '⚡ 2,480 XP',
                  style: const TextStyle(
                    fontFamily: 'Orbitron',
                    color: AppColors.amber,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const _SuccessRing(),

            const SizedBox(height: 20),

            const Text(
              'MISSION COMPLETE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Orbitron',
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Power Gate Restored!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Exo2',
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            Center(child: _XpRewardPill(xp: level.rewardXp)),

            const SizedBox(height: 22),

            _MetricsCard(
              stepsUsed: stepsUsed,
              efficiencyBadge: efficiencyBadge,
              timeTaken: formattedTime,
            ),

            const SizedBox(height: 14),

            const _ConceptCard(),

            const SizedBox(height: 18),

            _XpProgressBar(
              levelOrder: level.order,
              isLastLevel: isLastLevel,
              rewardXp: level.rewardXp,
            ),

            const SizedBox(height: 18),

            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: onNextMission,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cyan,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isLastLevel ? 'Finish →' : 'Next Mission →',
                  style: const TextStyle(
                    fontFamily: 'Exo2',
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: onReplayLevel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border2, width: 1.5),
                  backgroundColor: Colors.white.withValues(alpha: 0.03),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '↺ Replay Level',
                  style: TextStyle(
                    fontFamily: 'Exo2',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessRing extends StatelessWidget {
  const _SuccessRing();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.72, end: 1),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.green.withValues(alpha: 0.06),
                border: Border.all(
                  color: AppColors.green.withValues(alpha: 0.35),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.green.withValues(alpha: 0.18),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.green.withValues(alpha: 0.13),
                    border: Border.all(color: AppColors.green, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.green,
                    size: 30,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _XpRewardPill extends StatefulWidget {
  final int xp;

  const _XpRewardPill({required this.xp});

  @override
  State<_XpRewardPill> createState() => _XpRewardPillState();
}

class _XpRewardPillState extends State<_XpRewardPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.amber.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: AppColors.amber.withValues(alpha: 0.45),
            width: 1,
          ),
        ),
        child: Text(
          '⚡ + ${widget.xp} XP',
          style: const TextStyle(
            fontFamily: 'Exo2',
            color: AppColors.amber,
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.4,
          ),
        ),
      ),
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_controller.value);

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.amber.withValues(
                        alpha: 0.12 + (t * 0.25),
                      ),
                      blurRadius: 8 + (t * 12),
                      spreadRadius: 0.5 + (t * 1.2),
                    ),
                  ],
                ),
              ),
            ),
            child!,
          ],
        );
      },
    );
  }
}

class _MetricsCard extends StatelessWidget {
  final int stepsUsed;
  final String efficiencyBadge;
  final String timeTaken;

  const _MetricsCard({
    required this.stepsUsed,
    required this.efficiencyBadge,
    required this.timeTaken,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: AppColors.bg3,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _MetricColumn(
              title: 'EFFICIENCY',
              value: '$stepsUsed',
              subtitle: 'Steps used',
              badge: efficiencyBadge,
              valueColor: AppColors.textPrimary,
              badgeColor: efficiencyBadge == 'Optimal'
                  ? AppColors.green
                  : AppColors.amber,
            ),
          ),
          Container(
            width: 1,
            height: 130,
            color: AppColors.border.withValues(alpha: 0.6),
          ),
          Expanded(
            child: _MetricColumn(
              title: 'SPEED',
              value: timeTaken,
              subtitle: 'Time taken',
              badge: 'Fast',
              valueColor: AppColors.cyan,
              badgeColor: AppColors.cyan,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String badge;
  final Color valueColor;
  final Color badgeColor;

  const _MetricColumn({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.badge,
    required this.valueColor,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Exo2',
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Orbitron',
              color: valueColor,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(' ', style: TextStyle(fontSize: 1)),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Exo2',
              color: AppColors.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 7),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: badgeColor.withValues(alpha: 0.10),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontFamily: 'Exo2',
                color: badgeColor,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConceptCard extends StatelessWidget {
  const _ConceptCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.cyan.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.18)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✦ CONCEPT MASTERED',
            style: TextStyle(
              fontFamily: 'Exo2',
              color: AppColors.cyan,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Sequential Reasoning',
            style: TextStyle(
              fontFamily: 'Exo2',
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'You used ordered instructions to reach the target efficiently. Core skill unlocked.',
            style: TextStyle(
              fontFamily: 'Exo2',
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _XpProgressBar extends StatelessWidget {
  final int levelOrder;
  final bool isLastLevel;
  final int rewardXp;

  const _XpProgressBar({
    required this.levelOrder,
    required this.isLastLevel,
    required this.rewardXp,
  });

  @override
  Widget build(BuildContext context) {
    final nextLabel = isLastLevel ? 'Complete' : 'Level ${levelOrder + 1}';

    return Column(
      children: [
        Row(
          children: [
            Text(
              'Level $levelOrder',
              style: const TextStyle(
                fontFamily: 'Exo2',
                color: AppColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: Text(
                '→',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ),
            Text(
              nextLabel,
              style: const TextStyle(
                fontFamily: 'Exo2',
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              '+$rewardXp XP',
              style: const TextStyle(
                fontFamily: 'Exo2',
                color: AppColors.green,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.30, end: isLastLevel ? 1 : 0.74),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.bg4,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: value,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.cyan,
                            AppColors.purple.withValues(alpha: 0.85),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
