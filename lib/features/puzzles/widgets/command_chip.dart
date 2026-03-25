import 'package:flutter/material.dart';

import '../../../shared/widgets/auri_ui.dart';

class CommandChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool enabled;
  final Color accentColor;

  const CommandChip({
    super.key,
    required this.label,
    required this.onTap,
    this.enabled = true,
    this.accentColor = AuriColors.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AuriColors.surfaceMuted.withValues(alpha: enabled ? 1 : 0.72),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: enabled ? 0.04 : 0.02),
                Colors.transparent,
              ],
            ),
            border: Border.all(
              color: accentColor.withValues(alpha: enabled ? 0.26 : 0.08),
            ),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.05),
                      blurRadius: 12,
                    ),
                  ]
                : const [],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: enabled ? 0.92 : 0.42),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
