import 'package:flutter/material.dart';

import '../../../shared/widgets/auri_ui.dart';
import '../../boot/widgets/auri_face.dart';
import '../models/onboarding_snapshot.dart';
import '../widgets/onboarding_ui.dart';
import 'concept_reinforcement_screen.dart';

class PuzzleCompletionFeedbackScreen extends StatelessWidget {
  final OnboardingSnapshot snapshot;
  final int rewardCycles;

  const PuzzleCompletionFeedbackScreen({
    super.key,
    this.snapshot = const OnboardingSnapshot(),
    this.rewardCycles = 120,
  });

  void _continue(BuildContext context) {
    final OnboardingSnapshot updatedSnapshot = snapshot.copyWith(
      logicCycles: snapshot.logicCycles + rewardCycles,
    );

    Navigator.of(context).pushReplacement(
      buildAuriRoute(
        page: ConceptReinforcementScreen(snapshot: updatedSnapshot),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuriScene(
        signalStrength: 1,
        dangerStrength: 0,
        child: ListView(
          children: [
            const SizedBox(height: 8),
            const AuriHeaderLabel('CALIBRATION // REWARD STATE'),
            const SizedBox(height: 14),
            Row(
              children: const [
                Expanded(
                  child: Text(
                    'Sequence restored.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                StatusPill(label: 'SUCCESS'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'The corridor is stable again, and Auri can now execute a clean movement chain.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.68),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 26),
            const Center(
              child: AuriFace(
                isHolding: false,
                isComplete: true,
                progress: 1,
                width: 216,
                headOffsetY: -8,
                leanTurns: 0.02,
                glowBoost: 0.22,
                eyeOpenBoost: 0.10,
              ),
            ),
            const SizedBox(height: 22),
            const AuriPanel(
              emphasized: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AURI',
                    style: TextStyle(
                      color: AuriColors.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'That worked perfectly.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'You reduced my movement errors to zero.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const AuriPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SEQUENCE CALIBRATION COMPLETE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Instruction order directly affects execution outcome.',
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
            _LogicCycleRewardPanel(rewardCycles: rewardCycles),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _continue(context),
                child: const Text('CONTINUE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogicCycleRewardPanel extends StatelessWidget {
  final int rewardCycles;

  const _LogicCycleRewardPanel({required this.rewardCycles});

  @override
  Widget build(BuildContext context) {
    return AuriPanel(
      emphasized: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CPU LOAD INCREASE',
            style: TextStyle(
              color: AuriColors.accent.withValues(alpha: 0.92),
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 18),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1400),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return SizedBox(
                height: 160,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _CycleTransferPainter(progress: value),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SignalBar(
                        label: 'NEURAL RESERVE',
                        value: 0.40 * value,
                        trailing: '${(40 * value).round()}%',
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '+$rewardCycles LOGIC CYCLES',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.98),
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Reward state archived for dashboard sync.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.60),
                              fontSize: 13,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CycleTransferPainter extends CustomPainter {
  final double progress;

  const _CycleTransferPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final List<double> offsets = <double>[-68, 0, 68];

    for (int index = 0; index < offsets.length; index++) {
      final double alphaBase = (0.24 + (0.16 * index)) * progress;
      paint.color = AuriColors.accent.withValues(alpha: alphaBase);

      final Path path = Path()
        ..moveTo(size.width / 2, size.height - 28)
        ..quadraticBezierTo(
          size.width / 2 + (offsets[index] * 0.35),
          size.height * (0.70 - (0.10 * progress)),
          size.width / 2 + offsets[index],
          34,
        );

      final Iterable<dynamic> metrics = path.computeMetrics();
      for (final dynamic metric in metrics) {
        final Path extract = metric.extractPath(
          0,
          metric.length * progress.clamp(0.0, 1.0),
        );
        canvas.drawPath(extract, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CycleTransferPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
