import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/execution_state.dart';
import 'execution_state_notifier.dart';

final executionStateProvider =
    NotifierProvider<ExecutionStateNotifier, ExecutionState>(
      ExecutionStateNotifier.new,
    );
