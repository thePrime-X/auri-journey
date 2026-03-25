import 'package:flutter/material.dart';

class AuriColors {
  static const Color voidBlack = Color(0xFF05080C);
  static const Color midnight = Color(0xFF0B1117);
  static const Color surface = Color(0xFF111820);
  static const Color surfaceRaised = Color(0xFF151F28);
  static const Color surfaceMuted = Color(0xFF0D1319);
  static const Color outline = Color(0xFF26323D);
  static const Color accent = Color(0xFF72FFE2);
  static const Color accentMuted = Color(0xFF1E9D8E);
  static const Color accentWarm = Color(0xFFB5FFF1);
  static const Color danger = Color(0xFFFF5B6E);
  static const Color warning = Color(0xFFFFC96A);
}

class AuriScene extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double signalStrength;
  final double dangerStrength;

  const AuriScene({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    this.signalStrength = 1,
    this.dangerStrength = 0,
  });

  @override
  Widget build(BuildContext context) {
    final double clampedSignal = signalStrength.clamp(0.0, 1.0);
    final double clampedDanger = dangerStrength.clamp(0.0, 1.0);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(
                  AuriColors.voidBlack,
                  const Color(0xFF12202A),
                  clampedSignal * 0.65,
                ) ??
                AuriColors.voidBlack,
            Color.lerp(
                  AuriColors.midnight,
                  const Color(0xFF13202A),
                  clampedSignal * 0.55,
                ) ??
                AuriColors.midnight,
            Color.lerp(
                  const Color(0xFF070A0E),
                  const Color(0xFF19232D),
                  clampedSignal * 0.35,
                ) ??
                const Color(0xFF070A0E),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -140,
            right: -110,
            child: _GlowOrb(
              color: AuriColors.accent.withValues(
                alpha: 0.14 + (0.22 * clampedSignal),
              ),
              size: 280,
            ),
          ),
          Positioned(
            top: 100,
            left: -130,
            child: _GlowOrb(
              color: AuriColors.danger.withValues(
                alpha: 0.02 + (0.18 * clampedDanger),
              ),
              size: 240,
            ),
          ),
          Positioned(
            bottom: -150,
            right: -80,
            child: _GlowOrb(
              color: Colors.white.withValues(
                alpha: 0.05 + (0.06 * clampedSignal),
              ),
              size: 260,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(
                        alpha: 0.03 + (0.04 * clampedSignal),
                      ),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.16),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(padding: padding, child: child),
          ),
        ],
      ),
    );
  }
}

class AuriPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color accentColor;
  final bool emphasized;

  const AuriPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.accentColor = AuriColors.accent,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AuriColors.surfaceRaised, AuriColors.surface],
        ),
        border: Border.all(
          color: emphasized
              ? accentColor.withValues(alpha: 0.30)
              : Colors.white.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.26),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: accentColor.withValues(alpha: emphasized ? 0.10 : 0.04),
            blurRadius: emphasized ? 22 : 14,
            spreadRadius: emphasized ? 1 : 0,
          ),
        ],
      ),
      child: child,
    );
  }
}

class AuriHeaderLabel extends StatelessWidget {
  final String text;

  const AuriHeaderLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 13,
        letterSpacing: 3,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

ButtonStyle auriPrimaryButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: AuriColors.accent,
    foregroundColor: Colors.black,
    elevation: 0,
    padding: const EdgeInsets.symmetric(vertical: 18),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    textStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.2,
    ),
  );
}

ButtonStyle auriSecondaryButtonStyle() {
  return OutlinedButton.styleFrom(
    foregroundColor: Colors.white,
    side: BorderSide(color: Colors.white.withValues(alpha: 0.16)),
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.1,
    ),
  );
}

Route<T> buildAuriRoute<T>({
  required Widget page,
  Duration duration = const Duration(milliseconds: 500),
  Offset begin = const Offset(0, 0.04),
}) {
  return PageRouteBuilder<T>(
    transitionDuration: duration,
    pageBuilder: (context, animation, secondaryAnimation) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        child: SlideTransition(
          position: Tween<Offset>(begin: begin, end: Offset.zero).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: page,
        ),
      );
    },
  );
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: size * 0.55,
            spreadRadius: size * 0.12,
          ),
        ],
      ),
    );
  }
}
