import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/levels_firestore_service.dart';

final firestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

final levelsFirestoreServiceProvider = Provider((ref) {
  return LevelsFirestoreService(ref.read(firestoreProvider));
});
