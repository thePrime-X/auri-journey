import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/command_type.dart';

class CommandSequenceNotifier extends Notifier<List<CommandType?>> {
  static const int maxSequenceLength = 10;
  static const List<CommandType?> initialSequence = [null, null];

  @override
  List<CommandType?> build() {
    return [...initialSequence];
  }

  bool get canAddMore => state.length < maxSequenceLength;

  void addCommand(CommandType command) {
    final firstEmptyIndex = state.indexOf(null);

    if (firstEmptyIndex != -1) {
      final updated = [...state];
      updated[firstEmptyIndex] = command;
      state = updated;
      return;
    }

    if (!canAddMore) return;
    state = [...state, command];
  }

  void removeCommandAt(int index) {
    if (index < 0 || index >= state.length) return;

    final updated = [...state];
    updated[index] = null;
    state = updated;
  }

  void addEmptySlot() {
    if (!canAddMore) return;
    state = [...state, null];
  }

  void fillSlot({required int index, required CommandType command}) {
    if (index < 0 || index >= state.length) return;
    if (state[index] != null) return;

    final updated = [...state];
    updated[index] = command;
    state = updated;
  }

  void moveCommandToEmptySlot({required int fromIndex, required int toIndex}) {
    if (fromIndex < 0 || fromIndex >= state.length) return;
    if (toIndex < 0 || toIndex >= state.length) return;
    if (state[fromIndex] == null) return;
    if (state[toIndex] != null) return;

    final updated = [...state];
    final command = updated[fromIndex];
    updated[fromIndex] = null;
    updated[toIndex] = command;
    state = updated;
  }

  void compactSequence() {
    final filled = state.whereType<CommandType>().toList();
    state = [...filled];
  }

  void clearSequence() {
    state = [...initialSequence];
  }
}

final commandSequenceProvider =
    NotifierProvider<CommandSequenceNotifier, List<CommandType?>>(
      CommandSequenceNotifier.new,
    );
