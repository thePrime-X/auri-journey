import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/gameplay/application/firestore_provider.dart';
import 'offline_progress_queue_provider.dart';
import 'offline_progress_sync_service.dart';

final offlineProgressSyncServiceProvider = Provider<OfflineProgressSyncService>(
  (ref) {
    return OfflineProgressSyncService(
      queueService: ref.read(offlineProgressQueueServiceProvider),
      progressService: ref.read(progressFirestoreServiceProvider),
    );
  },
);
