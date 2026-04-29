import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/models/level_state.dart';
import '../../../core/services/offline_progress_queue_service.dart';

class ProgressFirestoreService {
  final FirebaseFirestore _firestore;

  ProgressFirestoreService(this._firestore);

  Future<void> saveDailyChallengeCompletion({
    required String uid,
    required int rewardXp,
    required int playTimeSeconds,
  }) async {
    final userRef = _firestore.collection('users').doc(uid);

    await _firestore.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userRef);

      if (!userSnapshot.exists) {
        throw Exception('User profile not found.');
      }

      final userData = userSnapshot.data() ?? {};

      final currentXp = _toInt(userData['totalXP']);
      final currentPlayTime = _toInt(userData['totalPlayTimeSeconds']);
      final currentStreak = _toInt(userData['streakDays']);

      final now = DateTime.now();
      final previousActiveDate = _toDateTime(userData['lastActiveDate']);

      final updatedStreak = _calculateStreak(
        currentStreak: currentStreak,
        previousActiveDate: previousActiveDate,
        now: now,
      );

      transaction.update(userRef, {
        'totalXP': currentXp + rewardXp,
        'totalPlayTimeSeconds': currentPlayTime + playTimeSeconds,
        'streakDays': updatedStreak,
        'lastActiveDate': Timestamp.fromDate(now),
      });
    });
  }

  Future<void> saveMissionCompletion({
    required String uid,
    required LevelState level,
    required String nextLevelId,
    required int movesUsed,
    required int hintsUsed,
    required int playTimeSeconds,
    required bool usedExactHint,
  }) async {
    final userRef = _firestore.collection('users').doc(uid);
    final progressRef = userRef.collection('progress').doc(level.id);

    await _firestore.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userRef);

      if (!userSnapshot.exists) {
        throw Exception('User profile not found.');
      }

      final userData = userSnapshot.data() ?? {};

      final currentXp = _toInt(userData['totalXP']);
      final currentCompleted = _toInt(userData['puzzlesCompleted']);
      final currentPlayTime = _toInt(userData['totalPlayTimeSeconds']);
      final currentStreak = _toInt(userData['streakDays']);

      final completedLevelIds = _toStringList(userData['completedLevelIds']);
      final alreadyCompleted = completedLevelIds.contains(level.id);

      final updatedCompletedLevelIds = alreadyCompleted
          ? completedLevelIds
          : [...completedLevelIds, level.id];

      final updatedXp = alreadyCompleted
          ? currentXp
          : currentXp + level.rewardXp;

      final updatedCompleted = alreadyCompleted
          ? currentCompleted
          : currentCompleted + 1;

      final now = DateTime.now();
      final previousActiveDate = _toDateTime(userData['lastActiveDate']);

      final updatedStreak = _calculateStreak(
        currentStreak: currentStreak,
        previousActiveDate: previousActiveDate,
        now: now,
      );

      final achievements = _toBoolMap(
        userData['achievements'],
        fallback: _defaultAchievements,
      );

      final updatedAchievements = _updatedAchievements(
        currentAchievements: achievements,
        totalXp: updatedXp,
        puzzlesCompleted: updatedCompleted,
        streakDays: updatedStreak,
        movesUsed: movesUsed,
        optimalSteps: level.optimalSolution.length,
        hintsUsed: hintsUsed,
      );

      final optimalMoves = level.optimalSolution.length;

      final sequenceSkillAwarded = alreadyCompleted
          ? _toInt(userData['skillStats']?['sequences'])
          : _calculateSequenceSkillAward(
              movesUsed: movesUsed,
              optimalMoves: optimalMoves,
              hintsUsed: hintsUsed,
              usedExactHint: usedExactHint,
            );

      final updatedSkillStats = {
        'sequences': alreadyCompleted
            ? _toInt(userData['skillStats']?['sequences'])
            : (_toInt(userData['skillStats']?['sequences']) +
                      sequenceSkillAwarded)
                  .clamp(0, 100),
        'conditions': 10,
        'loops': 10,
        'debugging': 10,
      };

      transaction.set(progressRef, {
        'levelId': level.id,
        'status': 'completed',
        'movesUsed': movesUsed,
        'hintsUsed': hintsUsed,
        'optimalMoves': optimalMoves,
        'usedExactHint': usedExactHint,
        'sequenceSkillAwarded': sequenceSkillAwarded,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      transaction.update(userRef, {
        'totalXP': updatedXp,
        'puzzlesCompleted': updatedCompleted,
        'currentLevel': nextLevelId,
        'completedLevelIds': updatedCompletedLevelIds,
        'streakDays': updatedStreak,
        'lastActiveDate': Timestamp.fromDate(now),
        'totalPlayTimeSeconds': currentPlayTime + playTimeSeconds,
        'skillStats': updatedSkillStats,
        'achievements': updatedAchievements,
      });
    });
  }

  Future<void> saveMissionCompletionWithFallback({
    required String uid,
    required LevelState level,
    required int movesUsed,
    required int hintsUsed,
    required int playTimeSeconds,
    required bool usedExactHint,
    required String nextLevelId,
    required OfflineProgressQueueService queue,
  }) async {
    try {
      await saveMissionCompletion(
        uid: uid,
        level: level,
        nextLevelId: nextLevelId,
        movesUsed: movesUsed,
        hintsUsed: hintsUsed,
        playTimeSeconds: playTimeSeconds,
        usedExactHint: usedExactHint,
      );
    } catch (e) {
      await queue.addItem({
        'type': 'missionCompletion',
        'uid': uid,
        'levelId': level.id,
        'movesUsed': movesUsed,
        'hintsUsed': hintsUsed,
        'playTimeSeconds': playTimeSeconds,
        'usedExactHint': usedExactHint,
        'nextLevelId': nextLevelId,
        'createdAt': DateTime.now().toIso8601String(),
      });
    }
  }

  static const Map<String, bool> _defaultAchievements = {
    'firstMission': false,
    'fiveMissions': false,
    'earned100Xp': false,
    'perfectSolution': false,
    'threeDayStreak': false,
    'noHintWin': false,
  };

  Map<String, bool> _updatedAchievements({
    required Map<String, bool> currentAchievements,
    required int totalXp,
    required int puzzlesCompleted,
    required int streakDays,
    required int movesUsed,
    required int optimalSteps,
    required int hintsUsed,
  }) {
    final updated = Map<String, bool>.from(currentAchievements);

    updated['firstMission'] = puzzlesCompleted >= 1;
    updated['fiveMissions'] = puzzlesCompleted >= 5;
    updated['earned100Xp'] = totalXp >= 100;
    updated['perfectSolution'] = movesUsed <= optimalSteps;
    updated['threeDayStreak'] = streakDays >= 3;
    updated['noHintWin'] = hintsUsed == 0;

    return updated;
  }

  int _calculateSequenceSkillAward({
    required int movesUsed,
    required int optimalMoves,
    required int hintsUsed,
    required bool usedExactHint,
  }) {
    var score = 10;

    if (movesUsed <= optimalMoves) {
      score += 5;
    }

    if (hintsUsed == 0) {
      score += 3;
    }

    if (!usedExactHint) {
      score += 2;
    }

    return score.clamp(0, 20);
  }

  int _calculateStreak({
    required int currentStreak,
    required DateTime? previousActiveDate,
    required DateTime now,
  }) {
    if (previousActiveDate == null) {
      return 1;
    }

    final previousDay = DateTime(
      previousActiveDate.year,
      previousActiveDate.month,
      previousActiveDate.day,
    );

    final today = DateTime(now.year, now.month, now.day);

    final difference = today.difference(previousDay).inDays;

    if (difference == 0) {
      return currentStreak <= 0 ? 1 : currentStreak;
    }

    if (difference == 1) {
      return currentStreak + 1;
    }

    return 1;
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  static List<String> _toStringList(dynamic value) {
    if (value is! List) return const [];
    return value.map((item) => item.toString()).toList();
  }

  static Map<String, bool> _toBoolMap(
    dynamic value, {
    required Map<String, bool> fallback,
  }) {
    if (value is! Map) return Map<String, bool>.from(fallback);

    return {
      ...fallback,
      ...value.map(
        (key, mapValue) => MapEntry(key.toString(), mapValue == true),
      ),
    };
  }
}
