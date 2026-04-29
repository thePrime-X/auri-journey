import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../features/profile/application/user_profile_provider.dart';
import '../../../../core/utils/time_formatter.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _avatarPulseController;

  Map<String, bool> _lastAchievements = {};
  bool _hasLoadedAchievementsOnce = false;

  @override
  void initState() {
    super.initState();

    _avatarPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _avatarPulseController.dispose();
    super.dispose();
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

  void _checkAchievementUnlocks(Map<String, bool> achievements) {
    if (!_hasLoadedAchievementsOnce) {
      _lastAchievements = Map<String, bool>.from(achievements);
      _hasLoadedAchievementsOnce = true;
      return;
    }

    for (final entry in achievements.entries) {
      final wasUnlocked = _lastAchievements[entry.key] == true;
      final isUnlocked = entry.value == true;

      if (!wasUnlocked && isUnlocked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showAchievementUnlockedPopup(entry.key);
          }
        });
        break;
      }
    }

    _lastAchievements = Map<String, bool>.from(achievements);
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
    final profileAsync = ref.watch(userProfileProvider);

    profileAsync.whenData((profile) {
      if (profile != null) {
        _checkAchievementUnlocks(profile.achievements);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          children: [
            Row(
              children: [
                _TopIconButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: () => context.go('/dashboard'),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'PROFILE',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3.2,
                      ),
                    ),
                  ),
                ),
                _TopIconButton(
                  icon: Icons.settings_outlined,
                  onTap: () => context.go('/settings'),
                ),
              ],
            ),

            const SizedBox(height: 26),

            _ProfileAvatar(controller: _avatarPulseController),

            const SizedBox(height: 22),

            Center(
              child: profileAsync.when(
                loading: () => const Text(
                  '@commander_auri',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                    shadows: [Shadow(color: Colors.white24, blurRadius: 12)],
                  ),
                ),
                error: (error, stackTrace) => const Text(
                  '@commander_auri',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                    shadows: [Shadow(color: Colors.white24, blurRadius: 12)],
                  ),
                ),
                data: (profile) => Text(
                  '@${profile?.displayName ?? 'commander_auri'}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                    shadows: [Shadow(color: Colors.white24, blurRadius: 12)],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 3),
            const Center(
              child: Text(
                'COMMANDER',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.7,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),

                  // 🔥 softer amber glow
                  color: const Color(0xFF1A1406),
                  border: Border.all(
                    color: AppColors.amber.withValues(alpha: 0.6),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.amber.withValues(alpha: 0.25),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: profileAsync.when(
                  loading: () => const Text(
                    '⚡ 0 XP   |   Level 1',
                    style: TextStyle(
                      fontFamily: 'Exo2',
                      color: AppColors.amber,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  error: (error, stackTrace) => const Text(
                    '⚡ 0 XP   |   Level 1',
                    style: TextStyle(
                      fontFamily: 'Exo2',
                      color: AppColors.amber,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  data: (profile) => Text(
                    '⚡ ${profile?.totalXP ?? 0} XP   |   Level ${profile?.displayLevel ?? 1}',
                    style: const TextStyle(
                      fontFamily: 'Exo2',
                      color: AppColors.amber,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 74),

            profileAsync.when(
              loading: () => const Row(
                children: [
                  Expanded(
                    child: _ProfileStatCard(
                      value: '1',
                      label: 'LEVEL',
                      color: AppColors.cyan,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _ProfileStatCard(
                      value: '1',
                      label: 'DAY STREAK',
                      color: AppColors.amber,
                    ),
                  ),
                ],
              ),
              error: (error, stackTrace) => const Row(
                children: [
                  Expanded(
                    child: _ProfileStatCard(
                      value: '1',
                      label: 'LEVEL',
                      color: AppColors.cyan,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _ProfileStatCard(
                      value: '1',
                      label: 'DAY STREAK',
                      color: AppColors.amber,
                    ),
                  ),
                ],
              ),
              data: (profile) {
                final level = profile?.displayLevel ?? 1;
                final streak = profile?.streakDays ?? 1;

                return Row(
                  children: [
                    Expanded(
                      child: _ProfileStatCard(
                        value: '$level',
                        label: 'LEVEL',
                        color: AppColors.cyan,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _ProfileStatCard(
                        value: '$streak',
                        label: 'DAY STREAK',
                        color: AppColors.amber,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            profileAsync.when(
              loading: () => const Row(
                children: [
                  Expanded(
                    child: _ProfileStatCard(
                      value: '1',
                      label: 'MISSIONS',
                      color: AppColors.purple,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _ProfileStatCard(
                      value: '0m',
                      label: 'PLAY TIME',
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
              error: (error, stackTrace) => const Row(
                children: [
                  Expanded(
                    child: _ProfileStatCard(
                      value: '1',
                      label: 'MISSIONS',
                      color: AppColors.purple,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _ProfileStatCard(
                      value: '0m',
                      label: 'PLAY TIME',
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
              data: (profile) {
                final missions = profile?.puzzlesCompleted ?? 1;
                final playTime = formatPlayTime(
                  profile?.totalPlayTimeSeconds ?? 0,
                );

                return Row(
                  children: [
                    Expanded(
                      child: _ProfileStatCard(
                        value: '$missions',
                        label: 'MISSIONS',
                        color: AppColors.purple,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _ProfileStatCard(
                        value: playTime,
                        label: 'PLAY TIME',
                        color: AppColors.green,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 26),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.045),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.green.withValues(alpha: 0.28),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✦ LEARNING INSIGHTS',
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.7,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '↑  Strongest concept: Sequences',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 9),
                  Text(
                    '★  Recommended next: Conditional Forest',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            const _SectionTitle(title: 'SKILL MAP'),
            const SizedBox(height: 13),
            profileAsync.when(
              loading: () => const Column(
                children: [
                  _SkillRow(
                    label: 'Sequences',
                    value: 0.90,
                    color: AppColors.cyan,
                  ),
                  _SkillRow(
                    label: 'Conditions',
                    value: 0.10,
                    color: AppColors.purple,
                    isLocked: true,
                  ),
                  _SkillRow(
                    label: 'Loops',
                    value: 0.10,
                    color: AppColors.amber,
                    isLocked: true,
                  ),
                  _SkillRow(
                    label: 'Debugging',
                    value: 0.10,
                    color: AppColors.red,
                    isLocked: true,
                  ),
                ],
              ),
              error: (error, stackTrace) => const Column(
                children: [
                  _SkillRow(
                    label: 'Sequences',
                    value: 0.90,
                    color: AppColors.cyan,
                  ),
                  _SkillRow(
                    label: 'Conditions',
                    value: 0.10,
                    color: AppColors.purple,
                    isLocked: true,
                  ),
                  _SkillRow(
                    label: 'Loops',
                    value: 0.10,
                    color: AppColors.amber,
                    isLocked: true,
                  ),
                  _SkillRow(
                    label: 'Debugging',
                    value: 0.10,
                    color: AppColors.red,
                    isLocked: true,
                  ),
                ],
              ),
              data: (profile) {
                final skillStats =
                    profile?.skillStats ??
                    const {
                      'sequences': 0,
                      'conditions': 10,
                      'loops': 10,
                      'debugging': 10,
                    };

                double skillValue(String key) {
                  final value = skillStats[key] ?? 0;
                  return value.clamp(0, 100) / 100;
                }

                return Column(
                  children: [
                    _SkillRow(
                      label: 'Sequences',
                      value: skillValue('sequences'),
                      color: AppColors.cyan,
                    ),
                    _SkillRow(
                      label: 'Conditions',
                      value: skillValue('conditions'),
                      color: AppColors.purple,
                      isLocked: true,
                    ),
                    _SkillRow(
                      label: 'Loops',
                      value: skillValue('loops'),
                      color: AppColors.amber,
                      isLocked: true,
                    ),
                    _SkillRow(
                      label: 'Debugging',
                      value: skillValue('debugging'),
                      color: AppColors.red,
                      isLocked: true,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 26),

            const _SectionTitle(title: 'ACHIEVEMENTS'),
            const SizedBox(height: 13),

            profileAsync.when(
              loading: () => const SizedBox(height: 98),
              error: (error, stackTrace) => const SizedBox(height: 98),
              data: (profile) {
                final achievements = profile?.achievements ?? {};

                return SizedBox(
                  height: 98,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _Achievement(
                        icon: Icons.emoji_events_rounded,
                        label: 'First\nMission',
                        unlocked: achievements['firstMission'] == true,
                      ),
                      const SizedBox(width: 12),
                      _Achievement(
                        icon: Icons.bolt_rounded,
                        label: '100\nXP',
                        unlocked: achievements['earned100Xp'] == true,
                      ),
                      const SizedBox(width: 12),
                      _Achievement(
                        icon: Icons.check_circle_rounded,
                        label: 'Perfect\nRun',
                        unlocked: achievements['perfectSolution'] == true,
                      ),
                      const SizedBox(width: 12),
                      _Achievement(
                        icon: Icons.local_fire_department_rounded,
                        label: '3 Day\nStreak',
                        unlocked: achievements['threeDayStreak'] == true,
                      ),
                      const SizedBox(width: 12),
                      _Achievement(
                        icon: Icons.visibility_off_rounded,
                        label: 'No Hint\nWin',
                        unlocked: achievements['noHintWin'] == true,
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 26),

            SizedBox(
              height: 54,
              child: OutlinedButton(
                onPressed: () => context.go('/dashboard'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.22),
                    width: 1.4,
                  ),
                  backgroundColor: Colors.white.withValues(alpha: 0.045),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Continue Playing →',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final AnimationController controller;

  const _ProfileAvatar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final pulse = controller.value;
          final pulseOpacity = (1 - pulse).clamp(0.0, 1.0);
          final pulseSize = 110 + (pulse * 26);

          return SizedBox(
            width: 138,
            height: 124,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Opacity(
                  opacity: pulseOpacity * 0.45,
                  child: Container(
                    width: pulseSize,
                    height: pulseSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.purple.withValues(alpha: 0.7),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 106,
                  height: 106,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.bg3.withValues(alpha: 0.75),
                    border: Border.all(color: AppColors.purple, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.purple.withValues(alpha: 0.5),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.purple, width: 2.2),
                        color: AppColors.bg.withValues(alpha: 0.35),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.android_rounded,
                          size: 26,
                          color: AppColors.purple,
                          shadows: [
                            Shadow(
                              color: AppColors.purple.withValues(alpha: 0.6),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 17,
                  bottom: 18,
                  child: Container(
                    width: 23,
                    height: 23,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.bg, width: 3),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.bg3,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 21),
      ),
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _ProfileStatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),

        // ✨ subtle gradient (THIS is what your design is missing)
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2333).withValues(alpha: 0.55),
            const Color(0xFF0F172A).withValues(alpha: 0.75),
          ],
        ),

        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          // ✨ subtle inner glow feel
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.03),
            blurRadius: 6,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 🔥 NUMBER (Orbitron + glow)
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontWeight: FontWeight.w700,
              fontSize: 34,
              color: color,
              height: 1,
              shadows: [
                Shadow(color: color.withValues(alpha: 0.6), blurRadius: 12),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 🔥 LABEL (Exo clean)
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Exo2',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.cyan,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.border2.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }
}

class _SkillRow extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final bool isLocked;

  const _SkillRow({
    required this.label,
    required this.value,
    required this.color,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                if (isLocked) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.lock_rounded,
                    size: 12,
                    color: AppColors.textMuted.withValues(alpha: 0.85),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 10,
                backgroundColor: Colors.white.withValues(alpha: 0.045),
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 34,
            child: Text(
              '${(value * 100).round()}%',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Achievement extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool unlocked;

  const _Achievement({
    required this.icon,
    required this.label,
    required this.unlocked,
  });

  @override
  State<_Achievement> createState() => _AchievementState();
}

class _AchievementState extends State<_Achievement>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _glow = Tween<double>(
      begin: 0.2,
      end: 0.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.unlocked) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _Achievement oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.unlocked && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }

    if (!widget.unlocked && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.unlocked
        ? AppColors.cyan
        : AppColors.textMuted.withValues(alpha: 0.3);

    return AnimatedBuilder(
      animation: _glow,
      builder: (context, child) {
        final glowStrength = widget.unlocked ? _glow.value : 0.0;

        return Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.unlocked
                    ? AppColors.cyan.withValues(alpha: 0.12)
                    : AppColors.bg3,
                border: Border.all(
                  color: widget.unlocked
                      ? AppColors.cyan.withValues(alpha: 0.4)
                      : AppColors.border2.withValues(alpha: 0.4),
                ),
                boxShadow: widget.unlocked
                    ? [
                        BoxShadow(
                          color: AppColors.cyan.withValues(alpha: glowStrength),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Icon(widget.icon, color: baseColor, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              widget.label,
              style: TextStyle(
                color: baseColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
