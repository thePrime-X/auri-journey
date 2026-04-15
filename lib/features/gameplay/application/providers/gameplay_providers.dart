import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/level_state.dart';
import '../../domain/models/execution_state.dart';
import 'execution_state_notifier.dart';
import 'level_state_notifier.dart';

final levelStateProvider =
    NotifierProvider<LevelStateNotifier, LevelState>(
  LevelStateNotifier.new,
);

final executionStateProvider =
    NotifierProvider<ExecutionStateNotifier, ExecutionState>(
  ExecutionStateNotifier.new,
);