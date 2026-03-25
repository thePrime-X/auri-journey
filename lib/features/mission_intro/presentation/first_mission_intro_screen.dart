import 'package:flutter/material.dart';

import '../../../shared/widgets/auri_ui.dart';
import '../../boot/widgets/auri_face.dart';
import '../../puzzles/presentation/first_puzzle_screen.dart';

class FirstMissionIntroScreen extends StatelessWidget {
  const FirstMissionIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuriScene(
        signalStrength: 0.95,
        dangerStrength: 0.12,
        child: Column(
          children: [
            const SizedBox(height: 10),
            const AuriHeaderLabel('MISSION // CALIBRATION 01'),
            const SizedBox(height: 10),
            Text(
              'MOVEMENT LOGIC RECOVERY',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.44),
                fontSize: 11,
                letterSpacing: 2.4,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            const AuriFace(
              isHolding: false,
              isComplete: true,
              progress: 1,
              width: 210,
            ),
            const SizedBox(height: 22),
            const AuriPanel(
              child: Text(
                'My base movement logic is unstable. A short test corridor '
                'has been prepared. Reconstruct the correct instruction '
                'sequence so I can move safely again.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.55,
                ),
              ),
            ),
            const SizedBox(height: 18),
            const AuriPanel(
              emphasized: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OBJECTIVE',
                    style: TextStyle(
                      color: AuriColors.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Guide Auri forward through a simple path using the '
                    'correct order of movement commands.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(buildAuriRoute(page: const FirstPuzzleScreen()));
                },
                child: const Text('START CALIBRATION'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
