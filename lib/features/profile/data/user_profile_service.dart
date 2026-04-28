import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/models/user_profile.dart';

class UserProfileService {
  UserProfileService(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) {
    return _firestore.collection('users').doc(uid);
  }

  Future<UserProfile?> fetchUserProfile(String uid) async {
    final snapshot = await _userDoc(uid).get();

    if (!snapshot.exists) {
      return null;
    }

    final data = snapshot.data();

    if (data == null) {
      return null;
    }

    return UserProfile.fromFirestore(uid: uid, data: data);
  }

  Stream<UserProfile?> watchUserProfile(String uid) {
    return _userDoc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }

      final data = snapshot.data();

      if (data == null) {
        return null;
      }

      return UserProfile.fromFirestore(uid: uid, data: data);
    });
  }

  Future<void> updateLastLogin(String uid) async {
    await _userDoc(uid).update({'lastLoginAt': FieldValue.serverTimestamp()});
  }

  Future<void> updateDisplayName({
    required String uid,
    required String displayName,
  }) async {
    await _userDoc(uid).update({'displayName': displayName.trim()});
  }

  Future<void> updateCurrentLevel({
    required String uid,
    required String levelId,
  }) async {
    await _userDoc(uid).update({'currentLevel': levelId});
  }

  Future<void> addXp({required String uid, required int xp}) async {
    await _userDoc(uid).update({'totalXP': FieldValue.increment(xp)});
  }

  Future<void> incrementCompletedMissions(String uid) async {
    await _userDoc(uid).update({'puzzlesCompleted': FieldValue.increment(1)});
  }

  Future<void> addPlayTime({required String uid, required int seconds}) async {
    await _userDoc(
      uid,
    ).update({'totalPlayTimeSeconds': FieldValue.increment(seconds)});
  }

  Future<void> updateStreak({
    required String uid,
    required int streakDays,
    required DateTime lastActiveDate,
  }) async {
    await _userDoc(uid).update({
      'streakDays': streakDays,
      'lastActiveDate': Timestamp.fromDate(lastActiveDate),
    });
  }

  Future<void> updateSkillStats({
    required String uid,
    required Map<String, int> skillStats,
  }) async {
    await _userDoc(uid).update({'skillStats': skillStats});
  }

  Future<void> updateAchievements({
    required String uid,
    required Map<String, bool> achievements,
  }) async {
    await _userDoc(uid).update({'achievements': achievements});
  }

  Future<void> resetProgress(String uid) async {
    final userRef = _userDoc(uid);

    await userRef.update({
      'currentLevel': 'level_1',
      'totalXP': 0,
      'puzzlesCompleted': 0,
      'streakDays': 1,
      'totalPlayTimeSeconds': 0,
      'completedLevelIds': <String>[],
      'skillStats': {
        'sequences': 0,
        'conditions': 10,
        'loops': 10,
        'debugging': 10,
      },
      'achievements': {
        'firstMission': false,
        'fiveMissions': false,
        'earned100Xp': false,
        'perfectSolution': false,
        'threeDayStreak': false,
        'noHintWin': false,
      },
      'lastActiveDate': FieldValue.serverTimestamp(),
    });
  }
}
