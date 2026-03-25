class MemoryFragment {
  final String code;
  final String title;
  final String description;

  const MemoryFragment({
    required this.code,
    required this.title,
    required this.description,
  });
}

class OnboardingSnapshot {
  final int logicCycles;
  final bool cloudLinked;
  final String? operatorName;
  final List<MemoryFragment> memoryBank;

  const OnboardingSnapshot({
    this.logicCycles = 0,
    this.cloudLinked = false,
    this.operatorName,
    this.memoryBank = const <MemoryFragment>[],
  });

  String get displayName {
    final String? trimmed = operatorName?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return cloudLinked ? 'LINKED OPERATOR' : 'LOCAL OPERATOR';
    }
    return trimmed.toUpperCase();
  }

  OnboardingSnapshot copyWith({
    int? logicCycles,
    bool? cloudLinked,
    String? operatorName,
    List<MemoryFragment>? memoryBank,
  }) {
    return OnboardingSnapshot(
      logicCycles: logicCycles ?? this.logicCycles,
      cloudLinked: cloudLinked ?? this.cloudLinked,
      operatorName: operatorName ?? this.operatorName,
      memoryBank: memoryBank ?? this.memoryBank,
    );
  }

  OnboardingSnapshot unlock(MemoryFragment fragment) {
    final bool alreadyUnlocked = memoryBank.any(
      (MemoryFragment item) => item.title == fragment.title,
    );
    if (alreadyUnlocked) {
      return this;
    }

    return copyWith(memoryBank: <MemoryFragment>[...memoryBank, fragment]);
  }
}

const MemoryFragment sequenceMemoryFragment = MemoryFragment(
  code: 'MEM-001',
  title: 'SEQUENCE',
  description:
      'Instructions must be executed in the correct order to produce the desired result.',
);

const MemoryFragment loopsMemoryFragment = MemoryFragment(
  code: 'MEM-002',
  title: 'LOOPS',
  description:
      'Repeated instructions can be compressed into a reusable pattern to reduce processing load.',
);
