import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/command_sequence_provider.dart';
import '../../domain/models/command_type.dart';
import 'command_block.dart';

class CommandPalette extends ConsumerWidget {
  final List<CommandType> commands;

  const CommandPalette({super.key, required this.commands});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'COMMANDS',
          style: TextStyle(
            color: AppColors.cyan,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: commands.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final command = commands[index];

              return CommandBlock(
                command: command,
                onTap: () {
                  ref
                      .read(commandSequenceProvider.notifier)
                      .addCommand(command);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
