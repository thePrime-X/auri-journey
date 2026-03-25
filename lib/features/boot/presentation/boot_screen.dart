import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'auri_greeting_screen.dart';
import '../widgets/auri_face.dart';

class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen>
    with SingleTickerProviderStateMixin {
  static const List<String> _systemLogs = [
    'ERR: MOTOR_CTRL_Z DISCONNECTED',
    'SYS: CORETEMP_CRITICAL',
    'WARN: MEMORY_FRAGMENTATION_DETECTED',
    'ERR: NAV_PATH_MODULE_OFFLINE',
    'RECOVER: AUX_POWER_STANDBY',
    'CHK: SENSOR_ARRAY_UNRESPONSIVE',
    'BOOT: MANUAL_OVERRIDE_PENDING',
    'AUTH: OPERATOR_SIGNAL_NOT_FOUND',
  ];

  double progress = 0.0;
  bool isHolding = false;
  bool isComplete = false;
  bool _didNavigate = false;

  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker((elapsed) {
      if (!isHolding || isComplete) return;

      setState(() {
        progress += 0.008;
        if (progress >= 1.0) {
          progress = 1.0;
          isComplete = true;
          isHolding = false;
        }
      });

      if (isComplete) {
        _ticker.stop();
        _goToReadyScreen();
      }
    });
  }

  void _startHolding() {
    if (isComplete) return;

    setState(() {
      isHolding = true;
    });

    if (!_ticker.isActive) {
      _ticker.start();
    }
  }

  void _stopHolding() {
    if (isComplete) return;

    _ticker.stop();
    setState(() {
      isHolding = false;
      progress = 0.0;
    });
  }

  Future<void> _goToReadyScreen() async {
    if (_didNavigate || !mounted) return;
    _didNavigate = true;

    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, animation, _) {
          return FadeTransition(
            opacity: animation,
            child: const AuriGreetingScreen(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Color.lerp(
          const Color(0xFF06080C),
          const Color(0xFF1D242B),
          progress,
        ) ??
        const Color(0xFF06080C);

    final accentColor =
        isHolding || isComplete ? Colors.tealAccent : Colors.redAccent;

    final statusText = isComplete
        ? 'SYSTEM ONLINE'
        : isHolding
            ? 'INITIALIZING...'
            : 'MANUAL OVERRIDE REQUIRED';

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          color: backgroundColor,
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 28,
                    ),
                    child: Opacity(
                      opacity: isComplete ? 0.04 : 0.14,
                      child: _BootLogBackground(
                        logs: _systemLogs,
                        active: !isComplete,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'AURI // BOOT SEQUENCE',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 28),
                      AuriFace(
                        isHolding: isHolding,
                        isComplete: isComplete,
                        progress: progress,
                      ),
                      const SizedBox(height: 28),
                      Text(
                        statusText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isComplete ? Colors.white : Colors.tealAccent,
                          fontSize: 22,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isComplete
                            ? 'Auri is now responsive.'
                            : 'Press and hold to initialize the unit.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.55),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 36),
                      GestureDetector(
                        onLongPressStart: (_) => _startHolding(),
                        onLongPressEnd: (_) => _stopHolding(),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 6,
                                color: Colors.tealAccent,
                                backgroundColor: Colors.white12,
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              width: 105,
                              height: 105,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: accentColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: accentColor.withValues(alpha: 0.55),
                                    blurRadius: isHolding ? 30 : 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'HOLD',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}

class _BootLogBackground extends StatefulWidget {
  final List<String> logs;
  final bool active;

  const _BootLogBackground({
    required this.logs,
    required this.active,
  });

  @override
  State<_BootLogBackground> createState() => _BootLogBackgroundState();
}

class _BootLogBackgroundState extends State<_BootLogBackground> {
  late final ScrollController _scrollController;
  Timer? _timer;
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _timer = Timer.periodic(const Duration(milliseconds: 90), (_) {
      if (!mounted || !widget.active || !_scrollController.hasClients) return;

      _offset += 1.4;
      final max = _scrollController.position.maxScrollExtent;
      if (_offset >= max) {
        _offset = 0;
      }

      _scrollController.jumpTo(_offset);
    });
  }

  @override
  void didUpdateWidget(covariant _BootLogBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.active && _scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repeatedLogs = List.generate(
      30,
      (index) => widget.logs[index % widget.logs.length],
    );

    return ListView.builder(
      controller: _scrollController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: repeatedLogs.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            repeatedLogs[index],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              height: 1.3,
              fontFamily: 'monospace',
            ),
          ),
        );
      },
    );
  }
}