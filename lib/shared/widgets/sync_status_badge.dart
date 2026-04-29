import 'package:flutter/material.dart';
import '../../core/services/sync_status_provider.dart';
import '../../core/theme/app_colors.dart';

class SyncStatusBadge extends StatelessWidget {
  final SyncStatus status;

  const SyncStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String label;

    switch (status) {
      case SyncStatus.offline:
        icon = Icons.wifi_off_rounded;
        color = AppColors.red;
        label = 'Offline';
        break;
      case SyncStatus.syncing:
        icon = Icons.sync_rounded;
        color = AppColors.cyan;
        label = 'Syncing';
        break;
      case SyncStatus.queued:
        icon = Icons.schedule_rounded;
        color = AppColors.amber;
        label = 'Queued';
        break;
      case SyncStatus.synced:
        icon = Icons.check_circle_rounded;
        color = AppColors.green;
        label = 'Synced';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
