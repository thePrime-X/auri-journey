import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../features/profile/application/user_profile_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/application/auth_state_provider.dart';
import '../../../../shared/widgets/privacy_policy_dialog.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authStateProvider.notifier).logout();

    if (context.mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.go('/profile'),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.bg3,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.textSecondary,
                      size: 22,
                    ),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'SETTINGS',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 36),
              ],
            ),

            const SizedBox(height: 32),

            const _SectionTitle(title: 'PREFERENCES'),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                _SettingsRow(
                  icon: Icons.volume_up_rounded,
                  title: 'Sound Effects',
                  trailing: _TogglePill(isOn: true),
                ),
                const _DividerLine(),
                _SettingsRow(
                  icon: Icons.vibration_rounded,
                  title: 'Haptic Feedback',
                  trailing: _TogglePill(isOn: false),
                ),
              ],
            ),

            const SizedBox(height: 26),

            const _SectionTitle(title: 'ACCOUNT'),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                _SettingsRow(
                  icon: Icons.privacy_tip_outlined,
                  title: profileAsync.when(
                    data: (profile) => profile?.policyAccepted == true
                        ? 'Privacy Policy · Agreed'
                        : 'Privacy Policy',
                    loading: () => 'Privacy Policy',
                    error: (error, stackTrace) => 'Privacy Policy',
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textMuted,
                  ),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) {
                        return const PrivacyPolicyDialog(
                          showAgreeButton: false,
                        );
                      },
                    );
                  },
                ),
                const _DividerLine(),
                _SettingsRow(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit Profile',
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textMuted,
                  ),
                  onTap: () => context.go('/edit-profile'),
                ),
                const _DividerLine(),
                _SettingsRow(
                  icon: Icons.restart_alt_rounded,
                  title: 'Reset Progress',
                  titleColor: AppColors.red,
                  iconColor: AppColors.red,
                  onTap: () async {
                    final shouldReset = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: AppColors.bg3,
                          title: const Text('Reset Progress?'),
                          content: const Text(
                            'This will reset XP, completed missions, streak, skills, and achievements.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'Reset',
                                style: TextStyle(color: AppColors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    if (shouldReset != true) return;

                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    if (uid == null) return;

                    await ref
                        .read(userProfileServiceProvider)
                        .resetProgress(uid);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Progress reset.')),
                      );
                    }
                  },
                ),
                const _DividerLine(),
                _SettingsRow(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  titleColor: AppColors.red,
                  iconColor: AppColors.red,
                  onTap: () => _logout(context, ref),
                ),
              ],
            ),

            const SizedBox(height: 42),

            const Center(
              child: Text(
                'Auri’s Journey v1.0.0\nCore Engine Online',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  height: 1.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.cyan,
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.8,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg3.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border2),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;
  final Color? iconColor;

  const _SettingsRow({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.titleColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppColors.textSecondary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: titleColor ?? AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.border.withValues(alpha: 0.55),
    );
  }
}

class _TogglePill extends StatelessWidget {
  final bool isOn;

  const _TogglePill({required this.isOn});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 26,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isOn ? AppColors.green : AppColors.bg4,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: isOn ? AppColors.green : AppColors.border2),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 180),
        alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: isOn ? AppColors.bg : AppColors.textSecondary,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
