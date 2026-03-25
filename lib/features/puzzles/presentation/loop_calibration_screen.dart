import 'dart:async';

import 'package:flutter/material.dart';

import '../../../shared/widgets/auri_ui.dart';
import '../../onboarding/models/onboarding_snapshot.dart';
import '../../onboarding/presentation/save_anchor_screen.dart';
import '../../onboarding/widgets/onboarding_ui.dart';
import '../widgets/command_chip.dart';
import '../widgets/corridor_view.dart';

class LoopCalibrationScreen extends StatefulWidget {
  final OnboardingSnapshot snapshot;

  const LoopCalibrationScreen({super.key, required this.snapshot});

  @override
  State<LoopCalibrationScreen> createState() => _LoopCalibrationScreenState();
}

class _LoopCalibrationScreenState extends State<LoopCalibrationScreen> {
  static const int _goalPosition = 5;
  static const int _repeatCount = 5;

  bool _repeatLoaded = false;
  String? _nestedCommand;
  bool _isRunning = false;
  bool _hasSucceeded = false;
  int _auriPosition = 0;
  String _feedback = 'Load REPEAT (x5), then place FORWARD inside the loop.';

  void _loadRepeat() {
    if (_isRunning || _repeatLoaded) return;

    setState(() {
      _repeatLoaded = true;
      _hasSucceeded = false;
      _feedback = 'Loop frame ready. Insert the repeated movement command.';
    });
  }

  void _insertForward() {
    if (_isRunning || !_repeatLoaded) {
      return;
    }

    setState(() {
      _nestedCommand = 'FORWARD';
      _hasSucceeded = false;
      _feedback = 'Compressed logic assembled. Execute the loop.';
    });
  }

  void _reset() {
    if (_isRunning) return;

    setState(() {
      _repeatLoaded = false;
      _nestedCommand = null;
      _hasSucceeded = false;
      _auriPosition = 0;
      _feedback = 'Load REPEAT (x5), then place FORWARD inside the loop.';
    });
  }

  Future<void> _execute() async {
    if (_isRunning || !_repeatLoaded || _nestedCommand == null) {
      setState(() {
        _feedback =
            'The loop is incomplete. Build REPEAT (x5) with FORWARD inside.';
      });
      return;
    }

    setState(() {
      _isRunning = true;
      _hasSucceeded = false;
      _auriPosition = 0;
      _feedback = 'Executing compressed loop...';
    });

    for (int index = 0; index < _repeatCount; index++) {
      if (!mounted) return;

      await Future<void>.delayed(const Duration(milliseconds: 340));
      if (!mounted) return;

      setState(() {
        if (_nestedCommand == 'FORWARD' && _auriPosition < _goalPosition) {
          _auriPosition++;
        }
      });
    }

    await Future<void>.delayed(const Duration(milliseconds: 240));
    if (!mounted) return;

    final bool success =
        _nestedCommand == 'FORWARD' && _auriPosition == _goalPosition;

    setState(() {
      _isRunning = false;
      _hasSucceeded = success;
      _feedback = success
          ? 'That reduced processing load by 60%.'
          : 'Compression failed. Rebuild the loop and try again.';
    });
  }

  void _continue() {
    final OnboardingSnapshot updatedSnapshot = widget.snapshot.unlock(
      loopsMemoryFragment,
    );

    Navigator.of(context).pushReplacement(
      buildAuriRoute(page: SaveAnchorScreen(snapshot: updatedSnapshot)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuriScene(
        signalStrength: _hasSucceeded ? 1 : 0.94,
        dangerStrength: _hasSucceeded ? 0.02 : 0.12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const AuriHeaderLabel('PUZZLE // LOOP CALIBRATION 02'),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(
                  child: Text(
                    'Compress the routine.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                StatusPill(label: 'LOOPS'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Auri keeps repeating the same movement instruction. Collapse the waste into a single reusable operation.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.66),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            const AuriPanel(
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
                    'I am repeating identical movement instructions multiple times.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'This is inefficient. My system is overheating.',
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
            AuriPanel(
              emphasized: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SignalBar(
                    label: 'PROCESSING LOAD',
                    value: _hasSucceeded ? 0.40 : 1,
                    trailing: _hasSucceeded ? '40%' : '100%',
                    color: _hasSucceeded
                        ? AuriColors.accent
                        : AuriColors.warning,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _feedback,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  CorridorView(
                    auriPosition: _auriPosition,
                    totalTiles: 6,
                    isRunning: _isRunning,
                  ),
                  const SizedBox(height: 16),
                  _RepeatAssembler(
                    repeatLoaded: _repeatLoaded,
                    nestedCommand: _nestedCommand,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'AVAILABLE COMMANDS',
                    style: TextStyle(
                      color: AuriColors.accent.withValues(alpha: 0.95),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      CommandChip(
                        label: 'REPEAT (x5)',
                        onTap: _loadRepeat,
                        enabled: !_isRunning && !_repeatLoaded,
                        accentColor: AuriColors.warning,
                      ),
                      CommandChip(
                        label: 'FORWARD',
                        onTap: _insertForward,
                        enabled:
                            !_isRunning &&
                            _repeatLoaded &&
                            _nestedCommand == null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: !_hasSucceeded
                        ? const SizedBox.shrink()
                        : AuriPanel(
                            key: const ValueKey<String>('loop-success'),
                            emphasized: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'AURI',
                                  style: TextStyle(
                                    color: AuriColors.accent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'That reduced processing load by 60%.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'You compressed five repeated instructions into a single logical pattern.',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.68),
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _continue,
                                    child: const Text('CONTINUE'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isRunning ? null : _reset,
                    child: const Text('RESET'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isRunning ? null : _execute,
                    child: Text(_isRunning ? 'RUNNING...' : 'EXECUTE'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RepeatAssembler extends StatelessWidget {
  final bool repeatLoaded;
  final String? nestedCommand;

  const _RepeatAssembler({
    required this.repeatLoaded,
    required this.nestedCommand,
  });

  @override
  Widget build(BuildContext context) {
    return AuriPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LOOP CONSTRUCTOR',
            style: TextStyle(
              color: AuriColors.accent.withValues(alpha: 0.95),
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: repeatLoaded
                    ? AuriColors.warning.withValues(alpha: 0.36)
                    : Colors.white.withValues(alpha: 0.08),
              ),
              color: Colors.black.withValues(alpha: 0.14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  repeatLoaded ? 'REPEAT (x5)' : 'EMPTY LOOP FRAME',
                  style: TextStyle(
                    color: repeatLoaded
                        ? AuriColors.warning
                        : Colors.white.withValues(alpha: 0.36),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: AuriColors.surfaceMuted,
                    border: Border.all(
                      color: nestedCommand != null
                          ? AuriColors.accent.withValues(alpha: 0.30)
                          : Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Text(
                    nestedCommand ?? 'Insert command here',
                    style: TextStyle(
                      color: nestedCommand != null
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.34),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
