import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../shared/widgets/auri_ui.dart';
import '../../puzzles/presentation/loop_calibration_screen.dart';
import '../models/onboarding_snapshot.dart';
import '../widgets/onboarding_ui.dart';

class ConceptReinforcementScreen extends StatefulWidget {
  final OnboardingSnapshot snapshot;

  const ConceptReinforcementScreen({super.key, required this.snapshot});

  @override
  State<ConceptReinforcementScreen> createState() =>
      _ConceptReinforcementScreenState();
}

class _ConceptReinforcementScreenState extends State<ConceptReinforcementScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..addListener(() => setState(() {}))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _storeMemory() {
    final OnboardingSnapshot updatedSnapshot = widget.snapshot.unlock(
      sequenceMemoryFragment,
    );

    Navigator.of(context).pushReplacement(
      buildAuriRoute(page: LoopCalibrationScreen(snapshot: updatedSnapshot)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool stabilized = _controller.value >= 0.5;

    return Scaffold(
      body: AuriScene(
        signalStrength: 1,
        dangerStrength: 0.02,
        child: ListView(
          children: [
            const SizedBox(height: 8),
            const AuriHeaderLabel('MEMORY BANK // FRAGMENT STABILIZING'),
            const SizedBox(height: 14),
            Row(
              children: const [
                Expanded(
                  child: Text(
                    'Memory unlocked.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                StatusPill(label: 'FRAGMENT LIVE'),
              ],
            ),
            const SizedBox(height: 26),
            _MemoryShard(controllerValue: _controller.value),
            const SizedBox(height: 24),
            const AuriPanel(
              emphasized: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MEMORY UNLOCKED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'SEQUENCE',
                    style: TextStyle(
                      color: AuriColors.accent,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Instructions must be executed in the correct order to produce the desired result.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            AuriPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MICRO VISUALIZATION',
                    style: TextStyle(
                      color: AuriColors.accent.withValues(alpha: 0.92),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 360),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.04, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _SequenceStateCard(
                      key: ValueKey<bool>(stabilized),
                      stabilized: stabilized,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _storeMemory,
                child: const Text('STORE IN MEMORY'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoryShard extends StatelessWidget {
  final double controllerValue;

  const _MemoryShard({required this.controllerValue});

  @override
  Widget build(BuildContext context) {
    final double angle = controllerValue * math.pi * 2;
    final double pulse = 1 + (0.08 * math.sin(angle));

    return Center(
      child: Transform.scale(
        scale: pulse,
        child: SizedBox(
          width: 170,
          height: 170,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AuriColors.accent.withValues(alpha: 0.24),
                      AuriColors.accent.withValues(alpha: 0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Transform.rotate(
                angle: angle + (math.pi / 4),
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.88),
                        AuriColors.accentWarm,
                        AuriColors.accentMuted,
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AuriColors.accent.withValues(alpha: 0.24),
                        blurRadius: 28,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              Transform.rotate(
                angle: -angle + (math.pi / 4),
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withValues(alpha: 0.18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.42),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SequenceStateCard extends StatelessWidget {
  final bool stabilized;

  const _SequenceStateCard({super.key, required this.stabilized});

  @override
  Widget build(BuildContext context) {
    final List<String> commands = stabilized
        ? const <String>['FORWARD', 'FORWARD', 'FORWARD']
        : const <String>['FORWARD', 'RIGHT', 'FORWARD'];

    final Color accent = stabilized ? AuriColors.accent : AuriColors.danger;
    final IconData icon = stabilized
        ? Icons.check_circle_rounded
        : Icons.close_rounded;

    return Container(
      key: key,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.black.withValues(alpha: 0.16),
        border: Border.all(color: accent.withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accent, size: 18),
              const SizedBox(width: 8),
              Text(
                stabilized ? 'ORDER STABILIZED' : 'ORDER CORRUPTED',
                style: TextStyle(
                  color: accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: commands.map((String command) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: accent.withValues(alpha: 0.12),
                  border: Border.all(color: accent.withValues(alpha: 0.20)),
                ),
                child: Text(
                  command,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.94),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Text(
            stabilized
                ? 'Auri reaches the target because each instruction lands in the correct position.'
                : 'A single misplaced instruction breaks the path and corrupts the outcome.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.68),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
