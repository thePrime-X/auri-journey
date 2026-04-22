import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/command_type.dart';

class CommandSequenceNotifier extends Notifier<List<CommandType>> {
  static const int maxSequenceLength = 10;

  @override
  List<CommandType> build() {
    return [];
  }

  void addCommand(CommandType command) {
    if (state.length >= maxSequenceLength) return;
    state = [...state, command];
  }

  void insertCommand({required int index, required CommandType command}) {
    if (state.length >= maxSequenceLength) return;
    if (index < 0 || index > state.length) return;

    final updated = [...state];
    updated.insert(index, command);
    state = updated;
  }

  void removeLastCommand() {
    if (state.isEmpty) return;
    state = state.sublist(0, state.length - 1);
  }

  void clearSequence() {
    state = [];
  }
}

final commandSequenceProvider =
    NotifierProvider<CommandSequenceNotifier, List<CommandType>>(
      CommandSequenceNotifier.new,
    );
