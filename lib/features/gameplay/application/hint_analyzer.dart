import '../domain/models/command_type.dart';

enum HintErrorType { emptySequence, tooShort, tooLong, wrongCommand, correct }

class HintAnalysis {
  final HintErrorType type;
  final int? incorrectIndex;

  const HintAnalysis({required this.type, this.incorrectIndex});
}

class HintAnalyzer {
  const HintAnalyzer();

  HintAnalysis analyze({
    required List<CommandType> userCommands,
    required List<CommandType> optimalSolution,
  }) {
    if (userCommands.isEmpty) {
      return const HintAnalysis(type: HintErrorType.emptySequence);
    }

    final shortestLength = userCommands.length < optimalSolution.length
        ? userCommands.length
        : optimalSolution.length;

    for (int i = 0; i < shortestLength; i++) {
      if (userCommands[i] != optimalSolution[i]) {
        return HintAnalysis(
          type: HintErrorType.wrongCommand,
          incorrectIndex: i,
        );
      }
    }

    if (userCommands.length < optimalSolution.length) {
      return const HintAnalysis(type: HintErrorType.tooShort);
    }

    if (userCommands.length > optimalSolution.length) {
      return HintAnalysis(
        type: HintErrorType.tooLong,
        incorrectIndex: optimalSolution.length,
      );
    }

    return const HintAnalysis(type: HintErrorType.correct);
  }

  String messageFor(HintAnalysis analysis) {
    switch (analysis.type) {
      case HintErrorType.emptySequence:
        return 'Add at least one command before running the sequence.';
      case HintErrorType.tooShort:
        return 'Your sequence starts correctly, but it needs more commands.';
      case HintErrorType.tooLong:
        return 'Your sequence has extra commands after the optimal solution.';
      case HintErrorType.wrongCommand:
        final step = (analysis.incorrectIndex ?? 0) + 1;
        return 'Check command $step. That step does not match the best path.';
      case HintErrorType.correct:
        return 'Your command pattern matches the optimal solution.';
    }
  }
}
