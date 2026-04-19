import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class XpBadge extends StatelessWidget {
  final String value;

  const XpBadge({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.bolt, color: AppColors.amber, size: 16),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.amber,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
