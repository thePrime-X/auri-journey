import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/direction.dart';

class GridCell extends StatelessWidget {
  final bool isAuri;
  final bool isGoal;
  final bool isObstacle;
  final bool isTrainingZone;
  final Direction? auriDirection;

  const GridCell({
    super.key,
    required this.isAuri,
    required this.isGoal,
    required this.isObstacle,
    required this.isTrainingZone,
    this.auriDirection,
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
      backgroundColor = AppColors.bg3;
      borderColor = AppColors.amber.withValues(alpha: 0.45);
      child = const Icon(Icons.bolt, color: AppColors.amber, size: 22);
    } else if (isAuri) {
      backgroundColor = AppColors.cyan.withValues(alpha: 0.08);
      borderColor = AppColors.cyan.withValues(alpha: 0.30);
      child = _AuriFace(direction: auriDirection!);
    }

    return AspectRatio(
      aspectRatio: 1,
      child: isGoal
          ? _OuterGoalGlow(
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: Center(child: child),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor),
              ),
              child: Center(child: child),
            ),
    );
  }
}

class _AuriFace extends StatefulWidget {
  final Direction direction;

  const _AuriFace({required this.direction});

  @override
  State<_AuriFace> createState() => _AuriFaceState();
}

class _AuriFaceState extends State<_AuriFace> {
  late Direction _previousDirection;
  bool _isTurning = false;
  late double _turns;

  @override
  void initState() {
    super.initState();
    _previousDirection = widget.direction;
    _turns = _directionToTurns(widget.direction);
  }

  @override
  void didUpdateWidget(covariant _AuriFace oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.direction == _previousDirection) return;

    _turns += _getTurnDelta(_previousDirection, widget.direction);
    _previousDirection = widget.direction;

    setState(() => _isTurning = true);

    Future.delayed(const Duration(milliseconds: 220), () {
      if (mounted) {
        setState(() => _isTurning = false);
      }
    });
  }

  double _directionToTurns(Direction direction) {
    switch (direction) {
      case Direction.up:
        return 0.0;
      case Direction.right:
        return 0.25;
      case Direction.down:
        return 0.5;
      case Direction.left:
        return -0.25;
    }
  }

  double _getTurnDelta(Direction from, Direction to) {
    const order = [
      Direction.up,
      Direction.right,
      Direction.down,
      Direction.left,
    ];

    final fromIndex = order.indexOf(from);
    final toIndex = order.indexOf(to);

    final raw = (toIndex - fromIndex + 4) % 4;

    if (raw == 1) return 0.25; // clockwise 90
    if (raw == 3) return -0.25; // counterclockwise 90
    if (raw == 2) return 0.5; // 180 fallback

    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 42,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Image.asset(
              'assets/images/robot.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),

          AnimatedRotation(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            turns: _turns,
            child: SizedBox(
              width: 42,
              height: 42,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 18,
                      height: 12,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF34D8FF,
                            ).withValues(alpha: _isTurning ? 0.7 : 0.45),
                            blurRadius: _isTurning ? 16 : 10,
                            spreadRadius: _isTurning ? 2 : 1,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.navigation_rounded,
                        size: 14,
                        color: Color(0xFF34D8FF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OuterGoalGlow extends StatefulWidget {
  final Widget child;

  const _OuterGoalGlow({required this.child});

  @override
  State<_OuterGoalGlow> createState() => _OuterGoalGlowState();
}

class _OuterGoalGlowState extends State<_OuterGoalGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final glow = 0.2 + (_controller.value * 0.25);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.amber.withValues(alpha: glow),
                      blurRadius: 10 + (_controller.value * 10),
                      spreadRadius: 1.5,
                    ),
                  ],
                ),
              ),
            ),

            // Solid cell sits above glow, so inside stays normal.
            Positioned.fill(child: child!),
          ],
        );
      },
    );
  }
}
