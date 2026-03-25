import 'package:flutter/material.dart';

import '../../../shared/widgets/auri_ui.dart';
import '../../mission_intro/presentation/first_mission_intro_screen.dart';
import '../widgets/auri_face.dart';
import '../widgets/dialogue_panel.dart';

class AuriGreetingScreen extends StatefulWidget {
  const AuriGreetingScreen({super.key});

  @override
  State<AuriGreetingScreen> createState() => _AuriGreetingScreenState();
}

class _AuriGreetingScreenState extends State<AuriGreetingScreen> {
  static const List<String> _messages = [
    'Systems functional... Wait.',
    'Who initialized the sequence? Is that... my Operator?',
    'My movement routines are unstable. I need your help to calibrate them.',
  ];

  int _dialogueStep = 0;

  void _advance() {
    if (_dialogueStep < _messages.length - 1) {
      setState(() {
        _dialogueStep++;
      });
      return;
    }

    Navigator.of(
      context,
    ).push(buildAuriRoute(page: const FirstMissionIntroScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastStep = _dialogueStep == _messages.length - 1;

    return Scaffold(
      body: AuriScene(
        signalStrength: 1,
        dangerStrength: 0.08,
        child: Column(
          children: [
            const SizedBox(height: 10),
            const AuriHeaderLabel('AURI // LINK ESTABLISHED'),
            const SizedBox(height: 10),
            Text(
              'OPERATOR CHANNEL VERIFIED',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.44),
                fontSize: 11,
                letterSpacing: 2.4,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 26),
            const AuriFace(
              isHolding: false,
              isComplete: true,
              progress: 1,
              width: 220,
            ),
            const SizedBox(height: 24),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.06),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: DialoguePanel(
                key: ValueKey(_dialogueStep),
                speaker: 'AURI',
                message: _messages[_dialogueStep],
                step: _dialogueStep + 1,
                totalSteps: _messages.length,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _advance,
                child: Text(isLastStep ? 'BEGIN CALIBRATION' : 'CONTINUE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
