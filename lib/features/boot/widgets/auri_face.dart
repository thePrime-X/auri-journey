import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../shared/widgets/auri_ui.dart';

class AuriFace extends StatelessWidget {
  final bool isHolding;
  final bool isComplete;
  final double progress;
  final double width;
  final double headOffsetY;
  final double leanTurns;
  final double glowBoost;
  final double eyeOpenBoost;

  const AuriFace({
    super.key,
    required this.isHolding,
    required this.isComplete,
    required this.progress,
    this.width = 240,
    this.headOffsetY = 0,
    this.leanTurns = 0,
    this.glowBoost = 0,
    this.eyeOpenBoost = 0,
  });

  @override
  Widget build(BuildContext context) {
    final double normalizedProgress = progress.clamp(0.0, 1.0);
    final bool active = isHolding || isComplete;
    final double scale = width / 240;

    final double baseEyeGlow = isComplete
        ? 1.0
        : (isHolding ? 0.35 + (normalizedProgress * 0.55) : 0.0);
    final double eyeGlow = (baseEyeGlow + glowBoost).clamp(0.0, 1.2);
    final double baseEyeOpen = isComplete
        ? 1.0
        : (isHolding ? 0.30 + (normalizedProgress * 0.48) : 0.08);
    final double eyeOpen = (baseEyeOpen + eyeOpenBoost).clamp(0.08, 1.0);
    final double baseHeadDrop = isComplete
        ? 0
        : (isHolding ? 14 - (normalizedProgress * 10) : 28);
    final double headDrop = baseHeadDrop + headOffsetY;
    final double baseChinTilt = isComplete
        ? 0
        : (isHolding ? 0.012 - (normalizedProgress * 0.018) : 0.028);
    final double chinTilt = baseChinTilt + leanTurns;

    final Color shellColor =
        Color.lerp(
          const Color(0xFF58616C),
          const Color(0xFFD3DEE7),
          0.18 + (normalizedProgress * 0.82),
        ) ??
        const Color(0xFF58616C);
    final Color shellShade =
        Color.lerp(
          const Color(0xFF2A3138),
          const Color(0xFF697681),
          normalizedProgress,
        ) ??
        const Color(0xFF2A3138);
    final Color visorColor =
        Color.lerp(
          const Color(0xFF0A0D10),
          const Color(0xFF162028),
          normalizedProgress,
        ) ??
        const Color(0xFF0A0D10);

    return Transform.scale(
      scale: scale,
      child: SizedBox(
        width: 240,
        height: 250,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 8,
              child: IgnorePointer(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  width: 196,
                  height: 196,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AuriColors.accent.withValues(
                          alpha: 0.08 + (0.18 * eyeGlow),
                        ),
                        AuriColors.accent.withValues(
                          alpha: 0.03 + (0.08 * eyeGlow),
                        ),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 34,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
                offset: Offset(0, headDrop / 170),
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  turns: chinTilt,
                  child: _HeadShell(
                    active: active,
                    complete: isComplete,
                    eyeGlow: eyeGlow,
                    eyeOpen: eyeOpen,
                    shellColor: shellColor,
                    shellShade: shellShade,
                    visorColor: visorColor,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 168,
              child: _NeckAssembly(
                active: active,
                eyeGlow: eyeGlow,
                shellColor: shellColor,
                shellShade: shellShade,
                progress: normalizedProgress,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeadShell extends StatelessWidget {
  final bool active;
  final bool complete;
  final double eyeGlow;
  final double eyeOpen;
  final Color shellColor;
  final Color shellShade;
  final Color visorColor;

  const _HeadShell({
    required this.active,
    required this.complete,
    required this.eyeGlow,
    required this.eyeOpen,
    required this.shellColor,
    required this.shellShade,
    required this.visorColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 148,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: _Antenna(active: active, eyeGlow: eyeGlow),
          ),
          Positioned(
            left: -12,
            top: 52,
            child: _TempleNode(
              side: Alignment.centerLeft,
              active: active,
              eyeGlow: eyeGlow,
              shellColor: shellColor,
            ),
          ),
          Positioned(
            right: -12,
            top: 52,
            child: _TempleNode(
              side: Alignment.centerRight,
              active: active,
              eyeGlow: eyeGlow,
              shellColor: shellColor,
            ),
          ),
          Container(
            width: 154,
            height: 126,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(shellColor, Colors.white, 0.18) ?? shellColor,
                  shellColor,
                  shellShade,
                ],
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.32),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: AuriColors.accent.withValues(
                    alpha: 0.08 + (0.16 * eyeGlow),
                  ),
                  blurRadius: 26,
                  spreadRadius: complete ? 2 : 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: Column(
                children: [
                  Container(
                    width: 36,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: Colors.white.withValues(alpha: 0.16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [const Color(0xFF06080B), visorColor],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned.fill(
                            child: IgnorePointer(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.03),
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.12),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _Eye(openness: eyeOpen, glow: eyeGlow),
                              const SizedBox(width: 18),
                              _Eye(openness: eyeOpen, glow: eyeGlow),
                            ],
                          ),
                          Positioned(
                            left: 18,
                            right: 18,
                            bottom: 13,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 240),
                              opacity: complete
                                  ? 0.7
                                  : (active ? 0.38 + (0.18 * eyeGlow) : 0.08),
                              child: Container(
                                height: 5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      AuriColors.accent.withValues(
                                        alpha: 0.28 + (0.28 * eyeGlow),
                                      ),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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

class _NeckAssembly extends StatelessWidget {
  final bool active;
  final double eyeGlow;
  final Color shellColor;
  final Color shellShade;
  final double progress;

  const _NeckAssembly({
    required this.active,
    required this.eyeGlow,
    required this.shellColor,
    required this.shellShade,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final Color nodeColor =
        Color.lerp(
          const Color(0xFF1A2229),
          const Color(0xFF355461),
          progress,
        ) ??
        const Color(0xFF1A2229);

    return Column(
      children: [
        Container(
          width: 22,
          height: 18,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF9AA4AE), Color(0xFF4D5964)],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 126,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(shellColor, Colors.white, 0.12) ?? shellColor,
                shellColor,
                shellShade,
              ],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.26),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 56,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: nodeColor,
                border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
                boxShadow: [
                  BoxShadow(
                    color: AuriColors.accent.withValues(
                      alpha: 0.12 + (0.22 * eyeGlow),
                    ),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 16 + (10 * progress),
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: active
                        ? AuriColors.accentWarm.withValues(alpha: 0.92)
                        : Colors.white24,
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

class _Antenna extends StatelessWidget {
  final bool active;
  final double eyeGlow;

  const _Antenna({required this.active, required this.eyeGlow});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          width: 10,
          height: 22,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFA4AFB8), Color(0xFF4A545D)],
            ),
          ),
        ),
        const SizedBox(height: 4),
        AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? AuriColors.accent.withValues(alpha: 0.65 + (0.35 * eyeGlow))
                : const Color(0xFF65707A),
            boxShadow: [
              BoxShadow(
                color: AuriColors.accent.withValues(
                  alpha: 0.12 + (0.32 * eyeGlow),
                ),
                blurRadius: 20,
                spreadRadius: eyeGlow > 0.8 ? 1 : 0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TempleNode extends StatelessWidget {
  final Alignment side;
  final bool active;
  final double eyeGlow;
  final Color shellColor;

  const _TempleNode({
    required this.side,
    required this.active,
    required this.eyeGlow,
    required this.shellColor,
  });

  @override
  Widget build(BuildContext context) {
    final double rotation = side == Alignment.centerLeft ? -0.04 : 0.04;

    return AnimatedRotation(
      duration: const Duration(milliseconds: 280),
      turns: rotation,
      child: Container(
        width: 24,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: side == Alignment.centerLeft
                ? Alignment.topRight
                : Alignment.topLeft,
            end: side == Alignment.centerLeft
                ? Alignment.bottomLeft
                : Alignment.bottomRight,
            colors: [
              Color.lerp(shellColor, Colors.white, 0.14) ?? shellColor,
              shellColor,
            ],
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: AuriColors.accent.withValues(
                alpha: 0.05 + (0.12 * eyeGlow),
              ),
              blurRadius: 14,
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 6,
            height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: active
                  ? AuriColors.accent.withValues(alpha: 0.55 + (0.25 * eyeGlow))
                  : Colors.white12,
            ),
          ),
        ),
      ),
    );
  }
}

class _Eye extends StatelessWidget {
  final double openness;
  final double glow;

  const _Eye({required this.openness, required this.glow});

  @override
  Widget build(BuildContext context) {
    final double clampedOpen = openness.clamp(0.08, 1.0);
    final double height = 28 * clampedOpen;
    final double width = 22 + (4 * math.min(glow, 1));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: glow > 0
              ? [Colors.white, AuriColors.accentWarm, AuriColors.accent]
              : const [Color(0xFF0A0C0F), Color(0xFF020304)],
        ),
        boxShadow: glow > 0
            ? [
                BoxShadow(
                  color: AuriColors.accent.withValues(
                    alpha: 0.24 + (0.32 * glow),
                  ),
                  blurRadius: 18 + (10 * glow),
                  spreadRadius: glow > 0.75 ? 1 : 0,
                ),
              ]
            : const [],
      ),
    );
  }
}
