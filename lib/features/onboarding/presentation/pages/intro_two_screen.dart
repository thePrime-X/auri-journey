import 'package:auri_app/shared/widgets/rotating_flow_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class IntroTwoScreen extends StatelessWidget {
  const IntroTwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const RotatingGlowIcon(
                icon: Icons.memory,
                color: AppColors.purple,
              ),
              const SizedBox(height: 32),
              const Text(
                'BUILD LOGIC',
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
                'Queue your commands.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.purple,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select directional blocks, loops, and conditions to navigate the execution grid safely to the target.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.6,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              _OnboardingIndicators(
                currentIndex: 1,
                activeColor: AppColors.purple,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [AppColors.purple, AppColors.purple2],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () => context.go('/intro-3'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment:
                          CrossAxisAlignment.center, // 👈 add this

                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 6),
                        Transform.translate(
                          offset: const Offset(0, -3),
                          child: const Text(
                            '→',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
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
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(999),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.6),
                      blurRadius: 6,
                    ),
                  ]
                : [],
          ),
        ),
      ),
    );
  }
}
