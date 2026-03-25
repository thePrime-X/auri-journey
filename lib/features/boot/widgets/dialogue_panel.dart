import 'package:flutter/material.dart';

import '../../../shared/widgets/auri_ui.dart';

class DialoguePanel extends StatelessWidget {
  final String speaker;
  final String message;
  final int step;
  final int totalSteps;

  const DialoguePanel({
    super.key,
    required this.speaker,
    required this.message,
    required this.step,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return AuriPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                speaker,
                style: TextStyle(
                  color: AuriColors.accent.withValues(alpha: 0.95),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              Text(
                '${step.toString().padLeft(2, '0')}/$totalSteps',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.42),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(totalSteps, (index) {
              final bool active = index < step;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == totalSteps - 1 ? 0 : 6,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: active
                          ? AuriColors.accent.withValues(alpha: 0.85)
                          : Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
