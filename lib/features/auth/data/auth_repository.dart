import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  AuthRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(code: 'user-null', message: 'Login failed.');
    }

    final userDoc = _firestore.collection('users').doc(user.uid);
    final snapshot = await userDoc.get();

    if (snapshot.exists) {
      final data = snapshot.data()!;

      await userDoc.update({
        'displayName': data['displayName'],
        'createdAt': data['createdAt'],
        'lastLoginAt': FieldValue.serverTimestamp(),
        'currentLevel': data['currentLevel'],
        'totalXP': data['totalXP'],
        'puzzlesCompleted': data['puzzlesCompleted'],
      });
    }

    return credential; // ✅ REQUIRED
  }

  Future<UserCredential> signup({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();

    final credential = await _auth.createUserWithEmailAndPassword(
      email: trimmedEmail,
      password: password.trim(),
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-null',
        message: 'User creation failed.',
      );
    }

    final displayName = trimmedEmail.split('@').first;

    await _firestore.collection('users').doc(user.uid).set({
      'displayName': displayName,
      'email': trimmedEmail,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLoginAt': FieldValue.serverTimestamp(),
      'lastActiveDate': FieldValue.serverTimestamp(),

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

      'policyAccepted': true,
      'policyAcceptedAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
