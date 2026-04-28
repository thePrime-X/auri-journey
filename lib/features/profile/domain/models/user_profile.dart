import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final String currentLevel;
  final int totalXP;
  final int puzzlesCompleted;
  final int streakDays;
  final int totalPlayTimeSeconds;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;
  final DateTime? lastActiveDate;
  final List<String> completedLevelIds;
  final Map<String, int> skillStats;
  final Map<String, bool> achievements;
  final bool policyAccepted;
  final DateTime? policyAcceptedAt;

  const UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.currentLevel,
    required this.totalXP,
    required this.puzzlesCompleted,
    required this.streakDays,
    required this.totalPlayTimeSeconds,
    required this.createdAt,
    required this.lastLoginAt,
    required this.lastActiveDate,
    required this.completedLevelIds,
    required this.skillStats,
    required this.achievements,
    required this.policyAccepted,
    required this.policyAcceptedAt,
  });

  factory UserProfile.empty(String uid) {
    return UserProfile(
      uid: uid,
      displayName: 'Commander',
      email: '',
      currentLevel: 'level_1',
      totalXP: 0,
      puzzlesCompleted: 0,
      streakDays: 0,
      totalPlayTimeSeconds: 0,
      createdAt: null,
      lastLoginAt: null,
      lastActiveDate: null,
      completedLevelIds: const [],
      skillStats: const {
        'sequences': 0,
        'conditions': 10,
        'loops': 10,
        'debugging': 10,
      },
      achievements: const {
        'firstMission': false,
        'fiveMissions': false,
        'earned100Xp': false,
        'perfectSolution': false,
        'threeDayStreak': false,
        'noHintWin': false,
      },
      policyAccepted: false,
      policyAcceptedAt: null,
    );
  }

  factory UserProfile.fromFirestore({
    required String uid,
    required Map<String, dynamic> data,
  }) {
    return UserProfile(
      uid: uid,
      displayName: data['displayName']?.toString() ?? 'Commander',
      email: data['email']?.toString() ?? '',
      currentLevel: data['currentLevel']?.toString() ?? 'level_1',
      totalXP: _toInt(data['totalXP']),
      puzzlesCompleted: _toInt(data['puzzlesCompleted']),
      streakDays: _toInt(data['streakDays']),
      totalPlayTimeSeconds: _toInt(data['totalPlayTimeSeconds']),
      createdAt: _toDateTime(data['createdAt']),
      lastLoginAt: _toDateTime(data['lastLoginAt']),
      lastActiveDate: _toDateTime(data['lastActiveDate']),
      completedLevelIds: _toStringList(data['completedLevelIds']),
      skillStats: _toIntMap(
        data['skillStats'],
        fallback: const {
          'sequences': 0,
          'conditions': 10,
          'loops': 10,
          'debugging': 10,
        },
      ),
      achievements: _toBoolMap(
        data['achievements'],
        fallback: const {
          'firstMission': false,
          'fiveMissions': false,
          'earned100Xp': false,
          'perfectSolution': false,
          'threeDayStreak': false,
          'noHintWin': false,
        },
      ),

      policyAccepted: data['policyAccepted'] == true,
      policyAcceptedAt: _toDateTime(data['policyAcceptedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      'currentLevel': currentLevel,
      'totalXP': totalXP,
      'puzzlesCompleted': puzzlesCompleted,
      'streakDays': streakDays,
      'totalPlayTimeSeconds': totalPlayTimeSeconds,
      'createdAt': createdAt == null ? null : Timestamp.fromDate(createdAt!),
      'lastLoginAt': lastLoginAt == null
          ? null
          : Timestamp.fromDate(lastLoginAt!),
      'lastActiveDate': lastActiveDate == null
          ? null
          : Timestamp.fromDate(lastActiveDate!),
      'completedLevelIds': completedLevelIds,
      'skillStats': skillStats,
      'achievements': achievements,
      'policyAccepted': policyAccepted,
      'policyAcceptedAt': policyAcceptedAt == null
          ? null
          : Timestamp.fromDate(policyAcceptedAt!),
    };
  }

  UserProfile copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? currentLevel,
    int? totalXP,
    int? puzzlesCompleted,
    int? streakDays,
    int? totalPlayTimeSeconds,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    DateTime? lastActiveDate,
    List<String>? completedLevelIds,
    Map<String, int>? skillStats,
    Map<String, bool>? achievements,
    bool? policyAccepted,
    DateTime? policyAcceptedAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      currentLevel: currentLevel ?? this.currentLevel,
      totalXP: totalXP ?? this.totalXP,
      puzzlesCompleted: puzzlesCompleted ?? this.puzzlesCompleted,
      streakDays: streakDays ?? this.streakDays,
      totalPlayTimeSeconds: totalPlayTimeSeconds ?? this.totalPlayTimeSeconds,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      completedLevelIds: completedLevelIds ?? this.completedLevelIds,
      skillStats: skillStats ?? this.skillStats,
      achievements: achievements ?? this.achievements,
      policyAccepted: policyAccepted ?? this.policyAccepted,
      policyAcceptedAt: policyAcceptedAt ?? this.policyAcceptedAt,
    );
  }

  double skillProgress(String skillKey) {
    final value = skillStats[skillKey] ?? 0;
    return (value.clamp(0, 100)) / 100;
  }

  String get formattedPlayTime {
    final hours = totalPlayTimeSeconds ~/ 3600;
    final minutes = (totalPlayTimeSeconds % 3600) ~/ 60;

    if (hours <= 0) {
      return '${minutes}m';
    }

    return '${hours}h ${minutes}m';
  }

  int get displayLevel {
    if (currentLevel.startsWith('level_')) {
      return int.tryParse(currentLevel.replaceFirst('level_', '')) ?? 1;
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

  static Map<String, int> _toIntMap(
    dynamic value, {
    required Map<String, int> fallback,
  }) {
    if (value is! Map) return fallback;

    return {
      ...fallback,
      ...value.map(
        (key, mapValue) => MapEntry(key.toString(), _toInt(mapValue)),
      ),
    };
  }

  static Map<String, bool> _toBoolMap(
    dynamic value, {
    required Map<String, bool> fallback,
  }) {
    if (value is! Map) return fallback;

    return {
      ...fallback,
      ...value.map(
        (key, mapValue) => MapEntry(key.toString(), mapValue == true),
      ),
    };
  }
}
