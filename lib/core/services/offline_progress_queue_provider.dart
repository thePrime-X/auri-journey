import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'offline_progress_queue_service.dart';

final offlineProgressQueueServiceProvider =
    Provider<OfflineProgressQueueService>((ref) {
      return OfflineProgressQueueService();
    });
