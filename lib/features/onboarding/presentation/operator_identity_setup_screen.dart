import 'package:flutter/material.dart';

import '../../../shared/widgets/auri_ui.dart';
import '../models/onboarding_snapshot.dart';
import '../widgets/onboarding_ui.dart';
import 'neural_link_dashboard_screen.dart';

class OperatorIdentitySetupScreen extends StatefulWidget {
  final OnboardingSnapshot snapshot;

  const OperatorIdentitySetupScreen({super.key, required this.snapshot});

  @override
  State<OperatorIdentitySetupScreen> createState() =>
      _OperatorIdentitySetupScreenState();
}

class _OperatorIdentitySetupScreenState
    extends State<OperatorIdentitySetupScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _confirmOperatorLink() {
    final String resolvedName = _nameController.text.trim().isEmpty
        ? 'Operator'
        : _nameController.text.trim();

    Navigator.of(context).pushReplacement(
      buildAuriRoute(
        page: NeuralLinkDashboardScreen(
          snapshot: widget.snapshot.copyWith(
            cloudLinked: true,
            operatorName: resolvedName,
          ),
          introMessage:
              'Operator profile registered. New calibration sequences are available.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuriScene(
        signalStrength: 0.98,
        dangerStrength: 0.04,
        child: ListView(
          children: [
            const SizedBox(height: 8),
            const AuriHeaderLabel('OPERATOR // LINK INITIALIZATION'),
            const SizedBox(height: 14),
            Row(
              children: const [
                Expanded(
                  child: Text(
                    'Initialize operator identity.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                StatusPill(label: 'CLOUD LINK'),
              ],
            ),
            const SizedBox(height: 22),
            AuriPanel(
              emphasized: true,
              child: Column(
                children: [
                  const _OperatorSigil(),
                  const SizedBox(height: 18),
                  Text(
                    'HOLOGRAPHIC ID CARD',
                    style: TextStyle(
                      color: AuriColors.accent.withValues(alpha: 0.94),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Operator Name',
                      labelStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.52),
                      ),
                      hintText: 'Enter your operator name',
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.26),
                      ),
                      filled: true,
                      fillColor: Colors.black.withValues(alpha: 0.16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: AuriColors.accent.withValues(alpha: 0.42),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.black.withValues(alpha: 0.16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RANK INITIALIZATION',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.52),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Intern Debugger',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const AuriPanel(
              child: Text(
                'This identity establishes your long-term operator link and personalizes future calibrations.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.55,
                ),
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmOperatorLink,
                child: const Text('CONFIRM OPERATOR LINK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OperatorSigil extends StatelessWidget {
  const _OperatorSigil();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 156,
      height: 156,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.16),
            AuriColors.surfaceRaised,
            AuriColors.surface,
          ],
        ),
        border: Border.all(color: AuriColors.accent.withValues(alpha: 0.24)),
        boxShadow: [
          BoxShadow(
            color: AuriColors.accent.withValues(alpha: 0.10),
            blurRadius: 22,
            spreadRadius: 1,
          ),
        ],
      ),
      child: CustomPaint(painter: _SigilPainter()),
    );
  }
}

class _SigilPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = AuriColors.accent.withValues(alpha: 0.86);

    final Paint fill = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: 0.08);

    final Path outer = Path()
      ..moveTo(size.width * 0.50, size.height * 0.14)
      ..lineTo(size.width * 0.78, size.height * 0.28)
      ..lineTo(size.width * 0.78, size.height * 0.60)
      ..lineTo(size.width * 0.50, size.height * 0.82)
      ..lineTo(size.width * 0.22, size.height * 0.60)
      ..lineTo(size.width * 0.22, size.height * 0.28)
      ..close();

    canvas.drawPath(outer, fill);
    canvas.drawPath(outer, stroke);

    final Paint innerStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withValues(alpha: 0.52);

    canvas.drawCircle(
      Offset(size.width * 0.50, size.height * 0.46),
      size.width * 0.14,
      innerStroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.50, size.height * 0.24),
      Offset(size.width * 0.50, size.height * 0.68),
      innerStroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.34, size.height * 0.46),
      Offset(size.width * 0.66, size.height * 0.46),
      innerStroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
