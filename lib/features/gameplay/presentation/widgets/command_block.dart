import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/command_type.dart';

class CommandBlock extends StatelessWidget {
  final CommandType? command;
  final VoidCallback? onTap;
  final bool isSmall;
  final bool isAddPlaceholder;

  const CommandBlock({
    super.key,
    this.command,
    this.onTap,
    this.isSmall = false,
    this.isAddPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    final double size = isSmall ? 48 : 64;

    if (isAddPlaceholder) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(isSmall ? 12 : 14),
            border: Border.all(
              color: AppColors.textMuted.withValues(alpha: 0.25),
              style: BorderStyle.solid,
            ),
          ),
          child: const Center(
            child: Icon(Icons.add, color: AppColors.textMuted, size: 22),
          ),
        ),
      );
    }

    final style = _styleFor(command!);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: style.backgroundColor,
          borderRadius: BorderRadius.circular(isSmall ? 12 : 14),
          border: Border.all(color: style.borderColor),
        ),
        child: Center(
          child: Icon(
            style.icon,
            color: style.iconColor,
            size: isSmall ? 22 : 28,
          ),
        ),
      ),
    );
  }

  _CommandBlockStyle _styleFor(CommandType command) {
    switch (command) {
      case CommandType.moveForward:
        return _CommandBlockStyle(
          icon: Icons.arrow_upward_rounded,
          backgroundColor: AppColors.cyan.withValues(alpha: 0.08),
          borderColor: AppColors.cyan.withValues(alpha: 0.25),
          iconColor: AppColors.cyan,
        );

      case CommandType.turnLeft:
        return _CommandBlockStyle(
          icon: Icons.turn_left_rounded,
          backgroundColor: AppColors.purple.withValues(alpha: 0.08),
          borderColor: AppColors.purple.withValues(alpha: 0.25),
          iconColor: AppColors.purple,
        );

      case CommandType.turnRight:
        return _CommandBlockStyle(
          icon: Icons.turn_right_rounded,
          backgroundColor: AppColors.amber.withValues(alpha: 0.08),
          borderColor: AppColors.amber.withValues(alpha: 0.25),
          iconColor: AppColors.amber,
        );

      case CommandType.ifPathClear:
        return _CommandBlockStyle(
          icon: Icons.diamond_outlined,
          backgroundColor: AppColors.green.withValues(alpha: 0.08),
          borderColor: AppColors.green.withValues(alpha: 0.25),
          iconColor: AppColors.green,
        );

      case CommandType.loop:
        return _CommandBlockStyle(
          icon: Icons.refresh_rounded,
          backgroundColor: AppColors.red.withValues(alpha: 0.08),
          borderColor: AppColors.red.withValues(alpha: 0.25),
          iconColor: AppColors.red,
        );

      case CommandType.loopUntil:
        return _CommandBlockStyle(
          icon: Icons.sync_rounded,
          backgroundColor: AppColors.textMuted.withValues(alpha: 0.08),
          borderColor: AppColors.textMuted.withValues(alpha: 0.20),
          iconColor: AppColors.textMuted,
        );
    }
  }
}

class _CommandBlockStyle {
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;

  const _CommandBlockStyle({
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
  });
}
