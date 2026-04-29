import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class OfflineProgressQueueService {
  static const _queueKey = 'offlineProgressQueue';

  Future<List<Map<String, dynamic>>> getQueuedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final rawQueue = prefs.getStringList(_queueKey) ?? [];

    return rawQueue
        .map((item) => jsonDecode(item) as Map<String, dynamic>)
        .toList();
  }

  Future<void> addItem(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    final rawQueue = prefs.getStringList(_queueKey) ?? [];

    rawQueue.add(jsonEncode(item));

    await prefs.setStringList(_queueKey, rawQueue);
  }

  Future<void> removeItemAt(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final rawQueue = prefs.getStringList(_queueKey) ?? [];

    if (index < 0 || index >= rawQueue.length) return;

    rawQueue.removeAt(index);

    await prefs.setStringList(_queueKey, rawQueue);
  }

  Future<void> clearQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_queueKey);
  }

  Future<int> count() async {
    final prefs = await SharedPreferences.getInstance();
    final rawQueue = prefs.getStringList(_queueKey) ?? [];
    return rawQueue.length;
  }
}
