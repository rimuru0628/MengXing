import 'package:cloud_firestore/cloud_firestore.dart';

enum ExerciseCategory {
  fullBody,
  chest,
  back,
  shoulders,
  arms,
  legs,
  core,
  cardio,
  walking,
  running,
  stretching,
  recovery,
}

enum ExerciseDifficulty { beginner, intermediate, advanced }

enum ExerciseEquipment { none, dumbbell, barbell, resistanceBand, mat, chair, pullupBar }

class Exercise {
  final String exerciseId;
  final String name;
  final String description;
  final ExerciseCategory category;
  final List<String> muscleGroups;
  final ExerciseDifficulty difficulty;
  final List<ExerciseEquipment> equipment;
  final List<String> instructions;
  final int defaultSets;
  final int defaultReps;
  final int? durationSeconds; // null = reps-based
  final int restSeconds;
  final String? imageUrl;
  final String? videoUrl;
  final double? caloriesPerMinute;

  const Exercise({
    required this.exerciseId,
    required this.name,
    required this.description,
    required this.category,
    this.muscleGroups = const [],
    this.difficulty = ExerciseDifficulty.beginner,
    this.equipment = const [ExerciseEquipment.none],
    this.instructions = const [],
    this.defaultSets = 3,
    this.defaultReps = 10,
    this.durationSeconds,
    this.restSeconds = 60,
    this.imageUrl,
    this.videoUrl,
    this.caloriesPerMinute,
  });

  factory Exercise.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Exercise(
      exerciseId: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: ExerciseCategory.values.firstWhere(
        (c) => c.name == data['category'],
        orElse: () => ExerciseCategory.fullBody,
      ),
      muscleGroups: List<String>.from(data['muscleGroups'] ?? []),
      difficulty: ExerciseDifficulty.values.firstWhere(
        (d) => d.name == data['difficulty'],
        orElse: () => ExerciseDifficulty.beginner,
      ),
      equipment: (data['equipment'] as List? ?? [])
          .map((e) => ExerciseEquipment.values.firstWhere(
                (eq) => eq.name == e,
                orElse: () => ExerciseEquipment.none,
              ))
          .toList(),
      instructions: List<String>.from(data['instructions'] ?? []),
      defaultSets: data['defaultSets'] ?? 3,
      defaultReps: data['defaultReps'] ?? 10,
      durationSeconds: data['durationSeconds'],
      restSeconds: data['restSeconds'] ?? 60,
      imageUrl: data['imageUrl'],
      videoUrl: data['videoUrl'],
      caloriesPerMinute: (data['caloriesPerMinute'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'description': description,
        'category': category.name,
        'muscleGroups': muscleGroups,
        'difficulty': difficulty.name,
        'equipment': equipment.map((e) => e.name).toList(),
        'instructions': instructions,
        'defaultSets': defaultSets,
        'defaultReps': defaultReps,
        'durationSeconds': durationSeconds,
        'restSeconds': restSeconds,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'caloriesPerMinute': caloriesPerMinute,
      };

  bool get isTimeBased => durationSeconds != null;

  String get categoryDisplayName {
    switch (category) {
      case ExerciseCategory.fullBody: return 'Full Body';
      case ExerciseCategory.chest: return 'Chest';
      case ExerciseCategory.back: return 'Back';
      case ExerciseCategory.shoulders: return 'Shoulders';
      case ExerciseCategory.arms: return 'Arms';
      case ExerciseCategory.legs: return 'Legs';
      case ExerciseCategory.core: return 'Core';
      case ExerciseCategory.cardio: return 'Cardio';
      case ExerciseCategory.walking: return 'Walking';
      case ExerciseCategory.running: return 'Running';
      case ExerciseCategory.stretching: return 'Stretching';
      case ExerciseCategory.recovery: return 'Recovery';
    }
  }

  String get difficultyDisplayName {
    switch (difficulty) {
      case ExerciseDifficulty.beginner: return 'Beginner';
      case ExerciseDifficulty.intermediate: return 'Intermediate';
      case ExerciseDifficulty.advanced: return 'Advanced';
    }
  }
}

// A workout item within a session (exercise + user-specific params)
class WorkoutExercise {
  final Exercise exercise;
  final int sets;
  final int reps;
  final int? durationSeconds;
  final int restSeconds;
  bool isCompleted;
  int completedSets;

  WorkoutExercise({
    required this.exercise,
    required this.sets,
    required this.reps,
    this.durationSeconds,
    required this.restSeconds,
    this.isCompleted = false,
    this.completedSets = 0,
  });
}
