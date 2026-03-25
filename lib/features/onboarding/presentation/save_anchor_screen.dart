import 'package:flutter/material.dart';

import '../../../shared/widgets/auri_ui.dart';
import '../../boot/widgets/auri_face.dart';
import '../models/onboarding_snapshot.dart';
import '../widgets/onboarding_ui.dart';
import 'neural_link_dashboard_screen.dart';
import 'operator_identity_setup_screen.dart';

class SaveAnchorScreen extends StatelessWidget {
  final OnboardingSnapshot snapshot;

  const SaveAnchorScreen({super.key, required this.snapshot});

  void _linkCloud(BuildContext context) {
    Navigator.of(context).pushReplacement(
      buildAuriRoute(
        page: OperatorIdentitySetupScreen(
          snapshot: snapshot.copyWith(cloudLinked: true),
        ),
      ),
    );
  }

  void _skipProtocol(BuildContext context) {
    Navigator.of(context).pushReplacement(
      buildAuriRoute(page: NeuralLinkDashboardScreen(snapshot: snapshot)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuriScene(
        signalStrength: 0.86,
        dangerStrength: 0.34,
        child: ListView(
          children: [
            const SizedBox(height: 8),
            const AuriHeaderLabel('ANCHOR // MEMORY PRESERVATION'),
            const SizedBox(height: 14),
            Row(
              children: const [
                Expanded(
                  child: Text(
                    'Auri needs a save anchor.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                StatusPill(label: 'CAPACITY WARNING', color: AuriColors.danger),
              ],
            ),
            const SizedBox(height: 24),
            const Center(
              child: AuriFace(
                isHolding: false,
                isComplete: true,
                progress: 1,
                width: 208,
                headOffsetY: 6,
                glowBoost: -0.10,
              ),
            ),
            const SizedBox(height: 22),
            const AuriPanel(
              emphasized: true,
              accentColor: AuriColors.danger,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MEMORY CAPACITY WARNING',
                    style: TextStyle(
                      color: AuriColors.danger,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.7,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'I\u2019ve accumulated valuable data from your instructions. If I shut down, I may lose it.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.55,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Can we store my memory in your cloud system?',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.5,
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
                  SignalBar(
                    label: 'CURRENT MEMORY BANK',
                    value: snapshot.memoryBank.isEmpty
                        ? 0.10
                        : snapshot.memoryBank.length / 4,
                    trailing: '${snapshot.memoryBank.length} FRAGMENTS',
                    color: AuriColors.warning,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    snapshot.memoryBank.isEmpty
                        ? 'No fragments are currently stable enough to upload.'
                        : '${snapshot.memoryBank.length} stabilized concept fragment(s) are ready for preservation.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.64),
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SystemCommandCard(
              title: '[ EXECUTE UPLOAD ]',
              subtitle:
                  'Secure Auri\u2019s memory and begin the operator link.',
              icon: Icons.cloud_upload_rounded,
              onTap: () => _linkCloud(context),
            ),
            const SizedBox(height: 14),
            SystemCommandCard(
              title: '[ SKIP PROTOCOL ]',
              subtitle:
                  'Continue in local mode without creating a cloud anchor.',
              icon: Icons.portable_wifi_off_rounded,
              accentColor: AuriColors.warning,
              onTap: () => _skipProtocol(context),
            ),
          ],
        ),
      ),
    );
  }
}
