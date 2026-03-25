import 'package:flutter/material.dart';

import '../../../shared/widgets/auri_ui.dart';

class CorridorView extends StatelessWidget {
  final int auriPosition;
  final int totalTiles;
  final bool isRunning;

  const CorridorView({
    super.key,
    required this.auriPosition,
    this.totalTiles = 4,
    this.isRunning = false,
  });

  @override
  Widget build(BuildContext context) {
    return AuriPanel(
      emphasized: true,
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 180,
        child: LayoutBuilder(
          builder: (context, constraints) {
            const double gap = 10;
            const double botSize = 52;
            final double tileWidth =
                (constraints.maxWidth - (gap * (totalTiles - 1))) / totalTiles;
            final double left =
                (auriPosition * (tileWidth + gap)) +
                ((tileWidth - botSize) / 2);

            return Stack(
              children: [
                Positioned(
                  left: 18,
                  right: 18,
                  bottom: 40,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                Row(
                  children: List.generate(totalTiles, (index) {
                    final bool isGoal = index == totalTiles - 1;

                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: index == totalTiles - 1 ? 0 : gap,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'T${index.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.36),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.6,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: tileWidth,
                              height: 108,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: isGoal
                                      ? [
                                          AuriColors.accent.withValues(
                                            alpha: 0.24,
                                          ),
                                          AuriColors.surfaceRaised,
                                        ]
                                      : [
                                          Colors.white.withValues(alpha: 0.05),
                                          AuriColors.surfaceMuted,
                                        ],
                                ),
                                border: Border.all(
                                  color: isGoal
                                      ? AuriColors.accent.withValues(
                                          alpha: 0.40,
                                        )
                                      : Colors.white.withValues(alpha: 0.05),
                                ),
                              ),
                              child: isGoal
                                  ? Center(
                                      child: Icon(
                                        Icons.flag_rounded,
                                        color: AuriColors.accent.withValues(
                                          alpha: 0.92,
                                        ),
                                        size: 30,
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 340),
                  curve: Curves.easeInOutCubic,
                  left: left,
                  bottom: 28,
                  child: _PuzzleAuri(isRunning: isRunning),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PuzzleAuri extends StatelessWidget {
  final bool isRunning;

  const _PuzzleAuri({required this.isRunning});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 220),
      scale: isRunning ? 1.04 : 1,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF1F5F8), Color(0xFFBBC7D0), Color(0xFF8A97A1)],
          ),
          boxShadow: [
            BoxShadow(
              color: AuriColors.accent.withValues(
                alpha: isRunning ? 0.26 : 0.16,
              ),
              blurRadius: isRunning ? 22 : 16,
              spreadRadius: isRunning ? 1 : 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.26),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 28,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFF111418),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _MiniEye(active: true),
                const SizedBox(width: 4),
                _MiniEye(active: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniEye extends StatelessWidget {
  final bool active;

  const _MiniEye({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AuriColors.accent : Colors.white10,
        boxShadow: active
            ? [
                BoxShadow(
                  color: AuriColors.accent.withValues(alpha: 0.36),
                  blurRadius: 8,
                ),
              ]
            : const [],
      ),
    );
  }
}
