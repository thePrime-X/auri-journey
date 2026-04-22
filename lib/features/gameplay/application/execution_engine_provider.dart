import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'execution_engine.dart';

final executionEngineProvider = Provider<ExecutionEngine>((ref) {
  return const ExecutionEngine();
});
