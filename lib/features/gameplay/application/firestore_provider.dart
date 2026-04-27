import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/levels_firestore_service.dart';
import '../data/progress_firestore_service.dart';

final firestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

final levelsFirestoreServiceProvider = Provider((ref) {
  return LevelsFirestoreService(ref.read(firestoreProvider));
});

final progressFirestoreServiceProvider = Provider<ProgressFirestoreService>((
  ref,
) {
  return ProgressFirestoreService(FirebaseFirestore.instance);
});
