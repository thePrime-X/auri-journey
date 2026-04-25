import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _avatarPulseController;

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

  @override
  Widget build(BuildContext context) {
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

            const Center(
              child: Text(
                '@commander_auri',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                  shadows: [Shadow(color: Colors.white24, blurRadius: 12)],
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
                child: const Text(
                  '⚡ 2,480 XP   |   Level 12',
                  style: TextStyle(
                    fontFamily: 'Exo2',
                    color: AppColors.amber,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 74),

            const Row(
              children: [
                Expanded(
                  child: _ProfileStatCard(
                    value: '12',
                    label: 'LEVEL',
                    color: AppColors.cyan,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _ProfileStatCard(
                    value: '7',
                    label: 'DAY STREAK',
                    color: AppColors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: _ProfileStatCard(
                    value: '34',
                    label: 'MISSIONS',
                    color: AppColors.purple,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _ProfileStatCard(
                    value: '4ʰ 12ᵐ',
                    label: 'PLAY TIME',
                    color: AppColors.green,
                  ),
                ),
              ],
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
            const _SkillRow(
              label: 'Sequences',
              value: 0.90,
              color: AppColors.cyan,
            ),
            const _SkillRow(
              label: 'Conditions',
              value: 0.65,
              color: AppColors.purple,
            ),
            const _SkillRow(
              label: 'Loops',
              value: 0.40,
              color: AppColors.amber,
            ),
            const _SkillRow(
              label: 'Debugging',
              value: 0.55,
              color: AppColors.red,
            ),

            const SizedBox(height: 26),

            const _SectionTitle(title: 'ACHIEVEMENTS'),
            const SizedBox(height: 13),

            SizedBox(
              height: 98,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: const [
                  _Achievement(
                    icon: '🏆',
                    label: 'First\nMission',
                    color: AppColors.cyan,
                    isUnlocked: true,
                  ),
                  SizedBox(width: 12),
                  _Achievement(
                    icon: '∞',
                    label: 'Loop\nMaster',
                    color: AppColors.purple,
                    isUnlocked: true,
                  ),
                  SizedBox(width: 12),
                  _Achievement(
                    icon: '⚡',
                    label: 'Speed\nRunner',
                    color: AppColors.amber,
                    isUnlocked: true,
                  ),
                  SizedBox(width: 12),
                  _Achievement(
                    icon: '',
                    label: 'Level\n10',
                    color: AppColors.textMuted,
                    isUnlocked: false,
                  ),
                ],
              ),
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

  const _SkillRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
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

class _Achievement extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final bool isUnlocked;

  const _Achievement({
    required this.icon,
    required this.label,
    required this.color,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isUnlocked ? 1 : 0.25,
      child: SizedBox(
        width: 56,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? color.withValues(alpha: 0.10)
                    : AppColors.bg4,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isUnlocked
                      ? color.withValues(alpha: 0.45)
                      : AppColors.border2,
                  width: 1.5,
                ),
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.15),
                          blurRadius: 12,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: isUnlocked
                    ? Text(
                        icon,
                        style: TextStyle(
                          color: color,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      )
                    : const Icon(
                        Icons.lock_rounded,
                        color: AppColors.textMuted,
                        size: 24,
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isUnlocked
                    ? AppColors.textSecondary
                    : AppColors.textMuted,
                fontSize: 9,
                height: 1.25,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
