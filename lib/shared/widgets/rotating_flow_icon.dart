import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui';

class RotatingGlowIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final bool reverse;

  const RotatingGlowIcon({
    super.key,
    required this.icon,
    required this.color,
    this.reverse = false,
  });

  @override
  State<RotatingGlowIcon> createState() => _RotatingGlowIconState();
}

class _RotatingGlowIconState extends State<RotatingGlowIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rotating dashed ring
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final rotation = widget.reverse
                  ? -_controller.value * 2 * pi
                  : _controller.value * 2 * pi;

              return Transform.rotate(
                angle: rotation,
                child: CustomPaint(
                  size: const Size(120, 120),
                  painter: _DashedCirclePainter(widget.color),
                ),
              );
            },
          ),

          // Icon glow that follows the icon silhouette
          Stack(
            alignment: Alignment.center,
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Icon(
                  widget.icon,
                  size: 64,
                  color: widget.color.withValues(alpha: 0.75),
                ),
              ),
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Icon(
                  widget.icon,
                  size: 62,
                  color: widget.color.withValues(alpha: 0.6),
                ),
              ),
              Icon(widget.icon, size: 60, color: widget.color),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;

  _DashedCirclePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const dashWidth = 4.0;
    const dashSpace = 4.0;

    final radius = size.width / 2;
    final circlePath = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius - 0.5),
      );

    for (final metric in circlePath.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final path = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(path, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
