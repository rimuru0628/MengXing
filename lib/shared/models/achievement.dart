import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum AchievementType {
  firstWalk,
  firstWorkout,
  steps1k,
  steps5k,
  steps10k,
  distance10km,
  distance50km,
  distance100km,
  workouts10,
  workouts50,
  streak7,
  streak30,
  streak100,
  walks10,
  walks50,
  walks100,
  earlyBird,
  nightOwl,
  weekendWarrior,
  consistentWeek,
}

class Achievement {
  final String achievementId;
  final AchievementType type;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.achievementId,
    required this.type,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  factory Achievement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Achievement(
      achievementId: doc.id,
      type: AchievementType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => AchievementType.firstWalk,
      ),
      isUnlocked: data['isUnlocked'] ?? false,
      unlockedAt: data['unlockedAt'] != null
          ? (data['unlockedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'type': type.name,
        'isUnlocked': isUnlocked,
        'unlockedAt':
            unlockedAt != null ? Timestamp.fromDate(unlockedAt!) : null,
      };

  AchievementDefinition get definition =>
      AchievementDefinition.definitions[type]!;
}

class AchievementDefinition {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String emoji;

  const AchievementDefinition({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.emoji,
  });

  static const Map<AchievementType, AchievementDefinition> definitions = {
    AchievementType.firstWalk: AchievementDefinition(
      title: 'First Steps',
      description: 'Complete your first walk',
      icon: Icons.directions_walk,
      color: AppColors.walkGreen,
      emoji: '👟',
    ),
    AchievementType.firstWorkout: AchievementDefinition(
      title: 'Workout Warrior',
      description: 'Complete your first workout',
      icon: Icons.fitness_center,
      color: AppColors.exercisePurple,
      emoji: '💪',
    ),
    AchievementType.steps1k: AchievementDefinition(
      title: '1K Steps',
      description: 'Walk 1,000 steps in a day',
      icon: Icons.looks_one,
      color: AppColors.accent,
      emoji: '🏃',
    ),
    AchievementType.steps5k: AchievementDefinition(
      title: '5K Steps',
      description: 'Walk 5,000 steps in a day',
      icon: Icons.looks_5,
      color: AppColors.primary,
      emoji: '🚶',
    ),
    AchievementType.steps10k: AchievementDefinition(
      title: '10K Club',
      description: 'Walk 10,000 steps in a day',
      icon: Icons.emoji_events,
      color: AppColors.goldBadge,
      emoji: '🏆',
    ),
    AchievementType.distance10km: AchievementDefinition(
      title: '10 KM Total',
      description: 'Walk a total of 10 km',
      icon: Icons.map,
      color: AppColors.walkBlue,
      emoji: '🗺️',
    ),
    AchievementType.distance50km: AchievementDefinition(
      title: '50 KM Explorer',
      description: 'Walk a total of 50 km',
      icon: Icons.explore,
      color: AppColors.secondary,
      emoji: '🧭',
    ),
    AchievementType.distance100km: AchievementDefinition(
      title: '100 KM Legend',
      description: 'Walk a total of 100 km',
      icon: Icons.stars,
      color: AppColors.goldBadge,
      emoji: '⭐',
    ),
    AchievementType.workouts10: AchievementDefinition(
      title: '10 Workouts',
      description: 'Complete 10 workouts',
      icon: Icons.fitness_center,
      color: AppColors.exercisePurple,
      emoji: '🏋️',
    ),
    AchievementType.workouts50: AchievementDefinition(
      title: '50 Workouts',
      description: 'Complete 50 workouts',
      icon: Icons.military_tech,
      color: AppColors.goldBadge,
      emoji: '🎖️',
    ),
    AchievementType.streak7: AchievementDefinition(
      title: '7-Day Streak',
      description: 'Stay active 7 days in a row',
      icon: Icons.local_fire_department,
      color: AppColors.streakOrange,
      emoji: '🔥',
    ),
    AchievementType.streak30: AchievementDefinition(
      title: '30-Day Streak',
      description: 'Stay active 30 days in a row',
      icon: Icons.whatshot,
      color: AppColors.streakRed,
      emoji: '🔥',
    ),
    AchievementType.streak100: AchievementDefinition(
      title: '100-Day Legend',
      description: 'Stay active 100 days in a row',
      icon: Icons.emoji_events,
      color: AppColors.goldBadge,
      emoji: '👑',
    ),
    AchievementType.walks10: AchievementDefinition(
      title: '10 Walks',
      description: 'Complete 10 walking sessions',
      icon: Icons.directions_walk,
      color: AppColors.walkGreen,
      emoji: '🦶',
    ),
    AchievementType.walks50: AchievementDefinition(
      title: '50 Walks',
      description: 'Complete 50 walking sessions',
      icon: Icons.directions_walk,
      color: AppColors.primary,
      emoji: '🥾',
    ),
    AchievementType.walks100: AchievementDefinition(
      title: '100 Walks',
      description: 'Complete 100 walking sessions',
      icon: Icons.emoji_people,
      color: AppColors.goldBadge,
      emoji: '🏅',
    ),
    AchievementType.earlyBird: AchievementDefinition(
      title: 'Early Bird',
      description: 'Complete a workout before 7 AM',
      icon: Icons.wb_sunny,
      color: AppColors.warning,
      emoji: '🌅',
    ),
    AchievementType.nightOwl: AchievementDefinition(
      title: 'Night Owl',
      description: 'Complete a workout after 9 PM',
      icon: Icons.nightlight,
      color: AppColors.exercisePurple,
      emoji: '🦉',
    ),
    AchievementType.weekendWarrior: AchievementDefinition(
      title: 'Weekend Warrior',
      description: 'Work out on both Saturday and Sunday',
      icon: Icons.weekend,
      color: AppColors.secondary,
      emoji: '⚡',
    ),
    AchievementType.consistentWeek: AchievementDefinition(
      title: 'Consistent Week',
      description: 'Meet your daily goal every day for a week',
      icon: Icons.calendar_today,
      color: AppColors.accent,
      emoji: '✅',
    ),
  };
}
