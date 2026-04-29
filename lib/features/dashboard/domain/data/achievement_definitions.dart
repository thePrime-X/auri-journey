import 'package:flutter/material.dart';
import '../models/achievement_ui.dart';

const achievementDefinitions = [
  AchievementUI(
    key: 'firstMission',
    title: 'First Step',
    description: 'Complete your first mission',
    icon: Icons.flag_rounded,
  ),
  AchievementUI(
    key: 'fiveMissions',
    title: 'Explorer',
    description: 'Complete 5 missions',
    icon: Icons.explore_rounded,
  ),
  AchievementUI(
    key: 'earned100Xp',
    title: 'XP Hunter',
    description: 'Reach 100 XP',
    icon: Icons.bolt_rounded,
  ),
  AchievementUI(
    key: 'perfectSolution',
    title: 'Perfect Run',
    description: 'Solve with optimal moves',
    icon: Icons.auto_awesome_rounded,
  ),
  AchievementUI(
    key: 'threeDayStreak',
    title: 'Consistency',
    description: '3 day streak',
    icon: Icons.local_fire_department_rounded,
  ),
  AchievementUI(
    key: 'noHintWin',
    title: 'No Assistance',
    description: 'Win without hints',
    icon: Icons.visibility_off_rounded,
  ),
];
