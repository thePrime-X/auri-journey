import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/command_type.dart';

class CommandSequenceNotifier extends Notifier<List<CommandType>> {
  static const int maxSequenceLength = 10;

  @override
  List<CommandType> build() {
    return [];
  }

  bool get canAddMore => state.length < maxSequenceLength;

  void addCommand(CommandType command) {
    if (!canAddMore) return;
    state = [...state, command];
  }

  void insertCommand({required int index, required CommandType command}) {
    if (!canAddMore) return;
    if (index < 0 || index > state.length) return;

    final updated = [...state];
    updated.insert(index, command);
    state = updated;
  }

  void moveCommand({required int fromIndex, required int toInsertIndex}) {
    if (fromIndex < 0 || fromIndex >= state.length) return;
    if (toInsertIndex < 0 || toInsertIndex > state.length) return;

    final updated = [...state];
    final command = updated.removeAt(fromIndex);

    var adjustedIndex = toInsertIndex;
    if (fromIndex < toInsertIndex) {
      adjustedIndex -= 1;
    }

    updated.insert(adjustedIndex, command);
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
