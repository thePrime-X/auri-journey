import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/command_chip.dart';
import '../widgets/corridor_view.dart';

class FirstPuzzleScreen extends StatefulWidget {
  const FirstPuzzleScreen({super.key});

  @override
  State<FirstPuzzleScreen> createState() => _FirstPuzzleScreenState();
}

class _FirstPuzzleScreenState extends State<FirstPuzzleScreen> {
  final List<String> queue = [];
  int auriPosition = 0;
  bool isRunning = false;
  String feedback = 'Build a sequence to move Auri to the goal.';
  static const int goalPosition = 3;

  void _addCommand(String command) {
    if (isRunning) return;
    setState(() {
      queue.add(command);
    });
  }

  void _clearQueue() {
    if (isRunning) return;
    setState(() {
      queue.clear();
      auriPosition = 0;
      feedback = 'Sequence cleared.';
    });
  }

  Future<void> _executeQueue() async {
    if (isRunning || queue.isEmpty) return;

    setState(() {
      isRunning = true;
      auriPosition = 0;
      feedback = 'Executing logic...';
    });

    for (final command in queue) {
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      setState(() {
        if (command == 'FORWARD' && auriPosition < goalPosition) {
          auriPosition++;
        }
      });
    }

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    final bool success =
        queue.length == 3 &&
        queue.every((command) => command == 'FORWARD') &&
        auriPosition == goalPosition;

    setState(() {
      isRunning = false;
      feedback = success
          ? 'Calibration successful. Auri reached the target.'
          : 'That sequence was incorrect. Try adjusting the commands.';
    });

    if (success) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF11161C),
        title: const Text(
          'Mission Complete',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'You restored Auri’s basic movement sequence.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'CONTINUE',
              style: TextStyle(color: Colors.tealAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueItem(String command, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF151D24),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Text(
        '${index + 1}. $command',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.92),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1318),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PUZZLE // SEQUENCE 01',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.72),
                  fontSize: 13,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Guide Auri to the target node.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Use the correct order of movement commands.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              CorridorView(
                auriPosition: auriPosition,
                totalTiles: 4,
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF11161C),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Text(
                  feedback,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontSize: 15,
                    height: 1.45,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  CommandChip(
                    label: 'FORWARD',
                    onTap: () => _addCommand('FORWARD'),
                  ),
                  CommandChip(
                    label: 'LEFT',
                    onTap: () => _addCommand('LEFT'),
                  ),
                  CommandChip(
                    label: 'RIGHT',
                    onTap: () => _addCommand('RIGHT'),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                'COMMAND QUEUE',
                style: TextStyle(
                  color: Colors.tealAccent.withValues(alpha: 0.95),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F151B),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  child: queue.isEmpty
                      ? Center(
                          child: Text(
                            'No commands loaded.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.35),
                              fontSize: 15,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: queue.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return _buildQueueItem(queue[index], index);
                          },
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isRunning ? null : _clearQueue,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('CLEAR'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isRunning ? null : _executeQueue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      child: Text(isRunning ? 'RUNNING...' : 'EXECUTE'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}