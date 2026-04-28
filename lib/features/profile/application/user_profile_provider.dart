import 'package:auri_app/features/profile/data/user_profile_service.dart';
import 'package:auri_app/features/profile/domain/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final userProfileServiceProvider = Provider<UserProfileService>((ref) {
  return UserProfileService(FirebaseFirestore.instance);
});

final currentFirebaseUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final currentUserIdProvider = Provider<String?>((ref) {
  final userAsync = ref.watch(currentFirebaseUserProvider);

  return userAsync.when(
    data: (user) => user?.uid,
    loading: () => FirebaseAuth.instance.currentUser?.uid,
    error: (_, _) => FirebaseAuth.instance.currentUser?.uid,
  );
});

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final uid = ref.watch(currentUserIdProvider);

  if (uid == null) {
    return Stream<UserProfile?>.value(null);
  }

  return ref.watch(userProfileServiceProvider).watchUserProfile(uid);
});

final userProfileFutureProvider = FutureProvider<UserProfile?>((ref) async {
  final uid = ref.watch(currentUserIdProvider);

  if (uid == null) {
    return null;
  }

  return ref.watch(userProfileServiceProvider).fetchUserProfile(uid);
});
