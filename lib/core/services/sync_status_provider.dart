import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SyncStatus { synced, syncing, offline, queued }

class SyncStatusNotifier extends Notifier<SyncStatus> {
  @override
  SyncStatus build() {
    return SyncStatus.synced;
  }

  void setStatus(SyncStatus status) {
    state = status;
  }
}

final syncStatusProvider = NotifierProvider<SyncStatusNotifier, SyncStatus>(
  SyncStatusNotifier.new,
);
