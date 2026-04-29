import 'package:flutter/foundation.dart';

@immutable
class DailyChallenge {
  final String id;
  final String dateKey;
  final String title;
  final String description;
  final List<String> levelIds;
  final int rewardXp;
  final bool isActive;

  const DailyChallenge({
    required this.id,
    required this.dateKey,
    required this.title,
    required this.description,
    required this.levelIds,
    required this.rewardXp,
    required this.isActive,
  });

  factory DailyChallenge.fromFirestore({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return DailyChallenge(
      id: id,
      dateKey: data['dateKey']?.toString() ?? '',
      title: data['title']?.toString() ?? 'Daily Challenge',
      description: data['description']?.toString() ?? '',
      levelIds: ((data['levelIds'] ?? []) as List)
          .map((item) => item.toString())
          .toList(),
      rewardXp: (data['rewardXp'] as num?)?.toInt() ?? 0,
      isActive: data['isActive'] == true,
    );
  }
}
