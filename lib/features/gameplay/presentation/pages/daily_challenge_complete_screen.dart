import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

class DailyChallengeCompleteScreen extends StatelessWidget {
  final int rewardXp;
  final int totalXp;
  final Duration timeTaken;
  final int stepsUsed;
  final int optimalSteps;

  const DailyChallengeCompleteScreen({
    super.key,
    required this.rewardXp,
    required this.totalXp,
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(34),
                      border: Border.all(color: AppColors.border2, width: 1.6),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'DAILY CHALLENGE',
                                style: TextStyle(
                                  fontFamily: 'Exo2',
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                            Text(
                              '⚡ $totalXp XP',
                              style: const TextStyle(
                                fontFamily: 'Orbitron',
                                color: AppColors.amber,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 34),

                        const _SuccessRing(),

                        const SizedBox(height: 28),

                        const Text(
                          'DAILY CHALLENGE COMPLETE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            color: AppColors.textPrimary,
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.7,
                          ),
                        ),

                        const SizedBox(height: 24),

                        _XpRewardPill(xp: rewardXp),

                        const SizedBox(height: 22),

                        _MetricsCard(
                          stepsUsed: stepsUsed,
                          efficiencyBadge: efficiencyBadge,
                          timeTaken: formattedTime,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.go('/dashboard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cyan,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Back to Dashboard',
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
              width: 110,
              height: 110,
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.green.withValues(alpha: 0.13),
                    border: Border.all(color: AppColors.green, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.green,
                    size: 32,
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
          const SizedBox(height: 7),
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
