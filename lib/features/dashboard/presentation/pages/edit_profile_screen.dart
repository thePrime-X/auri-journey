import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../features/profile/application/user_profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  late final AnimationController _avatarPulseController;

  bool _isSaving = false;
  bool _hasLoadedInitialName = false;

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
    _nameController.dispose();
    _avatarPulseController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final newName = _nameController.text.trim();

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username cannot be empty.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref
          .read(userProfileServiceProvider)
          .updateDisplayName(uid: uid, displayName: newName);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Username updated.')));

      context.go('/profile');
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to update username.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    profileAsync.whenData((profile) {
      if (!_hasLoadedInitialName && profile != null) {
        _nameController.text = profile.displayName;
        _hasLoadedInitialName = true;
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
                GestureDetector(
                  onTap: () => context.go('/settings'),
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
                      'EDIT PROFILE',
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

            const SizedBox(height: 28),

            _ProfileAvatar(controller: _avatarPulseController),

            const SizedBox(height: 18),

            profileAsync.when(
              loading: () => const Center(
                child: Text(
                  '@commander',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              error: (error, stackTrace) => const Center(
                child: Text(
                  '@commander',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              data: (profile) => Center(
                child: Text(
                  '@${profile?.displayName ?? 'commander'}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 4),

            const Center(
              child: Text(
                'COMMANDER',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.6,
                ),
              ),
            ),

            const SizedBox(height: 34),

            const Text(
              'USERNAME',
              style: TextStyle(
                color: AppColors.purple,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.8,
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _nameController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Display name',
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.textMuted,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'This name will appear on your profile and dashboard.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
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
