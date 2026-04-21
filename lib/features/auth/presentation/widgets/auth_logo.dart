import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AuthLogo extends StatelessWidget {
  final bool purpleMode;

  const AuthLogo({super.key, this.purpleMode = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: RadialGradient(
              colors: purpleMode
                  ? [const Color(0xFF1A0A4A), const Color(0xFF06030F)]
                  : [const Color(0xFF0A3D5C), const Color(0xFF030C18)],
            ),
            border: Border.all(
              color: purpleMode
                  ? AppColors.purple.withValues(alpha: 0.35)
                  : AppColors.cyan.withValues(alpha: 0.35),
            ),
          ),
          child: Icon(
            Icons.memory_rounded,
            size: 42,
            color: purpleMode ? AppColors.purple : AppColors.cyan,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "AURI'S JOURNEY",
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 2,
            color: purpleMode
                ? AppColors.purple.withValues(alpha: 0.8)
                : AppColors.textMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
