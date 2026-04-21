import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/command_type.dart';
import 'command_block.dart';

class SequencePanel extends StatelessWidget {
  final List<CommandType> sequence;

  const SequencePanel({super.key, required this.sequence});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bg3.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border2.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Sequence',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '✕ CLEAR',
                style: TextStyle(
                  color: AppColors.textMuted.withValues(alpha: 0.55),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.bg.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: sequence.length + 1,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  if (index < sequence.length) {
                    return CommandBlock(
                      command: sequence[index],
                      isSmall: true,
                    );
                  }

                  return const CommandBlock(
                    isSmall: true,
                    isAddPlaceholder: true,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
