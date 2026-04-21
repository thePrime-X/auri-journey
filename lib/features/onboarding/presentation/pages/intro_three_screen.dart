import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/onboarding_provider.dart';

class IntroThreeScreen extends ConsumerWidget {
  const IntroThreeScreen({super.key});

  void _finishOnboarding(BuildContext context, WidgetRef ref) {
    ref.read(onboardingCompletedProvider.notifier).completeOnboarding();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.amber.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.bolt, size: 60, color: AppColors.amber),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.amber.withValues(alpha: 0.25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'LEVEL UP',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Track your progression.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.amber,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Earn XP for efficiency, master new programming concepts, and unlock new sectors on the world map.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.6,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              _OnboardingIndicators(
                currentIndex: 2,
                activeColor: AppColors.amber,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [AppColors.amber, Color(0xFFD97706)],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () => _finishOnboarding(context, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Start Mission →',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
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

class _OnboardingIndicators extends StatelessWidget {
  final int currentIndex;
  final Color activeColor;

  const _OnboardingIndicators({
    required this.currentIndex,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _IndicatorButton(
          isActive: currentIndex == 0,
          color: currentIndex == 0 ? activeColor : AppColors.textMuted,
          onTap: () => context.go('/intro-1'),
        ),
        const SizedBox(width: 6),
        _IndicatorButton(
          isActive: currentIndex == 1,
          color: currentIndex == 1 ? activeColor : AppColors.textMuted,
          onTap: () => context.go('/intro-2'),
        ),
        const SizedBox(width: 6),
        _IndicatorButton(
          isActive: currentIndex == 2,
          color: currentIndex == 2 ? activeColor : AppColors.textMuted,
          onTap: () => context.go('/intro-3'),
        ),
      ],
    );
  }
}

class _IndicatorButton extends StatelessWidget {
  final bool isActive;
  final Color color;
  final VoidCallback onTap;

  const _IndicatorButton({
    required this.isActive,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isActive ? 16 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}
