import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../shared/widgets/auri_ui.dart';
import '../models/onboarding_snapshot.dart';
import '../widgets/onboarding_ui.dart';

class NeuralLinkDashboardScreen extends StatefulWidget {
  final OnboardingSnapshot snapshot;
  final String introMessage;

  const NeuralLinkDashboardScreen({
    super.key,
    required this.snapshot,
    this.introMessage = 'Operator, new calibration sequences are available.',
  });

  @override
  State<NeuralLinkDashboardScreen> createState() =>
      _NeuralLinkDashboardScreenState();
}

class _NeuralLinkDashboardScreenState extends State<NeuralLinkDashboardScreen>
    with SingleTickerProviderStateMixin {
  static const List<_NodeData> _nodes = <_NodeData>[
    _NodeData(
      label: 'BOOT',
      state: _NodeState.completed,
      alignment: Alignment(-0.86, 0.48),
      prompt: 'Boot archive complete.',
    ),
    _NodeData(
      label: 'SEQUENCE',
      state: _NodeState.completed,
      alignment: Alignment(-0.38, -0.10),
      prompt: 'Sequence memory stable.',
    ),
    _NodeData(
      label: 'LOOPS',
      state: _NodeState.completed,
      alignment: Alignment(0.02, 0.42),
      prompt: 'Loop compression stable.',
    ),
    _NodeData(
      label: 'CONDITIONALS',
      state: _NodeState.current,
      alignment: Alignment(0.46, -0.38),
      prompt: 'Conditionals are next in queue.',
    ),
    _NodeData(
      label: 'HEURISTICS',
      state: _NodeState.locked,
      alignment: Alignment(0.86, 0.18),
      prompt: 'Further sequences remain locked.',
    ),
  ];

  late final AnimationController _pulseController;
  double _mapTilt = 0;

  @override
  void initState() {
    super.initState();
    _pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..addListener(() => setState(() {}))
          ..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  double get _pulse => 0.5 + (0.5 * math.sin(_pulseController.value * math.pi));

  double get _cpuValue {
    final double raw = widget.snapshot.logicCycles / 300;
    return raw.clamp(0.18, 1.0);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _openMemoryBank() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: AuriPanel(
            emphasized: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MEMORY BANK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                if (widget.snapshot.memoryBank.isEmpty)
                  Text(
                    'No concept fragments have been stored yet.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.68),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  )
                else
                  ...widget.snapshot.memoryBank.map((MemoryFragment fragment) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.black.withValues(alpha: 0.14),
                          border: Border.all(
                            color: AuriColors.accent.withValues(alpha: 0.18),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${fragment.code} // ${fragment.title}',
                              style: const TextStyle(
                                color: AuriColors.accent,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              fragment.description,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.74),
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('CLOSE'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onNodeTap(_NodeData node) {
    _showMessage(node.prompt);
  }

  @override
  Widget build(BuildContext context) {
    final _NodeData currentNode = _nodes.firstWhere(
      (_NodeData node) => node.state == _NodeState.current,
    );

    return Scaffold(
      body: AuriScene(
        signalStrength: 1,
        dangerStrength: 0.04,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const AuriHeaderLabel('NEURAL LINK // DASHBOARD'),
            const SizedBox(height: 14),
            AuriPanel(
              emphasized: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _DashboardAvatar(pulse: _pulse),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.snapshot.displayName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.snapshot.cloudLinked
                                  ? 'ONLINE // CLOUD ANCHOR SECURED'
                                  : 'ONLINE // LOCAL MODE',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.62),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StatusPill(
                        label: 'ONLINE',
                        color: widget.snapshot.cloudLinked
                            ? AuriColors.accent
                            : AuriColors.warning,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SignalBar(
                    label: 'CPU LOAD',
                    value: _cpuValue,
                    trailing: '${widget.snapshot.logicCycles} CYCLES',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AuriPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'HOLOGRAPHIC NODE MAP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          'Swipe to rotate',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.42),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            _mapTilt = (_mapTilt + (details.delta.dx * 0.002))
                                .clamp(-0.12, 0.12);
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF101820),
                                  AuriColors.surface,
                                  const Color(0xFF0C1218),
                                ],
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: IgnorePointer(
                                    child: CustomPaint(
                                      painter: _NodeMapPainter(
                                        nodes: _nodes,
                                        pulse: _pulse,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Transform.rotate(
                                    angle: _mapTilt,
                                    child: Stack(
                                      children: [
                                        for (final _NodeData node in _nodes)
                                          Align(
                                            alignment: node.alignment,
                                            child: _DashboardNode(
                                              node: node,
                                              pulse: _pulse,
                                              onTap: () => _onNodeTap(node),
                                            ),
                                          ),
                                        Align(
                                          alignment: currentNode.alignment,
                                          child: const Padding(
                                            padding: EdgeInsets.only(
                                              bottom: 56,
                                            ),
                                            child: _MiniAuriMarker(),
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            AuriPanel(
              child: Row(
                children: [
                  DashboardCommandButton(
                    label: 'MEMORY BANK',
                    icon: Icons.auto_stories_rounded,
                    onTap: _openMemoryBank,
                  ),
                  const SizedBox(width: 10),
                  DashboardCommandButton(
                    label: 'EXECUTE',
                    icon: Icons.play_circle_fill_rounded,
                    accentColor: AuriColors.warning,
                    onTap: () =>
                        _showMessage('Conditionals calibration queued.'),
                  ),
                  const SizedBox(width: 10),
                  DashboardCommandButton(
                    label: 'UPGRADE MODULE',
                    icon: Icons.tune_rounded,
                    accentColor: const Color(0xFF69C7FF),
                    onTap: () =>
                        _showMessage('Module customization is still locked.'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            AuriPanel(
              child: Text(
                widget.introMessage,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.88),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardAvatar extends StatelessWidget {
  final double pulse;

  const _DashboardAvatar({required this.pulse});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF2F5F8), Color(0xFFB4C1CA), Color(0xFF7E8A95)],
        ),
        boxShadow: [
          BoxShadow(
            color: AuriColors.accent.withValues(alpha: 0.16 + (0.10 * pulse)),
            blurRadius: 18,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 30,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFF0E1217),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [_EyeDot(), SizedBox(width: 4), _EyeDot()],
          ),
        ),
      ),
    );
  }
}

class _EyeDot extends StatelessWidget {
  const _EyeDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AuriColors.accent,
        boxShadow: [
          BoxShadow(
            color: AuriColors.accent.withValues(alpha: 0.32),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }
}

class _MiniAuriMarker extends StatelessWidget {
  const _MiniAuriMarker();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFEAEFF3),
            boxShadow: [
              BoxShadow(
                color: AuriColors.accent.withValues(alpha: 0.18),
                blurRadius: 16,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 14,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF0E1217),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 2,
          height: 18,
          color: Colors.white.withValues(alpha: 0.20),
        ),
      ],
    );
  }
}

class _DashboardNode extends StatelessWidget {
  final _NodeData node;
  final double pulse;
  final VoidCallback onTap;

  const _DashboardNode({
    required this.node,
    required this.pulse,
    required this.onTap,
  });

  Color get _accentColor {
    switch (node.state) {
      case _NodeState.completed:
        return const Color(0xFF69C7FF);
      case _NodeState.current:
        return AuriColors.warning;
      case _NodeState.locked:
        return Colors.white24;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool active = node.state != _NodeState.locked;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accentColor.withValues(alpha: active ? 0.18 : 0.08),
              border: Border.all(
                color: _accentColor.withValues(alpha: active ? 0.70 : 0.24),
                width: 2,
              ),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: _accentColor.withValues(
                          alpha: 0.22 + (0.10 * pulse),
                        ),
                        blurRadius: 20,
                        spreadRadius: node.state == _NodeState.current ? 1 : 0,
                      ),
                    ]
                  : const <BoxShadow>[],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            node.label,
            style: TextStyle(
              color: Colors.white.withValues(
                alpha: node.state == _NodeState.locked ? 0.34 : 0.90,
              ),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _NodeMapPainter extends CustomPainter {
  final List<_NodeData> nodes;
  final double pulse;

  const _NodeMapPainter({required this.nodes, required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withValues(alpha: 0.14 + (0.06 * pulse));

    for (int index = 0; index < nodes.length - 1; index++) {
      final Offset start = _alignmentToOffset(nodes[index].alignment, size);
      final Offset end = _alignmentToOffset(nodes[index + 1].alignment, size);

      final Path path = Path()
        ..moveTo(start.dx, start.dy)
        ..quadraticBezierTo(
          (start.dx + end.dx) / 2,
          math.min(start.dy, end.dy) - 34,
          end.dx,
          end.dy,
        );

      canvas.drawPath(path, linePaint);
    }
  }

  Offset _alignmentToOffset(Alignment alignment, Size size) {
    return Offset(
      ((alignment.x + 1) / 2) * size.width,
      ((alignment.y + 1) / 2) * size.height,
    );
  }

  @override
  bool shouldRepaint(covariant _NodeMapPainter oldDelegate) {
    return oldDelegate.pulse != pulse || oldDelegate.nodes != nodes;
  }
}

enum _NodeState { completed, current, locked }

class _NodeData {
  final String label;
  final _NodeState state;
  final Alignment alignment;
  final String prompt;

  const _NodeData({
    required this.label,
    required this.state,
    required this.alignment,
    required this.prompt,
  });
}
