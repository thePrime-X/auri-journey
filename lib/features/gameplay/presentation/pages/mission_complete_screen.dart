import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/level_state.dart';

class MissionCompleteScreen extends StatelessWidget {
  final LevelState level;
  final bool isLastLevel;
  final VoidCallback onNextMission;
  final VoidCallback onReplayLevel;
  final Duration timeTaken;
  final int stepsUsed;
  final int optimalSteps;

  const MissionCompleteScreen({
    super.key,
    required this.level,
    required this.isLastLevel,
    required this.onNextMission,
    required this.onReplayLevel,
    required this.timeTaken,
    required this.stepsUsed,
    required this.optimalSteps,
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
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'SECTOR 1 · MISSION ${level.order}',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                Text(
                  '⚡ ${level.rewardXp} XP',
                  style: const TextStyle(
                    color: AppColors.amber,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              level.title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 34),

            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.green, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.green.withValues(alpha: 0.25),
                      blurRadius: 26,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.green,
                  size: 54,
                ),
              ),
            ),

            const SizedBox(height: 34),
            const Center(
              child: Text(
                'MISSION COMPLETE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Power Gate Restored!',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),

            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.amber.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppColors.amber.withValues(alpha: 0.55),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.amber.withValues(alpha: 0.22),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Text(
                  '⚡ + ${level.rewardXp} XP',
                  style: const TextStyle(
                    color: AppColors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'EFFICIENCY',
                    value: '$stepsUsed',
                    subtitle: 'Steps used',
                    badge: efficiencyBadge,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'SPEED',
                    value: formattedTime,
                    subtitle: 'Time taken',
                    badge: 'Fast',
                    cyan: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cyan.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.cyan.withValues(alpha: 0.35),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✦ CONCEPT MASTERED',
                    style: TextStyle(
                      color: AppColors.cyan,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Sequential Reasoning',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'You used ordered instructions to reach the target efficiently. Core skill unlocked.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Text(
                  'Level ${level.order}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '→',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
                Text(
                  isLastLevel ? 'Complete' : 'Level ${level.order + 1}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  '+${level.rewardXp} XP',
                  style: const TextStyle(
                    color: AppColors.green,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: isLastLevel ? 1 : 0.72,
                minHeight: 6,
                backgroundColor: AppColors.bg3,
                color: AppColors.cyan,
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              height: 58,
              child: ElevatedButton(
                onPressed: onNextMission,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cyan,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  isLastLevel ? 'Finish →' : 'Next Mission →',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            SizedBox(
              height: 58,
              child: OutlinedButton(
                onPressed: onReplayLevel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  '↻ Replay Level',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String badge;
  final bool cyan;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.badge,
    this.cyan = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = cyan ? AppColors.cyan : AppColors.green;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.bg3.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border2),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: cyan ? AppColors.cyan : AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: cyan ? AppColors.cyan : AppColors.textPrimary,
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              badge,
              style: TextStyle(color: color, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
