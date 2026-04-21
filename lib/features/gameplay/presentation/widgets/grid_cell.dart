import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class GridCell extends StatelessWidget {
  final bool isAuri;
  final bool isGoal;
  final bool isObstacle;
  final bool isTrainingZone;

  const GridCell({
    super.key,
    required this.isAuri,
    required this.isGoal,
    required this.isObstacle,
    required this.isTrainingZone,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isTrainingZone
        ? AppColors.purple.withValues(alpha: 0.08)
        : AppColors.bg3;

    Color borderColor = isTrainingZone
        ? AppColors.purple.withValues(alpha: 0.22)
        : AppColors.border;

    Widget? child;

    if (isObstacle) {
      backgroundColor = AppColors.red.withValues(alpha: 0.06);
      borderColor = AppColors.red.withValues(alpha: 0.25);
      child = const Icon(Icons.close_rounded, color: AppColors.red, size: 20);
    } else if (isGoal) {
      backgroundColor = AppColors.amber.withValues(alpha: 0.08);
      borderColor = AppColors.amber.withValues(alpha: 0.30);
      child = const Icon(Icons.bolt, color: AppColors.amber, size: 24);
    } else if (isAuri) {
      backgroundColor = AppColors.cyan.withValues(alpha: 0.08);
      borderColor = AppColors.cyan.withValues(alpha: 0.30);
      child = const Icon(
        Icons.smart_toy_rounded,
        color: AppColors.cyan,
        size: 24,
      );
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Center(child: child),
      ),
    );
  }
}
