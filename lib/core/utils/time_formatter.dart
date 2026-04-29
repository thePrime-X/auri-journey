String formatPlayTime(int seconds) {
  if (seconds <= 0) return '0m';

  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;

  if (hours > 0) {
    return '${hours}h ${minutes}m';
  }

  return '${minutes}m';
}
