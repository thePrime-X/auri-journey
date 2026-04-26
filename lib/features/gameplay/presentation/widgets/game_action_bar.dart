import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class GameActionBar extends StatefulWidget {
  final VoidCallback onRun;
  final VoidCallback onExit;
  final bool isBusy;

  const GameActionBar({
    super.key,
    required this.onRun,
    required this.onExit,
    this.isBusy = false,
  });

  @override
  State<GameActionBar> createState() => _GameActionBarState();
}

class _GameActionBarState extends State<GameActionBar> {
  bool _isRunPressed = false;
  bool _isExitPressed = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTapDown: widget.isBusy
                ? null
                : (_) => setState(() => _isRunPressed = true),
            onTapUp: widget.isBusy
                ? null
                : (_) => setState(() => _isRunPressed = false),
            onTapCancel: widget.isBusy
                ? null
                : () => setState(() => _isRunPressed = false),
            onTap: widget.isBusy ? null : widget.onRun,
            child: AnimatedScale(
              scale: _isRunPressed ? 0.97 : 1,
              duration: const Duration(milliseconds: 110),
              curve: Curves.easeOut,
              child: AnimatedContainer(
                height: 52,
                duration: const Duration(milliseconds: 160),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.isBusy
                        ? [
                            AppColors.cyan.withValues(alpha: 0.45),
                            AppColors.cyan.withValues(alpha: 0.32),
                          ]
                        : [
                            AppColors.cyan,
                            AppColors.cyan.withValues(alpha: 0.86),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: widget.isBusy
                      ? []
                      : [
                          BoxShadow(
                            color: AppColors.cyan.withValues(alpha: 0.28),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                ),
                child: Center(
                  child: widget.isBusy
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          '▶ RUN',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTapDown: widget.isBusy
                ? null
                : (_) => setState(() => _isExitPressed = true),
            onTapUp: widget.isBusy
                ? null
                : (_) => setState(() => _isExitPressed = false),
            onTapCancel: widget.isBusy
                ? null
                : () => setState(() => _isExitPressed = false),
            onTap: widget.isBusy ? null : widget.onExit,
            child: AnimatedScale(
              scale: _isExitPressed ? 0.97 : 1,
              duration: const Duration(milliseconds: 110),
              curve: Curves.easeOut,
              child: AnimatedContainer(
                height: 52,
                duration: const Duration(milliseconds: 160),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.isBusy
                        ? AppColors.border2.withValues(alpha: 0.35)
                        : AppColors.border2.withValues(alpha: 0.75),
                    width: 1.4,
                  ),
                ),
                child: Center(
                  child: Text(
                    '✕ EXIT',
                    style: TextStyle(
                      color: widget.isBusy
                          ? AppColors.textMuted.withValues(alpha: 0.45)
                          : AppColors.textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
