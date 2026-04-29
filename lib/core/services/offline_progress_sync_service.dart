import 'package:firebase_auth/firebase_auth.dart';

import '../../features/gameplay/data/progress_firestore_service.dart';
import '../../features/gameplay/domain/models/level_state.dart';
import 'offline_progress_queue_service.dart';

class OfflineProgressSyncService {
  OfflineProgressSyncService({
    required this.queueService,
    required this.progressService,
  });

  final OfflineProgressQueueService queueService;
  final ProgressFirestoreService progressService;

  Future<void> syncQueuedProgress({required List<LevelState> levels}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final queuedItems = await queueService.getQueuedItems();
    if (queuedItems.isEmpty) return;

    for (int i = queuedItems.length - 1; i >= 0; i--) {
      final item = queuedItems[i];

      if (item['type'] != 'missionCompletion') continue;

      final levelId = item['levelId']?.toString();
      if (levelId == null) continue;

      final levelIndex = levels.indexWhere((level) => level.id == levelId);
      if (levelIndex == -1) continue;

      final level = levels[levelIndex];

      try {
        await progressService.saveMissionCompletion(
          uid: uid,
          level: level,
          nextLevelId: item['nextLevelId']?.toString() ?? level.id,
          movesUsed: (item['movesUsed'] as num?)?.toInt() ?? 0,
          hintsUsed: (item['hintsUsed'] as num?)?.toInt() ?? 0,
          playTimeSeconds: (item['playTimeSeconds'] as num?)?.toInt() ?? 0,
          usedExactHint: item['usedExactHint'] == true,
        );

        await queueService.removeItemAt(i);
      } catch (_) {
        // Keep item queued if sync fails.
      }
    }
  }
}
